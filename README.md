## Pi-Zero-2W-BadUSB

**Platform**: Raspberry Pi Zero 2 W

**OS**: Raspberry Pi OS Lite (64-bit)


## Overview
This project transforms a **Raspberry Pi Zero 2 W** into a professional-grade BadUSB/HID (Human Interface Device) injection tool. By utilizing the Linux ConfigFS (USB Gadget API), the Pi emulates a trusted USB keyboard to execute automated payloads. This is designed specifically for **Red Teaming**, **Penetration Testing**, and **CTF** (Capture The Flag) scenarios.

Unlike traditional micro-controllers (like the ATmega32U4 used in the Rubber Ducky), the Pi Zero 2 W provides a full 64-bit Linux environment, allowing for complex Python-based logic, multi-stage payloads, and Wi-Fi-enabled exfiltration.

## Key Features
- **Stealth Emulation:** Configured to mimic a standard Dell USB Keyboard (VID: 0x413c, PID: 0x2107) to bypass OS security prompts.
- **Ducky Script Compatibility:** Includes a custom Python parser capable of executing standard `.txt` payloads from most security repositories.
- **Persistent Execution:** Automatically initializes the hardware and fires payloads upon connection to the target host.
- **High-Speed Processing:** Powered by the quad-core Zero 2 W, enabling faster keystroke injection and script handling.

## Hardware Requirements
- **Raspberry Pi Zero 2 W**
- **Micro-USB Data Cable** (Must be a data cable, not just a charging cable)
- **Target Machine:** (Windows/Linux/MacOS)
- **Micro SD Card:** With Raspberry Pi OS Lite (64-bit) installed.

## System Architecture
1. **`setup_gadget.sh`**: The hardware bridge. It interacts with `/sys/kernel/config/usb_gadget/` to define the Pi as a keyboard.
2. **`keymap.py`**: The translator. It maps ASCII characters to 8-byte HID reports that the computer understands.
3. **`ducky_runner.py`**: The engine. It parses the Ducky Script syntax and manages timing and execution.
4. **`my_payload.txt`**: The payload. A standard text file containing the sequence of commands to execute.

## Installation & Setup
1. **Enable Hardware Overlays:**
   Add `dtoverlay=dwc2` to `/boot/firmware/config.txt`.
   Add `dwc2` and `libcomposite` to `/etc/modules`.
    Add `modules-load=dwc2,g_hid` after rootwait to `/boot/firmware/cmdline.txt`.
3. **Workspace:**
   The project is hosted in `/home/astrabot/BadUSB_Project/`.
4. **Deployment:**
   Run `sudo ./setup_gadget.sh` followed by `sudo python3 ducky_runner.py`.

## Legal Disclaimer
This tool is for educational purposes and professional security testing only. Unauthorized use on systems without explicit permission is illegal and unethical.

