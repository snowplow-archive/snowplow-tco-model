#' Calculate the total Amazon costs associated with running Snowplow X months ahead
#'
#' @param uniquesPerMonth number of unique visitors to website(s) per month
#' @param eventsPerMonth number of events per month tracked
#' @param runsPerDay number of times per day that enrichment process is run (generally 1-24)
#' @param numberOfMonths number of months ahead that the model should project costs (e.g. 12 or 36)
#' @param edgeLocations The number of different locations in Amazon's Cloudfront network that each generate an independent log when hit. We believe this number is between 10000 and 100000, but are not sure. (This has an impact on S3 costs)
#'
#' @export
snowplowCostByMonth <- function(uniquesPerMonth, eventsPerMonth, runsPerDay, storageDatabase, numberOfMonths, edgeLocations){
	# Snowplow cost is made up of Cloudfront, S3, EMR and database (Redshift / storage) costs
	cloudfrontCost <- cfCostPerMonth(eventsPerMonth, uniquesPerMonth)
	s3Cost <- s3CostByMonth(eventsPerMonth, runsPerDay, edgeLocations, numberOfMonths)
	emrCost <- emrCostPerMonth(eventsPerMonth, runsPerDay)
	databaseCost <- databaseCostByMonth(storageDatabase, eventsPerMonth, numberOfMonths)

	# Combine above 4 costs in a single data frame:
	snowplowCost <- data.frame(cloudfrontCost, s3Cost, emrCost, databaseCost)
	snowplowCost$totalCost <- snowplowCost$cloudfrontCost + snowplowCost$s3Cost + snowplowCost$emrCost + snowplowCost$databaseCost

	# Now return the completed data frame
	snowplowCost
}