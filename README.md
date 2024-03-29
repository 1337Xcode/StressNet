# StressNet

StressNet is a powerful stress-testing tool designed for penetration testers and security professionals to assess the resilience of their network infrastructure. It provides a suite of attack vectors, including SYN flood, UDP flood, ICMP flood, ACK flood, TCP flood, UDP flood with random source ports, UDP flood with spoofed source IP, and custom socket flood attack, all implemented using the hping3 tool and Nmap for port scanning.

## Features

1. SYN Flood Attack
2. UDP Flood Attack
3. ICMP Flood Attack
4. ACK Flood Attack
5. TCP Flood Attack
6. UDP Flood Attack with Random Source Ports
7. UDP Flood Attack with Spoofed Source IP
8. Custom Socket Flood Attack

## Change Log

- **Version 1.1**
  - Added Custom Socket Flood Attack feature.
  - Implemented Nmap for automatic port scanning and domain name resolution.

## Prerequisites

- Termux installed on your Android device from [F-Droid](https://f-droid.org/packages/com.termux)
- Basic knowledge of networking and network security
- Git and other prerequisites installed on your Termux environment (Refer to Installation)

## Installation

1. Open Termux on your Android device.
2. Install Git, tsu, hping3, and Nmap: `pkg install git -y && pkg install tsu && pkg install root-repo && pkg install hping3 && pkg install nmap -y`
3. Clone the StressNet repository: `git clone https://github.com/1337Xcode/StressNet`
4. Navigate to the StressNet directory: `cd StressNet`
5. Run the StressNet script: `sudo bash Run.sh`

## Usage

1. After running the `Run.sh` script, follow the on-screen prompts to input the target IP address or domain name, target port (manual/auto), number of packets, and select the attack type.
2. Once all the necessary information is provided, the selected attack will be initiated.
3. Monitor the attack progress and results. Use responsibly and only on systems you have permission to test.

## Disclaimer

This tool is intended for educational and testing purposes only. Misuse of this tool can result in legal consequences. Use it responsibly and only on systems you own or have explicit permission to test. In no way am I both legally and literally responsible for any misuse of this script.

## Contributing

Contributions are welcome! If you have ideas for new features, enhancements, or bug fixes, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
