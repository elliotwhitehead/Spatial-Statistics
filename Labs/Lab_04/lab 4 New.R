## Lab 4 spatial descriptive statistics
## Teresa Chapman

## There are 110 points. Please answers all questions. You will submit your code for your lab grade. 

## load packages
## install.packages("sf")
## install.packages("terra")
## install.packages("tidyverse")
## install.packages("dplyr")


library(sf)
library (tidyverse)
library(terra)
library(ggplot2)

## set working directory -change this to your working directory.
setwd('~/Downloads/00_School/GEOG 3023/Labs')


## step 2 read in wildfire data using sf package   ***************************************

## read in the wildfire data
fires <- st_read("Lab_04/data/mtbs_wildfires_2020.shp")

class(fires)  


## QUESTION 1 **************************************************************************************
##--------------------------------------------------------------------------------------------------
## Q1a: What type of vector data is the shapefile (point, line or polygon) - 2 pts.
## HINT: in the console, it tells you under Geometry type. 

## fires is a dataframe of Geometry type: MULTIPOLYGON.


## Q1b. How many features are there in this shapefile? How would you find out using code? - 2pts.

## HINT: This spatial data has an attribute table. The attribute table has a row for every feature. The columns 
## in the table give information about the feature in that row. You can think of the attribute table as a dataframe 
## with rows and columns.


## There are 820 features in this shapefile. 
## You can find this out by investigating the length of the dataframe:
dim(fires)[1]


## Q1c. Print the first six rows of the spatial attribute table for fires. What are the column names? 2pts

head(fires)
## The column names are "Incid_Name" and "geometry"


## ****************************************************************************************

## Map the wildfires using the ggplot2 package
## we can map all the fires, but this can take a long time for some computers since there are many fires.
## let's just plot the first 100 fires in the file. 

## use base R plot
plot(fires[1:100,])


## use ggplot2
ggplot(fires[1:100,]) + 
  geom_sf()


## ****************************************************************************************

## Step 3 *********************************************************************

## calculate the area of each wildfire using a function in sf called st_area.

st_area(fires)

## the console will print out the area of each polygon. At the top of the console print out (scroll up), you will see
## the units for the area (Units: [m^2])

## Put the units in hectares. 1 ha = 100x100m
myArea <- st_area(fires)/10000

## add a field to the dataframe equal to the area in ha.
fires$areaFire <- myArea

# check your work
head(fires)

## Create a field in hectares and add it to fires
myArea <- units::set_units(st_area(fires), hectare)
fires$areaFire <- myArea

#check your work again
head(fires)

##Step 4****************************************************************************

## convert polygons to points. Use points on surface.  

firePoints <- st_point_on_surface(fires)

## check the dimensions
dim(firePoints)


## Question 2. **********************************************************************
##----------------------------------------------------------------------------------
## Q2a. Plot the firePoints. Show your code using ggplot(). 2pts. 
ggplot(firePoints[1:100,]) + 
  geom_sf()


## Q2b. What region of the US did not have many fires in 2020? 2pts.
## The Northeast and Midwest of the US did not have many fires in 2020.


## Step 5 **********************************************************************************

## Get the projection of the firePoints.

st_crs(firePoints)


## HINT: If your data has been projected, the text within the coordinate reference system will read PROJCRS[]. 
## The text in quotes is the name of the projection.
## If your data has not been projected and is still in a geographic coordinate system (latitude and longitude in decimal degrees)
## then it will read GEOGCRS[].

## look at the coordinates for firePoints. 
head(firePoints)

## You can tell the data is projected since the values are greater than 90 degrees latitude and 180 longitude under the geometry field. 
## Coordinates in a geographic coordinate system will be in decimal degrees (0-90 or 0-180). 
## 90 is at the poles and 0 is at the equator for latitude. 
## 0 is the prime meridian in longitude and half way around the globe is 180. 

## Question 3 ***************************************************************************************************
## ---------------------------------------------------------------------------------------------------------------
## Q3a. What is the name of the projection for firePoints? 2 pts
## This map is using the North_America_Albers_Equal_Area_Conic projection.


## Q3b: What is the unit of measurement for this projection? (e.g., meters, feet, degrees) 2 pts.
## HINT: look for LENGTHUNIT[] as you read down through the st_crs() print out.
## The length unit is metres.


## Q 3c. Why is the unit of length important to know for spatial analyses?  2 pts. 
## HINT: how far is a decimal degree at the poles compared to the equator in a geographic coordinate system?
## One degree of longitude is about 111km at the equator, as you approach the poles however, the distance of one degree approaches 0.
## Representations of spatial distances can vary greatly depending on the units of measurement, and the 
## map projection being used. Units are also important to take note of for area and density calculations.


## **************************************************************************************

## This database is a nice example of the minimum information you may want for a spatial analysis. We have coordinates (a geographic location),
## and we have attribute information at that location that varies across space (wildfire size). 

## get the coordinates
st_coordinates(firePoints)

## explore the class of the object
class(st_coordinates(firePoints))
dim(st_coordinates(firePoints))

## this is a matrix




## QUESTION 4 **************************************************************************************
## --------------------------------------------------------------------------------------------------
## Q4a: ## What is the mean center x coordinate value for wildfires in 2020?  Name the Mean center x object as MCx.Show code and answer. 2 pts. 
## Create a vector for X and Y
coords <- st_coordinates(firePoints)
X_coords <- coords[,1]

MCx <- mean(X_coords)
cat(MCx)
# the Mean Center x coordinate is: -395294.7


## Q4b: ## What is the mean center y coordinate value for wildfires in 2020? Name the Mean center Y object as MCy.  show code and answer. 2 pts. 
Y_coords <- coords[,2]
MCy <- mean(Y_coords)
cat(MCy)
# the Mean Center y coordinate is: -241134.2

## Step 6***********************************************************************************************

## Create a dataframe by combining the X and Y mean centers. 
(meanCenter <- data.frame(cbind(MCx, MCy)))

## Create sf object
(meanCenter_sf <- st_as_sf(meanCenter,coords=c("MCx", "MCy"), crs = st_crs(fires)))

## Note - we give the function st_as_sf the dataframe called meanCenter and we tell it that the coords are in the columns named "Mcx" and "MCy".
## Remember when we wrap our line of code in (), it will print the result in the console. This is very useful when you want to see what you are doing. 

## Create fields with X and Y coordinates
meanCenter_sf$MCx <- MCx
meanCenter_sf$MCy <- MCy

## Explore the new fields
(meanCenter_sf)


## Now we can map the mean center and the fire points together. We can add a geom_point after we plot the fires. 
## When we add a point, we can no longer use geom_sf() for the geometry. We must give ggplot the coordinates in a sf dataframe.


ggplot(firePoints) + 
  geom_sf()+ geom_point(data = meanCenter_sf,aes(x = MCx, y = MCy),  size = 7, fill="red",shape = 23)


## Step 7*******************************************************************************************
## Now calculate the central feature and compare it to the mean center. 

## Calculate the distance between ten points to get a sense of what the st_distance function does. 
(distSubset <- st_distance(firePoints[1:10,]))

## It is calculating the distance between each point and all other points in meters. Each point has 
## zero distance between itself. 

## Now Calculate the distance between all points
dist <- st_distance(firePoints)

## We can take the mean of each column to determine the average distance for each point and all other points.
(distMeans <- colMeans(dist))

## If we then take the fire point with the minimum value, we have the point that is the median center. 
(distMin <- min(colMeans(dist)))

## Find the firePoint with the minimum distance
which(distMeans==distMin)

## the which function here gives you the point number or index of which firePoints has the minimum distance to all other points.          


## Question 5 ***************************************************************************************
## --------------------------------------------------------------------------------------------------

## Q5a. Determine which point in the firePoints is the central feature within the firePoints sf object using the results above. 
## HINT: Filter the firePoints layer to only have this point and name it centralFeature. You know the row number. 
## Get two coordinates for x and y of the central feature. Make new fields in centralFeature with the coordinate column names (as we did in the mean center) 
## and map it onto your previous map. 
## Fill the central feature with blue. 8 pts. 
centralFeature <- firePoints[18,]

cf_coords <- st_coordinates(centralFeature)
cf_X <- cf_coords[,1]
cf_Y <- cf_coords[,2]

centralFeature["X"] <- cf_X
centralFeature["Y"] <- cf_Y

ggplot(firePoints) + 
  geom_sf()+ 
  geom_point(data = meanCenter_sf,aes(x = MCx, y = MCy),  size = 7, fill="red", shape = 23) + 
  geom_point(data=centralFeature,aes(x = cf_X, y = cf_Y), size = 3, fill="blue", shape = 21)

## Q5b. Describe where the central feature with respect to the mean center. Does this make sense to you? Why?  4 pts
## The central feature is the closest feature to the mean center. This makes perfect sense, 
## as that's the definition of the central feature!


## ********************************************************************************************************************************
## Step 8*************************************************************************************************************************
## Question 6 ************************************************************************************************************
## ------------------------------------------------------------------------------------------------------------------------
## Q6a. calculate the median center of firePoints. Name the point medianCenter 
## and add it to a map of firePoints with the mean center and central feature.
## Fill the medianCenter in yellow. 8 pts. 
## HINT: follow steps in step 6 to create a meanCenter, but use median. 

## the median center is the x,y coordinate which is the median of all the x coordinates, 
## and all the y coordinates

med_X <- median(X_coords)
med_Y <- median(Y_coords)

ggplot(firePoints) + 
  geom_sf()+ 
  geom_point(data=meanCenter_sf, aes(x=MCx, y=MCy),  size=7, fill="red", shape=23) + 
  geom_point(data=centralFeature, aes(x=cf_X, y=cf_Y), size=3, fill="blue", shape=21) + 
  geom_point(aes(x=med_X, y=med_Y), size=3, fill="yellow", shape=23)

## Q6b. Describe where the median center is with respect to the mean center and central feature.
##      Does this make sense to you? Why?  4 pts

## The median center is south of the mean center and central feature. this makes sense, because
## both the mean center and central feature are sensitive to outliers, and there is are several
## fires way up in Alaska which would pull the mean up north, and away from the median. The outliers
## to the northeast balance out the "west-ness" of the outliers in Alaska, so the mean center is
## pretty close to the median center on the E/W axis.


## Q6c. Which point best represents the spatial central tendency in your view and why? 4 pts. 

## All three of these points do a good job at representing the central tendency of the data.
## While the mean center, and thus the central feature are pulled a bit northward by the outliers
## in Alaska, they are still quite close to the median. 

## ****************************************************************************************************************
## Part 2 *********************************************************************************************************
## ****************************************************************************************************************

## Explore the variable area for wildfire size. 

## Question 7*************************************************************************************************
##----------------------------------------------------------------------------------------------------------------

## Q7a. Plot a histogram of the area of wildfires. Show code. 2 pts
##      since our area has units in hectares, you must first open the package called units. 

library(units)
library(scales)
ggplot(firePoints, aes(x = as.numeric(areaFire))) +
  geom_histogram(binwidth = 10000, fill = "blue", color = "black") +
  labs(title = "Histogram of Values", x = "Fire Area [hectares]", y = "Frequency") + 
  ## display mean as a dashed red line
  geom_vline(aes(xintercept = mean(as.numeric(areaFire))), color = "red", linetype = "dashed", size = 1) +
  ## display median as a dashed yellow line
  geom_vline(aes(xintercept = median(as.numeric(areaFire))), color = "yellow", linetype = "dashed", size = 1) +
  scale_x_continuous(labels = label_number()) # Use decimal formatting on the x axis

## Q7b. Describe the distribution of wildfire size in 2020. Be specific if it is skewed. 2 pts. 

## the distribution is heavily skewed to the right, with the August Complex fire 
## representing a massive outlier in the data at 432525.152ha. Nearly all of the 
## fires fall within the first two bins of the histogram, while the August Complex 
## Fire is 40 bins away to the right. It would be interesting to see a histogram
## of the data without this outlier present. 


##Q 7c. What is the maximum fire size and what fire incident recorded it? 2 pts. 

## The August Complex Fire with a size of 432525.152ha. 


## *************************************************************************************
## Step 9 ******************************************************************************

## Map the variable 'area' for our wildfire points.

## Create a proportional dot map map the coordinates of the fires.
## for the aes() function, you need to add the coordinates themselves and then scale them by the Area_ha attribute. 
## We can then add a legend with the scaled symbols.
## See how I added a title and labelled the x and y axes.
head(firePoints)

## Note that in the below graph, we had to convert the area in meters to just a number using as.numeric(). This function converts the vector to numbers. 
ggplot() + geom_point(data = firePoints, aes(x=st_coordinates(firePoints)[,1], y=st_coordinates(firePoints)[,2],size=as.numeric(areaFire))) + 
  scale_size_continuous(name="areaFire")+ ggtitle("Area of US Wildfires in 2020") + xlab("Longitude (m)") + ylab("Latitude (m)")


## QUESTION 8 **************************************************************************************
## ----------------------------------------------------------------------------------------------------
## Q8a: What region of the US appears to have the largest fire according to your graduated symbol map? 2 pts.

## California had the largest fire.

## Q8b: What region of the US appears to have the most large fires according to your graduated symbol map? 2 pts.

## The West Coast of the continental US appears to have the largest wildfires.
## But Oregon and Arizona had some big ones too.

## Q8c: Add a central tendency  point to the map by rewriting the above code to include:
##      the mean center, central feature or median center point. 6 pts.

ggplot() + geom_point(data = firePoints, aes(x=st_coordinates(firePoints)[,1], y=st_coordinates(firePoints)[,2],size=as.numeric(areaFire))) + 
  scale_size_continuous(name="areaFire")+ ggtitle("Area of US Wildfires in 2020") + xlab("Longitude (m)") + ylab("Latitude (m)") + 
  ## Add the median center
  geom_point(aes(x=med_X, y=med_Y), size=3, fill="green", shape=23)  


## ****************************************************************************************************

## Step 10 ************************************************************************************************

## calculate the number of fires per state and the % area burned
## Bring in US states spatial data. 

## Question 9 ******************************************************************************************
## ------------------------------------------------------------------------------------------------------
## Q9a: read in US states data and create a sf object and call the variable 'states' - 2 pts.
## HINT: look at code where we read in the fires at beginning of lab. 
## The US states shapefile is called: cb_2018_us_state_20m.shp 
## It should be in your data folder. 

## read in states shapefile
states <- st_read("Lab_04/data/cb_2018_us_state_20m.shp")

## Q9b: what is the coordinate reference system of states (e.g., GEOGCRS or PROCRS?)? 
##      How does this compare to the projection of our fire data? - 2 pts. 
##      (HINT: use the function to check the coordinate reference system)
##      It is important that all spatial data is in the same projection so that we can overlay them. 

## get states coordinate reference system
st_crs(states) ## states is using the GEOCRS system, using a NAD83 projection
st_crs(firePoints) ## firePoints is using the PROJCRS system, using the NA Albers Equal Area Conic projection

## *****************************************************************************************************

## We will need to re-project the state data to match that of the wildfire data
## so that we can run spatial analyses.


## re-project using st_transform. You need to provide the crs of firePoints
states <- st_transform(states, crs = st_crs(firePoints))

st_crs(states) ## confirmed.


## Question 10*******************************************************************************************
## -------------------------------------------------------------------------------------------------------
## Q10a Map the state polygons with the firePoints over the state boundary polygons. 2 pts. 
  ggplot() + geom_sf(data=states, fill="lightgrey") + 
    ##scale_size_continuous(name="areaFire")+ ggtitle("Area of US Wildfires in 2020") + xlab("Longitude (m)") + ylab("Latitude (m)") + 
    geom_point(data = firePoints, aes(x=st_coordinates(firePoints)[,1], y=st_coordinates(firePoints)[,2]))
  
  
## Q10b. List two states that did not have any wildfires in 2020. 2 pts. 

## Michigan and Maine did not have wildfires in 2020. 

## Q10c. Calculate the area of each state. Create a field called 'areaState' 
## and make it equal to the area of each state in hectares. 4pts. 
## HINT: we did this above with areaFire.

## save state areas in hectares
areaState <- st_area(states)/10000


## ********************************************************************************************************

## Step 11********************************************************************************************

## Sum the wildfire hectares by state. 
## Aggregate the area in the firePoints object we made above by the new states sf object that you just made. 
## There are 820 wildfires and 52 states. We will aggregate those fires by state. 

## Use the aggregate function. The FUN is the function. You can do many functions here. 
(fireAreaSum<- aggregate(x = firePoints["areaFire"], by = states, FUN = sum))

## check the result 
head(fireAreaSum)
dim(fireAreaSum)

## the result is a spatial polygon data frame. 
class(fireAreaSum)

## Now we can join this new field back to states by making a field in states equal to our new areaFire calculation

states$areaFire <- fireAreaSum$areaFire

## check your work 
head(states)

## Question 11 ******************************************************************************************
## ------------------------------------------------------------------------------------------------------
## Q11a.  Which state had the most hectares burned in 2020? - 2 pts. 



## Q11b. Create a new field in your 'states' sf object called 'PercentAreaBurned'and make it equal to
## the areaFire / areaState. 4 pts. Show your code. 




## Q11c. Create two maps: 1 - a map of states displayed by variable 'areaFire' and 2 - a map of states displayed by 'PercentAreaBurned'. 
## 4 pts. 

## To map this data as continuous data, you will need to convert the area fields to numeric using function as.numeric()

## Example - the scale_fill_fermenter () is a color package that allows to color in our polygons using already specified colors. 
## the direction = 1 keeps the dark colors in the highest values. 

## see your options for palette colors here: https://ggplot2.tidyverse.org/reference/scale_brewer.html

ggplot() + 
  geom_sf(data = states, aes(fill=as.numeric(areaFire) ) )+
  scale_fill_fermenter(palette = "Oranges",n.breaks = 9, direction=1)



## Q11d. How do your maps from above differ? Does summing the wildfire hectares by state provide an example of the Modifiable Areal Unit Problem (MAUP)? 
## Why or Why not? Define MAUP and then provide answer. - 8 pts




## *****************************************************************************************************
## Question 12*****************************************************************************************
## ----------------------------------------------------------------------------------------------------

## Q12a. Count the number of fires in each. Which state has the highest number of fires? 8 pts
## Use the tools you have learned. How would yo do this? HINT - you will need to make a new field in firePoints. 
## your final field in 'states' needs to be called 'fireCount'




## Q12b. Map states by number of fires (not areaFire). How does this map differ from the areaFire map? 4pts. 



## Q12c. Standardize the count variable by areaState to create a density map. Make a map of 'fireDensity'. 4 pts. 



## ****************************************************************************************************************************************


## Congratulations!!






