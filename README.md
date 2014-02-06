ffbx - Firefox bookmarks extractor
==================================

Simple Bash script using sqlite3 for extracting bookmarks from
`places.sqlite` found in Firefox user profiles.


Bookmarks are extracted with:

    + timestamp of last modification,
    + folder,
    + url,
    + title,
    + tags.



Usage
-----

~~~~ bash
ffbx ~/.mozilla/firefox/41t52vmb.default/places.sqlite
~~~~

