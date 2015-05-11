#! /bin/bash

# new stock svg
cp stock/stock-top.txt new/new-top.txt
cp stock/stock-bottom.txt new/new-bottom.txt

#####

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

# set proper image dimensions for new svg
sed -i "s:imgheight:$imgheight:g" new/new-top.txt new/new-bottom.txt
sed -i "s:imgwidth:$imgwidth:g" new/new-top.txt new/new-bottom.txt

#####

# define textbox geometry
topBoxWidth="$[$imgwidth * 55 / 100]" # because only integers (no 0.55)
bottomBoxWidth=$topBoxWidth #same as above for now

topBoxX="$[$imgwidth * 225 / 1000]" # rounds down always
bottomBoxX=$topBoxX #same as above for now

topBoxHeight="$[$imgheight / 3]" #this was 4, but i made it bigger for longer quotes, leaves ~2.67% in between quote boxes (not actual text)
bottomBoxHeight="$[$imgheight * 19 / 100]" # was 14%, made bigger for longer attributions

topBoxY="$[$imgheight / 4]" # TODO - translations start at centre, + goes up, - goes down
bottomBoxY="$[$imgheight * 61 / 100]" #"$[$imgheight * 11 / 100 * -1]" #"$[$imgheight / 4]" # TODO - optimize these, fix

# replace svg's textbox geometry
sed -i "s:topBoxWidth:$topBoxWidth:g" new/new-bottom.txt
sed -i "s:bottomBoxWidth:$bottomBoxWidth:g" new/new-bottom.txt

sed -i "s:topBoxX:$topBoxX:g" new/new-bottom.txt
sed -i "s:bottomBoxX:$bottomBoxX:g" new/new-bottom.txt

sed -i "s:topBoxHeight:$topBoxHeight:g" new/new-bottom.txt
sed -i "s:bottomBoxHeight:$bottomBoxHeight:g" new/new-bottom.txt

sed -i "s:topBoxY:$topBoxY:g" new/new-bottom.txt
sed -i "s:bottomBoxY:$bottomBoxY:g" new/new-bottom.txt

#####

#set font sizes (based on percents from original image (1440x900))
#4.4%h 40px
#5.3%h 48px
#6.2%h 56px
# TODO - make this a fraction of textbox size, not image

fontSizeMain="$[$imgheight * 44 / 1000]"
fontSizeBigger="$[$imgheight * 53 / 1000]"
fontSizeBiggest="$[$imgheight * 62 / 1000]"

#echo "fontSizeMain=$fontSizeMain"
#echo "fontSizeBigger=$fontSizeBigger"
#echo "fontSizeBiggest=$fontSizeBiggest"

sed -i "s:fontSizeMain:$fontSizeMain:g" new/new-bottom.txt
sed -i "s:fontSizeBigger:$fontSizeBigger:g" new/new-bottom.txt
sed -i "s:fontSizeBiggest:$fontSizeBiggest:g" new/new-bottom.txt

#####

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

#####

#echo "topBoxWidth=$topBoxWidth"
#echo "topBoxX=$topBoxX"

#echo "topBoxHeight=$topBoxHeight"
#echo "bottomBoxHeight=$bottomBoxHeight"

#echo "topBoxY=$topBoxY"
#echo "bottomBoxY=$bottomBoxY"

# replace quote stuff

quoteQuoteStart=${quoteQuote:0:2}
quoteQuoteRest=${quoteQuote:2}
quoteAuthorStart=${quoteAuthor:0:1}
quoteAuthorRest=${quoteAuthor:1}
#echo "quoteQuoteStart"
sed -i "s:quoteQuoteStart:$quoteQuoteStart:g" new/new-bottom.txt
#echo "quoteQuoteRest"
sed -i "s:quoteQuoteRest:$quoteQuoteRest:g" new/new-bottom.txt
#echo "quoteAuthorStart"
sed -i "s:quoteAuthorStart:$quoteAuthorStart:g" new/new-bottom.txt
#echo "quoteAuthorRest"
sed -i "s:quoteAuthorRest:$quoteAuthorRest:g" new/new-bottom.txt
#echo "quoteYear"
sed -i "s:quoteYear:$quoteYear:g" new/new-bottom.txt

#####

# merge all files to one svg
cat new/new-top.txt > new.svg
# convert jpg to base64
base64 walls/"$theWall" >> new.svg
cat new/new-bottom.txt >> new.svg

#####

# export to png
inkscape -f new.svg -e new.png

#########
# NOTES #
#########
# quote is ~33% of height, was 25% before
# bottom quote is ~19% of height, was 14% before
# therefor middle is ~2.67% of height, was ~11% before

# totals
# text boxes take up ~55% of width, centred (~22.5% each side)
# text boxes take up ~55% of height, centred, (25% top, 20% bottom)

# encode
# $ base64 sampleimage.jpg > sample.txt

# decode
# $ base64 -d sample.txt > newsample.jpg

# sed doesn't like colons, so I had to escape them all

#inkscape command-line options that may be relevant
#  -X, --query-x                             Query the X coordinate of the
#                                            drawing or, if specified, of the
#                                            object with --query-id
#  -Y, --query-y                             Query the Y coordinate of the
#                                            drawing or, if specified, of the
#                                            object with --query-id
# -W, --query-width                         Query the width of the drawing or,
#                                            if specified, of the object with
#                                            --query-id
#  -H, --query-height                        Query the height of the drawing
#                                            or, if specified, of the object
#                                            with --query-id
#  -S, --query-all                           List id,x,y,w,h for all objects
#  -I, --query-id=ID                         The ID of the object whose
#                                            dimensions are queried

# TODO - adjust font size to a percent based on image height and how many lines it takes somehow
# TODO - then (after above) position the author box closer to quote (based on quote position)

# imagemagick generate blank canvas
#convert -size 500x100 xc:transparent transparent.png

# imagemagick draw text
#convert -font "DejaVu Sans" -background 'rgba(0,0,0,0)' -gravity center -fill white -strokewidth 2 -stroke 'rgba(0,0,0,0.6)' -size 500x100 caption:"Stuff goes here" transparent.png +swap -gravity south -composite new.png

#then convert to b64 and add to svg?
