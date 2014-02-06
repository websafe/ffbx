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


Output bookmarks found in `places.sqlite`:

~~~~ bash
ffbx ~/.mozilla/firefox/41t52vmb.default/places.sqlite
~~~~


Output bookmarks from all `places.sqlite` files found
in `~/.mozilla/firefox` subdirectories. In this case
an additional column with the profile name is shown:

~~~~ bash
ffbx
~~~~

