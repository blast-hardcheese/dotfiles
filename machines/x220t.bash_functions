fprintd-enroll-all() {
    for FINGER in left-thumb left-index-finger left-middle-finger left-ring-finger left-little-finger right-thumb right-index-finger right-middle-finger right-ring-finger right-little-finger; do
        fprintd-list $USER | grep $FINGER > /dev/null
        EXISTS=$?
        if [[ $EXISTS == 0 ]]; then
            echo "$FINGER already enrolled for user $USER, skipping"
        else
            fprintd-enroll -f $FINGER
        fi
    done
}

xsetwacom-all() {
    OPT=$1
    shift
    xsetwacom $OPT "Wacom ISDv4 E6 Finger touch" $@
    xsetwacom $OPT "Wacom ISDv4 E6 Pen stylus" $@
    xsetwacom $OPT "Wacom ISDv4 E6 Pen eraser" $@
}

reset_touchscreen() {
    xsetwacom-all --set MapToOutput LVDS1
    xrandr --output LVDS1 --auto
}
