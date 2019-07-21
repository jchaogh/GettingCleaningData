---
title: "Code Book for the Getting and Cleaning Data Course Project"
author: "J Chao"
date: "7/21/2019"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Getting and Cleaning Data Course Project

This code book describes the transformations made to the UCI Human Activity Recognition (HAR) Dataset to generate a tidy table containing variable averages per subject and activity.  The transformations are described below:

### Data Source
The original UCI HAR dataset is available at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

An overview of the dataset is posted at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Import activity labels, features, and test and training data sets into corresponding data frames

##### The HAR source data used in this analysis is listed below along with a brief description of each table: 
* activity_labels : Table of activity IDs and corresponding activity names (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
* features : A list of measurements and calculations corresponding to columns in the test and training data sets
* subject_test : A list of subject IDs corresponding to the measurements in the test data set
* X_test : Measurements and values corresponding to each subject and activity in the test data set
* y_test : A list of activity IDs corresponding to a specific activity, identified by the activity_labels, in the test data set
* subject_train : A list of subject IDs corresponding to the measurements in the training data set
* X_train : Measurements and values corresponding to each subject and activity in the training data set
* y_train : A list of activity IDs corresponding to a specific activity, identified by the activity_labels, in the training data set

```{ }
# Read activity labels and features
activity_labels <- data.table::fread('./UCIHARDataset/activity_labels.txt')
features <- data.table::fread('./UCIHARDataset/features.txt')

# Read test data
subject_test <- data.table::fread('./UCIHARDataset/test/subject_test.txt')
x_test <- data.table::fread('./UCIHARDataset/test/X_test.txt')
y_test <- data.table::fread('./UCIHARDataset/test/y_test.txt')

# Read training data
subject_train <- data.table::fread('./UCIHARDataset/train/subject_train.txt')
x_train <- data.table::fread('./UCIHARDataset/train/X_train.txt')
y_train <- data.table::fread('./UCIHARDataset/train/y_train.txt')

```

### Merge training and test sets to create one data set

##### Tables are merged into the following data frames: 
* x_merge : Merged test and training data
* subject_merge : Merged subject IDs
* y_merge : Merged activity IDs

```{ }
# Merge training and test data sets
x_merge <- rbind(x_test, x_train)
subject_merge <- rbind(subject_test, subject_train)
y_merge <- rbind(y_test, y_train)
```

### Label the data set with descriptive variable names

##### Column names are added to each merged table: 
* features$V2 : Names of each measurement and/or calculation
* subject_id : Subject ID of the participant
* y_merge : Activity ID of the activity being measured

```{ }
# Add descriptive variable (column) names to data set
names(x_merge) <- features$V2
names(subject_merge) <- "subject_id"
names(y_merge) <- "activity"
```

### Extract measurements on the mean and standard deviation for each measurement

##### A subset of mean and standard deviation columns is extracted from the original table: 
* mean_std_cols : A vector of column IDs containing the string 'mean()' or 'std()' in the column title
* x_merge : Table containing only mean and standard deviation calculations

```{ }
# Extract mean and standard deviation column numbers
mean_std_cols <- grep("mean()|std()", features$V2)

# Retain only mean and standard deviation columns in merged data set
x_merge <- x_merge[, ..mean_std_cols]

```

### Add descriptive activity names to the data set

##### Activity IDs are replaced by activity names
* data_merge$activity : Column of activity IDs replaced by activity names.
* activity_labels$V2 : Table containing activity ID/name mappings

```{ }
# Add subject and activity columns to data set
data_merge <- cbind(subject_merge, y_merge, x_merge)

# Add descriptive activity names to data set
data_merge$activity <- factor(data_merge$activity, labels=activity_labels$V2)

```

### Create second tidy data set with the variable average for each subject and activity

##### Variable averages are calculated using the reshape2 library
* data_merge_melt: Melted table containing variable/value pairs per subject and activity
* activity_averages: New table containing variable averages per subject and activity
* activity_averages_per_subject.txt: New file containing variable averages in tidy data format

```{ }
# Create new table with the variable average for each subject and activity
data_merge_melt <- melt(data_merge, id=c("subject_id","activity"))
activity_averages <- dcast(data_merge_melt, subject_id+activity ~ variable, mean)

# Write table with tidy data to text file
write.table(activity_averages, "activity_averages_per_subject.txt", sep = ",")
```
