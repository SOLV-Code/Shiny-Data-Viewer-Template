## Shiny-Data-Viewer-Template
This repository contains a basic shiny app template for reviewing data sets, as well as a script for deploying the app to [shinyapps.io](shinyapps.io)

A sample app generated with this template is available [here](https://solv-code.shinyapps.io/GenericDataViewer/)


### Providing Feedback


You can add suggestions on the [issues  page](https://github.com/SOLV-Code/Shiny-Data-Viewer-Template/issues).

### How-To

To build your own viewer:
* fork the source repository at https://github.com/SOLV-Code/Shiny-Data-Viewer-Template or download the zip version from there.
* populate the 2 files in the DATA folder with your own data set.
* run script *1_RunLocally.R* to run the app locally and test it out.
* Modify script *2_Deploy.R* as needed for your own set-up to deploy the app


### Deployment Options

#### shinyapps.io

The easiest option is to get an account at [shinyapps.io](https://www.shinyapps.io/).
With this approach, almost everything is taken care of for you, but the
free account limits the total monthly use time for your apps, and does not
offer login-controlled apps.

#### Virtual Server

The more versatile option, with some extra effort at the start, is to set up your own virtual shiny server with a cloud provider. 
Here is a [step-by-step guide](https://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/).

