library(lme4)
library(MASS)
library(ggplot2)
library(plyr)
library(dplyr) 
library(data.table)
library(scales)
library(purrr)
library(stringr)
library(readr)
library(readxl)

# function for reading PCIbex output
read.pcibex <- function(filepath, auto.colnames=FALSE, fun.col=function(col,cols){cols[cols==col]<-paste(col,"Ibex",sep=".");return(cols)}) {
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

# read data
pilot_data <- read.pcibex("selection_pilot_results.csv")

View(pilot_data)

# rename columns
pilot_data <- plyr::rename(pilot_data,c("X2" = "IP_sign","X4"="order_number", "X6" = "trial_type", "X8" = "controller","X9" = "controller_type", "X10" = "index", 
                                            "X11" = "response","X12"="time_stamp", "X13" = "ID", "X14" = "answer_options"))

#filter for selection trials
pilot_data <- filter(pilot_data, controller == "Selector")


# look at control trials

pilot_attention <- pilot_data %>% filter(trial_type %in% c("friends-control","football-control","neighbours-control")) %>% 
  group_by(trial_type) %>% summarise(count_ones = sum(response != 1, na.rm = TRUE))

View(pilot_attention)


# explore modal trials

pilot_modals <- pilot_data %>% filter(str_detect(trial_type, "modal"))

View(pilot_modals)

cbp1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

plot_modals <- pilot_modals %>%
  arrange(response) %>%
  ggplot(aes(x=trial_type, fill=response)) +
  geom_bar (position=position_fill(),colour="black", alpha = 0.8) +
  xlab("Item") +
  ylab("Proportion of flavour chosen")+
  theme_bw() +
  theme(axis.text.x =element_text(size=8),
        axis.text.y = element_text(size=6),
        axis.title.y = element_text(size=13))+
  scale_fill_manual(values=cbp1) +
  scale_alpha_manual(values=c(1,.5),breaks=NULL) 

print(plot_modals)

plot_modals2 <- ggplot(pilot_modals, aes(x = response, fill = response)) +
  geom_bar() +
  geom_text(
    stat = "count",
    aes(label = after_stat(count)),
    vjust = -0.3
  ) +
  theme_bw() +
  theme(axis.text.x =element_text(size=8),
        axis.text.y = element_text(size=6),
        axis.title.y = element_text(size=13))+
  scale_fill_manual(values=cbp1) +
  scale_alpha_manual(values=c(1,.5),breaks=NULL)


print(plot_modals2)

# explore quantifier examples

pilot_quant <- pilot_data %>% filter(str_detect(trial_type, "quant"))

View(pilot_quant)

plot_quant <- pilot_quant %>%
  arrange(response) %>%
  ggplot(aes(x=trial_type, fill=response)) +
  geom_bar (position=position_fill(),colour="black", alpha = 0.8) +
  xlab("Item") +
  ylab("Proportion of quantifiers chosen")+
  theme_bw() +
  theme(axis.text.x =element_text(size=8),
        axis.text.y = element_text(size=6),
        axis.title.y = element_text(size=13))+
  scale_fill_manual(values=cbp1) +
  scale_alpha_manual(values=c(1,.5),breaks=NULL) 


print(plot_quant)

plot_quant2 <- ggplot(pilot_quant, aes(x = response, fill = response)) +
  geom_bar() +
  geom_text(
    stat = "count",
    aes(label = after_stat(count)),
    vjust = -0.3
  ) +
  theme_bw() +
  theme(axis.text.x =element_text(size=8),
        axis.text.y = element_text(size=6),
        axis.title.y = element_text(size=13))+
  scale_fill_manual(values=cbp1) +
  scale_alpha_manual(values=c(1,.5),breaks=NULL)

print(plot_quant2)


q()




