# RSG Lab Tools

Network management toolkit for RSG Network Lab - BIND9, DNS, file search, SSH, and alias management.

## Features

### 🔐 SSH Management
- Quick SSH to Lab Gateway (PC-G) and Lab Manager (PC-M)
- Direct CLI shortcuts: `rsglab ssh gate`, `rsglab ssh manager`

### 🌐 BIND9 Management
- Service control (restart, status)
- Configuration file editor (named.conf, zones)
- Configuration validation with zone checking

### 🔍 DNS Management
- systemd-resolved control
- DNS configuration files (resolv.conf, hosts, nsswitch.conf)
- DNS testing tools (dig, trace, specific nameserver queries)

### 🔗 Alias Management
- Create and manage bash aliases
- View, create, delete aliases via intuitive menu
- Auto-integration with ~/.bashrc

### 🔎 File Search
- System-wide file search with pattern matching

### ⚡ Command Sequences
- Chain commands: `3,2,1` or `3.2.1` or `3 2 1`
- Navigate menus rapidly: BIND9 → Config → named.conf → cat

## Installation

### Quick Install
```bash
cd ~
git clone https://github.com/ZakariaHamdan/rsglab.git
cd rsglab
./install.sh
```

### Manual Install
```bash
git clone https://github.com/ZakariaHamdan/rsglab.git
cd rsglab
chmod +x rsglab.sh
sudo ln -s ~/rsglab/rsglab.sh /usr/local/bin/rsglab
```

## Usage
```bash
# Interactive menu
rsglab

# Update to latest version
rsglab update

# SSH shortcuts
rsglab ssh gate
rsglab ssh manager

# Help
rsglab help
```

### Command Sequences
Navigate menus quickly by entering comma, dot, or space-separated numbers:
- `3,2,1` - BIND9 → Config Files → named.conf → cat
- `4.3.2` - DNS → Testing → Test specific domain
- `5 2` - Aliases → Create alias

## Update
```bash
rsglab update
# or manually:
cd ~/rsglab
git pull
```

## Uninstall
```bash
cd ~/rsglab
./uninstall.sh
```

## Requirements
- Linux (tested on Ubuntu 24.04)
- BIND9 (for DNS server management)
- systemd-resolved (for DNS client management)
- sudo access

## Team
RSG Network Lab - Zakaria, Leen, Mohamad, Marc