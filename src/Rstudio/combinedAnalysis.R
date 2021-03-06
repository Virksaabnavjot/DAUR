install.packages(c("e1071", "C50", "ggplot2", "hexbin","descr", "caret", "e1071", "plotly"))
library(e1071)
library(hexbin)
library(ggplot2)
library(waffle)
library(plotly)
library(caret)
library(descr)
library(C50)
library(plyr)
library(gridExtra)
library(reshape2)

#Author: Navjot Singh Virk
#Student Number: x13112406
#
#FILE 2
#File Content :Analysis of data combined from both datasets and 
#comparision of the results

#Lets get started ...

#Getting the current working directory
getwd()

#NOTE: Please modify the working directory when working in your computer and the files
#are saved at different location then whats set into setwd

#Setting current directory to where datasets are saved
setwd("~/documents/love/analyses-of-2-datasets-using-r/datasets/")

#################################################
# Joining both datasets together
#################################################

#reading data from csv file 
mathData <- read.csv("student-mat.csv",sep=";",header=TRUE)
porData <- read.csv("student-por.csv",sep=";",header=TRUE)


#########################################################################
#Preparing Data in the datasets before combining it

# Add a new column named subject with "1" representing maths on each row
mathData <- data.frame(subject = rep(1, nrow(mathData)), mathData[,]) 
# Add a new column named subject with "2" representing maths on each row
porData <- data.frame(subject = rep(2, nrow(porData)), porData[,])
#NOTE: Please only run once the 2 lines above
#########################################################################

#View(mathData)
#View(porData)

#Saving all the data in combinedData dataframe
combinedData <- rbind(mathData,porData)
View(combinedData)

# Start to clean the data for analysis
# Removing few columns that are not used during analysis
#combinedData <- combinedData[-c(5,7,12)]

barplot(table(combinedData$Dalc), ylab='Number of Students', xlab='Workday Alcohol Consumption',
        main ='Combined Results \nWorkday Alcohol Consumption',
        col=rainbow(7))


plot<- ggplot(combinedData, aes(age, Walc, fill = Walc))+
  geom_boxplot(aes(fill=factor(age)))+
  ggtitle("(Combined Results) \nWeekend Alcohol consumption as per age")

ggplotly(plot)


plot<- ggplot(combinedData, aes(age, Dalc, fill = Dalc))+
  geom_boxplot(aes(fill=factor(age)))+
  ggtitle("(Combined Results) \nWorkday Alcohol consumption as per age")

ggplotly(plot)


plot(x=mathData$sex, y=mathData$age)

#################################################
# Plot # Weekend & Workday Alcohol consumption as per family relations
#################################################
s1 <- ggplot(combinedData, aes(famrel, Walc, fill = sex))+
  geom_polygon()+
  ggtitle("Combined Results \nWeekend Alcohol consumption as per Family Relations")

s2 <- ggplot(combinedData, aes(famrel, Dalc, fill = sex))+
  geom_polygon()+
  ggtitle("Combined Results \nWorkday Alcohol consumption as per Family Relations")

grid.arrange(s1,s2)
#################################################
# Plot # Weekend & Workday Alcohol consumption as per Gender
#################################################

p1 <- ggplot(combinedData, aes(sex, Walc, fill = sex))+
  geom_boxplot()+
  ggtitle("Combined Results \nWeekend Alcohol consumption as per Gender")

p2 <- ggplot(combinedData, aes(sex, Dalc, fill = sex))+
  geom_boxplot()+
  ggtitle("Combined Results \nWorkday Alcohol consumption as per Gender")

grid.arrange(p1,p2)

#################################################
# Plot # Workday Alcohol Consumption 
#################################################

plot(combinedData$Dalc, ylab='(Combined dataset) Workday Alcohol Consumption', type="o", col="blue", ylim=c(0,7))

#################################################
# Plot # Plotting Activities and Internet availability
#################################################
 
m1 <- melt(combinedData, measure.vars=c("internet","activities"))
qplot(variable, data=m1, fill=value) + facet_wrap( facets= ~variable, scale="free_x")
#Reference: http://stackoverflow.com/questions/18819274/how-do-i-plot-a-number-of-categorical-variables-on-a-graph-in-r

#################################################
# Plot # Intrested to take Higher Education and alcohol consumption
#################################################

ggplot(combinedData,aes(higher,Dalc))+
  geom_violin()+coord_flip()+
  xlab("Intrested in higher education")+
  ylab("Workday Alcohol Consumption")+
  ggtitle(" Distribution of Alcohol Consumption Given Desire for Higher Education")
#Reference: https://www.kaggle.com/interkf/d/uciml/student-alcohol-consumption/alcohol-consumption-from-portuguese-school

#################################################
# Plot # Workday alcohol consumption per age
#################################################

ggplot(porData, aes(x=age, fill=Dalc))+
  geom_histogram(binwidth=1, colour="white",aes(fill=factor(age)))+
  facet_grid(~Dalc)+
  theme_bw()+
  theme(legend.position="none")+
  ggtitle("Combined Data results on \nWorkday alcohol consumption per age")+
  xlab("Student's age") 
#Reference: https://www.kaggle.com/marcdeveaux/d/uciml/student-alcohol-consumption/student-alcohol-consumption/comments



