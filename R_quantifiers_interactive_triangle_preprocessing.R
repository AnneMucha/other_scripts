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
# creates a list of files in the directory 
list_of_files_eng_freq <- list.files(path = "... /experiment_learning/quant_eng_frequency_interactive_revised/partner+dist+TRI",
                            recursive = TRUE,
                            pattern = "\\.xlsx$")

View(list_of_files_eng_freq)


quant_data_eng_freq <- Map(read_xlsx, list_of_files_eng_freq) # reads the data in the list
View(quant_data_eng_freq)

quant_eng_freq <- plyr::rbind.fill(quant_data_eng_freq) # creates the combined df, fills empty cells with NA, can handle inconsistent column number, includes headers
View(quant_eng_freq)

# -----------------------------------------------
# throw out empty columns
library(tidyverse)

empty_cols <- c("c_score", "survey_responses")

quant_eng_freq <- quant_eng_freq %>% select(-all_of(empty_cols))

# append the misplaced rows from the matcher trials
quant_eng_freq <- quant_eng_freq %>%
  mutate(
    actual_stimulus = ifelse(trial_type == "matcher",
                          lead(PARTICIPANT_ID,1),
                          button3),
    picture_choice = ifelse(trial_type == "matcher",
                          lead(trial_index,1),
                          button_selected),
    score = ifelse(trial_type == "matcher",
                   lead(button1,2),
                   score)
  )

#-------------------------------------------------
# analysis of director trials

quant_eng_freq_director <- filter(quant_eng_freq, trial_type == "director") 
View(quant_eng_freq_director)

# shape values based on stimuli (new column)
quant_eng_freq_director$shape_cond <- revalue(quant_eng_freq_director$button3, c("tri-nuni-red" = "triangle",
                                                                                "tri-nex-red" = "triangle",
                                                                                "tri-nex-blue" = "triangle",
                                                                                "circle-nuni-blue" = "circle",
                                                                                "circle-nex-red" = "circle",
                                                                                "circle-nex-blue" = "circle",
                                                                                "circle-nex-broken" = "circle",
                                                                                "circle-nuni-broken" = "circle",
                                                                                "circle-nex-filled" = "circle",
                                                                                "tri-nex-broken" = "triangle",
                                                                                "tri-nex-filled" = "triangle",
                                                                                "tri-nuni-filled" = "triangle"
))

# force values based on stimuli (new column)
quant_eng_freq_director$force_cond <- revalue(quant_eng_freq_director$button3, c("tri-nuni-red" = "nuni",
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

# revalue labels 
quant_eng_freq_director$label <- revalue(quant_eng_freq_director$observation_label, c("Nothing in this picture is blue" = "lexical", 
                                                                     "Nothing in this picture is broken" = "lexical", 
                                                                     "Nothing in this picture is filled" = "lexical",
                                                                     "Nothing in this picture is red" = "lexical",
                                                                     "Not everything in this picture is blue" = "weak",
                                                                     "Not everything in this picture is broken" = "weak",
                                                                     "Not everything in this picture is filled" = "weak",
                                                                     "Not everything in this picture is red" = "weak"
                                                                     
))

# revalue all remaining labels as "comp(ositional)" 
quant_eng_freq_director$label <- ifelse(quant_eng_freq_director$label %in% c("lexical", "weak"), quant_eng_freq_director$label, "comp")

# create a "condition" column from the force and shape columns
quant_eng_freq_director <- quant_eng_freq_director %>% mutate(condition = paste(shape_cond,force_cond))

# encode condition as a factor
quant_eng_freq_director$condition <- factor(quant_eng_freq_director$condition, levels =c('triangle nex','circle nex','triangle nuni','circle nuni'))

# add a column for the frequent shape
quant_eng_freq_director$frequent_shape <- "triangle"
View(quant_eng_freq_director)

q() 

