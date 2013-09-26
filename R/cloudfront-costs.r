toKilo <- function(x) (x/1024)
toMega <- function(x) (toKilo(toKilo(x)))
toGiga <- function(x) (toMega(toKilo(x)))
fromKilo <- function(x) (x*1024)
fromMega <- function(x) (fromKilo(fromKilo(x)))
fromGiga <- function(x) (fromMega(fromKilo(x)))

# Calculate the Cloudfront cost per month, based on the number of uniques and number of events per month

cfCostPerMonth <- function(events, uniques){
	# Assume sp.js is served once per unique per month (because of caching)
	# Assume that i is served once for every event
	requests <- events + uniques
	gigabytesServed <- events * sizeOfIPixel + uniques * sizeOfSpJs

	cfCostPerMonthRaw(gigabytesServed, requests)
}

# Calculate the Cloudfront cost per month, based on the monthly volume transferred out and number of requests
# Assumptions:
# * 10% of requests are HTTPS
# * all requests served to users in the US
# * < 10TB served per month
cfCostPerMonthRaw <- function(gigabytesServed, requests){
	dataTransferRatePerGigabytes <- 0.120
	dataTransferPrice <- dataTransferRatePerGigabytes * gigabytesServed

	httpRequestPricePerTenThousand <- 0.0075
	httpsRequestPricePerTenThousand <- 0.0100 

	httpRequests <- 0.9 * requests
	httpsResquests <- 0.1 * requests
	requestPrice <- httpRequests * httpRequestPricePerTenThousand / 10000 + httpsResquests * httpsRequestPricePerTenThousand / 10000

	# Return the total Cloudfront cost
	dataTransferPrice + requestPrice
}

# i pixel is 37 bytes
sizeOfIPixel <- toGiga(37)

# sp.js is 32 kilobytes
sizeOfSpJs <- fromKilo(toGiga(32))

