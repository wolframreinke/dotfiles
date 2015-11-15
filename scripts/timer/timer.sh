if [ -z "${1}" ]; then
    echo "Exactly one argument required!" >&2
    exit 1
fi

case ${1} in
    *:*:*)
        while :; do
            sleep 1;
            current_time=$(date +%T)
            [ "${current_time}" == "${1}" ] && break
        done
        exit 0
        ;;
    *:*)
        while :; do
            sleep 1;
            current_time=$(date +%R)
            [ "${current_time}" == "${1}" ] && break
        done
        exit 0
        ;;
    *)
        utc_time=$(date +%s)
        let utc_time=${utc_time}+${1}
        target=$(date --date="@${utc_time}" +%T)
        while :; do
            sleep 1;
            current_time=$(date +%T)
            [ "${current_time}" == "${target}" ] && break
        done
        exit 0
        ;;
esac
