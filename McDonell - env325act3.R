install.packages("dplyr")
install.packages("lubridate")
library(dplyr)
library(lubridate)

#read in the data
streamH <- read.csv("/cloud/project/stream_gauge.csv")
siteInfo <- read.csv("/cloud/project/site_info.csv")

###in class prompts, hw part 1
#parse the data, change character data into date/time
streamH$dateF <- ymd_hm(streamH$datetime,
                        tz= "America/New_York")

#example functions in lubridate
year(streamH$dateF)

leap_year(streamH$dateF)

##example functions in dplyr
#join site info and stream heights into a new data frame Floods
Floods <- full_join(streamH, # left table
                    siteInfo, # right table
                    by= "siteID") # common identifier

##filtering data in dplyr
#creating a new df, "peace", and subset to only look at one river
peace <- Floods %>%
  filter(siteID == 2295637)

#another example
example <- Floods %>% 
  filter(gheight.ft >= 10)

##plotting using base R
plot(peace$dateF, peace$gheight.ft, type = "l")
#default type is points, type b means there will be points connected by lines, type l means it will be a line

##to find the max height at each site, need to tell R to treat each name as a group, then within each group find the summary stats
max_height <- Floods %>%
  group_by(names) %>%
  summarise(max_height_ft = max(gheight.ft, na.rm = TRUE),
            mean_height_ft = mean(gheight.ft, na.rm = TRUE))

##prompt 3, working together
#what was the earliest date that each river reached the flood stage?
min_flood <- Floods %>%
  group_by(names) %>%
  summarise(min_flood_ft = min(flood.ft, na.rm = TRUE))

coochie <- Floods %>%
  filter(siteID == 2312000)
#we were going to go site by site and set the individual flood conditions at each site
##so how to actually do this
flood_date <- Floods %>%
  filter(gheight.ft >= flood.ft) %>%
  group_by(names) %>%
  summarise(min_date = min(dateF))


###homework part 2
#make a separate plot of the stream data for each river and in 3-4 sentences 
#compare general patterns in the stream stage between sites around Hurricane Irma. 

#creating df for fisheating river
fisheating <- Floods %>%
  filter(siteID == 2256500)

#creating a df for santa fe river
santa.fe <- Floods %>%
  filter(siteID == 2322500)

#creating a plot for each river
plot(peace$dateF, peace$gheight.ft, type = "l",
     xlab = "Date", ylab = "Height")

plot(coochie$dateF, coochie$gheight.ft, type = "l",
     xlab = "Date", ylab = "Height")

plot(fisheating$dateF, fisheating$gheight.ft, type = "l",
     xlab = "Date", ylab = "Height")

plot(santa.fe$dateF, santa.fe$gheight.ft, type = "l",
     xlab = "Date", ylab = "Height")

#question 2: What was the earliest date of occurrence for each flood category in each river? 
#How quickly did changes in flood category occur for each river? 
#Do you think there was enough time for advanced warning before a flood category changed?

flood_date <- Floods %>%
  filter(gheight.ft >= flood.ft) %>%
  group_by(names) %>%
  summarise(min_date = min(dateF))

#Water level changes occurred within a few hours. I do not think an advanced warning could have
#been administered before peak flood levels.

#question 3: Which river had the highest stream stage above its listed height in the major flood category?
#Peace River

#question 4: 


