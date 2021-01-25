FILE=$1
xwininfo -name AseemViewer | grep Width: | grep -o -e "[0-9]*" > "data/${FILE}/size"
xwininfo -name AseemViewer | grep Height: | grep -o -e "[0-9]*" >> "data/${FILE}/size"
xwininfo -name AseemViewer | grep "Absolute upper-left X" | grep -o -e "[0-9]*" >> "data/${FILE}/size"
xwininfo -name AseemViewer | grep "Absolute upper-left Y" | grep -o -e "[0-9]*" >> "data/${FILE}/size"

