

function(input, output, session) {



	data.file.src <- reactive({ 
					read.csv("DATA/Stock_TimeSeries.csv",stringsAsFactors=FALSE)
					})
	
	
	stock.info.src  <- reactive({ 
				stock.info.tmp <- read.csv("DATA/Stock_Info.csv",stringsAsFactors=FALSE)
				stock.info.tmp <- stock.info.tmp[order(stock.info.tmp[,"StkNmS"]),]	  	
				stock.info.tmp
				})
	
	
			
						
# Stock list filters


  watershed.list <- reactive({
    input$watershed.pick
	})

  area.list <- reactive({
    input$area.pick
	})
  
  

	
    stock.list.all <- reactive({  unique(stock.info.src()[,"StkNmS"])  })
   
   
	stock.list.filtered <- reactive({  
					stock.info.tmp <- stock.info.src()
					stock.all.tmp <- stock.list.all()
					filter.idx <- stock.info.tmp[,"Watershed"] %in% watershed.list() & stock.info.tmp[,"Area"] %in% area.list()
					stock.filter.tmp <- stock.info.tmp[filter.idx ,"StkNmS"]
					names(stock.filter.tmp) <- stock.filter.tmp  # placholder for future extensionto have long names and short stock ID
					stock.filter.tmp
					})
					
					
					
					
  
  # any way to merge these?
   observeEvent(input$faz.pick, { output$Num.Filtered.Stocks<- renderText({ paste(length(stock.list.filtered()),"/",length(stock.list.all()), "Stocks Left" )}) })
   observeEvent(input$area.pick, { output$Num.Filtered.Stocks <- renderText({ paste(length(stock.list.filtered()),"/",length(stock.list.all()), "Stocks Left" )}) })
    

	observe({
    updateSelectInput(session, "stock.pick",
      label = "Stock List",
      choices = stock.list.filtered(),
      selected = stock.list.filtered()[1]
    )
  }) 
	 

	 
	 
	 
  output$info <- renderText({
    if(!is.null(input$plot_click)){
		show.text <- paste0("Year = ", round(input$plot_click$x), "\nValue = ", prettyNum(round(input$plot_click$y,0),big.mark=","))
		}
		
	if(is.null(input$plot_click)){ show.text <- "Click on a point for the value" }
	show.text
		
  })
	 
##### MAIN PLOT 

     output$main_plot <- renderPlot({
	

	stock.info <- stock.info.src() 
	data.file <- data.file.src() 
	 
		yrs.all.range <- range(data.file[,"Year"])
		yrs.all <- yrs.all.range[1]:yrs.all.range[2]
	 
	 
	# this is the stock to display 
	stock.plot <- input$stock.pick
		


	stock.idx <- stock.info[,"StkNmS"] == stock.plot
	stock.name <- stock.info[stock.idx ,"StkNmL"]
		
	num.stocks <- 1 #length(stock.pick) 



		
	if(num.stocks==0){ 
			par(mfrow=c(2,2))
			plot(1:5,1:5,type="n", axes=FALSE, xlab="",ylab="",bty="o")
			text(2.5,2.5,labels="No Stocks selected",cex=3, col = "red")
			}
	
	if(num.stocks > 0){ 
		
		
		data.sub <- data.file[data.file[,"StkNmS"]== stock.plot,]
		series.plot <- data.sub[,c("Year",input$var.pick)]
		 	
		
		y.lim <- range(0,series.plot[,input$var.pick],na.rm=TRUE)
		if(input$var.pick == "Total_ER"){y.lim <- c(0,100)}	


		y.ticks <- pretty(y.lim)
        y.ticks <-  y.ticks[y.ticks <= y.lim[2]]
		

		
		x.lim <- yrs.all.range
		if(!is.finite(y.lim[2])){y.lim[2] <- 1}		
		plot(series.plot[,"Year"],series.plot[,input$var.pick],main=paste(stock.name,input$var.pick,sep=" - "),
				xlab="Year",xlim=x.lim,ylab = input$var.pick,ylim=y.lim, 	
				type="o",bty="n",cex.axis=1.4,cex.lab = 1.4, cex.main=1.5,col.main="darkblue",pch =21,col="darkblue",bg="lightblue",
				axes=FALSE,lwd=1,cex=1.5)
				
		axis(1,cex.axis=1.2)

		
		if(max(y.ticks) < 1000 ){ y.labels <- y.ticks}		
		if(max(y.ticks) > 1000 & max(y.ticks) < 10^6){ y.labels <- paste(y.ticks/1000,"k",sep="")}
		if(max(y.ticks) >= 10^6){ y.labels <- paste(y.ticks/10^6,"M",sep="")}
		
		axis(2,at=y.ticks,labels=y.labels,las=1,cex.axis=1.2)
		
		
		if(input$rng.avg.show){
		
			lines(series.plot[,"Year"],filter(series.plot[,input$var.pick],rep(1/input$rng.avg.yrs,input$rng.avg.yrs),sides=1),
				col="red",lwd=2)
		
		
			}
		
		
		points(series.plot[,"Year"],series.plot[,input$var.pick],
				type="o",pch =21,col="darkblue",bg="lightblue",lwd=2,cex=1.5)
		
		
		
		
		
		
		} # end if have a stock selected
			
		})	
		
	  


}

