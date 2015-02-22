library(shiny)
library(twitteR)

options(httr_oauth_cache = F)

jshtml <- paste(readLines("js.html"), collapse=" ")


fetch <- function(username) {

    source('.privateRdata.R', local=T)

    setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
    mht = homeTimeline(n=200)

    sortedtweets <- function(tweets,col="retweetCount") {
        # also try "favoriteCount"
        tw.df[ order(tweets[,col],decreasing=T), ]
    }

    makelink <- function(tweets,n=1,do.open=F,print.to.screen=T) {
        myurl <- paste("https://twitter.com/", tweets[n,]$screenName, "/status/", tweets[n,]$id, sep="" ) 
        if ( do.open ) {
            system( paste("open",myurl) )
        }
        if (print.to.screen) {
            print( myurl )
            print( paste("retweet count", tweets[n,]$retweetCount ) )
            print( paste("favorites    ", tweets[n,]$favoriteCount ) )
            print( paste("origin date  ", tweets[n,]$created ) )
        }
        myurl
    }

    makebq <- function(tweets,n=1) {
        part1 <- "<blockquote class='twitter-tweet' lang='en'><p>"
        part2 <- tweets[n,]$text 
        part3 <- "</p>"
        part4 <- paste( tweets[n,]$screenName , " (@", tweets[n,]$screenName, ")", sep="") 
        part5 <-  paste( "<a href=", makelink(tweets,n,print.to.screen=F) , ">", tweets[n,]$created, "</a>", sep="") 
        part6 <- "</blockquote>"
        allparts <- paste(part1,part2,part3,part4,part5,part6,sep="")
        #print(allparts)
        allparts
    }

    tw.df=twListToDF(mht)
    sorted_on_fav <- sortedtweets( tw.df, "favoriteCount" )
    sorted_on_rtw <- sortedtweets( tw.df )

    stuff_to_return <- ""

    for (i in 1:5) {
        stuff_to_return <- paste(stuff_to_return, "favorite rank: ", i, "\n" ) 
        stuff_to_return <- paste(stuff_to_return, makebq( sorted_on_fav, i ), "\n" )
    }

    for (i in 1:5) {
        stuff_to_return <- paste(stuff_to_return, "retweet rank: ", i, "\n" ) 
        stuff_to_return <- paste(stuff_to_return, makebq( sorted_on_rtw, i ), "\n" )
    }

    stuff_to_return <- paste( stuff_to_return, jshtml )
    stuff_to_return
}

fetch2 <- function(username) {
    paste("this is the output",username)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  output$twitter <- renderText({
      fetch( input$user )
  })



})


