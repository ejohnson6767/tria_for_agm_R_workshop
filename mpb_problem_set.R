# setup -------------------------------------------------------------------
# uncomment to install
#install.packages("tidyverse")
library(tidyverse)


# 1. read-in the alberta disk data as a dataframe ----------------------------------------
# HINT: use the read.csv function, check your working directory



# 2A data cleaning -------------------------------------------------------
# Sometimes, field crews accidentally sample a tree with no entry holes. It is likely that these trees were either not attacked, or were not sucessfully attacked. 
# Take the dataframe and remove all observations with zero entry holes.



# 2B. data cleaning -----------------------------------------------------
# We only want to consider trees that were successfully attacked. Even if adult beetles bore into the tree, resinosis (i.e. tree resin defenses) can kill the eggs. 
# Thus, we say that trees without any larvae or pupae (dead or alive) at the time of sampling were not successfully attacked. We want to remove these observations from the dataframe.
# HINt: use the OR operator (i.e. | ), or create a new variable for the sum of larvae and pupae (dead and alive)



# 2C. data cleaning -----------------------------------------------------
# remove all NAs from the dataframe. If we were to keep these NAs, they would cause errors and warnings later on. 



# 3. creating columns -----------------------------------------------------
# create a new column called "fitness". This should contain per female fecundity, which is the number of females that will exit the tree, divided by the number of females entering the tree. Only females bore into the tree, creating the entry holes. Assume that all live_brood individuals will leave the tree. Keep in mind that only females make entry holes, but that the brood (i.e. larvae, pupae, and adult) sex ratio is 50:50. 



# 4: scatter plots -----------------------------------------------------
# is ecological fitness associated with tree diameter? Answer this question with a scatterplot.



# 5. linear regression ----------------------------------------------------
# is ecological fitness associated with tree diameter? Answer this question with a linear regression. print the results of the regression with the "summary" function.
# Bonus conceptual questions to discuss with your partner(s): what does the sign of the coefficient tell us? What does the R-squared value tell us?



# 6: merging/joining data frames -----------------------------------------------------
# load the temperature data with read.csv

# combine the temperature data with your other dataframe (i.e. the result from question 4), by matching the "site_id" and "year" variables across rows.
# HINT: "join_" functions in dplyr and "merge" in base R.



# 7. user-defined functions -----------------------------
# Now that we have temperature in our dataframe, we ask which is more important for beetle fitness, minimum winter temperature (t_min), or tree diameter (dbh)?

# To figure this out, we will be fitting a multiple regression and comparing regression coefficients. However, the regression coefficients depend on the units of the predictors.

# So first, in order to make the predictors unitless, we will be *standardizing* the predictors, which involves first subtracting the mean, and then dividing by the standard deviation. write your own function called std and use it in the code snippet below
# 

# make sure to replace your_df_name and new_df_name
new_df_name <- your_df_name %>% 
  mutate(std_t_min = std(t_min),
         std_dbh = std(dbh))



# 8. multiple regression -----------------------------------------------------
# Now that we have standardized our predictors, run a multiple regression with std_t_min and std_dbh as your predictors. The predictor with the largest coefficient is the more important predictor, in the sense that fitness changes more across the natural range of variability in that predictor.
# which variable is the more important predictor of beetle fitness?




# 9. making a map -----------------------------------------------------
# use the latitude and longitude columns plot plot the locations of the Alberta Disk Data

# First, use this code to download the polygon for Alberta
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




# 11. plotting summary statistics --------------------------------------------------
# make a plot that looks like overcompensation_plot.png in the main folder. Don't worry if the formatting (e.g. font size) doesn't match exactly.





# 12. ADVANCED, iteration --------------------------------------------------

# For each year in the data set, calculate the mean t_min. Additionally, for each year in the dataset, run a regression where the response variable is fitness and the predictor is dbh (like in question 5). Collect the regression coefficients and plot them against the mean t_min. What does this plot tell us about how tree diameter and winter temperatures interact to affect beetles?

# HINT: you can do this in R with for loops, or in the tidyverse with group_by, nest, and map



