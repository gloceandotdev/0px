function fish_prompt --description 'Two-line bracketed prompt, Meadow'
    set -l last_status $status

    # Meadow / Meadow Light. switch-theme.sh sets $rice_theme to dark or light
    if test "$rice_theme" = light
        set -f c_frame a9a0b4 # dim
        set -f c_user 352c3f # text
        set -f c_time 5f828b # dew
        set -f c_cwd 6a7c9d # cornflower
        set -f c_git 807597 # lavender
        set -f c_ok 6e8272 # sage
        set -f c_err a56260 # poppy
    else
        set -f c_frame 5f5769
        set -f c_user ebe7f0
        set -f c_time 84c7d5
        set -f c_cwd 9cb8eb
        set -f c_git c1b0e7
        set -f c_ok a4bba9
        set -f c_err d68583
    end

    set -l frame (set_color $c_frame)
    set -l reset (set_color normal)

    # Git branch, starred when the tree is dirty
    set -l git_seg
    set -l branch (git symbolic-ref --short -q HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
    if test -n "$branch"
        test -n "$(git status --porcelain 2>/dev/null | head -n 1)"; and set branch "$branch*"
        set git_seg "$frame-["(set_color $c_git)"$branch$frame]"
    end

    # $ normally, # as root, poppy when the last command failed
    set -l sigil '$'
    set -l c_sigil $c_ok
    test (id -u) -eq 0; and set sigil '#'
    test $last_status -ne 0; and set c_sigil $c_err

    # Blank line between commands, but not before the first prompt
    set -q __rice_prompt_shown; and echo
    set -g __rice_prompt_shown 1

    echo -s $frame '┌─[' (set_color $c_user) $USER $frame ']-[' (set_color $c_time) (date +%H:%M) $frame ']'
    echo -s $frame '└─[' (set_color $c_cwd) (prompt_pwd --dir-length 0) $frame ']' $git_seg $frame '-[' (set_color $c_sigil) $sigil $frame ']-> ' $reset
end
