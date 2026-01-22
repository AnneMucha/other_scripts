library(plyr)
library(dplyr) 
library(readr)

# read complete data set (all experiments)
quant_freq_all_experiments <- read.csv("freq_main_complete.csv", encoding = "UTF-8")
View(quant_freq_all_experiments)

# plot sender/director data

# filter for director trials
quant_freq_all_experiments_director <- filter(quant_freq_all_experiments, trial_type == "director")
View(quant_freq_all_experiments_director)

# order factors
quant_freq_all_experiments_director$label <-factor(quant_freq_all_experiments_director$label, levels = c('weak','comp','lexical'))
quant_freq_all_experiments_director$condition_new <- factor(quant_freq_all_experiments_director$condition_new, levels =c('+frequent_nex','-frequent_nex','+frequent_nuni','-frequent_nuni'))
quant_freq_all_experiments_director$experiment <- factor(quant_freq_all_experiments_director$experiment, levels =c('partner+, dist+','partner+, dist-','partner-, dist+','partner-, dist-'))



cbp1 <- c("#999999", "#E69F00", "#56B4E9", "#009E73", 
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

library(ggplot2)

# proportion plot
plot_freq_all_experiments <- quant_freq_all_experiments_director %>%
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

print(plot_freq_all_experiments)

ggsave("plot_freq_all2.png", plot_freq_all_experiments, width=9.5, height=6, dpi=300, type = "cairo-png")


# Post-hoc analyses -------------------------------------------------

# Do conventional/optimal users get better results?

# filter for [+partner] experiments

quant_freq_all_experiments_partnered <- filter(quant_freq_all_experiments, has_partner == "1")
View(quant_freq_all_experiments_partnered)

# create an additional column to encode pairs
quant_freq_all_experiments_partnered <- quant_freq_all_experiments_partnered %>%
  mutate(
    pair_key = paste(
      pmin(PARTICIPANT_ID, partner_id),
      pmax(PARTICIPANT_ID, partner_id),
      sep = "_"
    ),
    pair = as.integer(factor(pair_key))
  ) %>%
  dplyr::select(-pair_key)

# filter for director trials
quant_freq_all_experiments_partnered_director <- filter(quant_freq_all_experiments_partnered, trial_type == "director")
View(quant_freq_all_experiments_partnered_director)

# add a column for the relative frequency of lexical labels in the +frequent non-existential trials
quant_freq_all_experiments_partnered_director <- quant_freq_all_experiments_partnered_director %>%
  group_by(pair) %>%
  mutate(
    relfreq_lexical_frequent_nex =
      mean(label == "lexical" & condition_new == "+frequent_nex") /
      mean(condition_new == "+frequent_nex")
  ) %>%
  ungroup()

# plot relating proportion of lexical labels to score by pair (not reported in the paper)

# aggregate data
pair_df <- quant_freq_all_experiments_partnered_director %>%
  group_by(pair) %>%
  summarise(
    final_score = first(final_score),
    relfreq_lexical_frequent_nex = first(relfreq_lexical_frequent_nex),
    has_distractor = as.factor(first(has_distractor)),
    .groups = "drop"
  )

plot_pair_score <- ggplot(pair_df,
       aes(x = final_score,
           y = relfreq_lexical_frequent_nex,
           color = has_distractor)) +
  geom_point(size = 3, alpha = 0.8) +
  labs(
    x = "Final score",
    y = "Relative frequency of 'lexical' label",
    color = "distractor",
    title = "Final score vs. relative frequency of label ''lexical'' for ''+frequent ¬∃'' pictures, by pair in +partner conditions"
  ) +
  # geom_text(aes(label = pair), vjust = -0.7, size = 2.8) + # adds pair numbers
  #facet_wrap(~has_distractor) +
   scale_color_manual(
    values = c("0" = "steelblue", "1" = "firebrick"),
    labels = c("0" = "no", "1" = "yes")
  ) +
  theme_minimal()

print(plot_pair_score)

ggsave("plot_score_lexical.png", plot_pair_score, width=9.5, height=6, dpi=300, type = "cairo-png",bg = "white")


# by-pair plot with non-existential trials, ordered by score (not reported in the paper)

# filter for non-existential
quant_freq_all_experiments_director_nex <- filter(quant_freq_all_experiments_partnered_director, type_in_condition == "nex")
View(quant_freq_all_experiments_director_nex)

quant_freq_all_experiments_director_nex$label <-factor(quant_freq_all_experiments_director_nex$label, levels = c('weak','comp','lexical'))
quant_freq_all_experiments_director_nex$condition_new <- factor(quant_freq_all_experiments_director_nex$condition_new, levels =c('+frequent_nex','-frequent_nex'))

# order pairs by final score
pair_order <- quant_freq_all_experiments_director_nex %>%
  group_by(pair) %>%
  summarise(final_score = first(final_score)) %>%
  arrange(desc(final_score))

df_plot_ordered <- quant_freq_all_experiments_director_nex %>%
  left_join(pair_order, by = "pair", suffix = c("", "_ord")) %>%
  mutate(
    pair = factor(pair, levels = pair_order$pair)
  )

# facet plot of director labels by pair, ordered by final score
plot_nex_ordered <- df_plot_ordered %>%
  arrange(label) %>%
  ggplot(aes(x=condition_new, fill=label)) +
  geom_bar(position=position_fill(), colour="black", alpha = 0.8) +
  xlab("Stimulus conditions: +/- frequent shape, non-existential (¬∃) / non-universal (¬∀)") +
  ylab("Proportion of labels chosen in the ¬∃ conditions") +
  ggtitle("Director choices in the ¬∃ conditions by pair, ordered by final score (desc)")+
  scale_x_discrete(labels = c(
    "+frequent_nex"  = "+frequent ¬∃",
    "-frequent_nex"  = "-frequent ¬∃",
    "+frequent_nuni" = "+frequent ¬∀",
    "-frequent_nuni" = "-frequent ¬∀"
  )) +
  theme_bw() +
  theme(
    text         = element_text(family = "Segoe UI Symbol"),
    axis.text.x  = element_text(size = 6, family = "Segoe UI Symbol"),
    axis.text.y  = element_text(size = 6,  family = "Segoe UI Symbol"),
    strip.text   = element_text(size = 10, family = "Segoe UI Symbol"),
    axis.title.y = element_text(size = 13, family = "Segoe UI Symbol")
  ) +
  scale_fill_manual(values = cbp1) +
  scale_alpha_manual(values = c(1, .5), breaks = NULL) +
  facet_wrap(~pair)

print(plot_nex_ordered)

ggsave("plot_nex_labels_ordered.png", plot_nex_ordered, width=9, height=6.5, dpi=300, type = "cairo-png",bg = "white")

# implementing a measure of convergence (independent of direction) ---------------

# filter for non-weak labels

quant_freq_all_experiments_director_nex_noweak <- filter(quant_freq_all_experiments_director_nex, label != "weak")
View(quant_freq_all_experiments_director_nex_noweak)

# aggregate convergence by pair
pair_convergence <- quant_freq_all_experiments_director_nex_noweak %>%
  group_by(pair) %>%
  summarise(
    p_lex_plus = # convergence in the predicted direction
      mean(label == "lexical" & condition_new == "+frequent_nex") /
      mean(condition_new == "+frequent_nex"),
    convergence = abs(p_lex_plus - 0.5) * 2,
    direction =
      ifelse(p_lex_plus > 0.5, "lexical_plus", "compositional_plus"),
    final_score = first(final_score),
    has_distractor = first(has_distractor),
    .groups = "drop"
  )

View(pair_convergence)

# linear model predicting final score from convergence 
model_score_conv <- lm(final_score ~ convergence, data = pair_convergence)
summary(model_score_conv)
confint(model_score_conv)

# model testing for interaction with direction
model_score_conv_dir <- lm(final_score ~ convergence * direction, data = pair_convergence)
summary(model_score_conv_dir)

# control for effect of distractor
model2 <- lm(final_score ~ convergence * has_distractor, data = pair_convergence)
summary(model2)


# plot the relation between convergence and final score (for "lexical+" and "compositional+" pairs)
ggplot(pair_convergence,
       aes(x = convergence,
           y = final_score,
           color = direction)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    x = "Strength of convergence",
    y = "Final score",
    color = "convention",
    title = "Stronger convergence predicts higher final score regardless of convention direction"
  ) +
  theme_minimal()

# taking direction into account (signed convergence)

# create an updated convergence table 

pair_convergence_updated <- quant_freq_all_experiments_director_nex_noweak %>%
  group_by(pair) %>%
  summarise(
    p_lex_plus = # P(lexical | +frequent)
      mean(label == "lexical" & condition_new == "+frequent_nex") /
      mean(condition_new == "+frequent_nex"),
    convergence = abs(p_lex_plus - 0.5) * 2,
    direction =
      ifelse(p_lex_plus > 0.5,
             "lexical_plus",
             "compositional_plus"),
    signed_convergence =
      convergence *
      ifelse(p_lex_plus > 0.5, 1, -1),
    final_score = first(final_score),
    has_distractor = first(has_distractor),
    .groups = "drop"
  )

View(pair_convergence_updated)

# sanity checks
summary(pair_convergence_updated$signed_convergence)

table(pair_convergence_updated$direction,
      pair_convergence_updated$signed_convergence > 0)

#  intercept-only model and equivalent t-test
model_simple <- lm(signed_convergence ~ 1, data = pair_convergence_updated)
summary(model_simple) 

t.test(pair_convergence_updated$signed_convergence, mu = 0)

# -----------------------------------------------------------------------

# Time course of change in the probability of choosing the compositional form over repetitions 

View(quant_freq_all_experiments_partnered_director)

# filter out non-universal conditions and weak labels
quant_partnered_director_freq_nex <- filter(quant_freq_all_experiments_partnered_director, type_in_condition == "nex" & label != "weak")
View(quant_partnered_director_freq_nex)

# create a "repetition" column (order by +/- frequent condition for each participant)
quant_partnered_director_freq_nex <- quant_partnered_director_freq_nex %>%
  arrange(PARTICIPANT_ID, trial_index) %>%
  group_by(PARTICIPANT_ID, condition_new) %>%
  mutate(repetition = row_number()) %>%
  ungroup()

# calculate probabilities of compositional form for each repetition
participant_rep <- quant_partnered_director_freq_nex %>%
  group_by(has_distractor, PARTICIPANT_ID, condition_new, repetition) %>%
  summarise(
    p_compositional = mean(label == "comp"),
    .groups = "drop"
  )

View(participant_rep)

# aggregate
summary_rep <- participant_rep %>%
  group_by(has_distractor, condition_new, repetition) %>%
  summarise(
    mean_p = mean(p_compositional),
    se_p   = sd(p_compositional) / sqrt(n()),
    ci = qt(0.975, df = n() - 1) * sd(p_compositional) / sqrt(n()),
    n = n(),
    .groups = "drop"
  )

View(summary_rep)

ggplot(summary_rep,
       aes(x = repetition,
           y = mean_p,
           color = condition_new,
           group = condition_new)) +
  geom_point(size = 2) +
  geom_line() +
  geom_errorbar(
    aes(ymin = mean_p - se_p,
        ymax = mean_p + se_p),
    width = 0.15
  ) +
  labs(
    x = "repetition",
    y = "P(compositional)",
    color = "condition",
    title = "Probability of compositional labels for non-existential pictures across repetitions"
  ) +
  facet_wrap(~has_distractor, labeller = labeller(
   has_distractor = c(
     "0" = "- distractor",
     "1" = "+ distractor")))+
  theme_minimal()

View(quant_partnered_director_freq_nex)

# --------------------------------------------------------------------------------------------------------------

# Are people less accurate when the director chose the compositional form?

# use df containing only partnered conditions and pair numbers

View(quant_freq_all_experiments_partnered)

# add the "matcher_response" column to the "director" rows

# create a within-pair counter separately for director and matcher
quant_freq_all_experiments_partnered_counter <- quant_freq_all_experiments_partnered %>%
  arrange(pair, trial_index) %>%
  group_by(pair) %>%
  mutate(
    trial_number = if_else(
      trial_type == "director",
      cumsum(trial_type == "director"),
      cumsum(trial_type == "matcher")
    )
  ) %>%
  ungroup()

# extract matcher responses
matcher_responses <- quant_freq_all_experiments_partnered_counter %>%
  filter(trial_type == "matcher") %>%
  dplyr::select(pair, trial_number, matcher_response)

# join matcher responses onto director rows
quant_freq_all_experiments_partnered <- quant_freq_all_experiments_partnered_counter %>%
  left_join(
    matcher_responses,
    by = c("pair", "trial_number")
  ) %>%
  mutate(
    director_matcher_response = if_else(
      trial_type == "director",
      matcher_response.y,
      NA_character_
    )
  ) %>%
  dplyr::select(-matcher_response.y)


# filter for director trials with non-existential pictures
quant_freq_all_experiments_accuracy <- filter(quant_freq_all_experiments_partnered, trial_type == "director" & type_in_condition == "nex")

# create a column with the force of the picture chosen by the matcher
library(stringr)

quant_freq_all_experiments_accuracy <- quant_freq_all_experiments_accuracy %>%
  mutate(
    matcher_choice_force = str_extract(
      director_matcher_response,
      "(?<=-)(nex|nuni)(?=-)"
    )
  )

View(quant_freq_all_experiments_accuracy)

# filter for errors with non-existential pictures

quant_freq_all_experiments_nex_errors <- filter(quant_freq_all_experiments_accuracy, matcher_choice_force == "nuni")
View(quant_freq_all_experiments_nex_errors)

# plot errors
quant_freq_all_experiments_nex_errors$label <- factor(quant_freq_all_experiments_nex_errors$label, levels = c('weak','comp','lexical'))

plot_nex_errors <- quant_freq_all_experiments_nex_errors %>%
  arrange(label) %>%
  ggplot(aes(x=label, fill=label)) +
  #facet_grid(.~force_cond, drop=T,scales = "free") +
  geom_bar(position = position_dodge(),stat= "count",colour="black", alpha = 0.8) +
  geom_text(aes(label = after_stat(count)),
            stat = "count", position = "fill"
  ) +
  ggtitle('Non-existential pictures wrongly matched as non-universal')+
  xlab("Labels chosen by director in the +partner conditions") +
  ylab("Number of labels chosen")+
  theme_bw() +
  theme(axis.text.x =element_text(size=10),
        axis.text.y = element_text(size=10),
        axis.title.y = element_text(size=13))+
  scale_fill_manual(values=cbp1) +
  #scale_y_continuous(labels = percent) +
  scale_alpha_manual(values=c(1,.5),breaks=NULL) +
  ylim(0,60) +
facet_wrap(~ has_distractor, labeller = labeller(
  has_distractor = c(
    "0" = "- distractor",
    "1" = "+ distractor")))

print(plot_nex_errors)

# table summary
library(tidyr)

table_nex_errors <- quant_freq_all_experiments_nex_errors %>%
  count(label, has_distractor) %>%
  mutate(
    has_distractor = recode(
      as.character(has_distractor),
      "0" = "- distractor",
      "1" = "+ distractor"
    )
  ) %>%
  pivot_wider(
    names_from = has_distractor,
    values_from = n,
    values_fill = 0
  ) %>%
  rename(Label = label)

print(table_nex_errors)

# calculate error rates
quant_freq_all_experiments_nex_errors_comp_dist <- filter(quant_freq_all_experiments_accuracy, label == "comp" & has_distractor == 1)
View(quant_freq_all_experiments_nex_errors_comp_dist)
# error rate comp, +dist
53 / 359 * 100


quant_freq_all_experiments_nex_errors_comp_nodist <- filter(quant_freq_all_experiments_accuracy, label == "comp" & has_distractor == 0)
View(quant_freq_all_experiments_nex_errors_comp_nodist)
# error rate comp, -dist
1 / 386 * 100

quant_freq_all_experiments_nex_errors_lex_dist <- filter(quant_freq_all_experiments_accuracy, label == "lexical" & has_distractor == 1)
View(quant_freq_all_experiments_nex_errors_lex_dist)
# error rate lex, +dist
5 / 806 * 100

quant_freq_all_experiments_nex_errors_lex_nodist <- filter(quant_freq_all_experiments_accuracy, label == "lexical" & has_distractor == 0)
View(quant_freq_all_experiments_nex_errors_lex_nodist)
# error rate lex, -dist
1 / 567 * 100


q()


