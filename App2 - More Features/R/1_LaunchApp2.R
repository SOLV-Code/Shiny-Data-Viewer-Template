# THIS DEFINES THE FUNCTION THAT LAUNCHES THE GUI IN A BROWSER
# The actual GUI lives in ui.R.
# The function call using the GUI output as an input lives in server.R

# NOTE: this includes sourcing  library_calls.R, which ensures that all the
# required packages are loaded when the app is compiled/

launchApp2 <- function(appDir.use=NULL,fun.path=NULL,local=TRUE){

if(!local){browseURL("https://solv-code.shinyapps.io/genericdataviewer2/")}

if(local){

# read in all ".R" files and ".r" files in /R, and all files with "_functions.r" from the subfolders"
# -------------------

if(is.null(fun.path)){fun.path <- "R"}

for(dir.use in list.dirs(path=fun.path,full.names = TRUE, recursive = TRUE)){
	print("------------------")
	print(dir.use)
	
	if(dir.use == fun.path){pattern.list <- c("*[.]R$","*[.]r$") } 
	if(dir.use != fun.path){pattern.list <- c("_functions.R","_functions.r") } 	
	
	
	for(pattern.use in pattern.list){
		print("Pattern ----------")
		print(pattern.use)
		fn.file.list <- list.files(path=dir.use,pattern=pattern.use) # get all .R files 
		print("File List------")
		print(fn.file.list)
		print("------")
		
		if(length(fn.file.list)>0){
		print(length(fn.file.list))
		for(file.source in fn.file.list){
			print(paste("Sourcing: ",file.source))
			source(paste(dir.use,file.source,sep="/"))
			} # end looping through files
			}
			

		
		} # end looping through patterns
	} # end looping through folders



# run the app
runApp(appDir = appDir.use)
} # end launching GUI if set-up matches



} # end function launchForecastR 



