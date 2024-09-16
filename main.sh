#!/bin/bash

# تابع برای تولید آدرس‌های IPv4 از رنج مشخص
generate_ips() {
    local start_ip="212.77.192.0"
    local end_ip="212.77.207.255"

    IFS='.' read -r i1 i2 i3 i4 <<< "$start_ip"
    end_ip_dec=$(( (i1 << 24) + (i2 << 16) + (i3 << 8) + i4 ))
    
    IFS='.' read -r j1 j2 j3 j4 <<< "$end_ip"
    end_ip_dec=$(( (j1 << 24) + (j2 << 16) + (j3 << 8) + j4 ))

    for ((i=start_ip_dec; i<=end_ip_dec; i++)); do
        ip="$(( (i >> 24) & 255 )).$(( (i >> 16) & 255 )).$(( (i >> 8) & 255 )).$(( i & 255 ))"
        echo "$ip"
    done | shuf -n 10  # انتخاب 10 آدرس تصادفی
}

# تابع برای پینگ آدرس‌ها
ping_ips() {
    for ip in "$@"; do
        response=$(python3 -c "from ping3 import ping; print(ping('$ip'))")
        if [[ $response != "None" ]]; then
            echo "$ip is reachable, response time: $(echo "$response * 1000" | bc) ms"
        else
            echo "$ip is not reachable"
        fi
    done
}

# تولید آدرس‌ها و پینگ کردن
ips=$(generate_ips)
ping_ips $ips
