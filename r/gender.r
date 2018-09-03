library(stringr)

#data from:
#
# http://reshare.ukdataservice.ac.uk/853082/
# http://sas-space.sas.ac.uk/4259/ not used, MDB file
# http://sas-space.sas.ac.uk/748/ 
# http://sas-space.sas.ac.uk/749/
# http://sas-space.sas.ac.uk/750/
# http://sas-space.sas.ac.uk/751/ 

setwd("Dropbox/github/names_and_genders/")

#pulldata from sources

#26 English parish family reconstitutions (http://reshare.ukdataservice.ac.uk/853082/)
download.file("http://reshare.ukdataservice.ac.uk/853082/1/All26FamRecons.zip", "data/All26FamRecons.zip")
unzip("data/All26FamRecons.zip", "26ParishesReconstitutions_ALL_DATA.txt", overwrite = TRUE)
file.rename(from = "26ParishesReconstitutions_ALL_DATA.txt", to = "data/26ParishesReconstitutions_ALL_DATA.txt")
file.remove("data/All26FamRecons.zip")

#cheapside data
download.file("http://sas-space.sas.ac.uk/748/1/CLines.csv", "data/cheapside_CLines.csv")
download.file("http://sas-space.sas.ac.uk/748/3/HLines.csv", "data/cheapside_HLines.csv")
download.file("http://sas-space.sas.ac.uk/748/6/WLines.csv", "data/cheapside_WLines.csv")
download.file("http://sas-space.sas.ac.uk/750/4/Person.csv", "data/cheapside_Person.csv")
download.file("http://sas-space.sas.ac.uk/750/5/Related_people.csv", "data/cheapside_Related_people.csv")

#clerkenwell data
download.file("http://sas-space.sas.ac.uk/749/1/CLines.csv", "data/clerkenwell_CLines.csv")
download.file("http://sas-space.sas.ac.uk/749/3/HLines.csv", "data/clerkenwell_HLines.csv")
download.file("http://sas-space.sas.ac.uk/749/5/WLines.csv", "data/clerkenwell_WLines.csv")
download.file("http://sas-space.sas.ac.uk/751/4/Person.csv", "data/clerkenwell_Person.csv")
download.file("http://sas-space.sas.ac.uk/751/5/Related_People.csv", "data/clerkenwell_Related_People.csv")

#create empty database - currently not including surname
gender_name_dict <- data.frame(forename=character(), gender=character(), birth_year=character(), death_year=character(), stringsAsFactors = FALSE)

#begin parsing data

#for http://reshare.ukdataservice.ac.uk/853082/ (data/gender_data/26ParishesReconstitutions_ALL_DATA.txt)

temp <- read.csv("data/26ParishesReconstitutions_ALL_DATA.txt", sep = "\t", stringsAsFactors = FALSE)

#males
# temp$husbands_Forename
# temp$husbands_BirthDate
# temp$husbands_DeathDate
# temp$husbandfathers_Forename
# temp$wifefathers_Forename

#husband's fathers
forename <- temp$husbandfathers_Forename[which(temp$husbandfathers_Forename != "")]
birth_year <- NA
death_year <- NA
temp_new_df <- data.frame(forename, gender = "M", birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

#wife's fathers
forename <- temp$wifefathers_Forename[which(temp$wifefathers_Forename != "")]
birth_year <- NA
death_year <- NA
temp_new_df <- data.frame(forename, gender = "M", birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

#husbands
list <- which(temp$husbands_Forename != "")
forename <- temp$husbands_Forename[list]
birth_year <- as.numeric(str_extract(temp$husbands_BirthDate[list], "\\d\\d\\d\\d"))
death_year <- as.numeric(str_extract(temp$husbands_DeathDate[list], "\\d\\d\\d\\d"))

temp_new_df <- data.frame(forename, gender = "M", birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

# female
# temp$wifemothers_Forename
# temp$husbandmothers_Forename
# temp$wives_Forename
# temp$wives_BirthDate
# temp$wives_DeathDate


#wife's mothers
forename <- temp$wifemothers_Forename[which(temp$wifemothers_Forename != "")]
birth_year <- NA
death_year <- NA
temp_new_df <- data.frame(forename, gender = "F", birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

#husband's mothers
forename <- temp$husbandmothers_Forename[which(temp$husbandmothers_Forename != "")]
birth_year <- NA
death_year <- NA
temp_new_df <- data.frame(forename, gender = "F", birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

#wives
list <- which(temp$wives_Forename != "")
forename <- temp$wives_Forename[list]
birth_year <- as.numeric(str_extract(temp$wives_BirthDate[list], "\\d\\d\\d\\d"))
death_year <- as.numeric(str_extract(temp$wives_DeathDate[list], "\\d\\d\\d\\d"))

temp_new_df <- data.frame(forename, gender = "F", birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

# unknown (children)
# temp$children_Sex
# temp$children_BirthDate
# temp$children_DeathDate
# temp$children_Name

list <- which(temp$children_Name != "")
forename <- temp$children_Name[list]
gender <- temp$children_Sex[list]
birth_year <- as.numeric(str_extract(temp$children_BirthDate[list], "\\d\\d\\d\\d"))
death_year <- as.numeric(str_extract(temp$children_DeathDate[list], "\\d\\d\\d\\d"))

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

#cheapside and clerkenwell data

#Children
temp <- read.csv("data/cheapside_CLines.csv", stringsAsFactors = FALSE)

gender <- temp$Sex
birth_year <- as.numeric(str_extract(temp$BirthDateNS, "\\d\\d\\d\\d"))
death_year <- as.numeric(str_extract(temp$DeathDateNS, "\\d\\d\\d\\d"))
forename <- temp$Forename

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

temp <- read.csv("data/clerkenwell_CLines.csv", stringsAsFactors = FALSE)

gender <- temp$Sex
birth_year <- as.numeric(str_extract(temp$BirthDateNS, "\\d\\d\\d\\d"))
death_year <- as.numeric(str_extract(temp$DeathDateNS, "\\d\\d\\d\\d"))
forename <- temp$Forename

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)


#Husbands
temp <- read.csv("data/clerkenwell_HLines.csv", stringsAsFactors = FALSE) 
forename <- temp$Forename
birth_year <- as.numeric(str_extract(temp$BapDate, "\\d\\d\\d\\d"))
death_year <- as.numeric(str_extract(temp$BurDate, "\\d\\d\\d\\d"))
gender <- "M"

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

temp <- read.csv("data/cheapside_HLines.csv", stringsAsFactors = FALSE) 
forename <- temp$Forename
birth_year <- as.numeric(str_extract(temp$BapDate, "\\d\\d\\d\\d"))
death_year <- as.numeric(str_extract(temp$BurDate, "\\d\\d\\d\\d"))
gender <- "M"

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

#wives
temp <- read.csv("data/cheapside_WLines.csv", stringsAsFactors = FALSE)
death_year <- as.numeric(str_extract(temp$BurDate, "\\d\\d\\d\\d"))
birth_year <- as.numeric(str_extract(temp$OwnBapDate, "\\d\\d\\d\\d"))
forename <- temp$Fname
gender <- "F"

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

temp <- read.csv("data/clerkenwell_WLines.csv", stringsAsFactors = FALSE)
death_year <- as.numeric(str_extract(temp$BurDate, "\\d\\d\\d\\d"))
birth_year <- as.numeric(str_extract(temp$OwnBapDate, "\\d\\d\\d\\d"))
forename <- temp$Fname
gender <- "F"

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

#other

temp <- read.csv("data/cheapside_Person.csv", stringsAsFactors = FALSE)  
forename <- temp$Forename
gender <- temp$stated_sex
death_year <- as.numeric(str_extract(temp$Death_date, "\\d\\d\\d\\d"))
birth_year <- as.numeric(str_extract(temp$Birth_date, "\\d\\d\\d\\d"))

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

temp <- read.csv("data/clerkenwell_Person.csv", stringsAsFactors = FALSE)  
forename <- temp$Forename
gender <- temp$stated_sex
death_year <- as.numeric(str_extract(temp$Death_date, "\\d\\d\\d\\d"))
birth_year <- as.numeric(str_extract(temp$Birth_date, "\\d\\d\\d\\d"))

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

temp <- read.csv("data/clerkenwell_Related_People.csv", stringsAsFactors = FALSE)  
forename <- temp$Forename
gender <- temp$stated_sex
birth_year <- NA
death_year <- NA

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)

temp <- read.csv("data/cheapside_Related_people.csv", stringsAsFactors = FALSE)  
forename <- temp$Forename
gender <- temp$stated_sex
birth_year <- NA
death_year <- NA

temp_new_df <- data.frame(forename, gender, birth_year, death_year, stringsAsFactors = FALSE)
gender_name_dict <- rbind(gender_name_dict, temp_new_df)


#clean up entries with missing/broken names or gender

#standardize name case
gender_name_dict$forename <- tolower(gender_name_dict$forename)

list <- grep("^-.*$", gender_name_dict$forename)
gender_name_dict <- gender_name_dict[-c(list),]

list <- grep("^@ymond$", gender_name_dict$forename)
gender_name_dict <- gender_name_dict[-c(list),]
list <- grep("^a son$", gender_name_dict$forename)
gender_name_dict <- gender_name_dict[-c(list),]
list <- grep("^a doughter$", gender_name_dict$forename)
gender_name_dict <- gender_name_dict[-c(list),]
list <- grep("^,ucy$", gender_name_dict$forename)
gender_name_dict <- gender_name_dict[-c(list),]



list <- grep("^[[].*[]]$", gender_name_dict$forename)
gender_name_dict <- gender_name_dict[-c(list),]

gender_name_dict$forename <- gsub("[.]\\d.*[.]\\d.*[.]", "", gender_name_dict$forename)
gender_name_dict$forename <- gsub("[.]\\d[.]", "", gender_name_dict$forename)
gender_name_dict$forename <- gsub("[.]\\d\\d[.]", "", gender_name_dict$forename)

#remove additional name info withing brackets (often juniors, elders, and other names)
gender_name_dict$forename <- gsub("[[].*[]]", "", gender_name_dict$forename)
gender_name_dict$forename <- gsub("[(.*[)]", "", gender_name_dict$forename)

gender_name_dict$forename <- gsub(" JUNR", "", gender_name_dict$forename, ignore.case = TRUE)
gender_name_dict$forename <- gsub(" JUNIOR", "", gender_name_dict$forename, ignore.case = TRUE)
gender_name_dict$forename <- gsub(" JNR", "", gender_name_dict$forename, ignore.case = TRUE)
gender_name_dict$forename <- gsub(" JR", "", gender_name_dict$forename, ignore.case = TRUE)
gender_name_dict$forename <- gsub(" SENR", "", gender_name_dict$forename, ignore.case = TRUE)
gender_name_dict$forename <- gsub(" SENIOR", "", gender_name_dict$forename, ignore.case = TRUE)
gender_name_dict$forename <- gsub("THE ELDER", "", gender_name_dict$forename, ignore.case = TRUE)
gender_name_dict$forename <- gsub("SIR ", "", gender_name_dict$forename, ignore.case = TRUE)
 

list <- grep("\\d", gender_name_dict$forename, ignore.case = T)
gender_name_dict <- gender_name_dict[-c(list),]

list <- which(gender_name_dict$forename == "")
gender_name_dict <- gender_name_dict[-c(list),]

list <- grep("^\\w$", gender_name_dict$forename)
gender_name_dict <- gender_name_dict[-c(list),]



to_correct <- c("", "X", "unstated")
for (i in 1:length(to_correct)) {
  list <- which(gender_name_dict$gender == to_correct[i])
  gender_name_dict <- gender_name_dict[-c(list),]
}

to_correct <- c("m", "son", "mr", "brother", "bachelor", "father", "man", "Mr", "Master", "Captain", 
                "boy", "grandson", "Sir", "Major", "his", "nephew", "Father", "Lord", "husband", 
                "Alderman", "male", "Mr Alderman", "father in law", "son in law", "father[husband?]", 
                "grandfather", "gentleman", "Colonel", "Worshipful", "Right Honourable", "Dr", "brother in law",
                "Mr Doctor", "Baron", "Duke", "Justice")
for (i in 1:length(to_correct)) {
  cat("\rCorrect : ", to_correct[i], "              ")
  list <- which(gender_name_dict$gender == to_correct[i])
  gender_name_dict$gender[list] <- "M"
}

to_correct <- c("f", "daughter", "wife", "woman", "sister", "mrs", "her", "Mrs", "Mistress", "maid", "mother", "niece",
                "female", "Lady", "Dame", "wire", "Mother", "widow", "Widow", "girl", "wench", "Goodwife", "grandmother")
for (i in 1:length(to_correct)) {
  cat("\rCorrect : ", to_correct[i], "                    ")
  list <- which(gender_name_dict$gender == to_correct[i])
  gender_name_dict$gender[list] <- "F"
}


#split by gender to do the rest of the anlysis

female_df <- subset(gender_name_dict, gender == "F")
male_df <- subset(gender_name_dict, gender == "M")


#add years for when the specirc names were active
unique_names <- unique(female_df$forename)
for (i in 1:length(unique_names)) {
  cat("\rAssigned active birth/death years for: ", unique_names[i], "                                            ")
  female_df$birth_year[which(female_df$forename == unique_names[i])] <- 
    min(female_df$birth_year[which(female_df$forename == unique_names[i])], na.rm = TRUE)
  female_df$death_year[which(female_df$forename == unique_names[i])] <- 
    max(female_df$death_year[which(female_df$forename == unique_names[i])], na.rm = TRUE)
}

female_df$birth_year[which(female_df$birth_year == Inf)] <- NA
female_df$death_year[which(female_df$death_year == -Inf)] <- NA

unique_names <- unique(male_df$forename)
for (i in 1:length(unique_names)) {
  cat("\rAssigned active birth/death years for: ", unique_names[i], "                                            ")
  male_df$birth_year[which(male_df$forename == unique_names[i])] <- 
    min(male_df$birth_year[which(male_df$forename == unique_names[i])], na.rm = TRUE)
  male_df$death_year[which(male_df$forename == unique_names[i])] <- 
    max(male_df$death_year[which(male_df$forename == unique_names[i])], na.rm = TRUE)
}

male_df$birth_year[which(male_df$birth_year == Inf)] <- NA
male_df$death_year[which(male_df$death_year == -Inf)] <- NA

#create column for number of uses of a name for each gender
male_df$count <- NA
unique_names <- unique(male_df$forename)
for (i in 1:length(unique_names)) {
  cat("\rChecking for number of instances of : ", unique_names[i], "                                            ")
  male_df$count[which(male_df$forename == unique_names[i])] <- sum(male_df$forename == unique_names[i])
}

female_df$count <- NA
unique_names <- unique(female_df$forename)
for (i in 1:length(unique_names)) {
  cat("\rChecking for number of instances of : ", unique_names[i], "                                            ")
  female_df$count[which(female_df$forename == unique_names[i])] <- sum(female_df$forename == unique_names[i])
}

female_df <- unique(female_df)
male_df <- unique(male_df)

#combine datasets again

finished_data <- rbind(female_df, male_df)

#save CSV

write.csv(gender_name_dict, file = "historical_forenames_genders.csv", row.names = FALSE)