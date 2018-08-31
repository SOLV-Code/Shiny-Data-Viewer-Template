


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


area.list <- sort(unique(cu.info1[,"Area"]))
watershed.list <- sort(unique(cu.info1[,"FAZ"]))



ui <- navbarPage("Data Viewer Sample App",





 tabPanel("Task 2 - Version 1",
  
    
pageWithSidebar(
  headerPanel("Comparing CUs"),
    
  sidebarPanel(
			tags$h4("Filter By Group"),
				selectizeInput("faz.pick", "Freshwater Adaptive Zone", choices = faz.list, multiple = TRUE ,selected=faz.list),
				selectizeInput("area.pick", "Area", choices = area.list, multiple = TRUE ,selected=area.list),
				helpText(span(textOutput("Num.Filtered.CU"), style="color:red")),
			tags$hr(),
			tags$h4("Select CUs"),
			  	selectizeInput("cu.pick", "CU", choices = cu.list, multiple = TRUE ,selected=cu.list[1]),
			tags$h4("Plot Layout"),
				selectizeInput("var1.pick", "Variable 1", choices = var.list, multiple = FALSE,selected=var.list[1]),
				selectizeInput("var2.pick", "Variable 2", choices = var.list, multiple = FALSE,selected=var.list[3]),
				selectizeInput("var3.pick", "Variable 3", choices = var.list, multiple = FALSE,selected=var.list[2]),
			  	sliderInput("yr.range", "Display Years", sep="",min = 1940, max = 2020, value = c(1995,2017)),
				checkboxInput("pts.plot", label="Show Points", value = FALSE),
				checkboxInput("log.plot", label="Log Scale", value = FALSE)
		) # end sidebar
  ,
   

     mainPanel(

		# details at https://shiny.rstudio.com/reference/shiny/latest/plotOutput.html
	   plotOutput("t2_plot_v1", width = "100%", height = "800px")	
	

		) # end main panel

  
  
  
  
  
  ) #end page with side bar for basic settings
  ),  # end end first tab panel
  
  tabPanel("Task 2 - Version 2",
    
pageWithSidebar(
  headerPanel("Comparing CUs"),
    
  sidebarPanel(
			tags$h4("Filter By Group"),
				selectizeInput("faz.pick2", "Freshwater Adaptive Zone", choices = faz.list, multiple = TRUE ,selected=faz.list),
				selectizeInput("area.pick2", "Area", choices = area.list, multiple = TRUE ,selected=area.list),
				helpText(span(textOutput("Num.Filtered.CU2"), style="color:red")),
			tags$hr(),
			tags$h4("Select CUs"),
			  	selectizeInput("cu.pick2", "CU", choices = cu.list, multiple = TRUE ,selected=cu.list[1]),
			tags$h4("Plot Layout"),
				selectizeInput("var1.pick2", "Variable 1", choices = var.list, multiple = FALSE,selected=var.list[1]),
				selectizeInput("var2.pick2", "Variable 2", choices = var.list, multiple = FALSE,selected=var.list[2]),
				sliderInput("yr.range2", "Data Years (not linked)", sep="",min = 1940, max = 2020, value = c(1995,2017)),
				checkboxInput("log.plot2", label="Log Scale", value = FALSE)
		) # end sidebar
			  
  ,
   

     mainPanel(			
	     
				   plotOutput("t2_plot_v2", width = "100%", height = "600px")	
			
	   
		) # end main panel
  
		) #end page with side bar for  data loading
  ), # end  second tab panel
   
   
   
   
#####################################
	tabPanel("About / Disclaimer",
	
	fluidPage(

	titlePanel("About the SotS Tool"),

	fluidRow(
     column(8,
      includeMarkdown("Markdown/about.md")
    )
  )	
)	
	  ),  # end about tab panel
	  
#####################################	
	
) # end navbar Page


  
    
  
