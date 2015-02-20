# Code Book
## Coursera Data Science Series: Getting and Cleaning Data
### Course Project

This exercise will turn several large flat files of motion variables recorded with a Samsung Galaxy's
accelerometer and gyroscope for thirty subjects into a tidy data set. Using R, a table is produced 
following tidy data principles ready for analysis by a researcher/statistician.

The data was sourced from the Getting and Cleaning Data course website. The original source with 
additional information can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#).
if more detail about the data is desired.

The data was devided into a training set and test set. These were merged together to create a single dataset.
The dataset contains 561 domain variables derived from the readings taken by the accelerometer (tria-axial acceleration) 
and gyroscope(tri-axial angular acceleration). We are only interested in the derived means and standard deviations.
This will reduce the dataset considerably and the variables presented in this code book will reflect that. 



## Variables
1. Subject

    Code for 1 of 30 individuals who participated in the study

2. Activity

    1 of 5 activities performed by subjects while data was recorded
    * WALKING
    * WALKING UPSTAIRS
    * WALKING DOWNSTAIRS
    * SITTING
    * STANDING
    * LAYING

3. metric
  
    mean - the mean of the data recorded on each subject for each observation
    std - the standard deviation

4. vector_property

    Almost all variables were recorded in 3-Dimensional space. The X,Y,X vectors are provided
    as well as the magnitude calculated from them.

5. fBodyAcc

    Frequency domain Body Acceleration signals

6. fBodyAccJerk

    Frequency domain Body Acceleration Jerk signals

7. fBodyGyro

    Frequency domain Body Angular Velocity signals

8. fBodyGyroJerk

    Frequency domain Body Angular Velocity Jerk signals

9. tBodyAcc

    Time domain Body Acceleration signals

10. tBodyAccJerk

    Time domain Body Acceleration Jerk signals

11. tBodyGyro

    Time domain Body Angular Velocity signals
12. tBodyGyroJerk

    Time domain Body Angular Velocity Jerk signals

13. tGravityAcc

    Time domain Gravity Accelration signals

No transformation of the data took place. The data set was created using the author's best 
understanding of Tidy data principles. One observation per row, one variable per column.
Only three packages besides base were used in R, plyr, dplyr, and tidyr.See comments in the
R scripts run_anlaysis.R for rationale for decisions of specific R code.