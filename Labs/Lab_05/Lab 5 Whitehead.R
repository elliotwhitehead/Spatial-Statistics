

## There are a total of 104 points in this lab across 6 questions. Please make sure to answer all questions. 

## Lab 5 focus on correlations and linear regressions
## data from: https://worldhappiness.report/ed/2022/#appendices-and-data - data for Table 2.1
## world country boundaries from: https://hub.arcgis.com/datasets/esri::world-countries-generalized/explore?location=-0.329878%2C0.000000%2C1.52

## bring in libraries

library(sf)
library(dplyr)
library (tidyverse)
library(ggplot2)

## Step 1 ***************************************************************************
## set your working directory - change this to your working directory.
setwd('/Users/elliotwhitehead/Downloads/00_School/GEOG 3023/Labs/Lab_05')


## read in happiness data
happinessData <- read.csv('data/WHR2021.csv')

## get head and dimensions of happiness data
head(happinessData)
dim(happinessData)

## select one country and map happiness measured in life ladder over time. 
## example for US. 

## find unique countries in happiness database and print
## the unique function is useful for seeing all unique elements in a column. 
(unique(happinessData$country))

## find unique countries in tidyverse
(happinessData %>% distinct(country))

  ## In this lab, we will explore doing manipulations in base R and tidyverse. 

## make subset of columns for a select country in base R selecting appropriate rows and columns
happinessDataUS <- happinessData[which(happinessData$country== 'United States'),]

#check your work
dim(happinessDataUS)
head(happinessDataUS)

## you now have just the US happiness data and all the associated columns

## in tidyverse - you get the same answer using the filter function
happinessDataUS <- happinessData %>% #filter to the US
  filter(country == 'United States') 

dim(happinessDataUS)
head(happinessDataUS)

## plot US happiness Life ladder over time in a scatter plot using base R
plot(x=happinessDataUS$year, y=happinessDataUS$Life.Ladder, main = "US Mean Life.Ladder, 2008 - 2020")

## Plot the scatter plot with ggplot
ggplot(happinessDataUS) + aes(x=year, y=Life.Ladder) + geom_point()+
  ggtitle("US Mean Life.Ladder, 2008 - 2020")

## Question 1 ********************************************************************
## -------------------------------------------------------------------------------

## Q 1a. Select a different country and a different metric of happiness from the database and create a scatter plot over time. 
## Make sure to change the title of the graph. Repeat the operation in base R and tidyverse. Show your code. 4 pts. 
happyDenmark <- happinessData %>% filter(country == "Denmark")
ggplot(happyDenmark) + aes(x=year, y=Healthy.life.expectancy.at.birth) + geom_point()+
  ggtitle("Denmark Healthy.life.expectancy.at.birth, 2005-2020")


## Q1b. Describe the trend over time. Is it positive or negative or neutral? 2 pts.
## The trend is shows a strong positive correlation over time. Nearly linear!


## ****************************************************************************

## Step 2 ********************************************************************
##Now let's look at two countries in base R
happinessDataGermany <- happinessData[which(happinessData$country== 'Germany'),]

## base R plot
plot(x=happinessDataGermany$year, y=happinessDataGermany$Life.Ladder, main = "Germany Mean Life.Ladder, 2008 - 2020", col='red', pch=19)
## add the next country as points to the first plot
points(x=happinessDataUS$year, y=happinessDataUS$Life.Ladder,col='blue', pch=19 )


## tidyverse and ggplot

happinessDataUSGermany <- happinessData %>% #filter to the US or Germany at same time
  filter(country == 'United States' | country == 'Germany') %>%
  select(country, Life.Ladder, year)

ggplot(happinessDataUSGermany) + aes(x=year, y=Life.Ladder, color=country) + geom_point() +
  ggtitle("Mean Life.Ladder, 2008 - 2020")


## we can also plot these as line graphs
plot(x=happinessDataGermany$year, y=happinessDataGermany$Life.Ladder,typ = 'l', main = "Germany Mean Life.Ladder, 2008 - 2020", col='red', pch=19)
lines(x=happinessDataUS$year, y=happinessDataUS$Life.Ladder,col='blue', pch=19 )

## or in ggplot

ggplot(happinessDataUSGermany) + aes(x=year, y=Life.Ladder, color=country) + geom_line() +
  ggtitle("Mean Life.Ladder, 2008 - 2020")


## let's compare overall averages over time as well by looking at boxplots in base R. 

## create a subset dataframe of the variable life ladder for just US and Germany 
lifeladder <- cbind(happinessDataUS$Life.Ladder,happinessDataUSGermany$Life.Ladder)
colnames(lifeladder) <- c('US_life_ladder', 'Germany_life_ladder')
boxplot(lifeladder)

## We can also use the summary function in R to get basic descriptive statistics on these two countries for this variable
summary(lifeladder)

## tidyverse

ggplot(data = happinessDataUSGermany, aes(x = country, y = Life.Ladder, fill = country)) +
  geom_boxplot() +
  labs(title = "Life Ladder for Germany and US", x = "Country", y = "Life.Ladder")

## summary statistics using tidyverse
happinessDataUSGermany %>%
  group_by(country)%>%
  summarize(
    Mean = mean(Life.Ladder),
    Median = median(Life.Ladder),
    SD = sd(Life.Ladder)
  )


## Question 2 ********************************************************************
## -------------------------------------------------------------------------------

## Q 2a. Select two different countries (not the US or Germany) and a different variable from the database (not Life.Ladder) 
## and create a comparison scatter plot of the variable over time between the two countries. 
## Make sure to change the title of the graph. Repeat in base R and tidyverse. Show your code. 8 pts. 

happyDenmarkRussia <- happinessData %>% #filter to Denmark and Russia
  filter(country == 'Denmark' | country == 'Russia') %>%
  select(country, Healthy.life.expectancy.at.birth, year)

ggplot(happyDenmarkRussia) + aes(x=year, y=Healthy.life.expectancy.at.birth, color=country) + geom_line() +
  ggtitle("Mean Healthy.life.expectancy.at.birth, 2005-2020")

## Q2b. Describe the trend over time for each country and how the two countries compare. 4 pts.

## Both Denmark and Russia's life expectancy has been increasing over the last 15 years,
## however the rate for Denmark's life expectancy increase has been accelerating, while
## the rate of increase for Russia has been decreasing. Denmark's life expectancy is much
## higher than Russia's.



## Q2c. Create a boxplot of the two country variables. How do the overall values compare? 4 pts.
## Which country has a higher median value over time?  
## Use just tidyverse to make your boxplots.

## summary statistics using tidyverse
happyDenmarkRussia %>%
  group_by(country)%>%
  summarize(
    Mean = mean(Healthy.life.expectancy.at.birth),
    Median = median(Healthy.life.expectancy.at.birth),
    SD = sd(Healthy.life.expectancy.at.birth)
  )

ggplot(data = happyDenmarkRussia, aes(x = country, y = Healthy.life.expectancy.at.birth, fill = country)) +
  geom_boxplot() +
  labs(title = "Life Expectancy for Russia and Denmark", x = "Country", y = "Life Expectancy")

## the boxplots show a similar story as the line chart. Denmark has a much higher
## median life expectancy of 71.3, compared to Russia's 62.3. The range for Russia
## is greater, which is good to see, showing that they've come a long way since 
## 2006. 


## Step 3 Correlations ****************************************************************************

## Now we are going to look at correlations of happiness with other variables. 
## For the entire database (all countries), let's explore if life ladder correlates with freedom to make life choices and Gross Domestic product). 
## First we will look at the scatter plot to see if we have a linear relationship. 

## To get the names of the variables, use the R function names

(names(happinessData))

## Question 3 ******************************************************************************
## -------------------------------------------------------------------------------

## Q3a. Create a scatter plot of freedom to make life choices and life ladder including all countries and all years 2pts
## Repeat with base R and ggplot

## base R plot
plot(x=happinessData$Life.Ladder, y=happinessData$Freedom.to.make.life.choices, main = "Freedom to Make Life Choices vs Life Ladder, All Countries", pch=19)
## ggplot
ggplot(happinessData) + aes(x=Life.Ladder, y=Freedom.to.make.life.choices) + geom_point() +
  ggtitle("Freedom to Make Life Choices vs Life Ladder, All Countries")

## Q3b. Based on the scatterplot, what will be the direction (positive, negative, or neutral) of the relationship between these variables? 2pts
## Based on the scatterplot, the direction of the correlation will be positive. 

## Q3c. Create a scatter plot of log of Gross Domestic Product (GDP) per capita and life ladder 2pts
## Repeat with base R and ggplot

## base R plot
plot(x=happinessData$Life.Ladder, y=happinessData$Log.GDP.per.capita, main = "Log GDP vs Life Ladder, All Countries", pch=19)

## ggplot
ggplot(happinessData) + aes(x=Life.Ladder, y=Log.GDP.per.capita) + geom_point() +
  ggtitle("Log GDP vs Life Ladder, All Countries")

## Q3d. Based on the scatterplot, what will be the direction (positive, negative, or neutral) of the relationship between these variables? 2pts
## Based on the scatterplot, the direction of the correlation between Log DGP and Life.Ladder will be positive. 


## Q3e. Comparing the two scatterplots, which two variables do you think will have a larger correlation (R) value? Why? Be specific. 4 pts. 
## Log GDP will have a larger correlation value to Life Ladder than Freedom to make life choices.



## *************************************************************************************************

## Now let's calculate the Pearson's Correlation coefficient for these two groups of variables. 

## We can use the built in function cor() in R. 
cor(happinessData$Freedom.to.make.life.choices, happinessData$Life.Ladder)

## what happens when you run this code? There are NA's in the data that we need to clean out first. 
## An NA is a place where data is missing - maybe a country did take the happiness survey all the years. 
## check the dimensions before and after omitting NAs to see how many empty rows you have
dim(happinessData)

happinessData <- na.omit(happinessData)

dim(happinessData)

## We removed 241 rows with NA values. Now we are ready for statistics! Remember this as you move forward doing your own statistics.
## If the code isn't working, check for NAs and remove them or replace them with 0s. 

## run the correlation function on the cleaned data
cor(happinessData$Freedom.to.make.life.choices, happinessData$Life.Ladder)

## we see that the correlation coefficient of 0.525 - that's strong and positive. 


## Question 4*****************************************************************************************
## -------------------------------------------------------------------------------

## Q4a. Run the correlation between Gross Domestic Product (GDP) per capita (Log.GDP.per.capita) and life ladder. Show code. 4 pts. 
cor(happinessData$Log.GDP.per.capita, happinessData$Life.Ladder)
## 0.793 - very strong and positive.

## Q4b. Run the correlation between freedom to make life choices and life ladder. Show code. 4 pts. 
cor(happinessData$Freedom.to.make.life.choices, happinessData$Life.Ladder)
## 0.525 - strong and positive

## Q4c. Which correlation coefficient is higher or lower? 2 pts
## Does this match your predictions based on the scatter plot? 
## Do these variables have a linear relationship? 
## The correlation between Life.Ladder and Log GDP is stronger than Life.Ladder to
## Freedom.to.make.life.choices. This is in line with my prediction. You can see
## that the data is much more closely clustered to a would-be line of best fit.
## Log GDP has a much more linear relationship than Life choices. Life choices was
## much more scattered and had outliers. 


## Q4d. Now create a scatter plot between Log.GDP.per.capita and Freedom.to.make.life.choices and then run a correlation. 6pts
ggplot(happinessData) + aes(x=Log.GDP.per.capita, y=Freedom.to.make.life.choices) + geom_point() +
  ggtitle("Log GDP vs Freedom to Make Life Choices, All Countries")
cor(happinessData$Log.GDP.per.capita, happinessData$Freedom.to.make.life.choices)
## 0.353

## How would you describe the relationship (strength and direction) between Log.GDP.per.capita and Freedom.to.make.life.choices? 2 pts. 
## There is a positive correlation between Log GDP and Freedom to make life choices,
## but it's a weak correlation of 0.353.


## Step 4 *******************************************************************************************************

## Linear Models

fit_LinearModel <- lm(happinessData$Life.Ladder ~ happinessData$Freedom.to.make.life.choices)


## show the summary of the fitted linear model
summary(fit_LinearModel)


## we can also get the slope and intercept
## We can access the fitted intercepts and slope values
fit_LinearModel$coefficients # this is a vector with two entries, the first one is intercept and other is slope


fit_LinearModel$coefficients[1] # is the intercept
fit_LinearModel$coefficients[2] # is the slope

## Now let's add the line to our scatter plot - make sure to place Life.Ladder on the y axis. 
## In base R, we use the function abline() to add lines to a scatterplot and we put the linear model in the function
plot(happinessData$Freedom.to.make.life.choices, happinessData$Life.Ladder)
abline(lm(happinessData$Life.Ladder ~happinessData$Freedom.to.make.life.choices), col='red', lwd=4)

## and in ggplot
## In ggplot, we call a smoothed line function using the linear model as the line

ggplot(happinessData) + aes(x=Freedom.to.make.life.choices, y=Life.Ladder) + geom_point() +
  geom_smooth(method='lm', formula=y~x, color = "red")

## Question 5*******************************************************************************************
## -------------------------------------------------------------------------------

## Q5a. Create a linear model predicting life ladder with Log.GDP.per.capita. 4 pts




## Q5b. What is the adjusted R-squared value? What does this value mean? 2 pts. 



## Q5c. What is the slope for this model and what does the slope mean? 4pts. 



## Q5d. Which predictor variable (Log.GDP.per.capita or Freedom.to.make.life.choices) is a stronger predictor of life ladder happiness? 4 pts. 
## Explain your answer.




## Step 5******************************************************************************************************

## Now we will map the data.

## Read in your world country boundaries. 

countries <- st_read("World_Countries__Generalized_.shp") 

## explore the data
head(countries)

## map the polygons
ggplot(countries) + geom_sf()

## Note that the country variable in the spatial database is called 'COUNTRY' and the column in the 
## happinessdata is called 'country'.


## We can join the happinessData to the spatial data together by these column in Base R using the merge() function.
## we use by.x and by.y to tell the function which fields are the same in each database. all.x= TRUE tells the merge() function
## to keep all the data in X and only the matched data from Y. 

countriesH <- merge(countries, happinessData, by.x= "COUNTRY", by.y = "country", all.x = TRUE)

## check your work
head(countriesH)

ggplot(countriesH) + geom_sf()

## Joining database in tidyverse, we use one of the join family functions. Note that since we use piping in tidyverse, 
## tidyverse assumes that everything after the pipe uses the stuff before the pipe as the input. 

countriesH <- countries %>%
  left_join(happinessData, by = c("COUNTRY" = "country"))

## check your work
head(countriesH)

ggplot(countriesH) + geom_sf()


## Step 6 *********************************************************************************************

## let's find out where the happiest countries are in 2020.In this step we will predict 2020 life ladder happiness iwht latitude. 

## The questions will lead you through each step. 

## Question 6*****************************************************************************************
## -------------------------------------------------------------------------------

## Q6a. Make subset of countriesH for year equals 2020 and call it countriesH2020. Repeat in base R and tidyverse. 4 pts. 





## Q6b.Map the countriesH2020 by the attribute Life.Ladder. Use code you learned in Lab 4 to map the polygons by an attribute.
## Use 5 breaks and any color you want. 4 pts. 



## Q6c. List two countries that spatially show the highest happiness bin and list two countries that spatially show the lowest happiness bin? 2 pts.



## Q6d. For countries with reported happiness ratings, what is the relationship between latitude (Y coordinate) and 
## life.ladder in 2020? Is latitude a predictor of life ladder happiness? 20 pts.

## you may use base R or tidyverse to answer this question (or a combination).
## You will need to use material from lab 4.

## Hint - 
## 1) turn your countriesH2020 into points, 
## 2) get the y coordinate value and take the absolute value using abs() and add these values to the dataframe in a field called y,
## 3) and predict 2020 life happiness (x) by latitude (y) in a linear regression. 



## Q6e. Plot life ladder happiness in 2020 (x) as a function of latitude (y) on a scatter plot and add the linear regression line 6 pts. 
## repeat in ggplot and in base R. 



## Q6f. Summarize the results of the linear model above. Is Latitude a strong predictor of life.ladder happiness? be specific. 6 pts. 


## *****************************************************************************************************

## Congratulations! You just did a spatial linear regression!