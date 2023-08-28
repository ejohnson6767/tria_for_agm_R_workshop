# setup -------------------------------------------------------------------
# uncomment to install
#install.packages("tidyverse")
library(tidyverse)


# 1. read in the alberta disk data ----------------------------------------
# HINT: use the read.csv function, check your working directory

# SOLUTION
getwd() # check working directory
# setwd("C:/Users/keked/OneDrive - University of Victoria/PhD/TRIA-FoR/RWorkshop")
setwd("C:/Users/panch/Documents/GitHub/tria_for_agm_R_worshop") # if the working directory does not contain the dataset, then set working directory
# a MUCH better solution is to make an R project and use the here package, but this is outside the scope of this workshop

df0 <- read.csv("ab_disk_data.csv") # load the data
df0 = read_csv("~/GitHub/tria_for_agm_R_worshop/ab_disk_data.csv")

# 2A data cleaning -------------------------------------------------------
# Sometimes, field crews accidentally sample a tree with no entry holes. It is likely that these trees were either not attacked, or were not sucessfully attacked. 
# take the dataframe and remove all observations with zero entry holes.

# SOLUTION
df1 <- df0 %>% filter(entry_holes > 0)

unique(is.na(df1$entry_holes))

df1[which(is.na(df1$entry_holes)),]

# alternative base r solution
df1 <- df0[which(df0$entry_holes > 0),]



# 2B. data cleaning -----------------------------------------------------
# We only want to consider trees that were successfully attacked. Even if adult beetles bore into the tree, resinosis (i.e. tree resin defenses) can kill the eggs. 
# Thus, we say that trees without any larvae or pupae (dead or alive) at the time of sampling were not successfully attacked. We want to remove these observations from the dataframe.
# HINt: use the OR operator (i.e. | ), or create a new variable for the sum of larvae and pupae (dead and alive)

# SOLUTIONS
df2 <- df1 %>% filter(larvae > 0 | pupae>0 | dead_pupae > 0)

#  or...
df2 <- df1 %>% mutate(brood = larvae+pupae+dead_pupae) %>%
  filter(brood > 0)

df2[which(df2$larvae > 0 | df2$pupae > 0 | df2$dead_pupae),]

# 2C. data cleaning -----------------------------------------------------
# remove all NAs from the dataframe. If we were to keep these NAs, they would cause errors and warnings later on. 

# SOLUTION
df3 <- df2 %>% drop_na()

# base r solution
df3 <- na.omit(df2)

# 3. creating columns -----------------------------------------------------
# create a new column called "fitness". This should contain per female fecundity, which is the number of females that will exit the tree, divided by the number of females entering the tree. Only females bore into the tree, creating the entry holes. Assume that all live_brood individuals will leave the tree. Keep in mind that only females make entry holes, but that the brood (i.e. larvae, pupae, and adult) sex ratio is 50:50. 

# SOLUTION
df4 <- df3 %>% mutate(fitness = 0.5*live_brood/entry_holes)

df3$fitness = 0.5 * df3$live_brood/df3$entry_holes

glimpse(df3)

# 4: scatter plots -----------------------------------------------------
# is ecological fitness associated with tree diameter? Answer this question with a scatterplot.

# SOLUTION
df4 %>% ggplot(aes(x = dbh, y= fitness)) + 
  geom_point() + 
  geom_smooth(method = "lm")

plot(x = df4$dbh, y = df4$fitness)

# R-based version
mod = lm(df4$fitness ~ df4$dbh)
plot(x = df4$dbh, y = df4$fitness, xlab = "DBH", ylab = "Fitness")
abline(mod, col = "red")

# 5. linear regression ----------------------------------------------------
# is ecological fitness associated with tree diameter? Answer this question with a linear regression. print the results of the regression with the "summary" function.
# bonus conceptual questions to discuss with your partner(s): what does the sign of the coefficient tell us? What does the R-squared value tell us?

# SOLUTION
mod1 <- lm(fitness ~ dbh, data=df4)
summary(mod1)
# ecological fitness is positively associated with tree diameter. The sign of coefficient tells us whether the statistical relationship is positive or negative. The r-squared tells you the proportion of explained variance. Here, the R-squared is 0.04, so there is a lot of variation in fitness, even after accounting for tree diameter.

# 6: merging/joining data frames -----------------------------------------------------
# load the temperature data with read.csv

# combine the temperature data with your other dataframe (i.e. the result from question 4), by matching the "site" variables across rows.
# HINT: "join_" functions in dplyr and "merge" in base R., 
# HINT: use the multiple = "first" argument to avoid the warning (you can look at the documentation if you want, but you don't have to worry about what this is doing)
# SOLUTION

temp <- read.csv("ab_temp_data.csv")
df5 <- left_join(df4, temp,
                 by = c("site"),
                 multiple = "first")



# 7. user-defined functions -----------------------------
# Now that we have temperature in our dataframe, we ask which is more important for beetle fitness, minimum winter temperature (t_min), or tree diameter (dbh)?

# To figure this out, we will be fitting a multiple regression and comparing regression coefficients. However, the regression coefficients depend on the units of the predictors.

# So first, in order to make the predictors unitless, we will be *standardizing* the predictors, which involves first subtracting the mean, and then dividing by the standard deviation. write your own function called std and use it in the code snippet below
# 

# make sure to replace your_df_name and new_df_name
new_df_name <- your_df_name %>% 
  mutate(std_t_min = std(t_min),
         std_dbh = std(dbh))


# SOLUTION
std <- function(x,...){
  return((x-mean(x,...))/sd(x,...))
}

df6 <- df5 %>% 
  mutate(std_t_min = std(t_min),
         std_dbh = std(dbh))

# 8. multiple regression -----------------------------------------------------
# Now that we have standardized our predictors, run a multiple regression with std_t_min and std_dbh as your predictors. The predictor with the largest coefficient is the more important predictor, in the sense that fitness changes more across the natural range of variability in that predictor.
# which variable is the more important predictor of beetle fitness?

# SOLUTION
mod2 <- lm(fitness ~ std_t_min + std_dbh, data=df6) #DF6
summary(mod2)
# temperature is more important, but just barely. It is fair to say that both variables are approximately equally important.

# 9. making a map -----------------------------------------------------
# use the latitude and longitude columns plot plot the locations of 

# First, use this code to download the polygon for alberta
# uncomment the following two lines to download the packages
# install.packages("rnaturalearth")
# install.packages("rnaturalearthdata")
library(rnaturalearth)
canada_states <- ne_states(country = "Canada", returnclass = "sf")
alberta <- subset(canada_states, name == "Alberta")

# add onto this code to plot the locations of the disk data
ggplot(data = alberta) +
  geom_sf() + 
  ggtitle("Disk data sampling locations") # add here

  
# SOLUTION
ggplot(data = alberta) +
  geom_sf() + 
  ggtitle("Disk data sampling locations") + 
  geom_point(data = df4, aes(x = longitude, y = latitude), color = 'red', size = 3) +
  theme_minimal()

# 10. summarizing data --------------------------------------------------------
# Next, we are going ask if there is overcompensatory density dependence. 
# Overcompensation is when more females going into the tree results in less females coming out of the tree. 
# If we see overcompensation, it would be evidence of extreme competition for phloem resources.

# to figure out if overcompensation is going on, we could make a scatterplot, like this:
df5 %>%
  mutate(females_out = live_brood/2) %>%
  ggplot(aes(x = entry_holes, y=females_out)) + 
  geom_point()
#.... but, the data are very noisy, and the clustering of data around integer values of entry_holes makes it difficult to see the distribution of live_brood. 
# To make things clearer, we are going to plot the summary statistics of this data. 

# For each unique value of the entry_holes, calculate the mean and standard error of the number of resulting females. Exclude rows where the standard error is NA (b/c there are not enough data)
# HINT: group_by

# SOLUTION
df7 <- df5 %>% 
  mutate(females_out = live_brood/2) %>%
  group_by(entry_holes) %>%
  summarize(m = mean(females_out/2),
            se = sd(females_out/2)/sqrt(n())) %>%
  filter(!is.na(se))


# 11. plotting summary statistics --------------------------------------------------
# make a plot that looks like overcompensation_plot.png in the main folder. Don't worry if the formatting (e.g. font size) doesn't match exactly.

# SOLUTION
df7 %>% ggplot(aes(x = entry_holes, y = m, ymin=m-2*se, ymax=m+2*se)) + 
  geom_point(size=3) + 
  geom_errorbar() + 
  xlab("females into a tree") + 
  ylab("females out of a tree (mean +/- 2 standard errors)")


# 12. ADVANCED, iteration --------------------------------------------------

# For each year in the data set, calculate the mean t_min. Additionally, for each year in the dataset, run a regression where the response variable is fitness and the predictor is dbh (like in question 5). Collect the regression coefficients and plot them against the mean t_min. What does this plot tell us about how tree diameter and winter temperatures interact to affect beetles?

# HINT: you can do this in R with for loops, or in the tidyverse with group_by, nest, and map, and tidy

### SOLUTION, base R
unique_years <- unique(df5$year)
num_years <- length(unique_years)
# preallocate an empty vector of length num_years; this will be filled with regression coefficients
coefs <- numeric(num_years) 
# preallocate an empty vector of length num_years; this will be filled with mean temperature
mean_t_min <- numeric(num_years)
i <- 1
for(i in 1:num_years){
  temp_df <- subset(df5, subset=(year==unique_years[i]))
  temp_mod <- lm(fitness ~ dbh, data=temp_df)
  coefs[i] <- coefficients(temp_mod)[["dbh"]]
  mean_t_min[i] <- mean(temp_df$t_min, na.rm=T)
}
plot(mean_t_min, coefs)


### SOLUTION, tidyverse
library(broom)
df8 <- df5 %>%
  group_by(year) %>%
  nest() %>%
  mutate(mean_t_min = map_dbl(.x=data, .f =  ~mean(.x[["t_min"]], na.rm=T)),
       mod = map(.x=data, .f = ~lm(fitness~dbh, data = .x)),
       res = map(.x = mod, .f = tidy)) %>%
  unnest(res) %>%
  filter(term == "dbh") %>%
  rename(coef=estimate)
  
df8 %>% ggplot(aes(x = mean_t_min, y=coef)) + 
  geom_point() + 
  geom_smooth(method="lm")

# SOLUTION, kind of cheating (b/c it ignore the prompt), but gets at the same idea.
glimpse(df6)
mod3 <- lm(fitness ~ std_dbh*std_t_min, data=df6)
summary(mod3)

# INTERPRETATION OF RESULTS: Although there are not enough years of data to draw definitive conclusion (using this kind of analysis) it appears as though there is a negative relationship between the coefficient (i.e. the effect of tree diameter on beetle fitness) and the minimum winter temperature. This implies that tree diameter is more important in colder years, which makes sense; bigger trees have thicker phloem, which allows beetle larvae to develop and possibly accumulate anti-freeze chemicals faster. Bigger trees also have thicker bark, which insulates the beetles. 

