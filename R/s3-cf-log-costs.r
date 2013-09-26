# Returns the number and size of Cloudfront log files generated per month
cfLogsGenerated <- function(events, edgeLocations){
	dataVolume <- sizeOfCfLogsGenerated(events)
	numOfFiles <- numOfCfLogs(events, edgeLocations)
	c(dataVolume, numOfFiles)
}

sizeOfCfLogsGenerated <- function(events){
	intercept <- 1692.2848
	gradient <- 148.0076
	toGiga(intercept + events * gradient) 	
}

numOfCfLogs <- function(events, edgeLocations){
	# Cloudfront log files are generated hourly - therefore we need to base our calculations on the number produced per month
	hoursPerMonth <- 24*365.25/12
	eventsPerHour <- events / hoursPerMonth

	# Model the number of log files generated each month in a single vector
	logFilesGeneratedByHour <- vector()
	for(i in 1:ceiling(hoursPerMonth)){
		logFilesGeneratedByHour <- 
			append(logFilesGeneratedByHour, numOfCfLogsPerHour(eventsPerHour, edgeLocations))
	}

	# Return the sum of all the log files generated each hour
	sum(logFilesGeneratedByHour)
}

numOfCfLogsPerHour <- function(eventsPerHour, edgeLocations){
	# For each event, generate a random number between 1 and the number of edge locations
	# This is the Cloudfront Edge location that the event "hits"
	# Assume that one log file is generated for each edge location hit each hour
	# Then the number of log files generated in each hour is the length of the set of edge locations hit
	length(unique(sample(1:edgeLocations, eventsPerHour, replace=T)))
}