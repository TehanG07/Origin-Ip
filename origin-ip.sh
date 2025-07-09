#!/bin/bash

input="mapped.txt"  # aapki cleaned file ka naam
output="verified-origins.txt"

> "$output"

while IFS=',' read -r domain ip; do
    if [[ -z "$domain" || -z "$ip" ]]; then
        echo "[!] Skipping incomplete line."
        continue
    fi

    echo "[*] Testing $domain => $ip"

    response=$(curl -sk --resolve "$domain:443:$ip" "https://$domain" -o /tmp/out.html -w "%{http_code}")

    if [[ "$response" == "200" ]]; then
        echo "[+] $domain is LIVE on $ip ✅"
        echo "$domain,$ip" >> "$output"
    else
        echo "[-] $domain is NOT responding on $ip ❌"
    fi
done < "$input"
