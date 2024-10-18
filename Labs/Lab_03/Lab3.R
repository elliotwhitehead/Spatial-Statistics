## GEOG3023 Statistics and Geographic Data
## Lab 3: Descriptive statistics

## Elliot Whitehead

##Use the "Lab3_GraphsAndDescriptiveStats.R" file as the first place to look if you're not sure how to do something.

# The enclosed 'ColoradoCovid.csv' file contains the basic covid statistics for the state of Colorado since September 1st, 2021
# The following is the description of each column:
# Date: each day of record
# State: Colorado
# death: accumulative number of death till each day
# deathIncrease: new confirmed death on each day
# positive: accumulative number of positive cases till each day
# positiveIncrease: new confirmed positive cases on each day
# totalTestResults: accumulative number of test conducted till that day
# totalTestResultsIncrease: new tests on each day

##*******************************************************************************************************************
#Read the csv file
covid=read.csv("Lab_03/ColoradoCovid.csv")

# install Lubridate for date formatting
install.packages("lubridate")
library(lubridate)


# QUESTION 1 (4 pts)*********************************************************************************************
##Please find:

# - which date has the most increased death
index_of_max_deathInc <- which.max(covid$deathIncrease)
date_of_max_deathInc <- ymd(covid[index_of_max_deathInc,]$date)
# Answer: 2020-04-25

# - and which date has the most increased positive cases 
index_of_max_positiveInc <- which.max(covid$positiveIncrease)
date_of_max_positivInc <- ymd(covid[index_of_max_positiveInc,]$date)
# ANSWER: 2020-04-25

# - and which date has the most tests
index_of_max_tests <- which.max(covid$totalTestResults)
print(date_of_max_tests <- ymd(covid[index_of_max_tests,]$date))
# ANSWER: 2020-08-30



# QUESTION 2 (4pts): ********************************************************************************************

##In the data frame 'covid', please add a new column called 'positivityRate' 
# to show the daily positive rate (positiveIncrease/totalTestResultsIncrease)
positiveIncrease <- covid$positiveIncrease
totalTestResultsIncrease <- covid$totalTestResultsIncrease
positivityRate <- positiveIncrease/totalTestResultsIncrease

# ANSWER
covid["positivityRate"] <- positivityRate



# QUESTION 3 (6 pts) ******************************************************************************************* 

##Based on the variable you added in Question 2

# QUESTION 3.1 PLOT the daily positivity rate over time

##load your package ggplot
library(ggplot2)

## HINT: create a new variable in your dataframe for day number since the first date
##USE +xlab("days since 9/1/2021") to label your x axis in your graph

start_date <- ymd(covid$date[1]) #2020-03-05
days_since_start <- ymd(covid$date) - start_date
covid["days_since_start"] <- days_since_start

ggplot(data=covid, aes(x=covid$days_since_start, y=covid$positivityRate)) +
  geom_line()+
  geom_point()+
  ylab("COVID Positivity Rate")+
  xlab("Days since March 5th, 2020")


# QUESTION 3.2 PLOT the cumulative deaths over time 

ggplot(data=covid, aes(x=covid$days_since_start, y=covid$death)) +
  geom_line()+
  geom_point()+
  ylab("Cumulative Deaths over Time")+
  xlab("Days since March 5th, 2020")

# QUESTION 3.3: What are the trends over the time for these two variables?

# Generally, deaths increased over time, and the positivity rate decreased from high
# spikes in the first 50 days to a relative stable and constant rate for the remainder
# of the time in the dataset. Since we didn't clean the data from negative and non-zero 
# entries, there's some error in the data, likely attributed to lack of data reported
# on that date (zeros) and corrections in the dataset (negative death increases).


## export image of plot in plot window or take screen shot for word document

# QUESTION 4 (10pts): ************************************************************************************

## QUESTION 4.1 Make a histogram of the daily positivity rate with the mean and median added in red and blue respectively

mean_positive <- mean(covid$positivityRate)
median_positive <- median(covid$positivityRate)

ggplot(data = covid, aes(x = positivityRate)) +
  geom_histogram(binwidth = 0.01, fill = "lightgray", color = "black") +
  
  ## QUESTION 4.2 Add a mean vertical line to your histogram in red
  geom_vline(aes(xintercept = mean_positive), color = "red", linetype = "dashed", size = .5) +
  
  ## QUESTION 4.3 Add a median vertical line to your histogram in blue
  geom_vline(aes(xintercept = median_positive), color = "blue", linetype = "dashed", size = .5) +  # Median line
  labs(title = "Histogram of Daily Positivity Rate",
       x = "Daily Positivity Rate",
       y = "Count") +
  theme_minimal()


## QUESTION 4.4:Is the distribution left-skewed, right-skewed, or fairly symmetric?
## The distribution is right skewed. There are several large outliers above .3 
## that skew the data to the right, pulling the mean to the right of the median.

## QUESTION 4.5: what is the better choice of central tendency? The mean or the median?
## In this case, the median is the best choice of central tendancy, as the data is much
## more clustered around this value.


## export image of plot with mean and with median in plot window or take screen shot for word document

## QUESTION 5 (6 pts): *************************************************************************************************

## QUESTION 5.1 Create a boxplot of positivity rate
## See: http://www.sthda.com/english/wiki/ggplot2-box-plot-quick-start-guide-r-software-and-data-visualization

# Basic box plot


## QUESTION 5.2 What are the 25th and 75th percentile (the values to calculate the Interquartile range) values for positivuty Rate?

## export image of plot with mean and with median in plot window or take screen shot for word document


# End! Once you're done, make sure to save this script (File -> Save)
# Copy and paste your plots into a word file or save them as image files 
# by clicking the "Export" button in the Plots pane
# On Canvas, you'll submit this Rscript file (named lastname_Lab3") and your 4 plots in a word document:
# 1. Daily positivity rate over time
# 2. Daily deaths over time
# 3. Your histogram of the daily positivity rate with mean and median lines
# 4. Your boxplot

