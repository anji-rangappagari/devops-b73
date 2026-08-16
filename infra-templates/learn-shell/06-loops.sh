# loops 

a=10
while [ $a -gt 0 ]; do
    echo "hello world"
    a=$((a-1))
    sleep 1
done


for component in frontend catalogue cart user shipping payment mysql rabbitmq redis; do
    echo "creating component: $component"
done
