#! /bin/bash
# ----------------------------------------------------------------------------
# File    : map.sh
# Author  : Wolfram Reinke
# Created : 04/21/15
# ----------------------------------------------------------------------------
#
# Map (I mean the associative container, not the similarily called ubiquitous
# function) implementation for bash shell scripts.
#
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# FUNCTION map_put( map, key, value )
#
# Adds the key-value pair to the map. This function does not check whether
# the pair is already in the list. If it is, map_get will return the old value
# and not the new one.
# ----------------------------------------------------------------------------
function map_put
{
        local MAP="$1"
        local KEY="$2"
        local VALUE="$3"

        echo "${MAP},${KEY}:${VALUE}"
}

# ----------------------------------------------------------------------------
# FUNCTION map_get( map, key, default )
#
# Returns the value associated with "key" in the "map" or "default" if this
# key does not exist in the map.
# ----------------------------------------------------------------------------
function map_get
{
        local MAP="$1"
        local KEY="$2"

        local OLD_IFS="$IFS"
        IFS=$'\n'
        for KVPAIR in $(echo "${MAP}" | tr ',' '\n')
        do
                local CURRENT_KEY="$(echo ${KVPAIR} | tr ':' '\n' | head -1)"
                local CURRENT_VAL="$(echo ${KVPAIR} | tr ':' '\n' | tail -1)"

                if [ "${KEY}" == "${CURRENT_KEY}" ]
                then
                        echo "${CURRENT_VAL}"
                        IFS="$OLD_IFS"
                        return 0
                fi
        done

        IFS="$OLD_IFS"
        echo "$3"
        return 0
}
