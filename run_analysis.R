# Getting and cleaning data: Week 4
# data source:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# extracted in the "UCI HAR Dataset" folder

# Note: Instruction where reported in the comments with their number (5-4) to help
#       for the review

avgfeature <- function(dir_data = 'UCI HAR Dataset', agg_file = 'avgfeature_per_activities_subject.txt'){
# I like to work with dplyr and pipe
library(dplyr)

# set working directory to the assignement folder
old_wd = getwd(); setwd(dir_data)


# retrieve ----------------------------------------------

## Subjects ---------------------------------
## the category variable is not part of the assignement, but i like to have the
## the source explicit in the dataset (it helped me in the past)

strain = read.csv("train/subject_train.txt", col.names = 'subject_id', 
                  header = FALSE) %>% 
  as_tibble() %>% 
  mutate(category = "train")
stest = read.csv("test/subject_test.txt", col.names = 'subject_id', 
                  header = FALSE) %>% 
  as_tibble() %>% 
  mutate(category = "test")


## Feature -----------------

# 4. Appropriately labels the data set with descriptive variable names. 
feature_name <-
  read.table(file = "features.txt", header = FALSE,
             stringsAsFactors = FALSE,
             col.names = c("feature_code", "feature_name"))$feature_name
  
xtrain = read.table("train/X_train.txt", header = FALSE,
                    col.names = feature_name) %>% 
  as_tibble()
xtest = read.table("test/X_test.txt", header = FALSE,
                   col.names = feature_name) %>% 
  as_tibble()

## Activity --------
ytrain = read.table("train/y_train.txt", header = FALSE,
                    col.names = 'activity_code') %>% 
  as_tibble()
ytest = read.table("test/y_test.txt", header = FALSE,
                    col.names = 'activity_code') %>% 
  as_tibble()


# pack train and test data in one dataset ------------------
# and give activity their name

activity_labels <- 
  read.table("activity_labels.txt", header = FALSE,
             col.names = c("activity_code", "activity_name")) %>% 
    as_tibble()

# we are done with the data, we return in the project directory
setwd(old_wd)

# 1. Merges the training and the test sets to create one data set.
# 3. Uses descriptive activity names to name the activities in the data set
analysis_ds <-
  inner_join(x = bind_rows(bind_cols(strain, xtrain, ytrain),
                           bind_cols(stest, xtest, ytest)),
             y = activity_labels,
             by = 'activity_code')

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# Note: "for each measurement" was quite ambiguous for an instruction,
# so I focused on what really was measured: 
# 'time' BodyGyro and BodyAcc/GravityAcc on the X,Y,Z axis
activity_mean_std = select(analysis_ds, 
                           subject_id, activity_name,
                           matches("^t(Body|Gravity)(Gyro|Acc).(mean|std)...[XYZ]$"))
                           # it all depends on the match specification



# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# VERSION 1
# it took me some time until I discover the aggregate function
# ... really suited for the present question
# ... plus I love the formula notation with the dot '.' meaning 'the rest'

# aggregate(. ~ subject_id + activity_name, data = activity_mean_std, mean)

# VERSION 2 - selected one
# ... also nice and part of the dplyr
avgfeature <-
  activity_mean_std %>% 
  group_by(subject_id,activity_name) %>% 
  # summarise all but the grouping variable
  summarise_all(mean) 

avgfeature %>% 
  # and finally save it :)
  write.table(agg_file, row.names = FALSE)

return(avgfeature)

}
