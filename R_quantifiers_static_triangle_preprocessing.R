library(lme4)
library(MASS)
library(ggplot2)
library(plyr)
library(dplyr) 
library(car)
library(data.table)
library(scales)
library(purrr)
library(stringr)
library(readr)
library(readxl)

# read in all data files 
data_path <- ".../experiment_learning/quant_english_frequency_static_revised/partner-dist+TRI"   # path to files
files <- dir(data_path, pattern = "\\.xlsx$") 


data_n <- data.frame(filename = files) %>%
  mutate(file_contents = map(filename,      
                             ~ read_xlsx(file.path(data_path, .))) 
  )


library(tidyr)
data_eng_freq_static <- unnest(data_n,cols = c(file_contents))
View(data_eng_freq_static)

# build column "PARTICIPANT_ID" from filenames
data_eng_freq_static <- data_eng_freq_static %>%
  mutate(PARTICIPANT_ID = sub(".*_(.*)\\.xlsx", "\\1", filename))

View(data_eng_freq_static)

data_eng_freq_static_clean <- select(data_eng_freq_static, c("PARTICIPANT_ID", "...2","...3","...4","...5","...6","...7","...8","...9","...10"))
View(data_eng_freq_static_clean)

names(data_eng_freq_static_clean) <- c("PARTICIPANT_ID","trial_index",	"trial_type", "shape",	"stimulus", "number", "RT",
                               "observation_label",	"score", "cumulative_score")


# force values based on stimuli (new column)
data_eng_freq_static_clean$force_cond <- revalue(data_eng_freq_static_clean$stimulus, c("tri-nuni-red" = "nuni",
                                                                                        "tri-nex-red" = "nex",
                                                                                        "tri-nex-blue" = "nex",
                                                                                        "circle-nuni-blue" = "nuni",
                                                                                        "circle-nex-red" = "nex",
                                                                                        "circle-nex-blue" = "nex",
                                                                                        "circle-nex-broken" = "nex",
                                                                                        "circle-nuni-broken" = "nuni",
                                                                                        "circle-nex-filled" = "nex",
                                                                                        "tri-nex-broken" = "nex",
                                                                                        "tri-nex-filled" = "nex",
                                                                                        "tri-nuni-filled" = "nuni"
))

View(data_eng_freq_static_clean)

# create a "condition" column from the force and shape columns
data_eng_freq_static_clean <- data_eng_freq_static_clean %>% mutate(condition = paste(shape,force_cond))

# revalue the labels 
data_eng_freq_static_clean$label <- revalue(data_eng_freq_static_clean$observation_label, c("Nothing in this picture is blue" = "lexical", 
                                                                                            "Nothing in this picture is broken" = "lexical", 
                                                                                            "Nothing in this picture is filled" = "lexical",
                                                                                            "Nothing in this picture is red" = "lexical",
                                                                                            "Not everything in this picture is blue" = "weak",
                                                                                            "Not everything in this picture is broken" = "weak",
                                                                                            "Not everything in this picture is filled" = "weak",
                                                                                            "Not everything in this picture is red" = "weak"
                                                                                            
))

# revalue all other cases as "nex_comp" 
data_eng_freq_static_clean$label <- ifelse(data_eng_freq_static_clean$label %in% c("lexical", "weak"), data_eng_freq_static_clean$label, "comp")

# factors
data_eng_freq_static_clean$condition <- factor(data_eng_freq_static_clean$condition, levels =c('tri nex','circle nex','tri nuni','circle nuni'))
data_eng_freq_static_clean$PARTICIPANT_ID <- factor(data_eng_freq_static_clean$PARTICIPANT_ID)

# filter for director trials

data_eng_freq_static_clean <- filter(data_eng_freq_static_clean, trial_type == 'director')

#add column for frequent shape
data_eng_freq_static_clean$frequent_shape <- "triangle"

View(data_eng_freq_static_clean)

q()




