# This script houses all the library calls for packages to be used.
# This has to be done in a separate file because:
#    - when turning R into a package, it is better to handle this through explicit dependencies
#    -  when deploying an app to shinyapps.io, it looks through all the code for any library calls 
#           to include the required packages

# eventually all calls to non-base package functions will be handled explicitly 
#  using the syntax mypackage::function(...)

library(shiny)
library(shinydashboard)
library(shinyjqui)
library(shinyFiles)
library(shinydashboard)
library(DT)
library(markdown)



