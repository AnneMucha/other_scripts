library(plyr)
library(dplyr) 
library(readr)

# create df for baseline ("neither") condition
freq_neither_tri <- read.csv("quant_eng_director_neither_triangle.csv")
freq_neither_cir <- read.csv("quant_eng_director_neither_circle.csv")

freq_neither <- rbind(freq_neither_tri, freq_neither_cir)

freq_neither$experiment <- "partner-, dist-"
View(freq_neither)

# create df for distractor-only condition
freq_distractor_tri <- read.csv("quant_eng_director_dist_triangle.csv")
freq_distractor_cir <- read.csv("quant_eng_director_dist_circle.csv")

freq_distractor <- rbind(freq_distractor_tri, freq_distractor_cir)

freq_distractor$experiment <- "partner-, dist+"
View(freq_distractor)

# create df for partner-only condition
freq_interaction_tri <- read.csv("quant_eng_director_interactive_triangle.csv")
freq_interaction_cir <- read.csv("quant_eng_director_interactive_circle.csv")


# select columns, combine circle and triangle conditions
freq_interaction_tri_red <- select(freq_interaction_tri, c("PARTICIPANT_ID","trial_index", "trial_type","shape_cond", "observation_label",
                                                           "actual_stimulus", "condition", "label", "frequent_shape"))

freq_interaction_cir_red <- select(freq_interaction_cir, c("PARTICIPANT_ID","trial_index", "trial_type","shape_cond", "observation_label",
                                                           "actual_stimulus", "condition", "label", "frequent_shape"))

freq_interaction <- rbind(freq_interaction_tri_red, freq_interaction_cir_red) 

freq_interaction$experiment <- "partner+, dist-"
View(freq_interaction)


# create df for combined condition
freq_combined_tri <- read.csv("quant_eng_director_combined_triangle.csv")
freq_combined_cir <- read.csv("quant_eng_director_combined_circle.csv")

freq_combined_tri_red <- select(freq_combined_tri, c("PARTICIPANT_ID","trial_index", "trial_type","shape_cond", "observation_label",
                                                           "actual_stimulus", "condition", "label", "frequent_shape"))

freq_combined_cir_red <- select(freq_combined_cir, c("PARTICIPANT_ID","trial_index", "trial_type","shape_cond", "observation_label",
                                                           "actual_stimulus", "condition", "label", "frequent_shape"))

freq_combined <- rbind(freq_combined_tri_red, freq_combined_cir_red)


freq_combined$experiment <- "partner+, dist+"
View(freq_combined)

# select columns for static experiment conditions
freq_neither_reduced <- select(freq_neither, c("PARTICIPANT_ID","trial_index", "trial_type", "shape", "observation_label", "stimulus",
                                               "condition", "label", "frequent_shape", "experiment"))

freq_distractor_reduced <- select(freq_distractor, c("PARTICIPANT_ID","trial_index", "trial_type", "shape", "observation_label", "stimulus",
                                                     "condition", "label", "frequent_shape", "experiment"))


# change diverging condition names, turn into factors
freq_distractor_reduced <- freq_distractor_reduced %>% mutate(condition = factor(condition, levels = c("tri nex", "circle nex", "tri nuni", "circle nuni"), 
                                                              labels =  c("triangle nex", "circle nex", "triangle nuni", "circle nuni")))

freq_neither_reduced <- freq_neither_reduced %>% mutate(condition = factor(condition, levels = c("tri nex", "circle nex", "tri nuni", "circle nuni"), 
                                                                                 labels =  c("triangle nex", "circle nex", "triangle nuni", "circle nuni")))

freq_distractor_reduced <- freq_distractor_reduced %>% mutate(shape = factor(shape, levels = c("tri", "circle"), 
                                                                                 labels =  c("triangle", "circle")))

freq_neither_reduced <- freq_neither_reduced %>% mutate(shape = factor(shape, levels = c("tri", "circle"), 
                                                                       labels =  c("triangle", "circle")))

View(freq_neither_reduced)

# rename stimulus columns
freq_combined <- plyr::rename(freq_combined, c("actual_stimulus" = "stimulus", "shape_cond" = "shape"))
freq_interaction <- plyr::rename(freq_interaction, c("actual_stimulus" = "stimulus", "shape_cond" = "shape"))

# add columns for interaction and distractor
freq_combined$has_partner <- 1
freq_combined$has_distractor <- 1

freq_interaction$has_partner <- 1
freq_interaction$has_distractor <- 0

freq_distractor_reduced$has_partner <- 0
freq_distractor_reduced$has_distractor <- 1

freq_neither_reduced$has_partner <- 0
freq_neither_reduced$has_distractor <- 0

# turn relevant columns into factors
freq_combined <- freq_combined %>%
  mutate(across(c("shape", "stimulus", "condition", "label", "experiment", "frequent_shape", "has_partner", "has_distractor"), as.factor))

freq_interaction <- freq_interaction %>%
  mutate(across(c("shape","stimulus", "condition", "label", "experiment", "frequent_shape", "has_partner", "has_distractor"), as.factor))

freq_distractor_reduced <- freq_distractor_reduced %>%
  mutate(across(c("shape","stimulus", "condition", "label", "experiment","frequent_shape", "has_partner", "has_distractor"), as.factor))

freq_neither_reduced <- freq_neither_reduced %>%
  mutate(across(c("shape","stimulus", "condition", "label", "experiment","frequent_shape", "has_partner", "has_distractor"), as.factor))

# combine dfs from all between-subject conditions
quant_freq_all_experiments <- rbind(freq_combined, freq_interaction, freq_distractor_reduced, freq_neither_reduced)

View(quant_freq_all_experiments)
str(quant_freq_all_experiments)

# create an additional "item" column from the stimulus and frequent shape
quant_freq_all_experiments <- quant_freq_all_experiments %>%
  mutate(
    item = paste0(stimulus, "_", frequent_shape),
    item = factor(item)
  )

# create a column "condition_new" that replaces "triangle/circle" with +/- frequent shape
quant_freq_all_experiments <- quant_freq_all_experiments %>%
  mutate(
    shape_in_condition = sub(" .*", "", condition),     
    type_in_condition  = sub(".* ", "", condition),     
    
    condition_new = case_when(
      shape_in_condition == frequent_shape ~ paste0("+frequent_", type_in_condition),
      TRUE                                ~ paste0("-frequent_", type_in_condition)
    ),
    condition_new = factor(condition_new)
  )

View(quant_freq_all_experiments)

# order factors, make plot
library(ggplot2)
quant_freq_all_experiments$label <-factor(quant_freq_all_experiments$label, levels = c('weak','comp','lexical'))
quant_freq_all_experiments$condition_new <- factor(quant_freq_all_experiments$condition_new, levels =c('+frequent_nex','-frequent_nex','+frequent_nuni','-frequent_nuni'))
quant_freq_all_experiments$experiment <- factor(quant_freq_all_experiments$experiment, levels =c('partner+, dist+','partner+, dist-','partner-, dist+','partner-, dist-'))



cbp1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


plot_freq_all_experiments <- quant_freq_all_experiments %>%
  arrange(label) %>%
  ggplot(aes(x=condition_new, fill=label)) +
  geom_bar(position=position_fill(), colour="black", alpha = 0.8) +
  xlab("Stimulus conditions: +/- frequent shape, non-existential (¬∃) / non-universal (¬∀)") +
  ylab("Proportion of labels chosen") +
  scale_x_discrete(labels = c(
    "+frequent_nex"  = "+frequent ¬∃",
    "-frequent_nex"  = "-frequent ¬∃",
    "+frequent_nuni" = "+frequent ¬∀",
    "-frequent_nuni" = "-frequent ¬∀"
  )) +
  theme_bw() +
  theme(
    text         = element_text(family = "Segoe UI Symbol"),
    axis.text.x  = element_text(size = 10, family = "Segoe UI Symbol"),
    axis.text.y  = element_text(size = 6,  family = "Segoe UI Symbol"),
    strip.text   = element_text(size = 10, family = "Segoe UI Symbol"),
    axis.title.y = element_text(size = 13, family = "Segoe UI Symbol")
  ) +
  scale_fill_manual(values = cbp1) +
  scale_alpha_manual(values = c(1, .5), breaks = NULL) +
  facet_wrap(~experiment)

ggsave("plot_freq_all2.png", plot_freq_all_experiments, width=9.5, height=6, dpi=300, type = "cairo-png")

print(plot_freq_all_experiments)


q()


