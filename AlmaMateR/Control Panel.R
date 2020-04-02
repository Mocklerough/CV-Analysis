#    CONTROL PANEL     #


# For running the scripts/functions herein


#Author: Alex Karl
# Create Date: 4/2/2020
# Last Update: 4/2/2020



# Libraries ---------------------------------------------------------------

library(tidyverse)
library(rjson)
library(Hmisc)
library(writexl)

source("JSON parsing.R")


# Read the JSON data ------------------------------------------------------

rawJSON <- pullJSON()
people <- pullNames(rawJSON)
education <- pullEdu(rawJSON)
employment  <- pullEmpl(rawJSON)



# writexlsx to check/test clean -------------------------------------------

write_xlsx(people, "people preliminary.xlsx")
write_xlsx(education, "education preliminary.xlsx")
write_xlsx(employment, "employment preliminary.xlsx")
