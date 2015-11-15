
let b:TMUXRefreshCycle      = []
let b:TMUXRefreshCycleIndex = -1
let b:TMUXRefreshActivated  = 0

function! TMUXRefresh_Activate()
    let b:TMUXRefreshActivated = 1
endfunction

function! TMUXRefresh_Cycle()
    if len(b:TMUXRefreshCycle) > 0 && b:TMUXRefreshActivated == 1

        let b:TMUXRefreshCycleIndex = b:TMUXRefreshCycleIndex + 1

        if b:TMUXRefreshCycleIndex >= len(b:TMUXRefreshCycle)
            let b:TMUXRefreshCycleIndex = -1
            echo 'TMUX refreshing DEACTIVATED.'
        else
            echo b:TMUXRefreshCycle[b:TMUXRefreshCycleIndex][1] . ' ACTIVATED.'
        endif

    endif
endfunction


function! TMUXRefresh_Refresh()
    if b:TMUXRefreshActivated == 1

        if len(b:TMUXRefreshCycle) > 0 && b:TMUXRefreshCycleIndex >= 0
            let l:cmd = b:TMUXRefreshCycle[b:TMUXRefreshCycleIndex][0]
            call feedkeys(':SlimeSend1 ' . cmd . '', 'n')
        endif
    endif
endfunction
