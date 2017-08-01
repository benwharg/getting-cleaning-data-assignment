library(tidyverse)

#import label data
activity_labels <- read.table("C:\\UCI HAR Dataset\\activity_labels.txt", header = F, stringsAsFactors = F)
features <- read.table("C:\\UCI HAR Dataset\\features.txt", header = F, stringsAsFactors = F)

#import test data
x_test <- read.table("C:\\UCI HAR Dataset\\test\\X_test.txt", header = F, stringsAsFactors = F)
y_test <- read.table("C:\\UCI HAR Dataset\\test\\Y_test.txt", header = F, stringsAsFactors = F)
subject_test <- read.table("C:\\UCI HAR Dataset\\test\\subject_test.txt", header = F, stringsAsFactors = F)

#set columnames
colnames(x_test) <- features$V2
colnames(subject_test) <- c("SubjectID")
colnames(y_test) <- c("ActivityID")

#filter for relevant columns
relevant_cols <- grepl(features$V2, pattern = "mean|std")
x_test <- x_test[,relevant_cols]
y_test$ActivityLabel <- activity_labels[y_test$ActivityID,2]

#create test df
test_df <- cbind(subject_test, y_test, x_test)

#import training data
x_train <- read.table("C:\\UCI HAR Dataset\\train\\X_train.txt", header = F, stringsAsFactors = F)
y_train <- read.table("C:\\UCI HAR Dataset\\train\\y_train.txt", header = F, stringsAsFactors = F)
subject_train <- read.table("C:\\UCI HAR Dataset\\train\\subject_train.txt", header = F, stringsAsFactors = F)

#set columnames
colnames(y_train) <- c("ActivityID")
colnames(x_train) <- features$V2
colnames(subject_train) <- c("SubjectID")


#filter for relevant columns
x_train <- x_train[,relevant_cols]
y_train$ActivityLabel <- activity_labels[y_train$ActivityID,2]

#create train df
train_df <- cbind(subject_train, y_train, x_train)

#merge df
merged_df <- rbind(test_df, train_df)

write.csv(merged_df, "merged_df.csv")

#average of each variable for each activit and each subject
mean_merged <- merged_df %>% group_by(SubjectID, ActivityID) %>% summarize_each(funs(mean))
