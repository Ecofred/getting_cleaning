# DATA
DATA SOURCE: [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
Extracted in the "UCI HAR Dataset" folder
FILE: meanfeature_per_activities_subject.txt contains aggregated features (metrics)

# VARIABLES

grouping variable (keys)

+ subject_id : subject id
+ activity_name : activity name

Aggregated measured variables (features) by the mean for the 3 axis (Body & Gravity acceleration and Body gyroscopy)

+ tBodyAcc.mean...X
+ tBodyAcc.mean...Y
+ tBodyAcc.mean...Z
+ tBodyAcc.std...X
+ tBodyAcc.std...Y
+ tBodyAcc.std...Z
+ tGravityAcc.mean...X
+ tGravityAcc.mean...Y
+ tGravityAcc.mean...Z
+ tGravityAcc.std...X
+ tGravityAcc.std...Y
+ tGravityAcc.std...Z
+ tBodyGyro.mean...X
+ tBodyGyro.mean...Y
+ tBodyGyro.mean...Z
+ tBodyGyro.std...X
+ tBodyGyro.std...Y
+ tBodyGyro.std...Z"



# TRANSFORMATION/WORK
for each test and train data group, the dataset was reconstructed by combining the 'subject' (subject ids), 'X' (feature dataset), 'y' (activity dataset).
A major asumption is that the lines are matching in the dataset. it would have been easier with a key variable to join the 3 datasets.

Variables from the 'X' dataset were named according to the 'feature.txt'

Activities were made human readable by matching the code available in the 'activity_labels.txt'

the train and tested tidy dataset were then combined (united) and a subset of variables (measured mean/standard deviation) were selected to compute an average per subject/activity.