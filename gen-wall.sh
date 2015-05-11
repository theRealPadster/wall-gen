#! /bin/bash

# pick image
ls walls > walls/walls-list.txt
numWalls=$(wc -l < walls/walls-list.txt)
wallNumber="$[$RANDOM % $[$numWalls - 1] + 1]" # make interval one smaller to ignore walls-list.txt
theWall=$(tail -n+$wallNumber walls/walls-list.txt | head -n1)
#custom wall
#theWall='600p.jpg'

#####

# get image dimensions
imgheight="$(identify -format "%h" walls/$theWall)"
imgwidth="$(identify -format "%w" walls/$theWall)"

#####

# define textbox geometry
quoteBoxWidth="$[$imgwidth * 55 / 100]" # because only integers (no 0.55)
attribBoxWidth=$quoteBoxWidth #same as above for now
yearBoxWidth=$quoteBoxWidth #same as above for now

quoteBoxX="$[$imgwidth * 225 / 1000]" # rounds down always
attribBoxX=$quoteBoxX #same as above for now
yearBoxX=$quoteBoxX #same as above for now

quoteBoxHeight="$[$imgheight / 3]"
attribBoxHeight="$[$imgheight * 10 / 100]"
yearBoxHeight="$[$imgheight * 8 / 100]"

quoteBoxY="$[$imgheight / 4]"
attribBoxY="$[$imgheight * 66 / 100]"
yearBoxY="$[$imgheight * 78 / 100]"

# pick quote
# number of lines in text file
numLines=$(wc -l < stock/processedQuotes.txt)
numQuotes="$[$numLines / 5]"
quoteNumber="$[$RANDOM % $numQuotes + 1]"
quotePosition="$[$quoteNumber * 5 - 4]"
quoteEpisode=$(tail -n+$quotePosition stock/processedQuotes.txt | head -n1)
quoteQuote=$(tail -n+$[$quotePosition + 1] stock/processedQuotes.txt | head -n1)
quoteAuthor=$(tail -n+$[$quotePosition + 2] stock/processedQuotes.txt | head -n1)
quoteYear=$(tail -n+$[$quotePosition + 3] stock/processedQuotes.txt | head -n1)

echo "Episode: $quoteEpisode"
echo "Quote: $quoteQuote"
echo "Author: $quoteAuthor"
echo "Year: $quoteYear"

quoteAnchor="$[$imgheight * 85 / 1000]" #want quote anchored (y) at 41.5, not 50
attribAnchor="$[$imgheight * 21 / 100]" #want attribution anchored (y) at 71, not 50
yearAnchor="$[$imgheight * 32 / 100]" #want year anchored (y) at 82, not 50

#drop quote, author, year
convert -font "DejaVu Sans" -background 'rgba(0,0,0,0)' -gravity center -geometry +0-$quoteAnchor -fill white -strokewidth 2 -stroke 'rgba(0,0,0,0.6)' -size "$quoteBoxWidth"x"$quoteBoxHeight" caption:"$quoteQuote" walls/$theWall +swap -composite new.png

convert -font "DejaVu Sans" -background 'rgba(0,0,0,0)' -gravity center -geometry +0+$attribAnchor -fill white -strokewidth 2 -stroke 'rgba(0,0,0,0.6)' -size "$attribBoxWidth"x"$attribBoxHeight" caption:"$quoteAuthor" new.png +swap -composite new.png

convert -font "DejaVu Sans" -background 'rgba(0,0,0,0)' -gravity center -geometry +0+$yearAnchor -fill white -strokewidth 2 -stroke 'rgba(0,0,0,0.6)' -size "$yearBoxWidth"x"$yearBoxHeight" caption:"$quoteYear" new.png +swap -composite new.png

# replace quote stuff

quoteQuoteStart=${quoteQuote:0:2}
quoteQuoteRest=${quoteQuote:2}
quoteAuthorStart=${quoteAuthor:0:1}
quoteAuthorRest=${quoteAuthor:1}

#when all done, set name of file to episodeTitle+quoteNumber?

#########
# NOTES #
#########

#TODO - set max text size
#TODO - set custom stroke width
#TODO - make captions not fuzzy?
#TODO - make first character of quote larger
#TODO - get proper font working
#TODO - don't need sed anti-colon formatting?

# sed doesn't like colons, so I had to escape them all

# imagemagick generate blank canvas
#convert -size 500x100 xc:transparent transparent.png

# imagemagick draw text
#convert -font "DejaVu Sans" -background 'rgba(0,0,0,0)' -gravity center -fill white -strokewidth 2 -stroke 'rgba(0,0,0,0.6)' -size 500x100 caption:"Stuff goes here" transparent.png +swap -gravity south -composite new.png
