#!/bin/bash

#Cookie for Yahoo Finance - Need to generate this dynamically
cookie=''
userId=''
fileBasePath='/Users/akashmehta/Dropbox/Yahoo-Finance-Live-Feed/apache-tomcat-8.5.9/webapps/live-graph'
yahooFinanceBaseUrl='https://query1.finance.yahoo.com'

# Write to Akash-DayGain.txt file for live day gain/loss data, file header: Date,DayGainPercentage
curl -s -H "cookie: $cookie" "$yahooFinanceBaseUrl/v7/finance/desktop/portfolio?formatted=true&userId=$userId&fields=quoteType" | python -m json.tool | grep dailyPercentGain | head -n1 | awk  {'print $2'} | awk -F "," {'print $1'} | sed "s/^/$(TZ=":US/Eastern" date +'%Y-%m-%d %T'),/" >> $fileBasePath/Akash-DayGain.txt

# Write to Akash-OverallGain.txt file for overall performace percentage, file header: Date,DayGainPercentage
curl -s -H "cookie: $cookie" "$yahooFinanceBaseUrl/v7/finance/desktop/portfolio?formatted=true&userId=$userId&fields=quoteType" | python -m json.tool | grep totalPercentGain | tail -n1 | awk  {'print $2'} | awk -F "," {'print $1'} | sed "s/^/$(TZ=":US/Eastern" date +'%Y-%m-%d %T'),/" >> $fileBasePath/Akash-OverallGain.txt

# Write to DJI-DayGain.txt file for Dow Jones index' ^DJI live data, file header: Date,DayGainPercentage
curl -s -H "cookie: $cookie" "$yahooFinanceBaseUrl/v8/finance/chart/^DJI?region=US&lang=en-US&includePrePost=false&interval=1d&useYfid=true&range=1d&corsDomain=finance.yahoo.com&.tsrc=financ" | python -m json.tool | grep -E "regularMarketPrice|chartPreviousClose" | awk -F ': ' '{print $2}' | awk -F ',' '{print $1}' | awk 'BEGIN{ RS = "" ; FS = "\n" }{print ($2-$1)*100/$1}' | sed "s/^/$(TZ=":US/Eastern" date +'%Y-%m-%d %T'),/" >> $fileBasePath/DJI-DayGain.txt

# Write to NASDAQ-DayGain.txt file for NASDAQ index' ^IXIC live data, file header: Date,DayGainPercentage
curl -s -H "cookie: $cookie" "$yahooFinanceBaseUrl/v8/finance/chart/^IXIC?region=US&lang=en-US&includePrePost=false&interval=1d&useYfid=true&range=1d&corsDomain=finance.yahoo.com&.tsrc=financ" | python -m json.tool | grep -E "regularMarketPrice|chartPreviousClose" | awk -F ': ' '{print $2}' | awk -F ',' '{print $1}' | awk 'BEGIN{ RS = "" ; FS = "\n" }{print ($2-$1)*100/$1}' | sed "s/^/$(TZ=":US/Eastern" date +'%Y-%m-%d %T'),/" >> $fileBasePath/NASDAQ-DayGain.txt

# Write to DJI-DayGain.txt file for SP500 index' ^GSPC ive data, file header: Date,DayGainPercentage
curl -s -H "cookie: $cookie" "$yahooFinanceBaseUrl/v8/finance/chart/^GSPC?region=US&lang=en-US&includePrePost=false&interval=1d&useYfid=true&range=1d&corsDomain=finance.yahoo.com&.tsrc=financ" | python -m json.tool | grep -E "regularMarketPrice|chartPreviousClose" | awk -F ': ' '{print $2}' | awk -F ',' '{print $1}' | awk 'BEGIN{ RS = "" ; FS = "\n" }{print ($2-$1)*100/$1}' | sed "s/^/$(TZ=":US/Eastern" date +'%Y-%m-%d %T'),/" >> $fileBasePath/SP500-DayGain.txt
