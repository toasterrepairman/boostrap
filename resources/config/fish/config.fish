# ~/.config/fish/config.fish

function fish_greeting
    echo The time is (set_color yellow; date +%T; set_color normal) and this machine is called $hostname
end