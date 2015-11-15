#! /bin/bash
# Short-Range Transit script by Wolfram Reinke and Nils Rohde (Spring 2014)

SRT_HOME=$HOME/scripts/shortrangeTransit

function index { head -n $1 | tail -n1 }

function printHelpMessage { cat ${SRT_HOME}/srt.help }

function printIfVerbose { [ "$QUIET" == false ] && echo $1; }

function main {

    # This file contains the saved favorite
    FAV_FILE=${SRT_HOME}/srt.fav

    local ORIGIN=undefined
    local DESTINATION=undefined
    local TIME=undefined
    local FAVORITE=false
    local QUIET=false
    local MODE=depart

    while [ $# -gt 0 ]; do

        CURRENT_OPT=$1
        shift

        case ${CURRENT_OPT} in

            -h|--help)
                printHelpMessage
                return 0 ;;

            -o|--origin)
                ORIGIN=$1
                shift
                if [ -z "${START}" ]; then
                    echo "-o/--origin requires an argument." >&2
                    exit 1
                fi;;

            -d|--destination)
                DESTINATION=$1
                shift
                if [ -z "${DESTINATION}" ]; then
                    echo "-d/--destination requires an argument." >&2
                    exit 1
                fi;;

            -t|--time)
                TIME=$1
                shift
                if [ -z "${TIME}" ]; then
                    echo "-t/--time requires an argument." >&2
                    exit 1
                fi
                echo "${TIME}" | grep -Pio '\d{2}:\d{2}' || {
                    echo "-t/--time's argument has to have format hh:mm." >&2;
                    exit 1; } 
                ;;


            -s|--departure) MODE=depart;;
            -a|--arrival)   MODE=arrive;;
            -f|--favorite)  FAVORITE=true;;
            -q|--quiet)     QUIET=true;;

            -r|--reset)
                rm "$FAV_FILE" 2> /dev/null \
                    && echo "Ihr Such-Favorit wurde gelöscht." \
                    || echo "Ihr Such-Favorit war bereits gelöscht." ;
                exit;;

            -*)
                echo "Unknown option $CURRENT_OPT" >&2
                exit 1;;

            *)
                echo "Dangling argument $CURRENT_OPT" >&2
                exit 1;;
        esac
    done

    if [ -z "${TIME}" ]; then
        TIME=$(date +%H:%M)
    fi

    if [ "${MODE}" == depart ]; then
        printIfVerbose "Departure time: ${TIME}"
    else
        printIfVerbose "Arrival time: ${TIME}"
    fi

    if ([ "${ORIGIN}" == undefined] || [ "${DESTINATION}" == undefined ]); then

        if [ -e ${FAV_FILE} ]; then
            DESTINATION=$(cat ${FAV_FILE} | index 1) || {
                echo "Your favorite couldn't be loaded." >&2;
                rm "${FAV_FILE}" > /dev/null 2>&1;
                exit 1;
            }
            ORIGIN=$(cat ${FAV_FILE} | index 2) || {
                echo "Your favorite couldn't be loaded." >&2;
                rm "${FAV_FILE}" > /dev/null 2>&1;
                exit 1;
            }
        else
            if [ ${ORIGIN} == undefined ]; then
                echo "A origin station is required." >&2
            fi
            if [ ${DESTINATION} == undefined ]; then
                echo "A destination station is required." >&2
            fi

            echo >&2
            printHelpMessage >&2
        fi
    fi

    if [ "${FAVORITE}" == true ]; then
        echo "${ORIGIN}"       > "${FAV_FILE}"
        echo "${DESTINATION}" >> "${FAV_FILE}"

        printIfVerbose "Your search has been saved as a favorite."
    fi

    # Replaces date's output with the german equivalents.
    CURRENT_DATE=$(date +%a%%2C+%d.%m.%g    \
                        | sed s/Tue/Di/     \
                        | sed s/Wed/Mi/     \
                        | sed s/Th/Do/      \
                        | sed s/Sat/Sa/     \
                        | sed s/Su/So/      \
                        | sed s/Mon/Mo/)

    # encodes the inputs by using URL-escape sequences
    local START=$(echo -n "${ORIGIN}"     \
            | perl -pe 's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg')
    local DEST=$(echo -n "${DESTINATION}" \
            | perl -pe 's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg')
    local TIME=$(echo -n "${TIME}"        \
            | perl -pe 's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg')


    URL="http://reiseauskunft.bahn.de/bin/query.exe/dn?revia=yes&existOptimize\
         Price=1&country=DEU&dbkanal_007=L01_S01_D001_KIN0001_qf-bahn_LZ003&ig\
         noreTypeCheck=yes&S=${ORIGIN}&REQ0JourneyStopsSID=&REQ0JourneyStopsS0\
         A=7&Z=${DESTINATION}&REQ0JourneyStopsZID=&REQ0JourneyStopsZ0A=7&trip-\
         type=single&date=${CURRENT_DATE}&time=${TIME}&timesel=${MODE}&returnT\
         imesel=depart&optimize=0&travelProfile=-1&adult-number=1&children-num\
         ber=0&infant-number=0&tariffTravellerType.1=E&tariffTravellerReductio\
         nClass.1=0&tariffTravellerAge.1=&qf-trav-bday-1=&tariffTravellerReduc\
         tionClass.2=0&tariffTravellerReductionClass.3=0&tariffTravellerReduct\
         ionClass.4=0&tariffTravellerReductionClass.5=0&tariffClass=2&start=1&\
         qf.bahn.button.suchen="

    printIfVerbose "Your request is processed..."
    printIfVerbose ""

    HTML_FILE=/tmp/srt.html
    wget -O ${HTML_FILE} "${URL}" 2> /dev/null || {
        echo "The required data couldn't be loaded." 1>&2;
        exit 1
    }

    if [ -z "$(grep -Pzio '(?<=<div class=\"resultDep\">\n)(.*?)(?=\n</div>)' \
            ${HTML_FILE})" ]; then
        echo -e "There are no hits for your search."
        exit
    fi

    printf "%-40s %-40s %-15s %-15s %-8s %-20s \n"  \
                "Origin"                            \
                "Destination"                       \
                "Departure"                         \
                "Arrival"                           \
                "Duration"                          \
                "Provider"

    # Prints a vertical line
    printf '-%.0s' {1..137}

    COUNT=3
    TI=1

    for I in $(seq ${COUNT}); do

        S_START=$(grep -Pzio '(?<=p">\n).+?(?=\n)' ${HTML_FILE} | index $I)
        S_DEST=$(grep -Pzio 'ter".*?>\n\K.+?(?=\n</)' ${HTML_FILE} | index $I)
        DURATION=$(grep -Pzio '2">\n?\K\d+:\d+(?=\n?<)' ${HTML_FILE} | index $I)
        PROVIDER=$(grep -Pzio 'lastrow".*?>\n?\K[A-Z, ]+?(?=\n?<)' ${HTML_FILE}\
                | index $I);

        # Die Abfahrtszeit greppen
        DTIME=$(grep -Pzio 'e".*?>\n?\K\d+:\d+(?=\n?.*?<)' ${HTML_FILE} \
             | index ${TI});

        # Auf der DB-Seite werden auch die Verspätungen angezeigt. Diese fangen
        # mit + oder - an und werden hier ausgefiltert
        if ([ ${DTIME:0:1} = + ] || [ ${DTIME:0:1} = - ]); then

          # Zeit neu laden, da sonst die Verspätungen statt der Zeit ausgegeben
          # würde. Der nächste Treffer von grep ist garantiert keine
          # Verspätungsangabe mehr, die kommen immer abwechselnd
          let TI=${TI}+1;
          DTIME=$(grep -Pzio 'e".*?>\n?\K\d+:\d+(?=\n?.*?<)' ${HTML_FILE} \
              | index $TI);
        fi

        # Zähler hochzählen für die Ankunftszeit
        let TI=${TI}+1

        # Die Ankunftszeit greppen
        ATIME=$(grep -Pzio 'e".*?>\n?\K\d+:\d+(?=\n?.*?<)' ${HTML_FILE} \
            | index ${TI});

        # Auf der DB-Seite werden auch die Verspätungen angezeigt. Diese fangen mit + oder - an und
        # werden hier ausgefiltert
        if ([ ${ATIME:0:1} = "+" ] || [ ${ATIME:0:1} = "-" ])
        then
          # Und wieder die Zeit neu laden.
          let TI=${TI}+1;
          ATIME=$(grep -Pzio 'e".*?>\n?\K\d+:\d+(?=\n?.*?<)' ${HTML_FILE} \
              | index  ${TI});
        fi

        # Zähler für den nächsten Schleifendurchlauf hochzählen
        let TI=${TI}+1

        # Die geladenen Werte können nocht HTML-Tags und HTML-Codes enthalten. Diese werden hiermit entfernt
        S_START=$(echo "${S_START}" | w3m -dump -T text/html)
        S_DEST=$(echo "${S_DEST}"   | w3m -dump -T text/html)
        PROVIDER=$(echo "$PROVIDER" | w3m -dump -T text/html)

        # Die grade geladene Reisemöglichkeit ausgeben
        printf "%-40s %-40s %-15s %-15s %-8s %-20s" "${S_START}"  \
                                                    "${S_DEST}"   \
                                                    "${DTIME}"    \
                                                    "${ATIME}"    \
                                                    "${DURATION}" \
                                                    "${PROVIDER}"
        echo ""
    done

    # Leerzeile ausgeben und temporäre Datei wieder löschen
    echo ""
    rm $HTML_FILE
}

main $@
