function fish_prompt --description 'Two-line bracketed prompt, Rosé Pine'
    set -l last_status $status

    # Rosé Pine main / dawn. switch-theme.sh sets $rice_theme to dark or light
    if test "$rice_theme" = light
        set -f c_frame 9893a5 # muted
        set -f c_user 575279 # text
        set -f c_time 56949f # foam
        set -f c_cwd 286983 # pine
        set -f c_git 907aa9 # iris
        set -f c_ok ea9d34 # gold
        set -f c_err b4637a # love
    else
        set -f c_frame 6e6a86
        set -f c_user e0def4
        set -f c_time 9ccfd8
        set -f c_cwd 31748f
        set -f c_git c4a7e7
        set -f c_ok f6c177
        set -f c_err eb6f92
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

    # $ normally, # as root, love when the last command failed
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
