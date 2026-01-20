if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source

# Android SDK
set -Ux ANDROID_HOME $HOME/Android/Sdk
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path /home/thinkpad/.npm-global/bin/
set -gx ACTUAL_DATA_DIR $HOME/Program/ActualData/
