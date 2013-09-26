# Calculates the EMR cost per month, based on the number of events per month and the number of times per day the enrichment process is run
emrCostPerMonth <- function(eventsPerMonth, runsPerDay){
	runsPerMonth <- runsPerDay * 30
	eventsPerRun <- eventsPerMonth / runsPerMonth
	instanceHoursPerRun <- emrInstanceHoursRequired(eventsPerRun)
	costOfEachRun <- emrCostPerRunRaw(instanceHoursPerRun)

	# Monthly EMR cost = cost per run x runs per month
	costOfEachRun * runsPerMonth
}


# Function for modelling EMR costs based on number of Instances and number of hours
# Currently assumes that all instances are m1.small
emrCostPerRunRaw <- function(instancesHours){
	ec2PricePerHour <- 0.06
	emrPricePerInstancePerHour <- 0.015
	totalEmrPricePerInstancePerHour <- ec2PricePerHour + emrPricePerInstancePerHour
	totalEmrPricePerInstancePerHour * instancesHours
}


# Calculate the number of instance (m1small) hours required to process X lines of data
emrInstanceHoursRequired <- function(linesToProcess){
	# Following figures based on a regression analysis of job time vs number of lines processed
	intercept <- 3.689e-06
	gradient <- 3.788e-01
	instanceHoursRequired <- linesToProcess * gradient + intercept

	# Now round up to nearest whole number
	ceiling(instanceHoursRequired)	
}