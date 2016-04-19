__insert_bm ()
{
    LINE=${READLINE_LINE:0:$READLINE_POINT}
    REST=${READLINE_LINE:$READLINE_POINT}
    WORD=$(echo ${LINE} | grep -Po '(?<=[^a-zA-Z0-9_])[a-zA-Z0-9_]*$' | tail -1)

    LEN=$(echo ${WORD} | wc -c)
    let NEW_END=$READLINE_POINT-$LEN+1
    NEW_LINE="$(echo ${READLINE_LINE:0:$NEW_END}$(bm -p ${WORD}))"
    NEW_LEN="$(echo ${NEW_LINE} | wc -c)"
    let NEW_LEN=$NEW_LEN-1

    READLINE_LINE="${NEW_LINE}${REST}"
    READLINE_POINT=${NEW_LEN}
}

bind -x '"\C-x\C-b": __insert_bm'
