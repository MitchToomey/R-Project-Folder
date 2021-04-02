
# This function checks the cleanliness of the College Data.

College_Data_Check <- function(CollegeData) {

# id check

perfect_id <- (length(unique(CollegeData$id)) == 14721) &
              (sum(CollegeData$id, na.rm = TRUE) == 108361281)

# gender check

perfect_gender <- (table(CollegeData$gender)[1] == 7411) &
                  (table(CollegeData$gender)[2] == 7310) &
                  (length(table(CollegeData$gender)) == 2)

names(perfect_gender) <- NULL

# class check

perfect_class <- (table(CollegeData$class)[1] == 3922) &
                 (table(CollegeData$class)[2] == 3509) &
                 (table(CollegeData$class)[3] == 3539) &
                 (table(CollegeData$class)[4] == 3751) &
                 (length(table(CollegeData$class)) == 4)


# gpa check

perfect_gpa <- sum(CollegeData$gpa, na.rm = TRUE) == 40038.92

# scale1 check

perfect_scale1 <- (table(CollegeData$scale1)[1] == 2980) &
                  (table(CollegeData$scale1)[2] == 3414) &
                  (table(CollegeData$scale1)[3] == 3899) &
                  (table(CollegeData$scale1)[4] == 2775) &
                  (table(CollegeData$scale1)[5] == 1648) &
                  (length(table(CollegeData$scale1)) == 5)  
  
# scale2 check

perfect_scale2 <- (table(CollegeData$scale2)[1] == 1698) &
                  (table(CollegeData$scale2)[2] == 1432) &
                  (table(CollegeData$scale2)[3] == 1639) &
                  (table(CollegeData$scale2)[4] == 1690) &
                  (table(CollegeData$scale2)[5] == 1401) &
                  (table(CollegeData$scale2)[6] == 1581) &
                  (table(CollegeData$scale2)[7] == 1654) &
                  (table(CollegeData$scale2)[8] == 1665) &
                  (table(CollegeData$scale2)[9] == 1954) &
                  (length(table(CollegeData$scale2)) == 9)

if (perfect_id) {
    id_message <- "You and Mike have the same id variable values"
} else {
    id_message <- "You and Mike have different id variable values"
}

if (perfect_gender) {
    gender_message <- "You and Mike have the same gender variable values"
} else {
    gender_message <- "You and Mike have different gender variable values"
}

if (perfect_class) {
    class_message <- "You and Mike have the same class variable values"
} else {
    class_message <- "You and Mike have different class variable values"
}

if (perfect_gpa) {
    gpa_message <- "You and Mike have the same gpa variable values"
} else {
    gpa_message <- "You and Mike have different gpa variable values"
}
  
if (perfect_scale1) {
    scale1_message <- "You and Mike have the same scale1 variable values"
} else {
    scale1_message <- "You and Mike have different scale1 variable values"
}  
    
if (perfect_scale2) {
    scale2_message <- "You and Mike have the same scale2 variable values"
} else {
    scale2_message <- "You and Mike have different scale2 variable values"
}

cat("\n", id_message, "\n",
    gender_message, "\n",
    class_message, "\n",
    gpa_message, "\n",
    scale1_message, "\n",
    scale2_message)

}
