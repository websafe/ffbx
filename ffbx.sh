#!/bin/bash
# ffbx.sh - Firefox bookmarks extractor - extract bookmarks from user profiles.
# Copyright (C) 2014-2015 Thomas Szteliga <ts@websafe.pl>, <https://websafe.pl/>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# ------------------------------------------------------------------------------

IFS="
"

#
CMD_CUT=${CMD_CUT:-/bin/cut}
CMD_FIND=${CMD_FIND:-/usr/bin/find}
CMD_SQLITE3=${CMD_SQLITE3:-/usr/bin/sqlite3}
CMD_TR=${CMD_TR:-/bin/tr}
CMD_UNIQ=${CMD_UNIQ:-/bin/uniq}

# 
FFBX_FIELD_SEPARATOR=${FFBX_FIELD_SEPARATOR:-"\t"}
FFBX_ROW_SEPARATOR=${FFBX_ROW_SEPARATOR:-"\n"}
FFBX_ITEM_SEPARATOR=${FFBX_ITEM_SEPARATOR:-","}

# ------------------------------------------------------------------------------

#
#
#
function debug() {
    if [ "${DEBUG}" = "1" ];
    then
        local msg="${*}"
        echo "DEBUG: $msg"
    fi
}

# ------------------------------------------------------------------------------

#
if [ -z "${1}" ];
then
    #
    found_db_places_paths=$(
        #
        ${CMD_FIND} ~/.mozilla/firefox/ \
            -type f \
            -name "places.sqlite" \
            -mindepth 2 \
            -maxdepth 2 \
            2>/dev/null
    )
    #
    if [ -z "${found_db_places_paths}" ];
    then
        echo "No places.sqlite path given and none could be found."
        exit 1
    else
        db_places_paths_were_autodiscovered="yes"
    fi
else
    #
    if [ ! -r "${1}" ];
    then
        echo "Profile path is not readable."
        exit 2
    else
        found_db_places_paths="${1}"
        db_places_paths_were_autodiscovered="no"
    fi
fi

debug "found_db_places_paths ${found_db_places_paths}"
debug "db_places_paths_were_autodiscovered" \
        "${db_places_paths_were_autodiscovered}"

# ------------------------------------------------------------------------------

#
for db_places_path in ${found_db_places_paths};
do

    profile_path=$(dirname "${db_places_path}")
    profile_name=$(basename "${profile_path}")

    # Retrieve list of bookmarks data with lastModified timestamp
    bookmarks_data=$(
        ${CMD_SQLITE3} "${db_places_path}" \
        "SELECT lastModified,fk FROM moz_bookmarks
            WHERE type=1 ORDER BY lastModified"
    )

    # Filter the obtained list for distinct places ids ordered
    # by lastModified timestamp:
    bookmarks_places_ids=$(
        echo "${bookmarks_data}" \
            | ${CMD_CUT} -d'|' -f2 \
            | ${CMD_UNIQ}
    )

    debug "bookmarks_places_ids ${bookmarks_places_ids}"

    #
    for bookmark_places_id in ${bookmarks_places_ids};
    do

        debug "bookmark_places_id ${bookmark_places_id}"

        # Retrieve the bookmark URL:
        bookmark_url=$(
            ${CMD_SQLITE3} "${db_places_path}" \
                "SELECT url FROM moz_places
                    WHERE id=${bookmark_places_id}" \
                | ${CMD_TR} -d "\n" \
                | ${CMD_TR} -d "\r"
        )

        debug "bookmark_url ${bookmark_url}"

        # Retrieve ids of tags assigned to the current bookmark:
        bookmark_tags_ids=$(
            ${CMD_SQLITE3} "${db_places_path}" \
                "SELECT parent FROM moz_bookmarks
                    WHERE fk=${bookmark_places_id} AND title IS NULL"
        )

        debug "bookmark_tags_ids ${bookmark_tags_ids}"

        # Retrieve comma-separated list of tags assigned to the current
        # bookmark:
        bookmark_tags=$(
            for bookmark_tag_id in ${bookmark_tags_ids};
            do
                ${CMD_SQLITE3} "${db_places_path}" \
                    "SELECT title FROM moz_bookmarks
                        WHERE id=${bookmark_tag_id}"
            done \
                | ${CMD_TR} "\n" "${FFBX_ITEM_SEPARATOR}"
        )

        debug "bookmark_tags ${bookmark_tags}"

        # Retrieve the title:
        bookmark_title=$(
            ${CMD_SQLITE3} "${db_places_path}" \
                "SELECT title FROM moz_bookmarks
                    WHERE fk=${bookmark_places_id} AND title!='' LIMIT 1"
        )

        debug "bookmark_title ${bookmark_title}"

        # Retrieve last modification timestamp for the current bookmark:
        bookmark_last_modification=$(
            ${CMD_SQLITE3} "${db_places_path}" \
                "SELECT lastModified FROM moz_bookmarks
                    WHERE fk=${bookmark_places_id} 
                    ORDER BY lastModified DESC LIMIT 1"
        )

        debug "bookmark_last_modification ${bookmark_last_modification}"

        # Retrieve id of current bookmarks parent folder:
        bookmark_folder_id=$(
            ${CMD_SQLITE3} "${db_places_path}" \
                "SELECT parent FROM moz_bookmarks
                    WHERE type=1 AND fk=${bookmark_places_id}
                    ORDER BY id ASC LIMIT 1"
        )

        debug "bookmark_folder_id ${bookmark_folder_id}"

        # Retrieve the name of current bookmarks parent folder:
        bookmark_folder_name=$(
            ${CMD_SQLITE3} "${db_places_path}" \
                "SELECT title FROM moz_bookmarks
                    WHERE id=${bookmark_folder_id}"
        )

        debug "bookmark_folder_name ${bookmark_folder_name}"

        # Output CSV data:
        echo -ne "${bookmark_last_modification}"
        if [ "${db_places_paths_were_autodiscovered}" = "yes" ];
        then
            echo -ne "${FFBX_FIELD_SEPARATOR}"
            echo -n "${profile_name}" | ${CMD_TR} "\t" " "
        fi
        #echo -ne "${FFBX_FIELD_SEPARATOR}"
        #echo -n "${profile_path}"
        #echo -ne "${FFBX_FIELD_SEPARATOR}"
        #echo -n "${bookmark_places_id}"
        echo -ne "${FFBX_FIELD_SEPARATOR}"
        echo -n "${bookmark_folder_name}" | ${CMD_TR} "\t" " "
        echo -ne "${FFBX_FIELD_SEPARATOR}"
        echo -n "${bookmark_url}" | ${CMD_TR} "\t" " "
        echo -ne "${FFBX_FIELD_SEPARATOR}"
        echo -n "${bookmark_title}" | ${CMD_TR} "\t" " "
        echo -ne "${FFBX_FIELD_SEPARATOR}"
        echo -n "${bookmark_tags}" | ${CMD_TR} "\t" " "
        echo -ne "${FFBX_ROW_SEPARATOR}"
    done
done
