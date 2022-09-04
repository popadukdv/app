#!/bin/bash
nginx -g 'daemon off;' & 

data=""
#Add metric to JSON file
    # $1 - name of parametr
    # $2 - value of parametr
add_metric() {
    data=${data::-1}
    
    if [ ${data: -1} == "}" ]; then
        data+=","
    fi

    data+="{ \"Metrics\" : \"$1\" , \"Value\" : \"$2\" }"
    data+="]"
}

get_cpu_data(){
    cpu_pecent_used=$(top -bn1 |  grep "Cpu(s)" | \
                    sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
                    awk '{print 100 - $1"%"}')
}

get_mem_data() {
    total_perc=100
    average=$( free -b | grep ":" | head -1 | tr -s ' ' | cut -d ':' -f2 | awk '{$1=$1};1' )
    a1=$(echo $average | cut -d ' ' -f1) #Total
    a2=$(echo $average | cut -d ' ' -f2) #Used
    a3=$(echo $average | cut -d ' ' -f3) #Free
    a4=$(echo $average | cut -d ' ' -f4) #Shared
    a5=$(echo $average | cut -d ' ' -f5) #Buffers/Cached
    #calculate used memory:
    addition=$(( a3 + a5 ))
    multi=$(( addition*100))
    divis=$(awk -v dividend="${multi}" -v divisor="${a1}" 'BEGIN {printf "%.2f", dividend/divisor; exit(0)}')
    mem_pecent_used=$(awk -v no1="${total_perc}" -v no2="${divis}" 'BEGIN {printf "%.2f", no1-no2; exit(0)}')
}

get_disk_data() {
    disk_pecent_used=$(df -h /  | grep [0-9]%  | awk '{ print $5 }')
}

get_inode_data(){
    inode_pecent_used=$(df -i /  | grep [0-9]%  | awk '{ print $5 }')
}

while true; do
    data="[]"

    #add CPU utilization to JSON file
    get_cpu_data
    add_metric "CPU" "$cpu_pecent_used"

    #add MEM utilization to JSON file
    get_mem_data
    add_metric "MEM" "$mem_pecent_used%"

    #add DISK utilization to JSON file
    get_disk_data
    add_metric "DISK" "$disk_pecent_used"

    #add INODE utilization to JSON file
    get_inode_data
    add_metric "INODE" "$inode_pecent_used"

    #Output to file
    echo "$data" > /var/www/html/data.json

    sleep 1
done
