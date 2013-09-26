\name{snowplowCostByMonth}
\alias{snowplowCostByMonth}
\title{Calculate the total Amazon costs associated with running Snowplow X months ahead}
\usage{
  snowplowCostByMonth(uniquesPerMonth, eventsPerMonth,
    runsPerDay, storageDatabase, numberOfMonths,
    edgeLocations)
}
\arguments{
  \item{uniquesPerMonth}{number of unique visitors to
  website(s) per month}

  \item{eventsPerMonth}{number of events per month tracked}

  \item{runsPerDay}{number of times per day that enrichment
  process is run (generally 1-24)}

  \item{numberOfMonths}{number of months ahead that the
  model should project costs (e.g. 12 or 36)}

  \item{edgeLocations}{The number of different locations in
  Amazon's Cloudfront network that each generate an
  independent log when hit. We believe this number is
  between 10000 and 100000, but are not sure. (This has an
  impact on S3 costs)}
}
\description{
  Calculate the total Amazon costs associated with running
  Snowplow X months ahead
}

