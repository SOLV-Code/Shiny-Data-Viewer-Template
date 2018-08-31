

function(input, output, session) {



	data.file.src <- reactive({ 
					read.csv("DATA/Stock_TimeSeries.csv",stringsAsFactors=FALSE)
					})
	
	
	stock.info.src  <- reactive({ 
				#read.csv("DATA/SoS_Data_CU_Info_FRSoxOnly.csv",stringsAsFactors=FALSE)
				stock.info.tmp <- read.csv("DATA/Stock_Info.csv",stringsAsFactors=FALSE)
				stock.info.tmp <- stock.info.tmp[order(stock.info.tmp[,"StkNmS"]),]	  	
				stock.info.tmp
				})
	
	
			
						
# Stock list filters


  faz.list <- reactive({
    input$faz.pick
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
	 

	 
	 
##### MAIN PLOT 

     output$main_plot <- renderPlot({
	


	 

	stock.info <- stock.info.src() 
	data.file <- data.file.src() 
	 
		yrs.all.range <- range(data.file[,"year"])
		yrs.all <- yrs.all.range[1]:yrs.all.range[2]
	 
	 
	# this is the stock to display 
	stock.plot <- input$stock.pick
		


	stock.idx <- stock.info[,"StkNmS"] == stock.plot
	stock.name <- stock.info[stock.idx ,"StkNmL"]
		
	num.stocks <- length(cu.list) 


	series.mat.template <- matrix(NA, ncol=num.cu,nrow=length(yrs.all),
			dimnames=list(yrs.all,cu.list))
		
		
	if(num.stocks==0){ 
			par(mfrow=c(2,2))
			plot(1:5,1:5,type="n", axes=FALSE, xlab="",ylab="",bty="o")
			text(2.5,2.5,labels="No Stocks selected",cex=3, col = "red")
			}
	
	if(num.stocks > 0){ 
		
		
		if(num.cu<=19){pch.list <- c(1:num.cu)}
			if(num.cu>19){ pch.list <- rep(c(1:19),5)[1:num.cu]}
			if(num.cu>19*5){ pch.list <- rep(c(1:19),10)[1:num.cu] } # assume that plots would never have > 190 lines
		
		if(!input$pts.plot){pch.list[] <- NA}
		
		# use this for color gradient
        #colfunc <- colorRampPalette(c("orange","gold")) # NOT WORKING, SO FOR NOW JUST RECYCLE THE FOLLOWING COLORS
		#  , colfunc(num.cu-3))
		col.vec <- c("firebrick1","darkblue","gold","grey")
		col.list <- rep(col.vec,ceiling(num.cu/length(col.vec)))       
		
		
				
		#data.sub <- data.file
		
		layout(matrix(c(1,1,2,3,4,4),ncol=2,byrow=TRUE))
		

		
		# -------------------------------------------------------------------------------
		# Plot 1: Variable 1
		
		series1.mat <- series.mat.template

		# loop through CUs (need to get all the data first, to get axis limits
		for(cu.use in cu.list){
			data.file.idx <- data.file[,"ID"] == cu.use & data.file[,"Var"] == input$var1.pick
			cu.yrs <- data.file[data.file.idx,"year"]
			series1.mat[as.character(cu.yrs),cu.use] <- data.file[data.file.idx,"value"]
			}
		
		if(input$log.plot){
					any.neg <- sum(series1.mat < 0,na.rm=TRUE ) > 0

					if(!any.neg){series1.mat <- log(series1.mat); title.suffix <- "- Log"}
					if(any.neg){series1.mat <- series1.mat ; title.suffix <- "" }
					}
		if(!input$log.plot){ title.suffix <- "" }
		
		
		
		ylim1 <- range(0,series1.mat,na.rm=TRUE)
		if(!is.finite(ylim1[2])){ylim1[2] <- 1}		
		plot(1:5,1:5,main=paste(input$var1.pick,title.suffix,sep=""),xlab="Year",xlim=input$yr.range,ylab = input$var1.pick,ylim=ylim1, type="n",bty="n",cex.axis=1.8,cex.lab = 1.8, cex.main=2,col.main="darkblue")
		abline(h=0,col="lightgrey",lty=2)
		for(i in 1:length(cu.list)){
		  		lines(yrs.all,series1.mat[,i],pch=pch.list[i],col=col.list[i],type="o",lwd=2,cex=1.5)
				}
		
		} # end if have a stock selected
			
		})	
		
	  


}

