# Calculates the S3 cost over a time period of X months (note - costs rise as the volume of data increases month by month)
s3CostByMonth <- function(eventsPerMonth, runsPerDay, edgeLocations, numberOfMonths){
	# Create the vector of monthly s3 costs, which the function will return
	s3CostByMonth <- vector()

	# Before Snowplow starts, there is no Snowplow dqta in S3
	gigabytesAlreadyInS3 <- 0

	# Calculate the s3 cost for each month, and save the monthly cost in the vector
	for(i in 1:numberOfMonths){
		ithMonth <- s3CostPerMonth(gigabytesAlreadyInS3, eventsPerMonth, runsPerDay, edgeLocations)
		gigabytesAlreadyInS3 <- ithMonth[2]
		ithMonthCost <- ithMonth[1]
		s3CostByMonth <- append(s3CostByMonth, ithMonthCost)
	}

	# Return the vector
	s3CostByMonth
}

# Calculate the S3 cost per month AND volume of data stored in S3 at the end of the month 
# (We need the volume of data stored at the month end when we calculate the monthyl costs over time)
s3CostPerMonth <- function(gigabytesSnowplowDataAlreadyInS3, eventsThisMonth, runsPerDay, edgeLocations){
	cfLogs <- cfLogsGenerated(eventsThisMonth, edgeLocations)
	snplowEventFiles <- snowplowEventFilesGenerated(eventsThisMonth, runsPerDay)

	newFilesGenerated <- cfLogs + snplowEventFiles

	# Note: for each file (cfLog and snowplow event file), there is 3 POST / COPY requests and 1 GET request
	putCopyListRequests <- newFilesGenerated[2] * 3
	getRequests <- newFilesGenerated[2]

	gigabytesDataAtMonthEnd <- gigabytesSnowplowDataAlreadyInS3 + newFilesGenerated[1]
	s3Cost <- s3CostPerMonthRaw(gigabytesDataAtMonthEnd, putCopyListRequests, getRequests)

	c(s3Cost, gigabytesDataAtMonthEnd)
}


# Calculate the S3 cost per month, based on the volume of data stored, the number of PUT / COPY / POST /  LIST requests and the number of GET requests
s3CostPerMonthRaw <- function(gigabytesStored, putCopyListRequests, getRequests){
	storageCostPerGigabyte <- 0.095
	putCopyPostListRequestPricePerThousandRequests <- 0.005
	getRequestPricePerTenThousandRequests <- 0.004

	storageCost <- storageCostPerGigabyte * gigabytesStored
	requestCost <- putCopyPostListRequestPricePerThousandRequests / 1000 * putCopyListRequests + 
					getRequestPricePerTenThousandRequests / 10000 * getRequests

	# Return the total cost
	storageCost + requestCost
}