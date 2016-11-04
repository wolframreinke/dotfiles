testdir="$(dirname $(readlink -f ${0}))"
testcnt=1

if [ ! -z "${1}" ]; then
    new="${1}"
else
    new=new
fi

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Date: $(date)"
echo "User: $(whoami)"
echo "Unit: ${new}"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo

fail() {
    printf -v num "%03d" ${testcnt}
    echo "[${num}] failed: ${1}" >&2
    exit 1
}

pass() {
    printf -v num "%03d" ${testcnt}
    echo "[${num}] passed." >&2
    let testcnt=${testcnt}+1
}

assertequal() {
    if [ "${1}" == "${2}" ]; then
        pass
    else
        printf -v num "%03d" ${testcnt}
        echo "[${num}] failed, expected '${1}'," >&2
        echo "[${num}]         but got  '${2}'," >&2
        exit 1
    fi
}

old_pwd=$(pwd)
cleanup() {
    cd ${old_pwd}
}
trap cleanup EXIT
cd ${HOME}/tmp


output=$(echo -en "unittest\n\n" | ${new} nasm module)
assertequal "module > author (default: Wolfram Reinke) > "  "${output}"
[ -e "unittest.asm" ] && pass || fail "unittest.h not created."
diff ${testdir}/unittest.asm unittest.asm >/dev/null 2>&1 && pass || {
    diff -y ${testdir}/unittest.asm unittest.asm
    fail "contents of unittest.asm incorrect."
}


output=$(${new} nasm module unittest)
[ -z "${output}" ]    && pass || fail "batch output not interactive."
[ -e "unittest.asm" ] && pass || fail "unittest.h not created."
diff ${testdir}/unittest.asm unittest.asm >/dev/null 2>&1 && pass || {
    diff -y ${testdir}/unittest.asm unittest.asm
    fail "contents of unittest.asm incorrect."
}


output=$(${new} c makefile unittest src)
[ -z "${output}" ] && pass || fail "was interactive despite saturated inputs"
[ -e "Makefile"  ] && pass || fail "Makefile not created."
diff ${testdir}/Makefile Makefile >/dev/null 2>&1 && pass || {
    diff -y ${testdir}/Makefile Makefile
    fail "contents of Makefile incorrect"
}
