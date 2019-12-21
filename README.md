# Getting and Cleaning Data Project
## run_analysis.R functionality

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## result of run_analysis.R
The script will perform transformations to produce a tidy data set and write it to `tidyDataSet.txt`.

## transformations performed
1. tidy up features
  - extract he mean and standard deviation features
  - read activity labels
  - read feature names
  - reduce to wanted features
2. tidy up test and train datasets and merge
3. convert activity and subject columns into factor variables
4. transform data, using subject / acitivity pair as key and apply the mean function to each vector of values 
5. save tidy dataset
