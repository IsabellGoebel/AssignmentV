#' ---
#' title: "Assignment V"
#' subtitle: "GitHub and the ticketmaster.com API"
#' author: "Isabell Goebel (Student ID: 5374775)"
#' output: 
#'   html_document:
#'      theme: lumen
#'      highlight: haddock
#'      code_download: true  # download button for code (upper right corner)
#'      toc: true  # table of contents with links
#'      toc_depth: 3  # depth of toc, i.e. subchapters
#'      toc_float:  # toc on the left (always visible, also when scrolling)
#'         collapsed: false  # otherwise not full toc (subchapters) shown
#'      number_sections: true  # numbers sections
#' ---
#' 
#' <br>
#' 
#' R Version: `r version$version.string`  
#' Last updated: `r Sys.time()`
#' 
#' <br>
#' 
#' I worked with no one. I hereby assure that my submission is in line with the 
#' *Code of Conduct* outlined on the lecture slides.
#' 
#' ------------------------
#' 
#' <details><summary>Task</summary>
#' 
#' In this assignment, you will apply what you have learned about APIs and about 
#' version control with Git(Hub).
#' First, you will acquire data about event venues using the API provided by ticketmaster.com. 
#' You will then use the geospatial data to visualize the extracted data on a map. 
#' Finally, you will repeat the same steps for a different country. 
#' It is further required that the entire project and its version history is documented 
#' in your personal GitHub repository.
#' 
#' 1. Setting up a new GitHub repository
#' 
#' * Register on github.com in case you have not done this already.
#' * Initialize a new public repository for this assignment on GitHub.
#' * For the following exercises of this assignment, follow the standard Git workflow 
#'   (i.e., pull the latest version of the project to your local computer, then stage, 
#'   commit, and push all the modifications that you make throughout the project). 
#'   Every logical programming step should be well documented on GitHub with a meaningful 
#'   commit message, so that other people (e.g., your course instructor) can follow 
#'   understand the development history. 
#'   You can to do this either using Shell commands or a Git GUI of your choice.
#' * In the HTML file that you submit, include the hyperlink to the project repository 
#'   (e.g., https://github.com/yourUserName/yourProjectName)
#'   
#'
#' 2. Getting to know the API
#' 
#' * Visit the documentation website for the API provided by ticketmaster.com 
#'   (see https://developer.ticketmaster.com/products-and-docs/apis/getting-started/)
#' * Familiarize yourself with the features and functionalities of the Ticketmaster 
#'   Discovery API. 
#'   Have a particular look at rate limits.
#' * Whithin the scope of this assignment, you do not have to request your own API key. 
#'   Instead retrieve a valid key from the API Explorer 
#'   (see https://developer.ticketmaster.com/api-explorer/v2/). 
#'   This API key enables you to perform the GET requests needed throughout this assignment.
#' * Even though this API key is not secret per se (it is publicly visible on the 
#'   API Explorer website), please comply to the common secrecy practices discussed 
#'   in the lecture and the tutorial: Treat the API key as a secret token. 
#'   Your API key I key should neither appear in the code that you are submitting 
#'   nor in your public GitHub repository.
#' 
#' 
#' 3. Interacting with the API - the basics
#' 
#' * Load the packages needed to interact with APIs using R.
#' * Perform a first GET request, that searches for event venues in Germany (countryCode = "DE"). 
#'   Extract the content from the response object and inspect the resulting list. 
#'   Describe what you can see.
#' * Extract the name, the city, the postalCode and address, as well as the url 
#'   and the longitude and latitude of the venues to a data frame.
#'
#'
#' 4. Interacting with the API - advanced
#' 
#' * Have a closer look at the list element named page. 
#'   Did your GET request from exercise 3 return all event locations in Germany? 
#'   Obviously not - there are of course much more venues in Germany than those 
#'   contained in this list. 
#'   Your GET request only yielded the first results page containing the first 20 
#'   out of several thousands of venues.
#' * Check the API documentation under the section Venue Search. 
#'   How can you request the venues from the remaining results pages?
#' * Write a for loop that iterates through the results pages and performs a GET 
#'   request for all venues in Germany. 
#'   After each iteration, extract the seven variables name, city, postalCode, 
#'   address, url, longitude, and latitude. 
#'   Join the information in one large data frame.
#'
#'   
#' 5. Visualizing the extracted data
#' 
#' * Below, you can find code that produces a map of Germany. 
#'   Add points to the map indicating the locations of the event venues across Germany.
#' * You will find that some coordinates lie way beyond the German borders and can 
#'   be assumed to be faulty. 
#'   Set coordinate values to NA where the value of longitude is outside the range 
#'   (5.866944, 15.043611) or where the value of latitude is outside the range 
#'   (47.271679, 55.0846) (these coordinate ranges have been derived from the extreme 
#'   points of Germany as listed on Wikipedia 
#'   (see https://en.wikipedia.org/wiki/Geography_of_Germany#Extreme_points). 
#'   For extreme points of other countries, 
#'   see https://en.wikipedia.org/wiki/Lists_of_extreme_points#Sovereign_states.      
#'   
#'  
#'</details>  
#' 
#' ------------------------
#'
#+ preamble, message = FALSE
# clear current workspace
remove(list = ls())
#' 
#'<details><summary>Chunk Options / Directory</summary>
#+ setup
# global code chunk options
knitr::opts_chunk$set(echo=TRUE,  # display code
                      options(width=80),  # line length 80 characters
                      tidy=TRUE, tidy.opts=list(width.cutoff=80),  # tidy code
                      # set directory
                      root.dir="/Users/isabellheinemann/Desktop/AssignmentV")
#'</details>
#'
#'
#'<details><summary>Packages and Libraries</summary>
#+ packages, message = FALSE
# Check if packages have been installed before; if not, install them
if (!require("tidyr")) install.packages("tidyr")
if (!require("dplyr")) install.packages("dplyr")
if (!require("knitr")) install.packages("knitr")
if (!require("formatR")) install.packages("formatR")
if (!require("jsonlite")) install.packages("jsonlite")
if (!require("rvest")) install.packages("rvest")
if (!require("xml2")) install.packages("xml2")
if (!require("httr")) install.packages("httr")
if (!require("rlist")) install.packages("rlist")
if (!require("ggplot2")) install.packages("ggplot2") 

# call package libraries
library(tidyr)
library(dplyr)
library(knitr)
library(formatR)
library(jsonlite)
library(rvest)
library(xml2)
library(httr)
library(rlist)
library(ggplot2)

#'</details>
#' 
#' ------
#' 
#+ spin, echo = FALSE, results = 'hide'
# To receive .Rmd file of this file
spin("Goebel_Isabell_AssignmentV.R", knit = FALSE)
#' 
#' 
#' 
#' # GitHub Repository
#' 
#' My GitHub public repository for this assignment can be found here: 
#' https://github.com/CeterisPartybus/AssignmentV
#' 
#' 
#' 
#' # Ticketmaster API
#' 
#' 
#' All API calls follow this format: 
#' https://app.ticketmaster.com/{package}/{version}/{resource}.json?apikey=**{API key}
#' 
#' 
#' **Rate Limit**
#' 
#' * All API keys are issued with a default quota of 5000 API calls per day and 
#'   rate limitation of 5 requests per second. 
#' * Rate limits may be increased on case-by-case basis. In order to increase the 
#'   rate limit for a particular application, we need to verify the following:
#'   * The application is in compliance with our Terms of Service
#'   * The application is in compliance with our branding guide
#'   * The application is representing the Ticketmaster data properly
#'   
#'   Once these three criteria are verified, the rate limit is increased to what 
#'   Ticketmaster and the developer determine to be appropriate.
#' 
#' 
#' **Rate Limit Info in Response Header**
#' 
#' To see how much of the quota has been used check the following response headers:
#' 
#' * Rate-Limit: What rate limit is available, default is 5000.
#' * Rate-Limit-Available: How many requests are available to you (5000 - requests carried out).
#' * Rate-Limit-Over: How many requests over your quota you made.
#' * Rate-Limit-Reset: The UTC date and time of when your quota will be reset.
#' * `curl -I 'http://app.ticketmaster.com/discovery/v1/events.json?keyword=Queen&apikey=xxx'`
#' 
#' 
#' **API Response When Quota is Reached**
#' 
#' When you do go over your quota, you will get an HTTP status code 429 indicating 
#' you’ve made too many requests. 
#' 
#' 
#' **API Explorer**
#' 
#' Generate key to access the event data via API 
#' (see https://developer.ticketmaster.com/api-explorer/v2/).
#' 
#' I stored the API key in a separate R file called `key.R` in the variable `key`.
#' The `key.R` file is located in the same folder as the rest of my R project for 
#' this assignment, but it is not admitted to GitHub for version control, since 
#' it is *secret*.
#' 
#+ key
# Source key from file key.R into this file
source("key.R")
#' 
#' 
#' 
#' # Interacting with the API - basics
#' 
#' 
#' The packages needed to interact with APIs using R have been loaded in the preamble
#' at the beginning of the file.
#' 
#' Subsequently, a GET request is performed that searches for event venues in Germany 
#' (countryCode = "DE"). 
#' The content from the response object `ticketmaster` is extracted and inspected. 
#' 
#+ 3.a
# since the country will vary
country <- "DE"

# generate response object
ticketmaster <- GET("https://app.ticketmaster.com/discovery/v2/venues.json?",
                    query = list(apikey = key,  # secret key
                                 countryCode = country,  # in this case "DE"
                                 locale = "*"))  # make sure to extract all info

# show content & status code of object (200 = success)
ticketmaster

# extract content of response object
venues <- fromJSON(content(ticketmaster, as="text"))

# inspect content
glimpse(venues)
#'
#' The extracted list `venues` consist of 3 elements.
#' In `_embedded$venues` there is a data frame consisting of 20 rows of 19 columns.
#' Further, `_links` contains links to the first, next, and last page found on the
#' main page "/discovery/v2/venues.json", from where I extracted the data.
#' Lastly, `page` contains information on the size 
#' (`r as.numeric(venues$page$size)`), total elements 
#' (`r as.numeric(venues$page$totalElements)`), 
#' total pages 
#' (`r as.numeric(venues$page$totalPages)`) and current page number
#' (`r as.numeric(venues$page$number)`) of the extracted data.
#'
#'
#' Next, the variables name, city, postalCode and address, as well as url and
#' longitude and latitude of the venues are extracted to a data frame.
#'
#+ 3.b
# extract venue content to data frame
venue_df <- data.frame(venues$'_embedded'$venues)

# extract variables from data frame 'venue_df'
vars <- c("name", "postalCode", "url")

# combine in new data frame 'venue_data'
venue_data <- data.frame(venue_df[vars])

# add variables from data frame within data frame 'venue_df'
venue_data$city = venue_df[["city"]][["name"]]
venue_data$address = venue_df[["address"]][["line1"]]
venue_data$longitude = venue_df[["location"]][["longitude"]]
venue_data$latitude = venue_df[["location"]][["latitude"]]

# adjust order
order <- c("name", "city", "postalCode", "address", "url", "longitude", "latitude")
venue_data <- venue_data[, order]

# check new data frame
glimpse(venue_data)
#' 
#' 
#' The resulting data frame contains 
#' `r nrow(venue_data)` 
#' rows and 
#' `r ncol(venue_data)` 
#' variables, namely name, postalCode, address, url, longi- and latitude.
#' 
#' 
#' 
#' 
#' # Interacting with the API - advanced
#'
#'   
#' Below, the content of the list element page is inspected.
#'           
#+ 4.a
# number of results per page
perpage <- as.numeric(venues$page$size)
perpage

# total results
n <- as.numeric(venues$page$totalElements)
n

# number of complete pages
pages <- floor(n/perpage)-1  # adjustment since page 1 is page 0
pages

# number of entries on the last incomplete page
remainder <- n-perpage*floor(n/perpage)
remainder
#' 
#' On the content of the list element `page` has been commented in the previous
#' exercise above, thus this is not repeated, but the code chunk is deemed to be 
#' rather self explanatory.
#' One observation worth pointing out, however, is that the first page number of
#' the event venue data starts with 0 instead of 1.
#' 
#' To retrieve more than the 20 results as shown above, it is necessary to loop
#' over the 
#' `r pages+1`
#' pages containing the 
#' `r n` observations of event venue data.
#' From the API documentation 
#' (see https://developer.ticketmaster.com/products-and-docs/apis/discovery-api/v2/#search-venues-v2)
#' it can be learned, that the option `page = ` can be used to access the different
#' pages.
#' 
#' Further, it is important to distinguish between complete pages (containing 
#' `r perpage` 
#' entries) and any remaining non-complete pages (in this case, the last page contains
#' `r remainder` 
#' observations).
#'
#' Subsequently, an empty data frame to store the results in is initiated.
#' Then, a loop that iterates through the results pages and performs a GET 
#' request for all venues in Germany is implemented. 
#' Since I experiences issues with some apparently empty object when performing 
#' the GET request, I added an `if statement` testing, whether an object is not
#' empty, then extracting the data, other wise fill in NA's.
#' 
#' After each iteration, the seven variables name, city, postalCode, address, url, 
#' longitude, and latitude are extracted for all complete pages, for the last 
#' incomplete page, and then joined in a large data frame. 
#'   
#+ 4.b, warning = FALSE
# initiate a data frame in correct dimensions to speed up our loop:
venue_all <- data.frame(
  name = character(n), 
  city = character(n), 
  postalCode = character(n), 
  address = character(n),
  url = character(n), 
  longitude = character(n),
  latitude = character(n)
  )

# loop through complete pages
for (i in 0:pages) {  # in this case the 1st page is page 0

  # generate response object
  ticketmaster <- GET("https://app.ticketmaster.com/discovery/v2/venues.json?",
                      query = list(apikey = key,  # secret key
                                   countryCode = country,  # in this case "DE"
                                   locale = "*",  # make sure to extract all info
                                   page = i)) # iterate through i pages
  
  # extract content of response object
  venues_content <- fromJSON(content(ticketmaster, as="text"))
  
  # adjust index, since the first page is page 0
  k <- i+1
  
  # gradually fill data frame page by page 
  index <- (perpage * k - (perpage-1)):(perpage * k)

  # if the object name exists, extract data
  if (!is.null(venues_content$'_embedded'$venues$name)) {
    venue_all[index,"name"] <- data.frame(venues_content$'_embedded'$venues$name)
  } else { # if the object address does not exist, fill with NA
    venue_all[index,"name"] <- rep(NA, perpage)
  } 
  
  # if the object url exists, extract data
  if (!is.null(venues_content$'_embedded'$venues$url)) {
    venue_all[index,"url"] <- data.frame(venues_content$'_embedded'$venues$url)
  } else { # if the object address does not exist, fill with NA
    venue_all[index,"url"] <- rep(NA, perpage)
  } 
  
  # if the object postalCode exists, extract data
  if (!is.null(venues_content$'_embedded'$venues$postalCode)) {
    venue_all[index,"postalCode"] <- data.frame(venues_content$'_embedded'$venues$postalCode)
  } else { # if the object address does not exist, fill with NA
    venue_all[index,"postalCode"] <- rep(NA, perpage)
  } 
  
  # if the object city$name exists, extract data
  if (!is.null(venues_content$'_embedded'$venues$city$name)) {
    venue_all[index,"city"] <- data.frame(venues_content$'_embedded'$venues$city$name)
  } else { # if the object address does not exist, fill with NA
    venue_all[index,"city"] <- rep(NA, perpage)
  } 
  
  # if the object address$line1 exists, extract data
  if (!is.null(venues_content$'_embedded'$venues$address$line1)) {
    venue_all[index,"address"] <- data.frame(venues_content$'_embedded'$venues$address$line1)
  } else { # if the object address does not exist, fill with NA
    venue_all[index,"address"] <- rep(NA, perpage)
  } 
  
  # if the object location$longtude exists (assuming then latitude exists as well)
  if (!is.null( venues_content$'_embedded'$venues$location$longitude)) {
    venue_all[index,"longitude"] <- data.frame(venues_content$'_embedded'$venues$location$longitude)
    venue_all[index,"latitude"] <- data.frame(venues_content$'_embedded'$venues$location$latitude)
  } else { # if the object location (containing longi- and latitude) does not exist
    venue_all[index,"longitude"] <- rep(NA, perpage)
    venue_all[index,"latitude"] <- rep(NA, perpage)
  } 
  
  # obey rate limit (request per second < 5)
  Sys.sleep(0.25)
}


# extract content of the last incomplete page
i <- i + 1  # adjust page number to be extracted 

# generate response object
ticketmaster <- GET("https://app.ticketmaster.com/discovery/v2/venues.json?",
                    query = list(apikey = key,  # secret key
                                 countryCode = country,  # in this case "DE"
                                 locale = "*",  # make sure to extract all info
                                 page = i)) # iterate through i pages

# extract content of response object
venues_content <- fromJSON(content(ticketmaster, as="text"))

# adjust index, since the first page is page 0
k <- i+1

# gradually fill data frame page by page 
index <- (perpage * k - (perpage-1)):(n)

# if the object name exists, extract data
if (!is.null(venues_content$'_embedded'$venues$name)) {
  venue_all[index,"name"] <- data.frame(venues_content$'_embedded'$venues$name)
} else { # if the object address does not exist, fill with NA
  venue_all[index,"name"] <- rep(NA, remainder)
} 

# if the object url exists, extract data
if (!is.null(venues_content$'_embedded'$venues$url)) {
  venue_all[index,"url"] <- data.frame(venues_content$'_embedded'$venues$url)
} else { # if the object url does not exist, fill with NA
  venue_all[index,"url"] <- rep(NA, remainder)
} 

# if the object postalCode exists, extract data
if (!is.null(venues_content$'_embedded'$venues$postalCode)) {
  venue_all[index,"postalCode"] <- data.frame(venues_content$'_embedded'$venues$postalCode)
} else { # if the object address does not exist, fill with NA
  venue_all[index,"postalCode"] <- rep(NA, remainder)
} 

# if the object city$name exists, extract data
if (!is.null(venues_content$'_embedded'$venues$city$name)) {
  venue_all[index,"city"] <- data.frame(venues_content$'_embedded'$venues$city$name)
} else { # if the object address does not exist, fill with NA
  venue_all[index,"city"] <- rep(NA, remainder)
} 

# if the object address$line1 exists, extract data
if (!is.null(venues_content$'_embedded'$venues$address$line1)) {
  venue_all[index,"address"] <- data.frame(venues_content$'_embedded'$venues$address$line1)
} else { # if the object address does not exist, fill with NA
  venue_all[index,"address"] <- rep(NA, remainder)
} 

# if the object location§longtude exists (assuming then latitude exists as well)
if (!is.null( venues_content$'_embedded'$venues$location$longitude)) {
  venue_all[index,"longitude"] <- data.frame(venues_content$'_embedded'$venues$location$longitude)
  venue_all[index,"latitude"] <- data.frame(venues_content$'_embedded'$venues$location$latitude)
} else { # if the object location (containing longi- and latitude) does not exist
  venue_all[index,"longitude"] <- rep(NA, remainder)
  venue_all[index,"latitude"] <- rep(NA, remainder)
} 

# check data
glimpse(venue_all)
#' 
#' 
#' 
#' # Visualizing the extracted data
#' 
#' 
#' Below, a map of Germany with points indicating the locations of the event venues 
#' is created.
#' 
#' Some coordinates lie beyond the German borders and can be assumed to be faulty. 
#' Therefore, the coordinate values are set to NA where the value of longitude is 
#' outside the range (5.866944, 15.043611) or where the value of latitude is outside 
#' the range (47.271679, 55.0846).
#' These coordinate ranges have been derived from the extreme points of Germany 
#' as listed on Wikipedia 
#' (see https://en.wikipedia.org/wiki/Geography_of_Germany#Extreme_points). 
#' 
#+ 5
# convert longi- and latitude from chr to num
venue_all$longitude <- as.numeric(venue_all$longitude)
venue_all$latitude <- as.numeric(venue_all$latitude)

# replace values outside German borders
venue_all$longitude[venue_all$longitude < 5.866944] <- NA
venue_all$longitude[venue_all$longitude > 15.043611] <- NA
venue_all$latitude[venue_all$latitude < 47.271679] <- NA
venue_all$latitude[venue_all$latitude > 55.0846] <- NA

# store defaults for this plot in object map
venue_map <- function(cntry){
  map <- ggplot(data = venue_all,  # select venue data
                mapping = aes(x = longitude, y = latitude)) +
    geom_polygon(
      aes(x = long, y = lat, group = group), 
      data = map_data("world", region = cntry),  # map of cntry
      fill = "grey90",color = "black") +
    theme_void() + 
    coord_quickmap() +
    theme(title = element_text(size=8, face='bold'),
          plot.caption = element_text(face = "italic")) +
    labs(title = paste0("Event locations across ",cntry),  # adjust title to cntry
         caption = "Source: ticketmaster.com") +
    geom_point(alpha = 0.5)  # add points
  
  return(map) # to actually display map
}

# plot map with event locations
venue_map(cntry="Germany")
#' 
#' 
#' 
#' 
#' # Event locations in Switzerland
#' 
#' 
#' Lastly, the whole process of extracting country specific event venue data is
#' repeated for another European country.
#' 
#' For my assignment I chose Switzerland (countryCode = "CH").
#' The extreme points can be retrieved via Wikipedia
#' (see https://en.wikipedia.org/wiki/List_of_extreme_points_of_Switzerland).
#' As in the previous exercise it is important to exclude longi- and latitudes of 
#' event venues outside the borders of a country, as otherwise data points 'all
#' over the place' will appear, that are not reasonable.
#' 
#' To shorten the output a bit I left aside for instance the `glimpse()` function
#' and other inspections of the data. 
#' As I am copying the previous (working) code I do not expect errors.
#' However, I the console of RStudio I did check the extracted data.
#' 
#' *Note*: I attempted to use a loop with 
#' `cntry <- c("DE", "CH")` and 
#' `for (c in cntry){ ... }` 
#' to not have to submit such a lengthy file, but I did  not work out.
#' I could probably have written a function to simplify and shorten my code. 
#' Since I am running out of time I will not be able to successfully implement 
#' either a loop or function to be more efficient.
#' But it would have been neat.
#' 
#+ 6
# adjust the country to Switzerland (CH)
country <- "CH"

# generate response object
ticketmaster <- GET("https://app.ticketmaster.com/discovery/v2/venues.json?",
                    query = list(apikey = key,  # secret key
                                 countryCode = country,  # in this case "DE"
                                 locale = "*"))  # make sure to extract all info

# extract content of response object
venues <- fromJSON(content(ticketmaster, as="text"))

# number of results per page
perpage <- as.numeric(venues$page$size)

# total results
n <- as.numeric(venues$page$totalElements)

# number of complete pages
pages <- floor(n/perpage)-1  # adjustment since page 1 is page 0

# number of entries on the last incomplete page
remainder <- n-perpage*floor(n/perpage)

# initiate a data frame in correct dimensions to speed up our loop:
venue_all <- data.frame(
  name = character(n), 
  city = character(n), 
  postalCode = character(n), 
  address = character(n),
  url = character(n), 
  longitude = character(n),
  latitude = character(n)
)

# loop through complete pages
for (i in 0:pages) {  # in this case the 1st page is page 0
  
  # generate response object
  ticketmaster <- GET("https://app.ticketmaster.com/discovery/v2/venues.json?",
                      query = list(apikey = key,  # secret key
                                   countryCode = country,  # in this case "CH"
                                   locale = "*",  # make sure to extract all info
                                   page = i)) # iterate through i pages
  
  # extract content of response object
  venues_content <- fromJSON(content(ticketmaster, as="text"))
  
  # adjust index, since the first page is page 0
  k <- i+1
  
  # gradually fill data frame page by page 
  index <- (perpage * k - (perpage-1)):(perpage * k)
  
  # if the object name exists, extract data
  if (!is.null(venues_content$'_embedded'$venues$name)) {
    venue_all[index,"name"] <- data.frame(venues_content$'_embedded'$venues$name)
  } else { # if the object address does not exist, fill with NA
    venue_all[index,"name"] <- rep(NA, perpage)
  } 
  
  # if the object url exists, extract data
  if (!is.null(venues_content$'_embedded'$venues$url)) {
    venue_all[index,"url"] <- data.frame(venues_content$'_embedded'$venues$url)
  } else { # if the object address does not exist, fill with NA
    venue_all[index,"url"] <- rep(NA, perpage)
  } 
  
  # if the object postalCode exists, extract data
  if (!is.null(venues_content$'_embedded'$venues$postalCode)) {
    venue_all[index,"postalCode"] <- data.frame(venues_content$'_embedded'$venues$postalCode)
  } else { # if the object address does not exist, fill with NA
    venue_all[index,"postalCode"] <- rep(NA, perpage)
  } 
  
  # if the object city$name exists, extract data
  if (!is.null(venues_content$'_embedded'$venues$city$name)) {
    venue_all[index,"city"] <- data.frame(venues_content$'_embedded'$venues$city$name)
  } else { # if the object address does not exist, fill with NA
    venue_all[index,"city"] <- rep(NA, perpage)
  } 
  
  # if the object address$line1 exists, extract data
  if (!is.null(venues_content$'_embedded'$venues$address$line1)) {
    venue_all[index,"address"] <- data.frame(venues_content$'_embedded'$venues$address$line1)
  } else { # if the object address does not exist, fill with NA
    venue_all[index,"address"] <- rep(NA, perpage)
  } 
  
  # if the object location$longtude exists (assuming then latitude exists as well)
  if (!is.null( venues_content$'_embedded'$venues$location$longitude)) {
    venue_all[index,"longitude"] <- data.frame(venues_content$'_embedded'$venues$location$longitude)
    venue_all[index,"latitude"] <- data.frame(venues_content$'_embedded'$venues$location$latitude)
  } else { # if the object location (containing longi- and latitude) does not exist
    venue_all[index,"longitude"] <- rep(NA, perpage)
    venue_all[index,"latitude"] <- rep(NA, perpage)
  } 
  
  # obey rate limit (request per second < 5)
  Sys.sleep(0.25)
}


# extract content of the last incomplete page
i <- i + 1  # adjust page number to be extracted 

# generate response object
ticketmaster <- GET("https://app.ticketmaster.com/discovery/v2/venues.json?",
                    query = list(apikey = key,  # secret key
                                 countryCode = country,  # in this case "CH"
                                 locale = "*",  # make sure to extract all info
                                 page = i)) # iterate through i pages

# extract content of response object
venues_content <- fromJSON(content(ticketmaster, as="text"))

# adjust index, since the first page is page 0
k <- i+1

# gradually fill data frame page by page 
index <- (perpage * k - (perpage-1)):(n)

# if the object name exists, extract data
if (!is.null(venues_content$'_embedded'$venues$name)) {
  venue_all[index,"name"] <- data.frame(venues_content$'_embedded'$venues$name)
} else { # if the object address does not exist, fill with NA
  venue_all[index,"name"] <- rep(NA, remainder)
} 

# if the object url exists, extract data
if (!is.null(venues_content$'_embedded'$venues$url)) {
  venue_all[index,"url"] <- data.frame(venues_content$'_embedded'$venues$url)
} else { # if the object url does not exist, fill with NA
  venue_all[index,"url"] <- rep(NA, remainder)
} 

# if the object postalCode exists, extract data
if (!is.null(venues_content$'_embedded'$venues$postalCode)) {
  venue_all[index,"postalCode"] <- data.frame(venues_content$'_embedded'$venues$postalCode)
} else { # if the object address does not exist, fill with NA
  venue_all[index,"postalCode"] <- rep(NA, remainder)
} 

# if the object city$name exists, extract data
if (!is.null(venues_content$'_embedded'$venues$city$name)) {
  venue_all[index,"city"] <- data.frame(venues_content$'_embedded'$venues$city$name)
} else { # if the object address does not exist, fill with NA
  venue_all[index,"city"] <- rep(NA, remainder)
} 

# if the object address$line1 exists, extract data
if (!is.null(venues_content$'_embedded'$venues$address$line1)) {
  venue_all[index,"address"] <- data.frame(venues_content$'_embedded'$venues$address$line1)
} else { # if the object address does not exist, fill with NA
  venue_all[index,"address"] <- rep(NA, remainder)
} 

# if the object location§longtude exists (assuming then latitude exists as well)
if (!is.null( venues_content$'_embedded'$venues$location$longitude)) {
  venue_all[index,"longitude"] <- data.frame(venues_content$'_embedded'$venues$location$longitude)
  venue_all[index,"latitude"] <- data.frame(venues_content$'_embedded'$venues$location$latitude)
} else { # if the object location (containing longi- and latitude) does not exist
  venue_all[index,"longitude"] <- rep(NA, remainder)
  venue_all[index,"latitude"] <- rep(NA, remainder)
} 

# convert longi- and latitude from chr to num
venue_all$longitude <- as.numeric(venue_all$longitude)
venue_all$latitude <- as.numeric(venue_all$latitude)

# replace values outside the Swiss borders
venue_all$longitude[venue_all$longitude < 5.956303] <- NA
venue_all$longitude[venue_all$longitude > 10.491944] <- NA
venue_all$latitude[venue_all$latitude < 45.818031] <- NA
venue_all$latitude[venue_all$latitude > 47.808264] <- NA

# plot map with event locations using function venue_map
venue_map(cntry="Switzerland")
#' 
#' 
#' 
#' 
#' 
#' <br><br>
#' 
#' <a href="#top">Back to top</a>