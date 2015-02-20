# Getting_Cleaning_course_project
The repo for Course Project for the Coursera Data Science track course - Getting and Cleaning Data

## run_analysis.R
Script that processes the project data into a tidy data set. Contains comments explaining code.
In summary, the script downloads, and unzips the data. Initial exploration of the data revealed that is well structured.
Note: This dataset is somewhat large, and the initial thought was to use data.table. However fread() not work, and the speed of base data frame 
functions still performed sufficiently.  
The dimensions of each dataset show how they logically fit to the other pieces. rbind and cbind were all that was needed. No need to call merge()
It is important to make sure the training data and testing data were bound consistently however. See code comments.

The mapvalue function form plyr turned out to be handy for swapping the activity lables for the integer codes.

The decision was made to only include variables with the -mean() and -std(). The instrcuctions were not very explicit so this is my interpretation.

String manipulation and some simple regular expressions were useful for selecting out the mean and std varbiables. I also used grepl() and sub()
to manipulate the magnitude variables, so that they would be easier to process with tidyr functions.

I made the decision to place magnitude and -XYZ variables into one column. Although magnitude is not the same variable as XYZ, in fact it is 
calculated from XYZ, it still seems like placing these in a "vector property" column was the most straightforward solution.

The numcolwise() function is very useful for summarizing many columns in a data frame. It made summarizing the step 4 data frame with ddply()
very easy in order to produce the final step data frame.

## CodeBook.md
Contains information that further explains the project details, the reasoning for the task, and the variables presented in the final dataset.
