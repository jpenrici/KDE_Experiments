#!/bin/bash
# Optional script to help install and test the plugin.

local="$HOME/.local/share/plasma/plasmoids"
url="com.plasmaplugin.jpenrici.simpleMemoryViewer"

filesList=( \
"package/contents/config/config.qml"        \
"package/contents/config/main.xml"          \
"package/contents/ui/configGeneral.qml"     \
"package/contents/ui/main.qml"              \
"package/metadata.json"                     \
)

today=$(date +%Y-%m-%d)
log="log-install-$today"

# Check if the environment is KDE Plasma.
echo "Started [ $(date '+%Y-%m-%d %H:%M:%S') ]." | tee "$log"
if [[ $DESKTOP_SESSION == "plasma" ]]; then
    echo "Desktop Session [$DESKTOP_SESSION]: ok!" | tee -a "$log"
else
    echo "Desktop Session [$DESKTOP_SESSION]: error, plugin not recommended for this environment!" | tee -a "$log"
    exit 0
fi

# Check required shell command.
if [[ ! -f "/usr/bin/free" ]]; then
    echo "Error [Shell command not found]: \"free\", required to read the memory status!" | tee -a "$log"
    exit 1
fi

# Check package.
for item in "${filesList[@]}"; do
    if [[ -f "$item" ]]; then
        echo "Path [$item]: ok!" | tee -a "$log"
    else
        echo "Error [$item not found]: stop!" | tee -a "$log"
        exit 1
    fi
done

# Check if the home/user/.local/plasma/plasmoids directory exists.
if [[ ! -d $local ]]; then
    echo "Error [Directory not found]: $local" | tee -a "$log"
    echo "Create: $local" | tee -a "$log"
    mkdir -p "$local"
fi

#rm -rfv "$local/$url" # Temporary. Test only!

# Check if the plugin is installed in ./local/plasma/plasmoids
if [[ ! -d "$local/$url" ]]; then
    echo "Error [Plugin not found]: $url" | tee -a "$log"
    echo "Create: $url" | tee -a "$log"
    mkdir -p "$local/$url"
    cp -r "./LICENSES" "$local/$url"
    cp -r "./package/contents" "$local/$url"
    cp "./package/metadata.json" "$local/$url"
fi

# Check if the plasmawindowded application exists.
if [[ -f "/usr/bin/plasmawindowed" ]]; then
    echo "Test with plasmawindowed ..."
    plasmawindowed "$url"
else
    echo "Error [plasmawindowed not found] : required \"plasma-workspace plasma-sdk\" to test!" | tee -a "$log"
fi

echo "Finished [ $(date '+%Y-%m-%d %H:%M:%S') ]." | tee -a "$log"
exit 0
