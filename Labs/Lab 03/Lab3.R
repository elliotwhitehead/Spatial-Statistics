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


#read in your data an set working directory

##Daily COVID cases and mortalities in Colorado in Spring 2020


# QUESTION 1 (4 pts)*********************************************************************************************
##Please find which date has the most increased death and which date has the most increased positive cases 
# and which date has the most tests

# Hint: use which.max() to find the row with the maximum for each separately, then use [] to find the dates, 
#and put the results in the comments
# Include both your code and your answer!


# QUESTION 2 (4pts): ********************************************************************************************

##In the data frame 'covid', please add a new column called 'positivityRate' 
# to show the daily positive rate (positiveIncrease/totalTestResultsIncrease)


# QUESTION 3 (6 pts) ******************************************************************************************* 

##Based on the variable you added in Question 2

# QUESTION 3.1 PLOT the daily positivity rate over time

## HINT: create a new variable in your dataframe for day number since the first date
##USE +xlab("days since 9/1/2021") to label your x axis in your graph
##load your package ggplot


# QUESTION 3.2 PLOT the cumulative deaths over time 

# QUESTION 3.3: What are the trends over the time for these two variables?


## export image of plot in plot window or take screen shot for word document

# QUESTION 4 (10pts): ************************************************************************************

## QUESTION 4.1 Make a histogram of the daily positivity rate with the mean and median added in red and blue respectively


## In the lecture we used base R. Try to make your histogram using ggplot2 package.Either will get your credit.
## See this site for instructions on ggplot histograms:
## http://www.sthda.com/english/wiki/ggplot2-histogram-plot-quick-start-guide-r-software-and-data-visualization
## for base R use par(mfrow=c(1,1),lwd=4) to return yoru plot frame to a 1:1 matrix


## QUESTION 4.2 Add a mean vertical line to your histogram in red


## QUESTION 4.3 Add a median vertical line to your histogram in blue




## QUESTION 4.4:Is the distribution left-skewed, right-skewed, or fairly symmetric? Answer in the comments?

## QUESTION 4.5: what is the better choice of central tendency? The mean or the median?


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

