library(data.table)
library(reshape2)

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

# Merge training and test data sets
x_merge <- rbind(x_test, x_train)
subject_merge <- rbind(subject_test, subject_train)
y_merge <- rbind(y_test, y_train)

# Add descriptive variable (column) names to data set
names(x_merge) <- features$V2
names(subject_merge) <- "subject_id"
names(y_merge) <- "activity"

# Extract mean and standard deviation column numbers
mean_std_cols <- grep("mean()|std()", features$V2)

# Retain only mean and standard deviation columns in merged data set
x_merge <- x_merge[, ..mean_std_cols]

# Add subject and activity columns to data set
data_merge <- cbind(subject_merge, y_merge, x_merge)

# Add descriptive activity names to data set
data_merge$activity <- factor(data_merge$activity, labels=activity_labels$V2)

# Create new table with the variable average for each subject and activity
data_merge_melt <- melt(data_merge, id=c("subject_id","activity"))
activity_averages <- dcast(data_merge_melt, subject_id+activity ~ variable, mean)

# Write table with tidy data to text file
write.table(activity_averages, "activity_averages_per_subject.txt", sep = ",")

