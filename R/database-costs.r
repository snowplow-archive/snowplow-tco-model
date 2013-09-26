# Returns the cost of database projecting X months forwards (postgres or Redshift)
databaseCostByMonth <- function(databaseType, eventsPerMonth, numberOfMonths){
	if (databaseType == 'postgres') 
		{postgresCostByMonth(eventsPerMonth, numberOfMonths)} else
		{redshiftCostByMonth(eventsPerMonth, numberOfMonths)}
}


# Returns the cost of Redshift projecting X months forwards
redshiftCostByMonth <- function(eventsPerMonth, numberOfMonths) {
	eventsStoredByMonth <- seq(eventsPerMonth, by=eventsPerMonth, length=numberOfMonths)
	nodesRequiredByMonth <- redshiftNodesRequired(eventsStoredByMonth)
	redshiftEffectiveCostPerMonth(nodesRequiredByMonth)
}


redshiftNodesRequired <- function(eventsStored){
	# We believe that 4 billion events can be stored on each Redshift XL node
	maxEventsPerNode <- 4000000000 
	ceiling(eventsStored/maxEventsPerNode)
}


# Amazon Redshift cost
# Assumes  year reserved instance pricing and XL nodes (not 8XL nodes)
redshiftEffectiveCostPerMonth <- function(numberOfNodes){
	upfrontCostPerNode <- 3000
	hourlyCostPerNode <- 0.114

	# Cost per month = cost for entire 3 years / 36
	threeYearCost <- (upfrontCostPerNode + hourlyCostPerNode * 24 * 365.25 * 3) * numberOfNodes
	threeYearCost / 36
}


# Returns the cost of PostgreSQL projecting X months forward
postgresCostByMonth <- function(eventsPerMonth, numberOfMonths) {
	eventsStoredByMonth <- seq(eventsPerMonth, by=eventsPerMonth, length=numberOfMonths)
	instancesRequiredByMonth <- postgresInstancesRequired(eventsStoredByMonth)
	postgresEffectiveCostPerMonth(instancesRequiredByMonth)
}

# Assume PostgreSQL is run on m1.xlarge instances, and that each instance can handle 100M lines of data
postgresInstancesRequired <- function(eventsStored){
	maxEventsPerInstance <- 100000000
	ceiling(eventsStored/maxEventsPerInstance)
}


# Assume m1.xlarge instances reserved for 3 years
postgresEffectiveCostPerMonth <- function(numberOfInstances){
	upfrontCostPerInstance <- 1028
	hourlyCostPerInstance <- 0.046

	# Cost per month = cost for entire 3 years / 36
	threeYearCost <- (upfrontCostPerInstance + hourlyCostPerInstance * 24 * 365.25 * 3) * numberOfInstances
	threeYearCost / 36
}

