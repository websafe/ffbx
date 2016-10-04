ffbx - Firefox bookmarks extractor
==================================

Simple Bash script using sqlite3 for extracting bookmarks from
`places.sqlite` found in Firefox user profiles.


Bookmarks are extracted with:

 + timestamp of last modification,
 + date added,
 + profile name,
 + folder,
 + url,
 + title,
 + tags.



Usage
-----

A simple test without installing:

~~~~ bash
wget -qO - https://raw.githubusercontent.com/websafe/ffbx/master/ffbx.sh | bash
~~~~

or:

~~~~ bash
lynx -dump https://raw.githubusercontent.com/websafe/ffbx/master/ffbx.sh | bash
~~~~

or:

~~~~ bash
curl -sS https://raw.githubusercontent.com/websafe/ffbx/master/ffbx.sh | bash
~~~~


Output bookmarks stored in `places.sqlite`:

~~~~ bash
ffbx.sh ~/.mozilla/firefox/41t52vmb.default/places.sqlite
~~~~


Output bookmarks from all `places.sqlite` files found
in `~/.mozilla/firefox` subdirectories. In this case
an additional column with the profile name is shown:

~~~~ bash
ffbx.sh
~~~~


Example on a new profile
------------------------

Testing on a new profile with one new bookmark added (the last one).


~~~~ bash
ffbx.sh ~/.mozilla/firefox/ffbx-example/places.sqlite
~~~~


the result:

~~~~
1475596075859000	1475596075857000	Bookmarks Toolbar	https://www.mozilla.org/en-US/firefox/central/	Getting Started	
1475596075862000	1475596075861000	Mozilla Firefox	https://www.mozilla.org/en-US/firefox/help/	Help and Tutorials	
1475596075863000	1475596075863000	Mozilla Firefox	https://www.mozilla.org/en-US/firefox/customize/	Customize Firefox	
1475596075865000	1475596075864000	Mozilla Firefox	https://www.mozilla.org/en-US/contribute/	Get Involved	
1475596075866000	1475596075866000	Mozilla Firefox	https://www.mozilla.org/en-US/about/	About Us	
1475596075945000	1475596075889000	Bookmarks Toolbar	place:sort=8&maxResults=10	Most Visited	
1475596075985000	1475596075949000	Bookmarks Menu	place:type=6&sort=14&maxResults=10	Recent Tags	
~~~~



Combining with PHP
------------------

### PHP arrays for each row:

~~~~ bash
ffbx.sh \
    ~/.mozilla/firefox/ffbx-example/places.sqlite \
    | php -r 'while(!feof(STDIN)){print_r(fgetcsv(STDIN,4096,"\t"));}'
~~~~


the result:

~~~~
Array
(
    [0] => 1475596075859000
    [1] => 1475596075857000
    [2] => Bookmarks Toolbar
    [3] => https://www.mozilla.org/en-US/firefox/central/
    [4] => Getting Started
    [5] => 
)
Array
(
    [0] => 1475596075862000
    [1] => 1475596075861000
    [2] => Mozilla Firefox
    [3] => https://www.mozilla.org/en-US/firefox/help/
    [4] => Help and Tutorials
    [5] => 
)
Array
(
    [0] => 1475596075863000
    [1] => 1475596075863000
    [2] => Mozilla Firefox
    [3] => https://www.mozilla.org/en-US/firefox/customize/
    [4] => Customize Firefox
    [5] => 
)
Array
(
    [0] => 1475596075865000
    [1] => 1475596075864000
    [2] => Mozilla Firefox
    [3] => https://www.mozilla.org/en-US/contribute/
    [4] => Get Involved
    [5] => 
)
Array
(
    [0] => 1475596075866000
    [1] => 1475596075866000
    [2] => Mozilla Firefox
    [3] => https://www.mozilla.org/en-US/about/
    [4] => About Us
    [5] => 
)
Array
(
    [0] => 1475596075945000
    [1] => 1475596075889000
    [2] => Bookmarks Toolbar
    [3] => place:sort=8&maxResults=10
    [4] => Most Visited
    [5] => 
)
Array
(
    [0] => 1475596075985000
    [1] => 1475596075949000
    [2] => Bookmarks Menu
    [3] => place:type=6&sort=14&maxResults=10
    [4] => Recent Tags
    [5] => 
)
~~~~



### JSON for each row:


~~~~ bash
ffbx.sh \
    ~/.mozilla/firefox/ffbx-example/places.sqlite \
    | php -r 'while(!feof(STDIN)){echo json_encode(fgetcsv(STDIN,4096,"\t")).PHP_EOL;}'
~~~~


the result:

~~~~
["1475596075859000","1475596075857000","Bookmarks Toolbar","https:\/\/www.mozilla.org\/en-US\/firefox\/central\/","Getting Started",""]
["1475596075862000","1475596075861000","Mozilla Firefox","https:\/\/www.mozilla.org\/en-US\/firefox\/help\/","Help and Tutorials",""]
["1475596075863000","1475596075863000","Mozilla Firefox","https:\/\/www.mozilla.org\/en-US\/firefox\/customize\/","Customize Firefox",""]
["1475596075865000","1475596075864000","Mozilla Firefox","https:\/\/www.mozilla.org\/en-US\/contribute\/","Get Involved",""]
["1475596075866000","1475596075866000","Mozilla Firefox","https:\/\/www.mozilla.org\/en-US\/about\/","About Us",""]
["1475596075945000","1475596075889000","Bookmarks Toolbar","place:sort=8&maxResults=10","Most Visited",""]
["1475596075985000","1475596075949000","Bookmarks Menu","place:type=6&sort=14&maxResults=10","Recent Tags",""]
false
~~~~
