---
title: "README for the Getting and Cleaning Data Course Project"
author: "J Chao"
date: "7/21/2019"
output: html_document
---

## Getting and Cleaning Data Course Project

The course project transforms data in the UCI Human Activity Recognition (HAR) Dataset to generate a tidy table containing variable averages per subject and activity.  Specifically, the script does the following:

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Files

* run_analysis.R - R script that generates a tidy data set containing variable averages per subject and activity
* CodeBook.RMD - Describes the variables in run_analysis.R

### Instructions

1. Download and unzip the UCI HAR source data to a local directory.  The UCI HAR dataset is available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip .
2. Place the run_analysis.R file in the same directory as the UCI HAR dataset.
3. Run the script to generate a new, tidy data set named 'activity_averages_per_subject.txt'

### Library Dependencies

The following packages must be installed in order to run run_analysis.R:

* data.table
* reshape2


