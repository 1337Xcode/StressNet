# Botnet

Botnet is a powerful stress-testing tool designed for penetration testers and security professionals to assess the resilience of their network infrastructure. It provides a suite of attack vectors, including SYN flood, UDP flood, ICMP flood, ACK flood, TCP flood, UDP flood with random source ports, and UDP flood with spoofed source IP, all implemented using the hping3 tool.

## Features

- Perform SYN flood attacks
- Conduct UDP flood attacks
- Execute ICMP flood attacks
- Launch ACK flood attacks
- Initiate TCP flood attacks
- Conduct UDP flood attacks with random source ports
- Execute UDP flood attacks with spoofed source IP addresses

## Prerequisites

- Termux installed on your Android device (available on Google Play Store)
- Basic knowledge of networking and network security
- Git installed on your Termux environment (`pkg install git`)

## Installation

1. Open Termux on your Android device.
2. Install Git if you haven't already: `pkg install git`
3. Clone the Botnet repository: `git clone https://github.com/1337Xcode/Botnet`
4. Navigate to the Botnet directory: `cd Botnet`
5. Run the Botnet script: `su -c bash botnet.sh`

## Usage

1. After running the `botnet.sh` script, follow the on-screen prompts to input the target IP address, target port, number of packets, and select the attack type.
2. Once all the necessary information is provided, the selected attack will be initiated.
3. Monitor the attack progress and results. Use responsibly and only on systems you have permission to test.

## Disclaimer

This tool is intended for educational and testing purposes only. Misuse of this tool can result in legal consequences. Use it responsibly and only on systems you own or have explicit permission to test.

## Contributing

Contributions are welcome! If you have ideas for new features, enhancements, or bug fixes, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
