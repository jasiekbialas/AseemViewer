xwininfo -name AseemViewer | grep Width: | grep -o -e "[0-9]*" 
xwininfo -name AseemViewer | grep Height: | grep -o -e "[0-9]*"
X=$(xwininfo -name AseemViewer | grep "Absolute upper-left X" | grep -o -e "[0-9]*") 
Y=$(xwininfo -name AseemViewer | grep "Absolute upper-left Y" | grep -o -e "[0-9]*")
x=$(xwininfo -name AseemViewer | grep "Relative upper-left X" | grep -o -e "[0-9]*") 
y=$(xwininfo -name AseemViewer | grep "Relative upper-left Y" | grep -o -e "[0-9]*")
echo $X

echo `expr $Y - $y`
