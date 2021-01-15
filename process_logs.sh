FILE=$1

mkdir "data/${FILE}"
sed '/BookingRequest/d' "data/fmLog.log" > "data/${FILE}/logs.v"
sed '/BookingRequest/p' "data/fmLog.log" > "data/${FILE}/logs.r"
