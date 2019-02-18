

function(input, output, session) {



	data.file.src <- reactive({ 
					read.csv("DATA/Stock_TimeSeries.csv",stringsAsFactors=FALSE)
					})
	
	
				
  
	 
##### MAIN PLOT 

     output$main_plot <- renderPlot({
	
		data.file <- data.file.src() 
	 
		yrs.all.range <- range(data.file[,"Year"])
		yrs.all <- yrs.all.range[1]:yrs.all.range[2]
	 
	 
	# this is the stock to display 
	stock.plot <- input$stock.pick
		

		
		
		data.sub <- data.file[data.file[,"StkNmS"]== stock.plot,]
		series.plot <- data.sub[,c("Year",input$var.pick)]
		 	
		
		y.lim <- range(0,series.plot[,input$var.pick],na.rm=TRUE)
		if(input$var.pick == "Total_ER"){y.lim <- c(0,100)}	

		y.ticks <- pretty(y.lim)
        y.ticks <-  y.ticks[y.ticks <= y.lim[2]]
		
		x.lim <- yrs.all.range
		if(!is.finite(y.lim[2])){y.lim[2] <- 1}		
		plot(series.plot[,"Year"],series.plot[,input$var.pick],main=paste(stock.plot,input$var.pick,sep=" - "),
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
		
		
		
		})	
		
	  


}

