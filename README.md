# UFMathGeo

In this study we attempt to predict the probability of Aedes aegypti and Aedes albopictus being observed in 95 counties across the contiguous United States 2 weeks in advance for each month in 2019 using a climate-based 2x2 population model.  


# Data Sources 
The U.S. Centers for Disease Control partnered with multiple vector control programs to provide a dataset containing monthly count data for trapping efforts of Aedes aegypti and Aedes albopictus for 95 counties from as early as January 2007 to as recent as December 2018. In order relate these count data to their geographic extent, a shapefile of all U.S. counties was attained from the U.S. Census Bureau. The PRISM (Parameter-elevation Regressions on Independent Slopes Model) climate group at Oregon State University creates and maintains a dataset of spatial climate data at 4 km resolution for the contiguous United States derived from weather monitoring stations. These data acquired for various time ranges. Monthly data was gathered from 1981 through 2019. Prospective monthly and seasonal forecasts in shapefile format were obtained from The National Oceanic and Atmospheric Administration. Temperature dependent trait data for Aedes aegypti and Aedes albopictus were digitized from a paper by Mordecai et al. 2017. These traits include biting rate, fecundity, mosquito development, egg-to-adult survival, and adult lifespan. In this study we refer to these traits as egg production frequency, egg production amount, egg development, egg to adult survival, and adult lifespan respectively.   

# Step 1
The first step in this study was to model the historical population of both species in each county and compare the predicted population number to the observed population number.  
Climate data for each county for each month from 2007 to 2018 was extracted from the PRISM dataset using the Census Bureau county shapefile to define the geographic area from which values should be taken. The mean of mean daily temperature values and the sum of monthly precipitation values was calculated for each county.  
Nonlinear functions were created using temperature dependent vector trait data, these functions were either quadratic or Briere (a model proposed Briere 1999 for arthropod traits). We followed the methods of Mordecai 2017 in deciding which functions to use for each traits.   
 
<p align="center">
  <img src="eqimage.png" />
</p>
 
Where 𝐸 is the number of eggs, 𝐴 is the number of adults, 𝑏 is the frequency of egg production in days, 𝑓 is the number of eggs produced, 𝑠 is the proportion of eggs that survive to become adults,  𝑣 is the daily rate of development from egg to adult, 𝑙 is the lifespan of an adult in days, and 𝑘 is the maximum number of eggs that can be supported. Parameters 𝑏, 𝑓, 𝑠, 𝑣, and 𝑙 are temperature dependent, and 𝑘 is precipitation dependent.  
 
The time step for the model is daily so each day after January 1st, 2007 was considered one time step. Monthly temperature and precipitation values were placed at the middle day of each month and values in between these days were linearly interpolated. The value of temperature-based parameters were determined using previously fitted functions. These fits were different for both species. Carrying capacity 𝑘 was assumed to be linearly associated with precipitation. Arbitrary initial conditions were selected with 𝐸 and 𝐴 both equalizing 500.

Output from each model was then compared to its respective count data. Count data was simplified to presence/absence data with 1 indicating presence and 0 indicating absence. The modeled population was aggregated back to the monthly level. For both species and each county the modeled population was compared to trapping attempts. A logistic function was fit, relating the modeled population size to the probability the mosquito was detected in a given month.


#Step 2

The second step in this study is to predict the probability of both species being detected in each county 2 weeks in advance for each month in 2019 using climate forecasts and the previously fitted detection curves. 

Monthly PRISM data are not available until after the month has ended. In order the generate this data for the current month, all available daily data are aggregated to the monthly level. This layer of data is then added to the collection of monthly PRISM climate data available for 2019. Again, the U.S. census county shapefile is used to extract mean temperature and precipitation. 

Forecasts provided by NOAA are in a peculiar format and must be converted into values for mean temperature and total precipitation. NOAA gives the probabilities that the value for a given climate variable will fall into one of three classes: below normal, normal, or above normal. The values for these classes were defined by NOAA using PRISM data from 1981 to 2010. Monthly data for this 30 year period is collected and split into thirds in ascending order. The median value for each third is considered the value for each class. To convert NOAA forecasts into values we calculated a weighted mean, weighing the median value for each class by the probability given by the NOAA forecast. This process must be done for each county. NOAA forecasts are available for next month and the next three months combined. The next three months combined was considered the month after next month for our modeling efforts.  

Monthly PRISM data was combined with the converted NOAA forecasts. The initial conditions for 2019 modeling were taken from the previous model which stopped at December 2018. The same parameters were also used as the previous model. Again, data was downscaled from the monthly level to the daily level using linear interpolation. The modeled population number for next month was converted into a probability of detection using the detection curve created in step 1 


References  
Briere JF, Pracros P, Le Roux AY, Pierre JS. A novel rate model of temperature-dependent development for arthropods. Environmental Entomology. 1999 Feb 1;28(1):22-9. 

Mordecai EA, Cohen JM, Evans MV, Gudapati P, Johnson LR, Lippi CA, Miazgowicz K, Murdock CC, Rohr JR, Ryan SJ, Savage V. Detecting the impact of temperature on transmission of Zika, dengue, and chikungunya using mechanistic models. PLoS neglected tropical diseases. 2017 Apr 27;11(4):e0005568. 








 
