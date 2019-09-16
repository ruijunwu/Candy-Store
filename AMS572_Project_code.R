
# Description: 

# What’s the best (or at least the most popular) Halloween candy? That was the question 
# this dataset was collected to answer. Data was collected by creating a website where 
# participants were shown presenting two fun-sized candies and asked to click on the one 
# they would prefer to receive. In total, more than 269 thousand votes were collected 
# from 8,371 different IP addresses.

# N = 85.

# The data contains the following fields: 
#   chocolate: Does it contain chocolate?
#   fruity: Is it fruit flavored?
#   caramel: Is there caramel in the candy?
#   peanutalmondy: Does it contain peanuts, peanut butter or almonds?
#   nougat: Does it contain nougat?
#   crispedricewafer: Does it contain crisped rice, wafers, or a cookie component?
#   hard: Is it a hard candy?
#   bar: Is it a candy bar?
#   pluribus: Is it one of many candies in a bag or box?
#   sugarpercent: The percentile of sugar it falls under within the data set.
#   pricepercent: The unit price percentile compared to the rest of the set.
#   winpercent: The overall win percentage according to 269,000 matchups.


# For binary variables, 1 means yes, 0 means no.




# ___________________________________________________________________________
library(ggplot2)
library(dplyr)
library(gridExtra)
library(viridis)
library(ggthemes)
library(ggridges)
library(RColorBrewer)
library(ggrepel)
library(ggdendro)
library(grid)
library(gridExtra)



#   Import data for the csv file
setwd("~/Desktop/AMS 572 project")
candy_data <- read.table("candy-data.csv", header=TRUE, sep=",")

#__________________________________Data analysis and Plots________________________________________

candydata<-read.csv("candy-data.csv",sep=",",stringsAsFactors=F)

summary(candydata)

#------------------ggplot-barplot of percentage of candies with features----------

candy_data_1<-candydata %>% dplyr::mutate(sum = rowSums(.[2:10]))

#convert to factor,1 means yes, 0 means no.
for(i in 2:10){
  candy_data_1[,i]<-ifelse(candy_data_1[,i]==1,'yes','no') 
}
features<-c('chocolate', 'fruity', 'caramel', 'peanutyalmondy', 'nougat', 'crispedricewafer', 'hard', 'bar', 'pluribus')

# made the 3*3 plot 
histPlot<-list()
for(i in 1:length(features)){
  histPlot[[i]]<-candy_data_1 %>% dplyr::group_by_(.dots =features[i]) %>% 
    summarize(count=n()) %>% 
    mutate(perc = round(100*count/sum(count),2)) %>% 
    ggplot(aes_string(x=features[i])) + 
    geom_bar(aes(y=perc), stat='identity') +
    theme_fivethirtyeight() + 
    ggtitle(paste0('percentage of candies having\n',features[i])) + 
    theme(plot.title=element_text(face="bold",hjust=.012,vjust=.8,colour="#3C3C3C",size=12)) + ylim(0,100)
}
do.call(grid.arrange, c(histPlot, ncol=3))

#---------------------winpercent ranking ---------
attach(candydata)
candyrank<-cbind(competitorname,winpercent)
candyrank[order(-winpercent),]

#-------------------correlation heat map-------------

library(corrplot) #Visualization of correlation
library(relaimpo) #Relative Importance of Attributes (Shapley Value)


#Correlation Heatmap of our data
candydatacor<-cor(candy_data[,-1])
corrplot(candydatacor)


#--------------------hypothesis 2   chocolate vs. caramel box polt--------------------
Features <- candy_data_1 %>% select(2:10)     
ggplot(Features, aes(x = chocolate, y= sugarpercent ) ) + geom_boxplot(varwidth = TRUE)# add the barpot
ggplot(Features, aes(x = caramel, y= sugarpercent ) ) + geom_boxplot(varwidth = TRUE) # add the barpot




#--------------------------Proportional Test Added-------11/02/2018----------------------------------

#Hypothesis 1

#Among the candies with winpercent greater than 50, the proportion of chocolate is greater than fruity

#H0: p.chocolate = p.fruity
#H1: p.chocolate > p.fruity

#First we extract data with winpercent greater than 50:
high_win = candy_data[which(candy_data$winpercent>50),]

#Then we collect the chocolate and fruity columns:
high_win_chocolate = high_win$chocolate
high_win_fruity = high_win$fruity

#Set up the parameters needed for the proportion test:
#Sample size of chocolate (n1):
nc = length(high_win_chocolate)
#Sample size of fruity (n2):
nf = length(high_win_fruity)
#Size of chocolate = 1:
xc = length(high_win_chocolate[which(high_win_chocolate==1)])
#Size of fruity = 1:
xf = length(high_win_fruity[which(high_win_fruity==1)])
#Proportion of chocolate (p1):
p.chocolate = xc/nc
#Proportion of fruity (p2):
p.fruity = xf/nf

#Do the proportion test with alpha = 0.05:
prop.test(x = c(xc, xf), n = c(nc, nf), alternative = "greater", conf.level = 0.95)

#The test gives a p.value = 0.0001454, which is extremely small, so we reject H0 and conclude that
#candies with chocolate has larger proportion than fruity candies among the "popular" candies.



#__________________________________________________________________________


#--------------------------------Equal Mean Test Added------11/08/2018------------------------------------

#Hypothesis 2

#We are interested in comparing the sugar amount between candies with different ingredients.
#We would like to check if chocolate candies contains less sugar than the caramel candies.

#H0: mu.chocolate = mu.caramel
#H1: mu.chocolate < mu.caramel

#First we extract the data of chocolate and fruity candies into two groups:
chocolate_test2 = candy_data[which(candy_data$chocolate == 1),]
caramel_test2 = candy_data[which(candy_data$caramel == 1),]

#Then we get the corresponding sugar percentages:
chocolate_sugar = chocolate_test2$sugarpercent
caramel_sugar = caramel_test2$sugarpercent

#Test normality
shapiro.test(chocolate_sugar)
shapiro.test(caramel_sugar)
#test the variance
var.test(chocolate_sugar,caramel_sugar,ratio=1, conf.level = 0.95)

#Perform a pooled-variance t-test:
t.test(chocolate_sugar, caramel_sugar, alternative = 'less', mu=0, conf.level = 0.95,var.equal = TRUE)
#The test gives a p-value = 0.0784, so we do not reject H0 and conclude that there is not enough evidence
#which shows that chocolate candies contain more sugar than caramel candies.



#__________________________________________________________________________

# Hypothesis 3:

# Whether a candy is a bar, whether a candy is fruity and overall win percentage are good predictors of whether the candy contains chocolate or not.

# Let's apply Generalized Linear Model to analyse this question. 

# First, let's convert binary variables to factors
candy_data$chocolate <- factor(candy_data$chocolate)
candy_data$fruity <- factor(candy_data$fruity)
candy_data$bar <- factor(candy_data$bar)

# Construct GLE model
chocolate_model <- glm(chocolate ~ bar + fruity + winpercent, 
                           data = candy_data, family = "binomial")
summary(chocolate_model)


# To assess explained variation we will use McFadden's pseudo-R squared. 

# Construct GLE null model
chocolate_predictor_null <- glm(chocolate ~ 1, data = candy_data, family="binomial")

#  McFadden's pseudo-R squared is equal to 0.7293682
1 - logLik(chocolate_model) / logLik(chocolate_predictor_null)

# Since pseudo-R squared is rather high, it is reasonable to conclude that the information 
# about whether a candy is a bar, whether a candy is a fruity, and overall win percentage 
# is a good predictors of whether the candy contains chocolate or not.




