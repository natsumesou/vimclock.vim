let bufname='[vimclock]'
edit! `=bufname`
setl bufhidden=delete
let s:w = winwidth('%')
let s:h = winheight('%')
setl modifiable
setl paste
let num = {}

let line      = repeat(" ", s:w/8 - s:w/9)." ".repeat('#', s:w/4-s:w/12)." ".repeat(" ", s:w/8 - s:w/9)
let noLine    = repeat(" ", s:w/8 - s:w/9)." ".repeat(' ', s:w/4-s:w/12)." ".repeat(" ", s:w/8 - s:w/9)
let rightLine = repeat(" ", s:w/8 - s:w/9)." ".repeat(' ', s:w/4-s:w/12)."#".repeat(" ", s:w/8 - s:w/9)
let leftLine  = repeat(" ", s:w/8 - s:w/9)."#".repeat(' ', s:w/4-s:w/12)." ".repeat(" ", s:w/8 - s:w/9)
let middle    = repeat(" ", s:w/8 - s:w/9)."#".repeat(' ', s:w/4-s:w/12)."#".repeat(" ", s:w/8 - s:w/9)

for i in range(10)
    " head
    let num[i] = {}
    let lineNum = 0
    if i == 1
        let num[i][lineNum] = rightLine
    elseif i == 4
        let num[i][lineNum] = middle
    else
        let num[i][lineNum] = line
    endif
    let lineNum = lineNum + 1
    " head middle
    for j in range((s:h - 2) / 2 - 2)
        if i == 5 || i == 6
            let num[i][lineNum] = leftLine
        elseif i == 1 || i == 2 || i == 3
            let num[i][lineNum] = rightLine
        else
            let num[i][lineNum] = middle
        endif
        let lineNum = lineNum + 1
    endfor
    " middle
    if i == 0 || i == 1 || i == 7
        let num[i][lineNum] = noLine
    else
        let num[i][lineNum] = line
    endif
    let lineNum = lineNum + 1
    " middle bottom
    for j in range((s:h - 2) / 2 - 2)
        if i == 2
            let num[i][lineNum] = leftLine
        elseif i == 0 || i == 6 || i == 8
            let num[i][lineNum] = middle
        else
            let num[i][lineNum] = rightLine
        endif
        let lineNum = lineNum + 1
    endfor
    " bottom
    if i == 1 || i == 4 || i == 7 || i == 9
        let num[i][lineNum] = rightLine
    else
        let num[i][lineNum] = line
    endif
endfor

let colon = {}
let span = (s:h - 2) / 10
for i in range(s:h - 2)
    let colon[i] = repeat(" ", s:w/12 - s:w/13)
    if (i > span*3 && i <= span*3+2) || ( i > span*6 && i <= span*6+2)
        let colon[i] = colon[i].repeat("#", s:w/8-s:w/9)
    else
        let colon[i] = colon[i].repeat(" ", s:w/8-s:w/9)
    endif
    let colon[i] = colon[i].repeat(" ", s:w/12 - s:w/13)
endfor

let beforeMinutes = -1
let flash = 1
while 1
    setl modifiable
    let hours = strftime("%H")
    let hoursLeft = hours[0]
    let hoursRight = hours[1]
    let minutes = strftime("%M")
    let minutesLeft = minutes[0]
    let minutesRight = minutes[1]
    let seconds = strftime("%S")
    let secondsLeft = seconds[0]
    let secondsRight = seconds[1]

    if beforeMinutes != minutes
        execute "norm! ggdGggA\n\<Esc>"
        for i in range(len(keys(num[0])))
            execute "norm! A".num[hoursLeft][i].num[hoursRight][i].colon[i].num[minutesLeft][i].num[minutesRight][i]."\n\<Esc>j"
        endfor
        let beforeMinutes = minutes
    endif
    if flash
        call setline(1, seconds)
        let flash = 0
    else
        call setline(1, ' ')
        let flash = 1
    endif

    setl nomodifiable
    setl nomodified
    redraw!
    sleep 500m
endwhile
