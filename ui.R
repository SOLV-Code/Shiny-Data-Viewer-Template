


# load packages 
# install check already done in RunLocally.R 
# all required CRAN packages are included as part of deployment to shinyapps.io
library(rsconnect)
library(shiny)
library(shinydashboard)
library(shinyjqui)
library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(shinyFiles)
library(markdown)


# read in the data and get some details for populating the GUI
data.file <- read.csv("DATA/Stock_TimeSeries.csv",stringsAsFactors=FALSE)
stock.info <- read.csv("DATA/Stock_Info.csv",stringsAsFactors=FALSE)

stock.list <- stock.info[,"StkNmL"]

names(stock.list) <- stock.info[,"StkNmS"]


area.list <- sort(unique(stock.info[,"Area"]))
watershed.list <- sort(unique(stock.info[,"Watershed"]))

var.list <- c("Total_Catch","Total_ER","Spawn_Escape","Total_Run") 


ui <- navbarPage("Data Viewer Sample App",





 tabPanel("Main Page",
  
    
pageWithSidebar(
  headerPanel("Time Series Plot"),
    
  sidebarPanel(
			tags$h4("Filter By Group"),
				selectizeInput("area.pick", "Area", choices = area.list, multiple = TRUE ,selected=area.list),
				selectizeInput("watershed.pick", "Watershed", choices = watershed.list, multiple = TRUE ,selected=watershed.list),
				helpText(span(textOutput("Num.Filtered.Stocks"), style="color:red")),
			tags$hr(),
			tags$h4("Select A Stock"),
			  	selectizeInput("stock.pick", "Stock", choices = stock.list, multiple = FALSE ,selected=stock.list[1]),
				selectizeInput("var.pick", "Variable", choices = var.list, multiple = FALSE ,selected=var.list[4])

		) # end sidebar
  ,
   

     mainPanel(

	   plotOutput("main_plot",click = "plot_click")	,
	   verbatimTextOutput("info")
	
		) # end main panel

  
  
  
  
  
  ) #end page with main plot
  ),  # end end first tab panel
  
   
   
   
#####################################
	tabPanel("About",
	
	fluidPage(

	titlePanel("About this App"),

	fluidRow(
     column(8,
      includeMarkdown("Markdown/about.md")
    )
  )	
)	
	  )  # end about tab panel
	  
#####################################	
	
) # end navbar Page


  
    
  
