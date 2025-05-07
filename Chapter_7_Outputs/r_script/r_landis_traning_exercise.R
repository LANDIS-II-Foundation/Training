library(terra)
#This is the R library used to process raster files.

library(rgdal) ## not available for newer versions of R
#You may need this library as well.

library(dplyr)
## This can be used to summarize means

LANDIS_directory<-"C:/Users/d86081g/Desktop/2025 LANDIS Training/Chapter_7_Outputs/"
#file directory where inputs and outputs are found.  Edit this to represent your own file #location.

list.files(LANDIS_directory)
#lists files within the directory.

ecoregion_file<-paste(LANDIS_directory,"ecoregions.tif",sep="")
#paste LANDIS-II directory with ecoregion file name. (sep ="") defines what to separate pasted #objects with.  ?? = nothing separating objects.

ecoregion_raster<-rast(ecoregion_file)
#Rasterize the directory pointing to the LANDIS-II ecoregion raster file.

plot(ecoregion_raster)
#Plot ecoregion.  This gives a quick visual of your map.  This line could be edited to include a prettier map but that's not the point.

freq(ecoregion_raster)
#This line gives the value and count of the raster.  Same information as an Attribute Table in #ARC GIS.

max_age_file<-paste(LANDIS_directory,"outputs/max-age-spp/AllSppMaxAge-20.tif",sep="")
#paste directory with output file name.  This could be easily edited to assess alternative years.
# FKT edit adjust to .tif file and change folder names

max_age_raster<-rast(max_age_file)
#Rasterize a LANDIS-II output file. 

plot(max_age_raster)
#Plot output for reference. Again, this map could be made prettier but that's not the point. 

ecoregion_DF<-as.data.frame(ecoregion_raster) 
#Dataframizes the ecoregion raster (puts the raster into one long string).

max_age_DF<-as.data.frame(max_age_raster) 
#Dataframize the LANDIS-II output raster (puts raster into one long string).
colnames(max_age_DF) <- "AllSppMaxAge.20"
# FKT edit. change columnn name to avoid problem later with -; to match code in for-loop 

ecoregion_Max_age_combine<-cbind(ecoregion_DF,max_age_DF)
#Column Bind the ecoregion data frame to the max age data frame.

head(ecoregion_Max_age_combine)
#This line prints the first few rows of data so that  you can see what the data look like.

## Method 1. Using a for-loop

unique_ecoregions<-unique(ecoregion_DF[,1])
#Identify unique ecoregion names (i.e. 1 and 2)

for (unique_ecoregion in unique_ecoregions){
  #for every unique ecoregion name (do some function)...
  
  print (unique_ecoregion)
  #print the ecoregion name
  
  ecoregion_subset<- subset(ecoregion_Max_age_combine, ecoregion_Max_age_combine$ecoregions == unique_ecoregion)
  #subset just the data from a single ecoregion.
  
  ecoregion_mean_max_age<-mean(ecoregion_subset$AllSppMaxAge.20)
  #Average max age for a unique ecoregion
  
  print(ecoregion_mean_max_age)
  #print the mean max age for a unique ecoregion
  
}
#end of unique ecoregion loop.

## Method 2. Using tapply.

#The following tapply line returns the same information as loop above.
ecoregion_mean_max_age_summary<-tapply(max_age_DF[,1],list(ecoregion_DF[,1]), mean)
#summary of maxage by ecoregion.

print(ecoregion_mean_max_age_summary)
#print the summary of maximum age by ecoregion

## Method 3. Using dplyr ## FKT added tidyverse option 

Max_age_Summary<-
ecoregion_Max_age_combine %>%
  group_by(ecoregions)%>%
  summarise(mean=mean(AllSppMaxAge.20))

print(Max_age_Summary)





