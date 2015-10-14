ffbx - Firefox bookmarks extractor
==================================

Simple Bash script using sqlite3 for extracting bookmarks from
`places.sqlite` found in Firefox user profiles.


Bookmarks are extracted with:

 + timestamp of last modification,
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
1391725993809844        Bookmarks Toolbar       https://www.mozilla.org/en-US/firefox/central/  Getting Started
1391725993811277        Mozilla Firefox https://www.mozilla.org/en-US/firefox/help/     Help and Tutorials
1391725993812029        Mozilla Firefox https://www.mozilla.org/en-US/firefox/customize/        Customize Firefox
1391725993812829        Mozilla Firefox https://www.mozilla.org/en-US/contribute/       Get Involved
1391725993813492        Mozilla Firefox https://www.mozilla.org/en-US/about/    About Us
1391725993870487        Bookmarks Toolbar       place:sort=8&maxResults=10      Most Visited
1391725993870988        Bookmarks Menu  place:folder=BOOKMARKS_MENU&folder=UNFILED_BOOKMARKS&folder=TOOLBAR&queryType=1&sort=12&maxResults=10&excludeQueries=1  Recently Bookmarked
1391725993871436        Bookmarks Menu  place:type=6&sort=14&maxResults=10      Recent Tags
1391726063106065        Unsorted Bookmarks      https://github.com/websafe/ffbx websafe/ffbx · GitHub   Firefox,bookmarks,extract,Bash,script,SQLite
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
    [0] => 1391725993809844
    [1] => Bookmarks Toolbar
    [2] => https://www.mozilla.org/en-US/firefox/central/
    [3] => Getting Started
    [4] => 
)
Array
(
    [0] => 1391725993811277
    [1] => Mozilla Firefox
    [2] => https://www.mozilla.org/en-US/firefox/help/
    [3] => Help and Tutorials
    [4] => 
)
Array
(
    [0] => 1391725993812029
    [1] => Mozilla Firefox
    [2] => https://www.mozilla.org/en-US/firefox/customize/
    [3] => Customize Firefox
    [4] => 
)
Array
(
    [0] => 1391725993812829
    [1] => Mozilla Firefox
    [2] => https://www.mozilla.org/en-US/contribute/
    [3] => Get Involved
    [4] => 
)
Array
(
    [0] => 1391725993813492
    [1] => Mozilla Firefox
    [2] => https://www.mozilla.org/en-US/about/
    [3] => About Us
    [4] => 
)
Array
(
    [0] => 1391725993870487
    [1] => Bookmarks Toolbar
    [2] => place:sort=8&maxResults=10
    [3] => Most Visited
    [4] => 
)
Array
(
    [0] => 1391725993870988
    [1] => Bookmarks Menu
    [2] => place:folder=BOOKMARKS_MENU&folder=UNFILED_BOOKMARKS&folder=TOOLBAR&queryType=1&sort=12&maxResults=10&excludeQueries=1
    [3] => Recently Bookmarked
    [4] => 
)
Array
(
    [0] => 1391725993871436
    [1] => Bookmarks Menu
    [2] => place:type=6&sort=14&maxResults=10
    [3] => Recent Tags
    [4] => 
)
Array
(
    [0] => 1391726063106065
    [1] => Unsorted Bookmarks
    [2] => https://github.com/websafe/ffbx
    [3] => websafe/ffbx · GitHub
    [4] => Firefox,bookmarks,extract,Bash,script,SQLite,
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
["1391725993809844","Bookmarks Toolbar","https:\/\/www.mozilla.org\/en-US\/firefox\/central\/","Getting Started",""]
["1391725993811277","Mozilla Firefox","https:\/\/www.mozilla.org\/en-US\/firefox\/help\/","Help and Tutorials",""]
["1391725993812029","Mozilla Firefox","https:\/\/www.mozilla.org\/en-US\/firefox\/customize\/","Customize Firefox",""]
["1391725993812829","Mozilla Firefox","https:\/\/www.mozilla.org\/en-US\/contribute\/","Get Involved",""]
["1391725993813492","Mozilla Firefox","https:\/\/www.mozilla.org\/en-US\/about\/","About Us",""]
["1391725993870487","Bookmarks Toolbar","place:sort=8&maxResults=10","Most Visited",""]
["1391725993870988","Bookmarks Menu","place:folder=BOOKMARKS_MENU&folder=UNFILED_BOOKMARKS&folder=TOOLBAR&queryType=1&sort=12&maxResults=10&excludeQueries=1","Recently Bookmarked",""]
["1391725993871436","Bookmarks Menu","place:type=6&sort=14&maxResults=10","Recent Tags",""]
["1391726063106065","Unsorted Bookmarks","https:\/\/github.com\/websafe\/ffbx","websafe\/ffbx \u00b7 GitHub","Firefox,bookmarks,extract,Bash,script,SQLite,"]
false
~~~~
