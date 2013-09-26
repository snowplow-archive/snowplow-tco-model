# The Snowplow Total Cost of Ownership (TCO) Model 

`snowplowtcomodel` is a package for estimating the Amazon fees associated with running Snowplow.

The model is a work in progress: 

1. We've made a number of simplifying asumptions (see the next section). Over time, we'll evolve the model to enable people to flex those assumptions
2. The model is very "raw" - you simply execute a function in R to forecast prices, and then use other R functionality (e.g. ggplot2) to plot the costs over time.

## Assumptions

A number of simplifying assumptions have been made:

* All visitors tracked are located in the US. (Relevant when modelling Cloudfront costs.)
* All AWS services used are setup in the US-East-1 region. (The price of each AWS service varies by region.)
* The Cloudfront collector is used (rather than the Clojure collector). These reduces EC2 and EBS costs, but increases S3 costs, because it generates a larger number of log files than the Clojure Collector.
* The Snowplow user tracks the same number of uniques and events each month

## Installing the package

You can install the package directly from Github, via `dev_tools`

	> library("devtools")
	> install_github("snowplow-tco-model", "snowplow")
	> library("snowplowtcomodel")

## Using the package

Using the package is straightforward, you simply call the `snowplowCostByMonth` function. 

The `snowplowCostByMonth` function takes the following arguments, all of which **must** be supplied:

#' @param uniquesPerMonth The number of unique visitors to website(s) per month (integer)
#' @param eventsPerMonth The number of events per month tracked (integer)
#' @param runsPerDay The number of times per day that enrichment process is run (generally 1-24) (integer)
#' @param storageDatabase The type of database used to store Snowplow data. This *MUST* either be 'redshift' or 'postgres'
#' @param numberOfMonths number of months ahead that the model should project costs (e.g. 12 or 36)
#' @param edgeLocations The number of different locations in Amazon's Cloudfront network that each generate an independent log when hit. We believe this number is between 10000 and 100000, but are not sure. (This has an impact on S3 costs)

| ** Argument ** | ** Description ** |
|:---------------|:------------------|
| uniquesPerMonth| The number of uniques tracked per month [type: integer] |
| eventsPerMonth | The number of events tracked per month [type: integer] |
| runsPerDay     | The number of times that the Enrichment process is run per day [type: integer] |
| storageDatabase| The database that is used to store Snowplow data. This can be 'redshift' or 'postgres' [type: integer] |
| numberOfMonths | The number of months that the model will run for |
| edgeLocations  | This is the number of locations on the Amazon Cloudfront network that generate a log file each time one of the associated nodes is hit. We are not sure how many of these exist in the Cloudfront network. (We guess there are 10k - 100k). This impacts S3 costs, because it determines how many log files are generated in each time period, and a certain number of requests are made per log file generated. |

For example, to find out how much Snowplow would cost for a user with 800k uniques per month, 5M events per month who uses PostgreSQL to store the data, we would run:

	> costModel <- snowplowCostByMonth(800000, 5000000, )