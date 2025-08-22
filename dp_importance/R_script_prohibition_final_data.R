library(lme4)
library(ordinal)
library(MASS)
library(ggplot2)
library(plyr)
library(dplyr) 
library(car)
library(data.table)
library(reshape)
library(reshape2)
library(scales)


# reading spreadsheet with final data

data <- "results_prohib_final_corrected.csv"
data_all <- read.csv(data, header=TRUE)
str(data_all)

# confirming overall number of data sets (96)
n_distinct(data_all$subject_id)

# filtering for data after exclusion

data_incl_6_scale <- data_all %>% filter(exclude=="0")
str(data_incl_6_scale)
View(data_incl_6_scale)

# number of data sets for analysis (64)
n_distinct(data_incl_6_scale$subject_id)


# checking for numberof participants per list

list1<- data_incl_6_scale %>% filter(list=="1") 
n_distinct(list1$subject_id) #9

list2<- data_incl_6_scale %>% filter(list=="2") 
n_distinct(list2$subject_id) #9

list3 <- data_incl_6_scale %>% filter(list=="3") 
n_distinct(list3$subject_id) #12

list4 <- data_incl_6_scale %>% filter(list=="4") 
n_distinct(list4$subject_id) #11

list5 <- data_incl_6_scale %>% filter(list=="5") 
n_distinct(list5$subject_id) #9

list6 <- data_incl_6_scale %>% filter(list=="6") 
n_distinct(list6$subject_id) #14


# recode scale values to 1-7 scale 

data_incl <- data_incl_6_scale %>% mutate(importance = importance + 1, naturalness = naturalness + 1)
View(data_incl)


# filter for content items
data_incl_target <- filter(data_incl, item_type=="content")
str(data_incl_target) 


# spell out names of factor levels
data_incl_target$flavour_cond <- revalue(data_incl_target$flavour_cond, c("circ" = "circumstantial", "epist" = "epistemic"))
levels(data_incl_target$flavour_cond)

data_incl_target$force_cond <- revalue(data_incl_target$force_cond, c("p" = "possibility", "ip" = "impossibility"))
levels(data_incl_target$force_cond)


# descriptive statistics

tapply(data_incl_target$importance,list(data_incl_target$force_cond,data_incl_target$flavour_cond),mean) 
tapply(data_incl_target$importance,list(data_incl_target$force_cond,data_incl_target$flavour_cond),sd)

# plot mean importance ratings

(data_imp <- cast(melt(data_incl_target, id.var=c("subject_id","force_cond","flavour_cond"), measure.var="importance"), force_cond*flavour_cond  ~ ., function(x) c(M=mean(x), SE=sd(x)/sqrt(length(x)), N=length(x) ) ) ) 

# change order of levels in the flavour condition
data_imp$flavour_cond <- factor(data_imp$flavour_cond, levels = c("deontic", "circumstantial", "epistemic"))


p <- qplot(x=force_cond, y=M, linetype=flavour_cond, shape=flavour_cond, group=flavour_cond, data=data_imp, xlab="", ylab="Mean Importance Rating", geom=c("point", "line"))
p <- p + geom_errorbar(aes(max=M+SE, min=M-SE, width=0.2)) + geom_point(size=3) + theme_bw(base_size=16) + scale_shape(guide = guide_legend(title = NULL)) + scale_linetype(guide = guide_legend(title = NULL)) + coord_cartesian(ylim = c(1,7))

p

# relevel flavour condition such that deontic is the reference level
data_incl_target_rel <- within(data_incl_target, flavour_cond <- relevel(flavour_cond, ref = "deontic"))

# proportion plot

cbp1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

p2 <- data_incl_target_rel %>%
  arrange(importance) %>%
  mutate(Response = factor(importance,levels=c("7","6","5","4","3","2","1"), labels=c("7","6","5","4","3","2","1"))) %>%
  ggplot(aes(x=flavour_cond, fill=Response)) +
  facet_grid(.~force_cond, drop=T,scales = "free") +
  geom_bar (position=position_fill(),colour="black", alpha = 0.8) +
  xlab("") +
  ylab("Proportion of each response")+
  scale_x_discrete(breaks=c("deontic","circumstantial", "epistemic"))+
  theme_bw() +
  theme(axis.text.x =element_text(size=8),
        axis.text.y = element_text(size=6),
        axis.title.y = element_text(size=13))+
  scale_fill_manual(values=cbp1) +
  scale_y_continuous(labels = percent) +
  scale_alpha_manual(values=c(1,.5),breaks=NULL) 
print(p2)



# look at naturalness ratings

# descriptive statistics

tapply(data_incl_target$naturalness,list(data_incl_target$force_cond,data_incl_target$flavour_cond),mean) 
tapply(data_incl_target$naturalness,list(data_incl_target$force_cond,data_incl_target$flavour_cond),sd)

# plot

(data_n <- cast(melt(data_incl_target, id.var=c("subject_id","force_cond","flavour_cond"), measure.var="naturalness"), force_cond*flavour_cond  ~ ., function(x) c(M=mean(x), SE=sd(x)/sqrt(length(x)), N=length(x) ) ) ) 

# change order of levels in the flavour condition
data_n$flavour_cond <- factor(data_n$flavour_cond, levels = c("deontic", "circumstantial", "epistemic"))

p_n <- qplot(x=force_cond, y=M, linetype=flavour_cond, shape=flavour_cond, group=flavour_cond, data=data_n, xlab="", ylab="Mean Naturalness Rating", geom=c("point", "line"))
p_n <- p_n + geom_errorbar(aes(max=M+SE, min=M-SE, width=0.2)) + geom_point(size=3) + theme_bw(base_size=16) + scale_shape(guide = guide_legend(title = NULL)) + scale_linetype(guide = guide_legend(title = NULL)) + coord_cartesian(ylim = c(1,7))

p_n

# -----------------------

# Inferential statistics 

# ordinal model (cumulative link mixed model) for importance ratings

# turning importance into a factor:

data_incl_target_rel$importance <- factor(data_incl_target_rel$importance, level=c("1","2","3","4","5","6","7"), label=c("1","2","3","4","5","6","7"))

str(data_incl_target_rel)

# fitting the model with by participant and by item random intercepts and random slopes for both predictors

mdl_ord <- clmm(importance ~ force_cond + flavour_cond + force_cond:flavour_cond + (1 + force_cond + flavour_cond |subject_id) + (1 + force_cond + flavour_cond |item_id), data = data_incl_target_rel)

summary(mdl_ord)
confint(mdl_ord)

# model without interaction (for model comparison, reduced because doesn't converge with random slopes)

mdl_ord_wo_int <- clmm(importance ~ force_cond + flavour_cond + (1|subject_id) + (1|item_id), data = data_incl_target_rel)
summary(mdl_ord_wo_int)

# reduced model with only random intercepts for model comparison

mdl_ord_red <- clmm(importance ~ force_cond + flavour_cond + force_cond:flavour_cond + (1|subject_id) + (1|item_id), data = data_incl_target_rel)

summary(mdl_ord_red)
confint(mdl_ord_red)


# model comparison with vs. without interaction

anova(mdl_ord_red, mdl_ord_wo_int) 

# model comparison with vs. without random slopes

anova(mdl_ord, mdl_ord_red) 

# isolating the difference between deontic ip and deontic p

data_incl_target_deon <- filter(data_incl_target, flavour_cond == "deontic")

data_incl_target_deon$importance <- factor(data_incl_target_deon$importance, level=c("1","2","3","4","5","6","7"), label=c("1","2","3","4","5","6","7"))

mdl_deontic <- clmm(importance ~ force_cond + (1|subject_id) + (1|item_id), data = data_incl_target_deon)

summary(mdl_deontic) # ***
confint(mdl_deontic)

# same for circumstantial flavor

data_incl_target_circ <- filter(data_incl_target, flavour_cond == "circumstantial")

data_incl_target_circ$importance <- factor(data_incl_target_circ$importance, level=c("1","2","3","4","5","6","7"), label=c("1","2","3","4","5","6","7"))

mdl_circ <- clmm(importance ~ force_cond + (1|subject_id) + (1|item_id), data = data_incl_target_circ)

summary(mdl_circ) # *
confint(mdl_circ)


# isolating the difference between ip conditions

data_incl_target_ip <- filter(data_incl_target, force_cond == "impossibility")
str(data_incl_target_ip)


data_incl_target_ip$importance <- factor(data_incl_target_ip$importance, level=c("1","2","3","4","5","6","7"), label=c("1","2","3","4","5","6","7"))

# relevel flavour condition such that deontic is the reference level

data_incl_target_ip <- within(data_incl_target_ip, flavour_cond <- relevel(flavour_cond, ref = "deontic"))

mdl_ip <- clmm(importance ~ flavour_cond + (1|subject_id) + (1|item_id), data = data_incl_target_ip)

summary(mdl_ip) # *** for both conditions
confint(mdl_ip)

#--------------- explore mean natural and importance ratings for "high importance" controls -------------

# filtering for "high importance" controls

data_high_controls <- filter(data_incl, item_id %in% c("high_crucial31", "high_crucial39", "high_vital19","high_vital23", "high_vital27","high_vital35"))

View(data_high_controls)
str(data_high_controls)

mean(data_high_controls$naturalness) #6.05
mean(data_high_controls$importance) #6.45


q()
y
