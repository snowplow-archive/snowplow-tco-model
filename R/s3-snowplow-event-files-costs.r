# Returns the number and size of the Snowplow event files generated each month
snowplowEventFilesGenerated <- function(events, runsPerDay){
	dataVolume <- sizeOfSnowplowEventFilesGenerated(events)
	numOfFiles <- numOfSnowplowEventFiles(events, runsPerDay)
}

sizeOfSnowplowEventFilesGenerated <- function(events){
	# Results of regression analysis (see 'estimate size of snowplow event files from number of lines of data')
	intercept <- -30329
	gradient <- 710	
	toGiga(intercept + events * gradient)
}

numOfSnowplowEventFiles <- function(events, runsPerDay){
	runsPerMonth <- runsPerDay * 30 
	eventsPerRun <- events / runsPerMonth
	filesGeneratedPerRun <- numOfSnowplowEventFilesGeneratedPerRun(eventsPerRun)

	# files generated per month = files generated per run x runs per month
	filesGeneratedPerRun * runsPerMonth
}

numOfSnowplowEventFilesGeneratedPerRun <- function(eventsPerRun){
	# Snowplow *should* product 1 event file per 128 MB of data per run
	megabytesPerRun <- sizeOfSnowplowEventFilesGenerated(eventsPerRun)
	ceiling(megabytesPerRun / fromMega(toGiga(128)))
}