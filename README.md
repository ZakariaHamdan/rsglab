# Zak's Network Lab Tools

Network management toolkit for BIND9, file search, and remote SSH access.

## Features
- 🔐 Quick SSH into lab gateway
- 🔍 System-wide file search
- 🌐 BIND9 Management
  - Restart/status checks
  - Config file editing (named.conf, zones)
  - Configuration validation
  - Zone file management

## Installation

### Quick Install (adds to PATH)
```bash
sudo curl -o /usr/local/bin/zaktools https://raw.githubusercontent.com/YOUR_USERNAME/zaktools/main/zaktools.sh
sudo chmod +x /usr/local/bin/zaktools
```

### Manual Install
```bash
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/zaktools/main/zaktools.sh
chmod +x zaktools.sh
./zaktools.sh
```

## Usage
```bash
zaktools
```

## Requirements
- Linux (tested on Ubuntu 24.04)
- BIND9 (for DNS management features)
- sudo access (for system operations)

## Author
Zakaria Yahya Hamdan - RSG Network Lab
```

**LICENSE (MIT is simple):**
```
MIT License

Copyright (c) 2025 Zakaria Yahya Hamdan

Permission is hereby granted, free of charge, to any person obtaining a copy...
```

**.gitignore (optional):**
```
*~
*.swp
.DS_Store
