# PART 1: LAUNCHING THE APP LOCALLY

# Load the function that does the model set-up and launches the GUI
source("App2 - More Features/R/1_LaunchApp2.R")

# Run the function to launch GUI locally
launchApp2(appDir.use="App2 - More Features",fun.path="App2 - More Features/R",local=TRUE)


# Run the function to just go to the server version 
# THIS DOES NOT USE THE LATEST LOCAL VERSION!
launchApp2(local=FALSE)



# PART 2: DEPLOY THE APP TO SHINYAPPS.IO

#https://support.rstudio.com/hc/en-us/articles/229848967-Why-does-my-app-work-locally-but-not-on-shinyapps-io-


# load/install functions needed for shiny dashboard
require("rsconnect")

# deploy the app
rsconnect::deployApp(appDir="App2 - More Features", appTitle="GenericDataViewer2")

rsconnect::showLogs()




