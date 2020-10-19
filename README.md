# gettingandcleaningdataproject
Peer-graded Assignment: Getting and Cleaning Data Course Project

As per the assignment instructions, there is only one R file.
The scripts are in fact a series of commands in that file that go step-by-step through the assignment.

The order is as follows:

1. Rading the data from the zip file on the web and saving into local directory
2. showing details of files in the zip file and storing the file path/name in a vector
3. create variables for the activity labels (activity_labs), features names (features)
4. Load the following for the test data into data frames: subject id number, activity id number and main data (X)
5. Combine the above in a data frame for the test data using cbind twice.
6. Repeat 4 and 5 for the train data.
7. Combine the test and train data into a big data frame called X (using rbind)
8. Edit the feature names using sub() and regex (regular expressions) to remove numbers and other messy characters
9. The result is then what is required up to point 4 in the assignment.
10. Using the dplyr library and %>% function, create the solution to part 5 as data frame called X2. 
