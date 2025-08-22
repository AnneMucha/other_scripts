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
library(purrr)
library(readr)

# function to read results file from PCIbex:

read.pcibex <- function(filepath, auto.colnames=TRUE, fun.col=function(col,cols){cols[cols==col]<-paste(col,"Ibex",sep=".");return(cols)}) {
  n.cols <- max(count.fields(filepath,sep=",",quote=NULL),na.rm=TRUE)
  if (auto.colnames){
    cols <- c()
    con <- file(filepath, "r")
    while ( TRUE ) {
      line <- readLines(con, n = 1, warn=FALSE)
      if ( length(line) == 0) {
        break
      }
      m <- regmatches(line,regexec("^# (\\d+)\\. (.+)\\.$",line))[[1]]
      if (length(m) == 3) {
        index <- as.numeric(m[2])
        value <- m[3]
        if (is.function(fun.col)){
          cols <- fun.col(value,cols)
        }
        cols[index] <- value
        if (index == n.cols){
          break
        }
      }
    }
    close(con)
    return(read.csv(filepath, comment.char="#", header=FALSE, col.names=cols))
  }
  else{
    return(read.csv(filepath, comment.char="#", header=FALSE, col.names=seq(1:n.cols)))
  }
}

# read results files

listA_results_csv <- "results_listA_updated.csv"
listA_results <- read.pcibex(listA_results_csv)

listB_results_csv <- "results_listB_updated.csv"
listB_results <- read.pcibex(listB_results_csv)

listC_results_csv <- "results_listC_updated.csv"
listC_results <- read.pcibex(listC_results_csv)

listD_results_csv <- "results_listD_updated.csv"
listD_results <- read.pcibex(listD_results_csv)

list_mixed_csv <- "results_10.2.csv"
listM_results <- read.pcibex(list_mixed_csv)

# create CSV files from reformatted data -------------------------------------

write.csv(listA_results,"/Users/amucha/OneDrive - University of Edinburgh/experiments_AEs/results_SPR/AEs_listA_results_formatted.csv", row.names = FALSE)
write.csv(listB_results,"/Users/amucha/OneDrive - University of Edinburgh/experiments_AEs/results_SPR/AEs_listB_results_formatted.csv", row.names = FALSE)
write.csv(listC_results,"/Users/amucha/OneDrive - University of Edinburgh/experiments_AEs/results_SPR/AEs_listC_results_formatted.csv", row.names = FALSE)
write.csv(listD_results,"/Users/amucha/OneDrive - University of Edinburgh/experiments_AEs/results_SPR/AEs_listD_results_formatted.csv", row.names = FALSE)
write.csv(listM_results,"/Users/amucha/OneDrive - University of Edinburgh/experiments_AEs/results_SPR/AEs_listM_results_formatted.csv", row.names = FALSE)

# restart here 

listA_results <- read.csv("AEs_listA_results_formatted.csv")
listB_results <- read.csv("AEs_listB_results_formatted.csv")
listC_results <- read.csv("AEs_listC_results_formatted.csv")
listD_results <- read.csv("AEs_listD_results_formatted.csv")
listM_results <- read.csv("AEs_listM_results_formatted.csv")

View(listA_results)

# create ad hoc IDs based on IP address

listA_results <- listA_results %>% mutate(Participant_ID = factor(MD5.hash.of.participant.s.IP.address) %>% as.integer()) %>% mutate(Participant_ID = paste0("a", Participant_ID))
#
n_distinct(listA_results$MD5.hash.of.participant.s.IP.address)
n_distinct(listA_results$Participant_ID)

listB_results <- listB_results %>% mutate(Participant_ID = factor(MD5.hash.of.participant.s.IP.address) %>% as.integer()) %>% mutate(Participant_ID = paste0("b", Participant_ID))
#
n_distinct(listB_results$MD5.hash.of.participant.s.IP.address)
n_distinct(listB_results$Participant_ID)

listC_results <- listC_results %>% mutate(Participant_ID = factor(MD5.hash.of.participant.s.IP.address) %>% as.integer()) %>% mutate(Participant_ID = paste0("c", Participant_ID))
#
n_distinct(listC_results$MD5.hash.of.participant.s.IP.address)
n_distinct(listC_results$Participant_ID)

listD_results <- listD_results %>% mutate(Participant_ID = factor(MD5.hash.of.participant.s.IP.address) %>% as.integer()) %>% mutate(Participant_ID = paste0("d", Participant_ID))
#
n_distinct(listD_results$MD5.hash.of.participant.s.IP.address)
n_distinct(listD_results$Participant_ID)

listM_results <- listM_results %>% mutate(Participant_ID = factor(MD5.hash.of.participant.s.IP.address) %>% as.integer()) %>% mutate(Participant_ID = paste0("m", Participant_ID))
#
n_distinct(listM_results$MD5.hash.of.participant.s.IP.address)
n_distinct(listM_results$Participant_ID)

# filter for SPR attention checks (by list, to see if the groups are still balanced)

listA_attention <- filter(listA_results, PennElementType == "Controller-Question" & Label == "SPR-trial-attention")
View(listA_attention)

# calculate how many correct answers we need to make sure people answered above chance
# Parameters
n <- 24          # no of questions
chance_level <- 1/2  # two answer options

# Function to check lower bound of confidence interval
for (x in 0:n) {
  result <- binom.test(x, n, conf.level = 0.99)  
  if (result$conf.int[1] > chance_level) {       
    cat("Minimum correct answers:", x, "\n")
    break
  }
}
# 19 correct answers as threshold for exclusion

# count number of correct answers by participant (values in "Reading.time" column for questions)

listA_attention_SPR_points <- listA_attention %>% group_by(Participant_ID) %>%
  summarise(count_ones = sum(Reading.time == 1, na.rm = TRUE))

View(listA_attention_SPR_points) # noone to exclude from list A


listB_attention <- filter(listB_results, PennElementType == "Controller-Question" & Label == "SPR-trial-attention")

listB_attention_SPR_points <- listB_attention %>% group_by(Participant_ID) %>%
  summarise(count_ones = sum(Reading.time == 1, na.rm = TRUE))

View(listB_attention_SPR_points) # noone to exclude from list B

listC_attention <- filter(listC_results, PennElementType == "Controller-Question" & Label == "SPR-trial-attention")

listC_attention_SPR_points <- listC_attention %>% group_by(Participant_ID) %>%
  summarise(count_ones = sum(Reading.time == 1, na.rm = TRUE))

View(listC_attention_SPR_points) # noone to exclude from list C

listD_attention <- filter(listD_results, PennElementType == "Controller-Question" & Label == "SPR-trial-attention")

listD_attention_SPR_points <- listD_attention %>% group_by(Participant_ID) %>%
  summarise(count_ones = sum(Reading.time == 1, na.rm = TRUE))

View(listD_attention_SPR_points) # noone to exclude from list D

listM_attention <- filter(listM_results, PennElementType == "Controller-Question" & Label == "SPR-trial-attention")

listM_attention_SPR_points <- listM_attention %>% group_by(Participant_ID) %>%
  summarise(count_ones = sum(Reading.time == 1, na.rm = TRUE))

View(listM_attention_SPR_points) # noone to exclude

# combine the lists
results_complete <- rbind(listA_results, listB_results, listC_results, listD_results, listM_results)
View(results_complete)

# write a new csv file with the complete data

write.csv(results_complete,"/Users/amucha/OneDrive - University of Edinburgh/experiments_AEs/results_SPR/results_AEs_SPR_complete.csv", row.names = FALSE)

# --------------------------- continue with complete data set ---------------------------------------------------------------------------------------------------------------------

# read and inspect file with complete data

results_AEs_SPR <- read.csv("results_AEs_SPR_complete.csv", encoding = "UTF-8") 

View(results_AEs_SPR)

# count the number of item sets per group

results_AEs_SPR %>%
  group_by(group) %>%
  summarise(num_participants = n_distinct(Participant_ID)) 

# ----------------------------------------  analyze SPR data  --------------------------------------------------------

# filter for SPR data
results_SPR_items <- filter(results_AEs_SPR, PennElementName == "DashedSentence" & Label != "practice-SPR")
View(results_SPR_items)

# change confusing column name
results_SPR_items <- rename(results_SPR_items,c('Parameter'='region'))

# filter for targets
results_SPR_targets <- filter(results_SPR_items, trial.type == "target")

View(results_SPR_targets)
str(results_SPR_targets)

# filter for last 6 regions in every target (= second conjunct)
results_SPR_targets_critical <- filter(results_SPR_targets, region %in% c('7','8','9','10','11','12','13','14'))
View(results_SPR_targets_critical)

# annotate short and long items
results_SPR_targets_critical <- results_SPR_targets_critical %>%
  group_by(item) %>%
  mutate(length = case_when(
    any(region == 7 & Value == "und") ~ "short",
    any(region == 9 & Value == "und") ~ "long",
  )) %>%
  ungroup()

# select relevant columns (just for readability)

results_SPR_targets_critical <- results_SPR_targets_critical[c("Label","region","Value","item","group","condition","modal.type","lex.type","Reading.time","Participant_ID","length")]

# throw out regions before "und" for longer items

results_SPR_targets_critical <- results_SPR_targets_critical %>% filter(!(length == "long" & region %in% c(7, 8)))

# define levels for critical regions (depending on the item length)

results_SPR_targets_critical <- results_SPR_targets_critical %>%
  mutate(region = case_when(
    length == "short" & region == 7  ~ "und",
    length == "short" & region == 8  ~ "auch",
    length == "short" & region == 9  ~ "subject",
    length == "short" & region == 10 ~ "aux",
    length == "short" & region == 11 ~ "midfield",
    length == "short" & region == 12 ~ "verb",
    length == "long"  & region == 9  ~ "und",
    length == "long"  & region == 10 ~ "auch",
    length == "long"  & region == 11 ~ "subject",
    length == "long"  & region == 12 ~ "aux",
    length == "long"  & region == 13 ~ "midfield",
    length == "long"  & region == 14 ~ "verb",
  )) %>%
  mutate(region = factor(region)) # Convert back to factor 

results_SPR_targets_critical <- results_SPR_targets_critical %>%
  mutate(region = factor(region, levels = c("und", "auch", "subject", "aux", "midfield", "verb")))

# turn RTs into numeric values
results_SPR_targets_critical$Reading.time <- as.numeric(as.character(results_SPR_targets_critical$Reading.time))

# scatterplot for raw reading times 
ggplot(results_SPR_targets_critical, aes(x=region, y=Reading.time, color=condition)) + geom_point() 


# exclude outliers by relative criteria -- more than 3 SDs away from the mean

results_SPR_cleaned <- results_SPR_targets_critical %>%
  group_by(region, condition) %>% 
  mutate(
    mean_rt = mean(Reading.time, na.rm = TRUE),   
    sd_rt = sd(Reading.time, na.rm = TRUE),      
    diff = abs(Reading.time - mean_rt),
    sd_rt_3 = 3 * sd_rt
  ) %>%
  filter(
    abs(Reading.time - mean_rt) <= 3 * sd_rt      
  )



# apply the absolute thresholds 
results_SPR_cleaned <- filter(results_SPR_cleaned, Reading.time >= 100 & Reading.time <= 3000)

View(results_SPR_cleaned) 

# updated scatterplot
ggplot(results_SPR_cleaned, aes(x=region, y=Reading.time, color=condition)) + geom_point()

# continue here -----------------------------------------------------
# plot raw reading times

agg_data <- results_SPR_cleaned %>%
  group_by(region, condition) %>%
  summarise(mean_RT = mean(Reading.time), .groups = "drop")

View(agg_data)

ggplot(agg_data, aes(x = region, y = mean_RT, group = condition, color = condition)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  labs(
    title = "Mean Reading Times Across Regions",
    x = "Region",
    y = "Mean Reading Time",
    color = "Condition"
  ) +
  theme_minimal()


# ----------- calculate residual RTs (by participant) -------------------------------


# Value column contains the words, turn to character values 
results_SPR_cleaned$Value <- as.character(results_SPR_cleaned$Value)


#create a new column for word length
results_SPR_cleaned$word_length <- nchar(results_SPR_cleaned$Value)


# new df with column for residual RTs
residual_data <- results_SPR_cleaned %>%
  group_by(Participant_ID) %>%
  group_modify(~ {
    model <- lm(Reading.time ~ word_length + region, data = .x)  
    .x$predicted_RT <- predict(model) 
    .x$residuals <- residuals(model)  
    return(.x)  
  }) %>%
  ungroup()

View(residual_data)

# aggregate data for regions and conditions
agg_residual_data <- residual_data %>%
  group_by(region, condition) %>%
  summarise(mean_ResRT = mean(residuals), .groups = "drop") 

# plot aggregated residual RTs
ggplot(agg_residual_data, aes(x = region, y = mean_ResRT, group = condition, color = condition)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Mean Residual Reading Times Across Regions",
    x = "Region",
    y = "Mean Residual Reading Time",
    color = "Condition"
  ) +
  theme_minimal()

# separate by lexicalisation type 
residual_data_abil <- filter(residual_data, lex.type == "ability")
View(residual_data_abil)

residual_data_goal <- filter(residual_data, lex.type == "goal")
View(residual_data_goal)


# ---------------------- modeling with residual RTs ------------------------------------------------------------

# fitting models for all 6 regions separately ---------------------------------

data_und <- filter(residual_data, region == "und")
View(data_und)

# model with maximal effects structure, testing for effects of lex.type, modal.type, or interaction
model_und <- lmer(residuals ~ lex.type * modal.type + (1 + lex.type + modal.type | Participant_ID) + (1 + lex.type + modal.type | item), data= data_und)
summary(model_und)
# overfit --> simplify model

# remove by-participant random effects (already accounted for by resRTs):
model_und <- lmer(residuals ~ lex.type * modal.type + (1 + lex.type + modal.type | item), data= data_und)

# model doesn't converge, remove by-item varying slopes:
model_und <- lmer(residuals ~ lex.type * modal.type + (1 | item), data= data_und)

model_und_simpl <- lmer(residuals ~ lex.type + modal.type + (1 | item), data= data_und)



summary(model_und)
confint(model_und, method = "Wald") # this kind of data pattern gives us interactions --> try to analyze ability and goal-oriented conditions separately and check for effect of modal.type

anova(model_und_simpl, model_und)

# all data with "auch"

data_auch <- filter(residual_data, region == "auch")
View(data_auch)

model_auch <- lmer(residuals ~ lex.type * modal.type + (1 | item), data= data_auch)

model_auch_simpl <- lmer(residuals ~ lex.type + modal.type + (1 | item), data= data_auch)


summary(model_auch)
confint(model_und, method = "Wald") 

anova(model_auch_simpl, model_auch)



# start with ability data ---------

data_und_abil <- filter(residual_data_abil, region == "und")
View(data_und_abil)

model_und_abil <- lmer(residuals ~ modal.type + (1 | item), data= data_und_abil)
summary(model_und_abil)
confint(model_und_abil, method = "Wald") 



# Region "und": sign. effect of modal.type (root) 

data_auch_abil <- filter(residual_data_abil, region == "auch")
View(data_auch_abil)

model_auch_abil <- lmer(residuals ~ modal.type + (1 | item), data= data_auch_abil)


summary(model_auch_abil)
confint(model_auch_abil, method = "Wald") 

# Region "auch": sign. effect of modal.type (root) 

data_subj_abil <- filter(residual_data_abil, region == "subj")
View(data_subj_abil)

model_subj_abil <- lmer(residuals ~ modal.type + (1 | item), data= data_subj_abil)
summary(model_subj_abil)
confint(model_subj_abil, method = "Wald") 

# Region "subj": no significant effect

data_aux_abil <- filter(residual_data_abil, region == "aux")
View(data_aux_abil)

model_aux_abil <- lmer(residuals ~ modal.type + (1 | item), data= data_aux_abil)
summary(model_aux_abil)
confint(model_aux_abil, method = "Wald") 

# Region "aux": no significant effect

data_MF_abil <- filter(residual_data_abil, region == "MF")
View(data_MF_abil)

model_MF_abil <- lmer(residuals ~ modal.type + (1 | item), data= data_MF_abil)
summary(model_MF_abil)
confint(model_MF_abil, method = "Wald") 

# Region "MF": not significant effect 

data_verb_abil <- filter(residual_data_abil, region == "verb")
View(data_verb_abil)

model_verb_abil <- lmer(residuals ~ modal.type + (1 | item), data= data_verb_abil)
summary(model_verb_abil)
confint(model_verb_abil, method = "Wald") 

# Region "verb": no significant effects 

# ----------------- same for goal-oriented items (don't expect any effects here, parameters only noted otherwise) ----------------------------------

data_und_goal <- filter(residual_data_goal, region == "und")
View(data_und_goal)

model_und_goal <- lmer(residuals ~ modal.type + (1 | item), data= data_und_goal)
summary(model_und_goal)
confint(model_und_goal, method = "Wald") 

# Region "und": no sign effect


data_auch_goal <- filter(residual_data_goal, region == "auch")
View(data_auch_goal)

model_auch_goal <- lmer(residuals ~ modal.type + (1 | item), data= data_auch_goal)
summary(model_auch_goal)
confint(model_auch_goal, method = "Wald") 

# Region "auch": no sign effect

data_subj_goal <- filter(residual_data_goal, region == "subj")
View(data_subj_goal)

model_subj_goal <- lmer(residuals ~ modal.type + (1 | item), data= data_subj_goal)
summary(model_subj_goal)
confint(model_subj_goal, method = "Wald") 

# Region "subj": no significant effect 

data_aux_goal <- filter(residual_data_goal, region == "aux")
View(data_aux_goal)

model_aux_goal <- lmer(residuals ~ modal.type + (1 | item), data= data_aux_goal)
summary(model_aux_goal)
confint(model_aux_goal, method = "Wald") 

# Region "aux": no significant effect

data_MF_goal <- filter(residual_data_goal, region == "MF")
View(data_MF_goal)

model_MF_goal <- lmer(residuals ~ modal.type + (1 | item), data= data_MF_goal)
summary(model_MF_goal)
confint(model_MF_goal, method = "Wald") 

# Region "MF": no significant effect 

data_verb_goal <- filter(residual_data_goal, region == "verb")
View(data_verb_goal)

model_verb_goal <- lmer(residuals ~ modal.type + (1 | item), data= data_verb_goal)
summary(model_verb_goal)
confint(model_verb_goal, method = "Wald") 

# result: only significant effects for "und" ,"auch" in the ability conditions

# make separate plots for ability and teleological data ---------------------------

# aggregate data for regions and conditions
agg_residual_abil <- residual_data_abil %>%
  group_by(region, condition) %>%
  summarise(mean_ResRT = mean(residuals),
            se = sd(residuals, na.rm = TRUE) / sqrt(n()),  
            ci = 1.96 * se,  
            .groups = "drop") 

# plot aggregated residual RTs
ggplot(agg_residual_abil, aes(x = region, y = mean_ResRT, group = condition, color = condition)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_ribbon(aes(ymin = mean_ResRT - ci, ymax = mean_ResRT + ci, fill = condition), alpha = 0.1, color = NA) + 
  labs(
    title = " ",
    x = "Region",
    y = "Mean Residual Reading Time",
    color = "Condition"
  ) +
  theme(legend.title = element_text(size=14), 
                legend.text = element_text(size=13),
                axis.text.x = element_text(size=12),
                axis.text.y = element_text(size=11),
                axis.title.x = element_text(size=13),
                axis.title.y = element_text(size=13))

# aggregate data for regions and conditions
agg_residual_goal <- residual_data_goal %>%
  group_by(region, condition) %>%
  summarise(mean_ResRT = mean(residuals),
            se = sd(residuals, na.rm = TRUE) / sqrt(n()),  
            ci = 1.96 * se,  
            .groups = "drop") 

# reorder factors so that coloring the same as in ability conditions
agg_residual_goal$condition <- factor(agg_residual_goal$condition, levels = c("goal","epist_goal"))

# plot aggregated residual RTs
ggplot(agg_residual_goal, aes(x = region, y = mean_ResRT, group = condition, color = condition)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_ribbon(aes(ymin = mean_ResRT - ci, ymax = mean_ResRT + ci, fill = condition), alpha = 0.1, color = NA) +
  labs(
    title = "",
    x = "Region",
    y = "Mean Residual Reading Time",
    color = "Condition"
  ) +
  theme(legend.title = element_text(size=14), 
        legend.text = element_text(size=13),
        axis.text.x = element_text(size=12),
        axis.text.y = element_text(size=11),
        axis.title.x = element_text(size=13),
        axis.title.y = element_text(size=13)) 
  

# ---------- separate plots with raw RTs

# aggregate data for regions and conditions
agg_raw_abil <- residual_data_abil %>%
  group_by(region, condition) %>%
  summarise(mean_RT = mean(Reading.time), .groups = "drop") 

# plot aggregated residual RTs
ggplot(agg_raw_abil, aes(x = region, y = mean_RT, group = condition, color = condition)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Mean Reading Times Across Regions for Ability Conditions",
    x = "Region",
    y = "Mean Reading Time",
    color = "Condition"
  ) +
  theme_minimal()

# aggregate data for regions and conditions
agg_raw_goal <- residual_data_goal %>%
  group_by(region, condition) %>%
  summarise(mean_RT = mean(Reading.time), .groups = "drop") 

# reorder factors so that coloring the same as in ability conditions
agg_raw_goal$condition <- factor(agg_raw_goal$condition, levels = c("goal","epist_goal"))

# plot aggregated residual RTs
ggplot(agg_raw_goal, aes(x = region, y = mean_RT, group = condition, color = condition)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Mean Reading Times Across Regions for Teleological Conditions",
    x = "Region",
    y = "Mean Reading Time",
    color = "Condition"
  ) +
  theme_minimal()




# ---------------- make plots with all regions (per flavor) -------------------------

# turn RTs into numeric values
results_SPR_targets$Reading.time <- as.numeric(as.character(results_SPR_targets$Reading.time))

results_SPR_targets$region <- as.numeric(as.character(results_SPR_targets$region))

# scatterplot for raw reading times 
ggplot(results_SPR_targets, aes(x=region, y=Reading.time, color=condition)) + geom_point() 

# exclude outliers by relative criteria -- more than 3 SDs away from the mean

results_SPR_cleaned_long <- results_SPR_targets %>%
  group_by(region, condition) %>% 
  mutate(
    mean_rt = mean(Reading.time, na.rm = TRUE),   
    sd_rt = sd(Reading.time, na.rm = TRUE),      
    diff = abs(Reading.time - mean_rt),
    sd_rt_3 = 3 * sd_rt
  ) %>%
  filter(
    abs(Reading.time - mean_rt) <= 3 * sd_rt      
  )

# scatterplot for raw reading times 
ggplot(results_SPR_cleaned_long, aes(x=region, y=Reading.time, color=condition)) + geom_point() 

# apply the absolute thresholds 
results_SPR_cleaned_long <- filter(results_SPR_cleaned_long, Reading.time >= 100 & Reading.time <= 3000)

results_SPR_cleaned_long_abil <- filter(results_SPR_cleaned_long, lex.type == "ability")

str(results_SPR_cleaned_long_abil)
View(results_SPR_cleaned_long_abil)

results_SPR_cleaned_long_abil$region <- factor(results_SPR_cleaned_long_abil$region, level = c("1","2","3","4","5","6","7","8","9","10","11","12"), label = c("1","2","3","4","5","6","und","auch","subj","aux","MF","verb"))

# plot raw reading times

agg_data_abil_allregions <- results_SPR_cleaned_long_abil %>%
  group_by(region, condition) %>%
  summarise(mean_RT = mean(Reading.time), 
            se = sd(Reading.time, na.rm = TRUE) / sqrt(n()),  
            ci = 1.96 * se,  
            .groups = "drop") 

# ability, raw RTs, all regions, with ribbons

ggplot(agg_data_abil_allregions, aes(x = region, y = mean_RT, group = condition, color = condition)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  geom_ribbon(aes(ymin = mean_RT - ci, ymax = mean_RT + ci, fill = condition), alpha = 0.1, color = NA) +
  labs(
    title = "Mean Reading Times Across Regions",
    x = "Region",
    y = "Mean Reading Time",
    color = "Condition"
  ) +
  theme_minimal()

# same for goal-oriented  --------------------

results_SPR_cleaned_long_goal <- filter(results_SPR_cleaned_long, lex.type == "goal")


View(results_SPR_cleaned_long_goal)

results_SPR_cleaned_long_goal$region <- factor(results_SPR_cleaned_long_goal$region, level = c("1","2","3","4","5","6","7","8","9","10","11","12","13","14"), label = c("1","2","3","4","5","6","7","8","und","auch","subj","aux","MF","verb"))

# plot raw reading times

agg_data_goal_allregions <- results_SPR_cleaned_long_goal %>%
  group_by(region, condition) %>%
  summarise(mean_RT = mean(Reading.time), 
            se = sd(Reading.time, na.rm = TRUE) / sqrt(n()),  
            ci = 1.96 * se,  
            .groups = "drop") 

# goal-oriented, raw RTs, all regions, with ribbons
ggplot(agg_data_goal_allregions, aes(x = region, y = mean_RT, group = condition, color = condition)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  geom_ribbon(aes(ymin = mean_RT - ci, ymax = mean_RT + ci, fill = condition), alpha = 0.1, color = NA) +
  labs(
    title = "Mean Reading Times Across Regions",
    x = "Region",
    y = "Mean Reading Time",
    color = "Condition"
  ) +
  theme_minimal()

# ------------------------------- plot resRTs --------------------------

# Value column contains the sentences, turn to character values 
results_SPR_cleaned_long$Value <- as.character(results_SPR_cleaned_long$Value)


#create a new column for word length
results_SPR_cleaned_long$word_length <- nchar(results_SPR_cleaned_long$Value)


# new df with column for residual RTs
residual_data_long <- results_SPR_cleaned_long %>%
  group_by(Participant_ID) %>%
  group_modify(~ {
    model <- lm(Reading.time ~ word_length + region, data = .x)  
    .x$predicted_RT <- predict(model)
    .x$residuals <- residuals(model)  
    return(.x)  
  }) %>%
  ungroup()

View(residual_data_long)

residual_data_long_goal <- filter(residual_data_long, lex.type == "goal")


View(residual_data_long_goal)

residual_data_long_goal$region <- factor(residual_data_long_goal$region, level = c("1","2","3","4","5","6","7","8","9","10","11","12","13","14"), label = c("1","2","3","4","5","6","7","8","und","auch","subj","aux","MF","verb"))

# reorder factors so that coloring the same as in ability conditions
residual_data_long_goal$condition <- factor(residual_data_long_goal$condition, levels = c("goal","epist_goal"))

# aggregate data for regions and conditions
agg_residual_data_long_goal <- residual_data_long_goal %>%
  group_by(region, condition) %>%
  summarise(mean_ResRT = mean(residuals), 
            se = sd(residuals, na.rm = TRUE) / sqrt(n()),  
            ci = 1.96 * se,   
            .groups = "drop")

# plot aggregated residual RTs
ggplot(agg_residual_data_long_goal, aes(x = region, y = mean_ResRT, group = condition, color = condition)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_ribbon(aes(ymin = mean_ResRT - ci, ymax = mean_ResRT + ci, fill = condition), alpha = 0.1, color = NA) +
  labs(
    title = "Mean Residual Reading Times Across Regions",
    x = "Region",
    y = "Mean Residual Reading Time",
    color = "Condition"
  ) +
  theme_minimal()

# same for ability
residual_data_long_abil <- filter(residual_data_long, lex.type == "ability")


View(residual_data_long_abil)

residual_data_long_abil$region <- factor(residual_data_long_abil$region, level = c("1","2","3","4","5","6","7","8","9","10","11","12"), label = c("1","2","3","4","5","6","und","auch","subj","aux","MF","verb"))


# aggregate data for regions and conditions
agg_residual_data_long_abil <- residual_data_long_abil %>%
  group_by(region, condition) %>%
  summarise(mean_ResRT = mean(residuals), 
            se = sd(residuals, na.rm = TRUE) / sqrt(n()),  
            ci = 1.96 * se,   
            .groups = "drop") 

# plot aggregated residual RTs
ggplot(agg_residual_data_long_abil, aes(x = region, y = mean_ResRT, group = condition, color = condition)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_ribbon(aes(ymin = mean_ResRT - ci, ymax = mean_ResRT + ci, fill = condition), alpha = 0.1, color = NA) +
  labs(
    title = "Mean Residual Reading Times Across Regions",
    x = "Region",
    y = "Mean Residual Reading Time",
    color = "Condition"
  ) +
  theme_minimal()

q()

