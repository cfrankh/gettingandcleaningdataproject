# Checking for and creating directories
if (!file.exists("data")) {
    dir.create("data")
}

if (!file.exists("data/unzip")) {
    dir.create("data/unzip")
}


# Download the files from the web
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "./data/PeerGradedAssignData.zip"
download.file(zipURL, destfile = zipFile, method = "curl")

fileDetails <- unzip(zipFile, list=TRUE)

# Load activity labels into activity_labs
activity_labs <- readLines( unz(zipFile, fileDetails[1,1]))
# Remove the numbers and spaces
activity_labs <- sub("^[0-9]{1,3} ", "", activity_labs)


# Load the feature IDs into features
features <- readLines( unz(zipFile, fileDetails[2,1]))

# LOAD TEST DATA
# Load subject data IDs into subject_test
subject_test <- read.table( unz(zipFile, 
                                fileDetails[16,1]), col.names="subject" )
# Load activity data IDs into subject_test
activity_test <- read.table( unz(zipFile, 
                                 fileDetails[18,1]), col.names="activity" )
# Change the activity labels to text using activity_labs
library(dplyr)
activity_test <- mutate(activity_test, activity = activity_labs[activity])

# Load X_test data
X_test <- read.table( unz(zipFile, fileDetails[17,1]) )

# Combine subject and activity numbers with the X_test data using cbind() 
X_test <- cbind(activity_test, X_test)
X_test <- cbind(subject_test, X_test)

# LOAD TRAIN DATA (in the same manner as for TEST data)
# Load subject data IDs into subject_train
subject_train <- read.table( unz(zipFile, 
                                 fileDetails[30,1]), col.names="subject" )
# Load activity data IDs into subject_train
activity_train <- read.table( unz(zipFile, 
                                  fileDetails[32,1]), col.names="activity" )
# Change the activity labels to text using activity_labs
activity_train <- mutate(activity_train, activity = activity_labs[activity])
# Load X_train data
X_train <- read.table( unz(zipFile, fileDetails[31,1]) )
# Combine subject and activity numbers with the X_train data using cbind()
X_train <- cbind(activity_train, X_train)
X_train <- cbind(subject_train, X_train)

# Combine train and test data using rbind()
# put the result in a data frame called X
X <- rbind(X_train, X_test)

# Now change the add names
# add "subject" and "activity to the features vector
features <- c("subject", "activity", features)

# Assign these values to the columns names
names(X) <- features

# Make a vector called "include" to deterimine which columns to keep
# First define regular expression for column names
my_regex = "mean\\(\\)|std\\(\\)"
# Then use grep to select column numbers for those that are to be retained
include <- grep(my_regex, features)
# Make sure that the "subject" column (which is column number 1) is retained
include <- c(1,2, include)

# Shrink X to contain only the columns numbers in "include"
X <- X[,include]

# Now "tidy" the column names
# put the columns names into variable called newfeatures
newfeatures <- names(X)

# Refine the features vector to give suitable column headings
newfeatures <- sub("^[0-9]{1,3} ", "", newfeatures)
newfeatures <- gsub("-|_", "", newfeatures)
newfeatures <- gsub("\\(\\)", "", newfeatures)
newfeatures <- tolower(newfeatures)

# Write the new feature names back to the column headings of data frame X
names(X) <- newfeatures


# Finally
# Create a second, independent tidy data set with the average of each 
# variable for each activity and each subject
# Save this is a dataframe called X2
library(dplyr)

X2 <- X %>% 
    group_by(subject, activity) %>%
    summarise_all("mean")

#Now write the dataframes out as csv files to try to get in GitHub
write.csv(X,"./data/X.csv", row.names = FALSE)
write.csv(X2,"./data/X2.csv", row.names = FALSE)