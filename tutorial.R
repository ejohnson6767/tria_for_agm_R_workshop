
#----------------------------------------------------------------------------- #

#---------------------------------- R WORKSHOP ------------------------------- #

#----------------------------------------------------------------------------- #

# TRIA-FoR 2023 AGM

# R Primers tutorial 

#----------------------------- Introduction ---------------------------------- #

# It is recommended to comment your script extensively. Use a hashtag to start a comment.
# R simply ignores anything after a # sign and does not execute it as a command.

# You can write code in the console; it is good for quickly trying things (e.g. looking at dataframe contents, back-of-the-envelope calculations)
# However if you wanna keep track of your work
# You have to create a .R files 
# Shortcut is: Ctrl + Shift + N

# Values assignment
my_vec = 1
my_vec <- 1 # Arrow shortcut: Alt + 6 

#----------------------------------------------------------------------------- #


# Set the working directory -----------------------------------------------

# First thing to do is to set your working directory, the folder where your work contents (e.g., script, data) will be saved

# If you wanna check your current working directory:
getwd()

# Now to print the names of the files inside your directory:
dir()

# You can also consult the files in the bottom right panel in the Files tab (on the left of Plots tab)

# To set your working directory
# Shortcut: Ctrl + Shift + H
setwd() #ex: setwd("C:/Users/Documents")

# How to use the built-in R help?
?dir

# Basic R Syntax ----------------------------------------------------------

## Data Types --------------------------------------------------------------

# Basic types include Numeric, Character, Logical

# Numeric: Numbers
1.5
class(1.5)

# Integers

# Character: Text
"Hello world"
class("Hello_world")

# Logical: TRUE or FALSE
1 == 1
class(1 == 1)

# Factor: A variable with different categories
color <- c("Red", "Blue", "Green")

# Convert the vector to a factor
color_factor <- factor(color)
color_factor

# TIPS: Good to always keep an eye on the type of the object you are manipulating
# It is a common source of error


# Operator ----------------------------------------------------------------

# Comparison Operators: 
x = 1
x == 1 # Equal to 
x == 2
x != 2 # Not equal to

# Logical operators:
x == 1 | x == 2 # OR 
x == 1 & x == 2 # AND


# R Packages and Libraries ---------------------------------------------

# A library is a collection of ready-to-use functions coded by the community and
# wrap up in the CRAN website with a documentation and examples

# How to load a library?
library(tidyverse)
#install.packages("tidyverse") 
library(tidyverse)

## Data Structure ------------------------------------------------------------

### R is a vector-based language -------------------------------------------

# To create a vector use c()
vec1 <- c(1,2,3,4)
# Display the vector
vec1
print(vec1)

## Sub-setting vector
vec1[1]
vec1[4]
vec1[5]
vec1[1:3]
vec1[-2]

## Creation of a second vector
vec2 <- c(4,2,6,-8)

# Mathematical operators: Addition, Subtraction, Multiplication, Division, Exponentiation
vec1
vec2
vec1 - vec2
vec1 + vec2
vec1 * vec2
vec1 / vec2

# Comparison operators
vec1 == vec2
vec1 %in% c(1,2) | vec2 %in% c(-5, 4)
vec1 %in% c(1,2) & vec2 %in% c(-5, 4)

# Functions performed on Vector
log(vec1)
mean(vec1)
mean(log(vec1))

# Advanced Syntax: USE THE PIPE
# first, you need to install and load the tidyverse package
# install.packages("tidyverse") # uncomment to install
library(tidyverse)
# Shortcut is: Ctrl + shift + M
log(vec1) %>% mean()
vec1 %>% log() %>% mean()

### Data frame ---------------------------------------------------------------

# How to create a df?
data.frame()

vec1
vec2
vec3 <- c("Ind1", "Ind2", "Ind3", "Ind4")
my_df <- data.frame("first_col" = vec3, "second_col" = vec1, "third_col" = vec2)
my_df
View(my_df)
glimpse(my_df)

class(my_df$first_col)
class(my_df$third_col)

#### Sub-setting data frame --------------------------------------------------

#### Syntax is my_df[row_index, col_index]

my_df[1]
my_df[2]
my_df[1:2]
my_df[3,2]
my_df[,1]
my_df[1,]
my_df[1:2,]

# Others object you can play with: 
matrix()
list()

# loading ----------------------------------------------------

# If you were asleep until now, it is time to wake up!
# We are going to work on a real data set!

# R has a bunch of built-in datasets that you can play with
data(mtcars)
data(ChickWeight)
data(faithful)

# We will use the Iris dataset. It contains measurements of sepal and petal, lengths
# and widths for 3 species of iris flowers (setosa, versicolor, and virginica)
data(iris)
iris
View(iris)

## Data cleaning and data wrangling ----------------------------------------

# look at the data
View(iris)
head(iris)
str(iris)
iris
glimpse(iris)

### Only look at particular species
# first, we ask: what species are in the dataset?
unique(iris$Species)
iris %>% distinct(Species)

# Filtering using the PIPE %>% (Ctrl + Shift + M)
iris %>% filter(Species == "virginica") %>% head() # only look at virginica
iris[which(iris$Species == "virginica"),]
iris %>% filter(Species != "virginica") %>% head() # look at everything except for virginica
iris %>% filter(Species %in%  c("virginica", "setosa")) %>% head() # look at virginica and setosa
iris %>% filter(Petal.Length < 1 | Petal.Width < 0.5) %>% head() # look at rows where the petal length or width is small.

# Mutating 
# mutate() is used to create new variables or modify existing ones within a data frame
# enabling you to perform calculations and transformations on the data.

iris %>% mutate(petal_area = Sepal.Width * Sepal.Length) %>% head()
iris %>% mutate(is_petal_short = ifelse(Petal.Length < 1.5, "Yes", "No")) %>% head()
iris %>% mutate(length_deviation = Petal.Length - mean(Petal.Length)) %>% head()


# Grouping and Summarizing
# group_by() is used to group rows of a data frame based on one or more variables
# enabling subsequent aggregation and summary statistic operations to be performed within each group.

iris %>% 
  group_by(Species) %>% 
  summarise(mean_sp = mean(Sepal.Length))

iris %>% 
  group_by(Species) %>%
  summarise(mean_sepal = mean(Sepal.Length),
            sd_sepal = sd(Sepal.Length),
            num_individuals = n())


# Visualization
# ggplot() is a flexible and customization framework for constructing plots.
# ggplot employs a "grammar of graphics" approach that will initial unintuitive -- stick with it!


# Ggplot works as an stacking layers
# aes argument stands for "aesthetic" and it represents how you want to visually represent your data
# When you create a plot, you often want to show different aspects of your data, 
# like which values go on the x-axis, the y-axis and how things like colors or sizes should be linked to your data.


# scatterplots in base R 
plot(x=iris$Petal.Length, y=iris$Petal.Width)

# scatterplots in ggplot
iris %>% ggplot(mapping=aes(x = Petal.Length, y = Petal.Width))

iris %>% 
  ggplot(aes(x = Petal.Length, y = Petal.Width) ) + 
  geom_point()

iris %>% ggplot(aes(x = Petal.Length, y = Petal.Width, col = Species) ) + geom_point()

iris %>% ggplot(aes(x = Petal.Length, y = Petal.Width, col = Species, size = Sepal.Length) ) + geom_point()

iris %>% ggplot(aes(x = Petal.Length, y = Petal.Width, col = Species, size = Sepal.Length) ) + 
          geom_point() + 
          labs(title = "Petal Length by Species",
          y = "Petal Width",
          x = "Peta Length")

# try a boxplot
iris %>% ggplot(aes(x=Species, y=Petal.Length)) + geom_boxplot()





## Bonus: Join functions ---------------------------------------------------

# Join functions are used in data manipulation to combine and merge data from different sources on common columns.
?inner_join()
?right_join()
?left_join()
?full_join()
# For example, left_join function is used to combine 2 data frames based on a common column, 
# keeping all the rows from the left data frame and matching rows from the right data frame.

# Left_join example
grades <- data.frame(
  StudentID = c(1, 2, 3, 4, 5),
  Grade = c("A", "B", "C", "A", "B")
)

attendance <- data.frame(
  StudentID = c(2, 3, 5),
  DaysPresent = c(15, 17, 16)
)

# Merge both data grades and attendance on the column StudentID
grades_attendance <- left_join(grades, attendance, by = "StudentID")

grades_attendance


my_path <- "document/workshop"
set_wd(my_path)

paste0(my_path, "/ab_disk_data.csv")














