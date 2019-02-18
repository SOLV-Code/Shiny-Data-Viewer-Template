



# read in the data and get some details for populating the GUI
data.file <- read.csv("DATA/Stock_TimeSeries.csv",stringsAsFactors=FALSE)

stock.list <- sort(unique(data.file$StkNmS))
var.list <- c("Total_Catch","Total_ER","Spawn_Escape","Total_Run") 


ui <- navbarPage("Data Viewer Sample App 1 - Basic",




 tabPanel("Main Page",
  
    
pageWithSidebar(
 headerPanel("Time Series Plot"),
    
  sidebarPanel(

			  	selectizeInput("stock.pick", "Stock", choices = stock.list, multiple = FALSE ,selected=stock.list[1]),
				selectizeInput("var.pick", "Variable", choices = var.list, multiple = FALSE ,selected=var.list[4]),
			tags$h4("Plot Options ---------------------"),				
				checkboxInput("rng.avg.show", "Show Running Average", value = TRUE),
				sliderInput("rng.avg.yrs", "Time Window", value=4, min = 2, max = 12)
		) # end sidebar
  ,
   

     mainPanel(

	   plotOutput("main_plot")	

	
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


  
    
  
