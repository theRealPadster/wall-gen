# wall-gen
Script to overlay Andromeda quotes on wallpapers, given a list of quotes and some wallpapers. 
## Instructions:
1. Put any wallpapers you want in the *walls* folder
2. Put any quotes you want in the *stock/processedQuotes.txt* file in the form:
  * Episode name
  * "Quote"
  * Author
  * Date
  * Blank line
3. cd to *wall-gen* directory
4. run *gen-wall-around-b64.sh*
This will output *new.svg*, which contains the new wallpaper, and *new.png*, which is an exported png version of the same file.
