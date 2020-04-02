# JSON FILE EXTRACTOR

library(tidyverse)
library(rjson)
library(Hmisc)
library(writexl)

# we're gonna make 3 functions, pulling each of the Name, School, and Job info
#   this is done at the individual record level
# then we tie them together with a map(reduce)
#   and those are our outputs
  

# pulJSON function --------------------------------------------------------
#pull the JSON files produced by parsing CVs in Sovern

pullJSON <- function(dir = "C:/Users/Alex Karl/OneDrive/Documents/R projects/Alma Maters/Sovren Parsed") {
  list.files(dir, full.names = T, recursive = T) %>%  
  str_subset(".json$") %>% str_subset(".Scrubbed.", negate = T) %>%
  map(read_lines) %>%
  map(reduce, paste0) %>%
  map(rjson::fromJSON) %>% 
  map(`[[`, "Resume") %>% map(`[[`, "StructuredXMLResume")
}


# pullNames Function -------------------

pullNames <- function(rawJSON) {
  rawJSON %>%
    map(`[[`, "ContactInfo") %>%
    map(`[[`, "PersonName") %>%
    map(as_tibble) %>% 
    map(mutate, Affix = NULL) %>%
    reduce(full_join) %>% 
    #TODO: better capitalize that capitalizes first letter after spaces and -
    transmute(rawName = FormattedName,
              firstName = capitalize(tolower(GivenName)),
              middleName = capitalize(tolower(MiddleName)),
              lastName = capitalize(tolower(FamilyName)),
              fullName = paste(firstName, middleName, lastName) %>%
                            str_remove("NA ")) %>%
    select(fullName, rawName, everything())
  #TODO: remove duplicate names
}


# pullEmpl Function -------------------

NULL_to_NA <- function(x) ifelse(is.null(x), NA, x)

pullEmpl <- function(rawJSON) {
  
  #TODO: Report individuals with no work history
  employment <- 
   tibble(rawName = character(),
          institution = character(), 
          title = character(), 
          startDate = character(), 
          endDate = character(), 
          normInstitution = character(),
          normTitle = character())

  for (ind in rawJSON) {
    rawName <- ind$ContactInfo$PersonName$FormattedName
    for (employer in ind$EmploymentHistory$EmployerOrg) {
      for (role in employer$PositionHistory) {
        #TODO all of these need to handle missing values
        employment <- 
          rbind(employment,
                tibble(
                  rawName = rawName,
                  institution = NULL_to_NA(role$OrgName$OrganizationName),
                  title = NULL_to_NA(role$Title),
                  startDate = NULL_to_NA(role$StartDate$Year),
                  endDate = NULL_to_NA(role$EndDate$Year), #This doesn't pick up most recent position, as its stored in $StringDate
                  normInstitution = NULL_to_NA(role$UserArea$`sov:PositionHistoryUserArea`$`sov:NormalizedOrganizationName`),
                  normTitle = NULL_to_NA(role$UserArea$`sov:PositionHistoryUserArea`$`sov:NormalizedTitle`)
                ))
      }
    }
  }
  employment
}


# pullEdu Function -------------------


pullEdu <- function(rawJSON) {
  
  #TODO: Report individuals with no work history
  education <- 
    tibble(rawName = character(),
           university = character(),
           degreeType = character(),
           degreeName = character(),
           date = character(),
           major = character()
           )

  for (ind in rawJSON) {
    rawName <- ind$ContactInfo$PersonName$FormattedName
    for (degree in ind$EducationHistory$SchoolOrInstitution) {
      #TODO all of these need to handle missing values
      education <- 
        rbind(education,
              tibble(rawName =    rawName,
                     uni =        NULL_to_NA(unlist(degree$School)),
                     degreeType = NULL_to_NA(degree$Degree[[1]]$`@degreeType`),
                     degreeName = NULL_to_NA(degree$Degree[[1]]$DegreeName),
                     date =       NULL_to_NA(degree$Degree[[1]]$DegreeDate$Year),
                     major =      NULL_to_NA(unlist(degree$Degree[[1]]$DegreeMajor))
                ))
    }
  }
  education %>%
    separate(degreeName, c("degreeName", "sepSubject"), sep = " in ", fill = "right")
  #TODO: Normalize degreeName. For now the degreeType is sufficient
  #TODO: Handle multiple majors (ie "Public policy and SOciology" or "Math, Econ, and French")
}






