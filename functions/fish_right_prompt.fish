function fish_right_prompt
    set -l layout (defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources 2>/dev/null | grep '"KeyboardLayout Name"' | sed 's/.*= //;s/;//')
    set -l color (set_color brblack)
    set -l normal (set_color normal)
    echo -n -s $color $layout $normal
end
