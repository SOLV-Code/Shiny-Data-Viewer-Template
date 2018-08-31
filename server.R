
# assuming that data.file is already read in from ui.R


function(input, output, session) {


	# assuming that data.file is already read in from ui.R
				
     # this is just a specific test of the method for passing info back and forth

	 
# Plan is to pass this from ui.R (see note there)
# but for now just read in again	 
# read in the data and get some details for populating the GUI
# NOTE: THIS WAY THE OBJECTS ARE ACTUALLY FUNCTIONS
# Need to access as cu.info()[,"CU_ID"]
#data.file <- reactive({ read.csv("../../OUTPUT/Data Inventory/SoS_DataInventory_Table.csv",stringsAsFactors=FALSE) })
#summary.file <- reactive({ read.csv("../../OUTPUT/Data Inventory/SoS_Data_SeriesInventory.csv",stringsAsFactors=FALSE)  })
#cu.info <- reactive({ read.csv("../DATA/SoS_Data_CU_Info.csv",stringsAsFactors=FALSE)  })
#cu.info <- reactive({  cu.info[order(cu.info[,"CU_ID"]),]	  })
	 
# do it inside reactive plot below
# How to handle this outside once?




# -> Starting to fix as per below
# key is: 
#  1) reactive() creates a function,so the last element is what the function produces
#  2) then access it in 2 steps: cu.info.tmp <- cu.info() ;  cu.info.tmp[,"FAZ"] 




	data.file.src <- reactive({ 
					read.csv("DATA/SoS_DataInventory_Table_FRSoxOnly.csv",stringsAsFactors=FALSE)
					})
	
	
	cu.info.src  <- reactive({ 
				#read.csv("DATA/SoS_Data_CU_Info_FRSoxOnly.csv",stringsAsFactors=FALSE)
				cu.info.tmp <- read.csv("DATA/SoS_Data_CU_Info_FrSoxOnly.csv",stringsAsFactors=FALSE)
				cu.info.tmp <- cu.info.tmp[order(cu.info.tmp[,"CU_ID"]),]	  	
				cu.info.tmp
				})
	
	
	summary.file.src  <- reactive({ 
					read.csv("DATA/SoS_Data_SeriesInventory_FRSoxOnly.csv",stringsAsFactors=FALSE)				
					})
				
		
	
	output$output.data.list <- reactive({ 
						list(cu.info.src = 	cu.info.src(),data.file.src = data.file.src(),
							summary.file.src = summary.file.src()  )
						})
						
# CU list filters


  faz.list <- reactive({
    input$faz.pick
	})

  area.list <- reactive({
    input$area.pick
	})
  
  

	
    cu.list.all <- reactive({  unique(cu.info.src()[,"CU_ID"])  })
   
   
	cu.list.filtered <- reactive({  
					cu.info.tmp <- cu.info.src()
					cu.all.tmp <- cu.list.all()
					filter.idx <- cu.info.tmp[,"FAZ"] %in% faz.list() & cu.info.tmp[,"Area"] %in% area.list()
					cu.filter.tmp <- cu.info.tmp[filter.idx ,"CU_ID"]
					names(cu.filter.tmp) <- paste(cu.filter.tmp,cu.info.tmp[match(cu.filter.tmp,cu.info.tmp[,"CU_ID"]),"CU_Acro"],sep="-")
					cu.filter.tmp
					})
					
					
					
					
  
  # any way to merge these?
   observeEvent(input$faz.pick, { output$Num.Filtered.CU <- renderText({ paste(length(cu.list.filtered()),"/",length(cu.list.all()), "CUs Left" )}) })
   observeEvent(input$area.pick, { output$Num.Filtered.CU <- renderText({ paste(length(cu.list.filtered()),"/",length(cu.list.all()), "CUs Left" )}) })
    

	observe({
    updateSelectInput(session, "cu.pick",
      label = "CU List",
      choices = cu.list.filtered(),
      selected = cu.list.filtered()[1]
    )
  }) 
	 
# --------------------------------------------------------------------------------------------------	 
# FOR NOW, JUST REPEAT THE WHOLE THING FOR THE OTHER TAB
# Worry about better solution later
  
	    faz.list2 <- reactive({
    input$faz.pick2
	})

  area.list2 <- reactive({
    input$area.pick2
	})
  
	  
	  
	  	cu.list.filtered2 <- reactive({  
					cu.info.tmp <- cu.info.src()
					cu.all.tmp <- cu.list.all()
					filter.idx <- cu.info.tmp[,"FAZ"] %in% faz.list2() & cu.info.tmp[,"Area"] %in% area.list2()
					cu.filter.tmp <- cu.info.tmp[filter.idx ,"CU_ID"]
					names(cu.filter.tmp) <- paste(cu.filter.tmp,cu.info.tmp[match(cu.filter.tmp,cu.info.tmp[,"CU_ID"]),"CU_Acro"],sep="-")
					cu.filter.tmp
					})
	  
	  
   observeEvent(input$faz.pick2, { output$Num.Filtered.CU2 <- renderText({ paste(length(cu.list.filtered2()),"/",length(cu.list.all()), "CUs Left" )}) })
   observeEvent(input$area.pick2, { output$Num.Filtered.CU2 <- renderText({ paste(length(cu.list.filtered2()),"/",length(cu.list.all()), "CUs Left" )}) })
    

	observe({
    updateSelectInput(session, "cu.pick2",
      label = "CU List",
      choices = cu.list.filtered2(),
      selected = cu.list.filtered2()[1]
    )
  }) 
	 
	
# --------------------------------------------------------------	
	 
	 
	 
##### VERSION 1 PLOT 

     output$t2_plot_v1 <- renderPlot({
	

	# old version
	# GET ALL THE DATA AND EXTRACT INFO -> NEED TO FIND A WAY TO HANDLE THIS OUTSIDE THE PLOT			
	#data.file <- read.csv("DATA/SoS_DataInventory_Table_FRSoxOnly.csv",stringsAsFactors=FALSE)
	#summary.file <- read.csv("DATA/SoS_Data_SeriesInventory_FRSoxOnly.csv",stringsAsFactors=FALSE)
	#cu.info <- read.csv("DATA/SoS_Data_CU_Info_FRSoxOnly.csv",stringsAsFactors=FALSE)
	#cu.info <- cu.info[order(cu.info[,"CU_ID"]),]	 
	 
	# new version 
	cu.info <- cu.info.src() 
	data.file <- data.file.src() 
	summary.file <- summary.file.src() 	
	 
		yrs.all.range <- range(data.file[,"year"])
		yrs.all <- yrs.all.range[1]:yrs.all.range[2]
	 
	 
	# this is the list of CUs to display 
	cu.list <- input$cu.pick
		
# with reactive above -> not working
#info.idx <- cu.info()[,"CU_ID"]%in%cu.list
#cu.names <- cu.info()[info.idx ,"Conservation_Unit"]
#cu.species <- cu.info()[info.idx ,"Species_Short"]

	info.idx <- cu.info[,"CU_ID"]%in%cu.list
	cu.names <- cu.info[info.idx ,"Conservation_Unit"]
	cu.species <- cu.info[info.idx ,"Species_Short"]		
		
	num.cu <- length(cu.list) 


	series.mat.template <- matrix(NA, ncol=num.cu,nrow=length(yrs.all),
			dimnames=list(yrs.all,cu.list))
		
		
	if(num.cu==0){ 
			par(mfrow=c(2,2))
			plot(1:5,1:5,type="n", axes=FALSE, xlab="",ylab="",bty="o")
			text(2.5,2.5,labels="No CUs selected",cex=3, col = "red")
			}
	
	if(num.cu > 0){ 
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
		
		
		
		# -------------------------------------------------------------------------------
		# Plot 2: Variable 2
		
		series2.mat <- series.mat.template
	
		# loop through CUs (need to get all the data first, to get axis limits
		for(cu.use in cu.list){
			data.file.idx <- data.file[,"ID"] == cu.use & data.file[,"Var"] == input$var2.pick
			cu.yrs <- data.file[data.file.idx,"year"]
			series2.mat[as.character(cu.yrs),cu.use] <- data.file[data.file.idx,"value"]
			}
		
		if(input$log.plot){
					any.neg <- sum(series2.mat < 0,na.rm=TRUE  ) > 0
					if(!any.neg){series2.mat <- log(series2.mat); title.suffix <- "- Log"}
					if(any.neg){series2.mat <- series2.mat ; title.suffix <- "" }
					}
		if(!input$log.plot){ title.suffix <- "" }
		
		
		ylim2 <- range(0,series2.mat,na.rm=TRUE)
		if(!is.finite(ylim2[2])){ylim2[2] <- 1}			
		plot(1:5,1:5,main=paste(input$var2.pick,title.suffix,sep=""),xlab="Year",xlim=input$yr.range,ylab = input$var2.pick,ylim=ylim2, type="n",bty="n",cex.axis=1.8,cex.lab = 1.8, cex.main=2,col.main="darkblue")
		abline(h=0,col="lightgrey",lty=2)
		for(i in 1:length(cu.list)){
		  		lines(yrs.all,series2.mat[,i],pch=pch.list[i],col=col.list[i],type="o",lwd=2,cex=1.5)
				}
			
			
			
		# -------------------------------------------------------------------------------
		# Plot 3: Variable 3
		
		series3.mat <- series.mat.template
	
		# loop through CUs (need to get all the data first, to get axis limits
		for(cu.use in cu.list){
			data.file.idx <- data.file[,"ID"] == cu.use & data.file[,"Var"] == input$var3.pick
			cu.yrs <- data.file[data.file.idx,"year"]
			series3.mat[as.character(cu.yrs),cu.use] <- data.file[data.file.idx,"value"]
			}
		
		if(input$log.plot){
					any.neg <- sum(series3.mat < 0 ,na.rm=TRUE ) > 0
					if(!any.neg){series3.mat <- log(series3.mat); title.suffix <- "- Log"}
					if(any.neg){series3.mat <- series3.mat ; title.suffix <- "" }
					}
		if(!input$log.plot){ title.suffix <- "" }
		
		ylim3 <- range(0,series3.mat,na.rm=TRUE)
		if(!is.finite(ylim3[2])){ylim3[2] <- 1}			
		plot(1:5,1:5,main=paste(input$var3.pick,title.suffix,sep=""),xlab="Year",xlim=input$yr.range,ylab = input$var3.pick,ylim=ylim3, type="n",bty="n",cex.axis=1.8,cex.lab = 1.8, cex.main=2,col.main="darkblue")
		abline(h=0,col="lightgrey",lty=2)
		for(i in 1:length(cu.list)){
		  		lines(yrs.all,series3.mat[,i],pch=pch.list[i],col=col.list[i],type="o",lwd=2,cex=1.5)
				}	
			
			
			
			
		# Plot 4: Map	
		plot(1:5,1:5,type="n", axes=FALSE, xlab="",ylab="",bty="o")
		text(2.5,2.5,labels="Placeholder for Map",cex=3)
		legend("topleft",legend=paste(cu.species,cu.names,sep="-"),pch=pch.list,lty=1,col=col.list,cex=2,bty="n",pt.cex=2,pt.lwd=2)
		
	  } # end if num.cu > 0	
		
		
      }) # end 	t2_plot_v1


	  
##### VERSION 2 PLOT 

     output$t2_plot_v2 <- renderPlot({
				
	# GET ALL THE DATA AND EXTRACT INFO 		
	# new version 
	cu.info <- cu.info.src() 
	data.file <- data.file.src() 
	summary.file <- summary.file.src() 	
	 
		yrs.all.range <- range(data.file[,"year"])
		yrs.all <- yrs.all.range[1]:yrs.all.range[2]
	 
	cu.list <- input$cu.pick2
		
# with reactive above -> not working
#info.idx <- cu.info()[,"CU_ID"]%in%cu.list
#cu.names <- cu.info()[info.idx ,"Conservation_Unit"]
#cu.species <- cu.info()[info.idx ,"Species_Short"]

	info.idx <- cu.info[,"CU_ID"]%in%cu.list
	cu.names <- cu.info[info.idx ,"Conservation_Unit"]
	cu.species <- cu.info[info.idx ,"Species_Short"]		
		
	num.cu <- length(cu.list) 


	series.mat.template <- matrix(NA, ncol=num.cu,nrow=length(yrs.all),
			dimnames=list(yrs.all,cu.list))
		
		
		

		
		if(num.cu<=19){pch.list <- c(1:num.cu)}
			if(num.cu>19){ pch.list <- rep(c(1:19),5)[1:num.cu]}
			if(num.cu>19*5){ pch.list <- rep(c(1:19),10)[1:num.cu] } # assume that plots would never have > 190 lines
		
		#if(!input$pts.plot2){pch.list[] <- NA}
		
		# use this for color gradient
        #colfunc <- colorRampPalette(c("orange","gold")) # NOT WORKING, SO FOR NOW JUST RECYCLE THE FOLLOWING COLORS
		col.list <- c("firebrick1","darkblue","gold","grey")#, colfunc(num.cu-3))
		
		
				
		#data.sub <- data.file
		
		
		if(input$log.plot2){title.suffix <- "- Log"}
		if(!input$log.plot2){title.suffix <- ""}
		
		
		series1.mat <- series.mat.template

		# loop through CUs (need to get all the data first, to get axis limits
		for(cu.use in cu.list){
			data.file.idx <- data.file[,"ID"] == cu.use & data.file[,"Var"] == input$var1.pick2
			cu.yrs <- data.file[data.file.idx,"year"]
			series1.mat[as.character(cu.yrs),cu.use] <- data.file[data.file.idx,"value"]
			}
		
		if(input$log.plot2){series1.mat <- log(series1.mat)}
		
		ylim1 <- range(0,series1.mat,na.rm=TRUE)
		
		
		
		series2.mat <- series.mat.template
	
		# loop through CUs (need to get all the data first, to get axis limits
		for(cu.use in cu.list){
			data.file.idx <- data.file[,"ID"] == cu.use & data.file[,"Var"] == input$var2.pick2
			cu.yrs <- data.file[data.file.idx,"year"]
			series2.mat[as.character(cu.yrs),cu.use] <- data.file[data.file.idx,"value"]
			}
		
		if(input$log.plot2){series2.mat <- log(series2.mat)}
		
		ylim2 <- range(0,series2.mat,na.rm=TRUE)
		if(!is.finite(ylim2[2])){ylim2[2] <- 1}			
		


		par(pty="s")
		
		
		plot(1:5,1:5,xlim=ylim1,ylim=ylim2,bty="n",xlab= input$var1.pick2,ylab=input$var2.pick2, type="n",bty="n",cex.axis=1.8,cex.lab = 1.8)

		#write.csv(series1.mat,file="test1.csv")
		#write.csv(series2.mat,file="test2.csv")
		
		for(i in 1:length(cu.list)){
		  		points(series1.mat[,i],series2.mat[,i],pch=pch.list[i],col=col.list[i],lwd=2,cex=1.5)
				}
			
		#plot(1:5,1:5,type="n", axes=FALSE, xlab="",ylab="",bty="o")
		legend("topleft",legend=paste(cu.species,cu.names,sep="-"),pch=pch.list,lty=1,col=col.list,cex=1.5,bty="n",pt.cex=1.5,pt.lwd=1.5,xpd=NA)
		
      }) # end 	t2_plot_v2
	  


}

