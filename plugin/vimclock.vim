" Name: vimclock.vim
" Author: @natsumesou

function! s:init()
    let bufname='[vimclock]'
    edit! `=bufname`
    setl bufhidden=delete
    setl nonumber
    let s:w = winwidth('%')
    let s:h = winheight('%')

    let s:num = {}
    let s:line      = repeat(' ', s:w/12-s:w/13)." ".repeat('#', s:w/5)." ".repeat(' ', s:w/12-s:w/13)
    let s:noLine    = repeat(' ', s:w/12-s:w/13)." ".repeat(' ', s:w/5)." ".repeat(' ', s:w/12-s:w/13)
    let s:rightLine = repeat(' ', s:w/12-s:w/13)." ".repeat(' ', s:w/5)."#".repeat(' ', s:w/12-s:w/13)
    let s:leftLine  = repeat(' ', s:w/12-s:w/13)."#".repeat(' ', s:w/5)." ".repeat(' ', s:w/12-s:w/13)
    let s:middle    = repeat(' ', s:w/12-s:w/13)."#".repeat(' ', s:w/5)."#".repeat(' ', s:w/12-s:w/13)
endfunction

function! s:createNumberString()
    for i in range(10)
        " head
        let s:num[i] = {}
        let lineNum = 0
        if i == 1
            let s:num[i][lineNum] = s:rightLine
        elseif i == 4
            let s:num[i][lineNum] = s:middle
        else
            let s:num[i][lineNum] = s:line
        endif
        let lineNum = lineNum + 1
        " head middle
        for j in range((s:h - 2) / 2 - 2)
            if i == 5 || i == 6
                let s:num[i][lineNum] = s:leftLine
            elseif i == 1 || i == 2 || i == 3
                let s:num[i][lineNum] = s:rightLine
            else
                let s:num[i][lineNum] = s:middle
            endif
            let lineNum = lineNum + 1
        endfor
        " middle
        if i == 0 || i == 1 || i == 7
            let s:num[i][lineNum] = s:noLine
        else
            let s:num[i][lineNum] = s:line
        endif
        let lineNum = lineNum + 1
        " middle bottom
        for j in range((s:h - 2) / 2 - 2)
            if i == 2
                let s:num[i][lineNum] = s:leftLine
            elseif i == 0 || i == 6 || i == 8
                let s:num[i][lineNum] = s:middle
            else
                let s:num[i][lineNum] = s:rightLine
            endif
            let lineNum = lineNum + 1
        endfor
        " bottom
        if i == 1 || i == 4 || i == 7 || i == 9
            let s:num[i][lineNum] = s:rightLine
        else
            let s:num[i][lineNum] = s:line
        endif
    endfor

    let s:colon = {}
    let span = (s:h - 2) / 10
    for i in range(s:h - 2)
        let s:colon[i] = repeat(" ", s:w/8-s:w/9 ? 1 : 0)
        if (i > span*3 && i <= span*3+2) || ( i > span*6 && i <= span*6+2)
            let s:colon[i] = s:colon[i].repeat("#", s:w/8-s:w/9)
        else
            let s:colon[i] = s:colon[i].repeat(" ", s:w/8-s:w/9)
        endif
        let s:colon[i] = s:colon[i].repeat(" ", s:w/8-s:w/9 ? 1 : 0)
    endfor
endfunction

function s:drawClock()
    let beforeMinutes = -1
    let flash = 1
    while 1
        let hours = strftime("%H")
        let hoursLeft = hours[0]
        let hoursRight = hours[1]
        let minutes = strftime("%M")
        let minutesLeft = minutes[0]
        let minutesRight = minutes[1]
        let seconds = strftime("%S")
        let secondsLeft = seconds[0]
        let secondsRight = seconds[1]

        setl modifiable
        if beforeMinutes != minutes
            execute "norm! ggdGggA\n\<Esc>"
            for i in range(len(keys(s:num[0])))
                execute "norm! A".s:num[hoursLeft][i].s:num[hoursRight][i].s:colon[i].s:num[minutesLeft][i].s:num[minutesRight][i]."\n\<Esc>j"
            endfor
            let beforeMinutes = minutes
        endif
        if s:showFlash
            if flash
                call setline(1, seconds)
                let flash = 0
            else
                call setline(1, ' ')
                let flash = 1
            endif
        endif
        setl nomodifiable
        setl nomodified

        redraw!
        sleep 500m
    endwhile
endfunction


function s:clock(...)
    let show = 1
    if a:0 >= 1
        let show = a:1 ? 1 : 0
    endif

    let s:showFlash = show
    call s:init()
    call s:createNumberString()
    call s:drawClock()
endfunction

command! -nargs=* Clock :call s:clock(<f-args>)

