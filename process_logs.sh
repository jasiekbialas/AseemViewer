FILE=$1
DOCKER_ID=$(docker ps -aqf "name=aseem_aseem")

docker cp "${DOCKER_ID}:/root/dev/aseem/apps/output/fmLog.log" data
mkdir "data/${FILE}"
sed '/BookingRequest/d' "data/fmLog.log" > "data/${FILE}/logs.v"
sed '/BookingRequest/p' "data/fmLog.log" > "data/${FILE}/logs.r"
rm data/fmLog.log
