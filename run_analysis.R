# This script fulfills the course project assignment for the Getting and 
# Cleaning Data class offered as part of the 
# John Hopkins Data Science Course track

# Set Working Directory
setwd("./DataSci_coursera/Getting_Cleaning/Project")

# Load necessary packages
# make sure to load plyr before dplyr, there is a nice warning if you do not
library(plyr) 
library(dplyr)
library(tidyr)

# # source the data (commented out after initial download)
# download.file(paste0("http://d396qusza40orc.cloudfront.net/",
#                      "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"), 
#               destfile = "./prj_data.zip")
# 
# # unzip the file, there are multiple files, which all will be extracted by 
# # default, the default is to extract to the same directory the zip file is in
# # which is what I want
# unzip("prj_data.zip")
# list.files(".", recursive = TRUE) # checking what was extracted

# After reading in the individual tables, it is fairly straightforward
# figuring our how each component would fit together after checking each 
# table's dimensions. We should not have to call merge() since this data is
# well structured. Calls to rbind() and cbind() should suffice. Also, after
# some testing with the data.table package, this dataset seems to crash fread(),
# so I decided to just not work with data.tables in this exercise.

# The first two tasks are combined, read in the data and merge the training
# and testing sets with rbind() since we want to merge the observations
# (rows) together. IMPORTANT - make sure the order when combining is consistent.
# Here, the training data is always added first.

dta <- rbind(read.table("./UCI HAR Dataset/train/X_train.txt"),
              read.table("./UCI HAR Dataset/test/X_test.txt"))

# Insert the names of the columns. Load in the features table. Set colClasses 
# arg. to "character." This makes sure that labels aren't coerced to factors.

var_names <- read.table("./UCI HAR Dataset/features.txt", 
                        colClasses = "character")

names(dta) <- unlist(var_names[,2])

# Although somewhat unclear and open-ended, my interpretation of the project
# instructions is to extract the columns that contain mean() and std() in their
# names. This would leave out the meanFreq as well as those from angle()
# variable. We can match only "mean" and "std" lower case letters in this case.
# Now subset out only the those columns that have the names containing "mean()"
# or "std()" which is short for standard deviation. A grepl() call with a 
# regex will catch all of these. Used the metacharcter[^] to make sure I do not 
# get the meanFreq() observations.

dta <- dta[,grepl("mean[^Freq]()|std()", names(dta))]

# read  in the activity labels table, giving the activity codes

lab_key <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                      colClasses = "character")

# Read in activity labels. 

act_lab <- rbind(read.table("./UCI HAR Dataset/train/y_train.txt"),
             read.table("./UCI HAR Dataset/test/y_test.txt"))
 
# make sure the the plyr package is loaded and use mapvalue() to create a vector
# of factors that use the actual descriptors rather the the integer code. 
# It will need  be atomic factor vector, so unlist and coerce to factor.

act_descript <- mapvalues(as.factor(unlist(act_lab)), from = 1:6, 
                          to = unlist(lab_key[,2]))

# Combine into a data frame and rename for clarity and readability

act_lab <- cbind(act_lab, act_descript) 
names(act_lab) <- c("Activity_Code", "Activity")

# Read in the subjects, make an atomic vector, coerce as factor, then combine 
# with the ID number. Then rename as above.

Subject <- as.factor(unlist(rbind(read.table(paste0("./UCI HAR Dataset/train/",
                                                     "subject_train.txt")),
                                   read.table(paste0("./UCI HAR Dataset/test/",
                                                     "subject_test.txt")))))

# stick all three togther with cbind(), get rid of activity_code, not necessary
# now and thus untidy, also add a row number index, this is needed so that all 
# observations can be uniquely identified by tidyr functions as found out
# from a stack overflow post (answered by Hadley Wickham)

dta <- cbind(Subject, act_lab, dta)
dta <- dta[,-2]
dta$Row <- 1:nrow(dta)


# This dataset is still quite messy with columns representing 2 categorical 
# variables (whether it's mean/std, and its vector property - X,Y,Z, magnitude).
# This will be fixed with some tidyr and plyr functions. First, variable names 
# need to manipulated to make this easier.

# Remove the "BodyBody" typo in some variables
names(dta) <- sub("BodyBody", "Body", names(dta))

# This next block of code takes all variables with "Mag" in there name and 
# appends "-magnitude" giving it a similar  string structure to -XYZ variables
# The "Mag" is then removed

magni_logi <- grepl("Mag", names(dta))
i = 1
for(i in 1:length(names(dta))){
      if (magni_logi[i] == TRUE){
            names(dta)[i] <- paste0(names(dta)[i], "-magnitude")
            i <- i + 1
      } else {
            i <- i + 1
      }
      
}
names(dta) <- sub("Mag", "", names(dta))

# Using tidyr functions, all of the variables will be placed in their own 
# column. This will make the final summarizing easy using plyr's ddply in 
# conjunction numcolwise() function. See documentation for what these
# functions do.

tidy_dta <- dta %>% gather(variables, measure, -Row, -Subject, -Activity) %>%
      separate(col = variables, 
               into = c("var", "metric", "vector_property")) %>%
      spread(var, measure)

# Row Column no longer needed and is last messy part of the data frame
tidy_dta <- tidy_dta[,-3]

# We now have a tidy data frame, the fBodyGyroJerk only had a magnitude, so 
# NAs were introduced to -XYZ rows, but this should not be a problem for 
# interpretation

# Here is the final step put into a single line. numcolwise() will perform the 
# function passed to it on all the columns in a data frame. In conjunction with
# ddply() you can group by several categorical variables like is done here then
# perform the function on the rest of the columns which is what is desired.

tidy_dta2 <- ddply(tidy_dta, 
                   .(Subject, Activity, metric, vector_property),
                   numcolwise(mean))

# We are now done with the project task. we have the mean for each subject for
# each activity for each variable. Write the dataset to a .txt file.

write.table(tidy_dta2, file = "./TidyDataProjectStep5.txt", row.names = FALSE)

