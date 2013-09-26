# Calculate the total Amazon costs associated with running Snowplow X months ahead
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