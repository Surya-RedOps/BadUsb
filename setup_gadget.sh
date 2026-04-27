#!/bin/bash
# High-Efficiency BadUSB Setup for Pi Zero 2 W - Suryaganthan R

# --- CLEANUP ---
if [ -d "/sys/kernel/config/usb_gadget/g1" ]; then
    echo "Resetting existing USB gadget..."
    echo "" | sudo tee /sys/kernel/config/usb_gadget/g1/UDC 2>/dev/null
    sudo rm /sys/kernel/config/usb_gadget/g1/configs/c.1/hid.usb0 2>/dev/null
    sudo rm -rf /sys/kernel/config/usb_gadget/g1/configs/c.1/strings/0x409 2>/dev/null
    sudo rm -rf /sys/kernel/config/usb_gadget/g1/configs/c.1 2>/dev/null
    sudo rm -rf /sys/kernel/config/usb_gadget/g1/functions/hid.usb0 2>/dev/null
    sudo rm -rf /sys/kernel/config/usb_gadget/g1/strings/0x409 2>/dev/null
    sudo rm -rf /sys/kernel/config/usb_gadget/g1 2>/dev/null
fi

# --- START SETUP ---
sudo modprobe libcomposite
cd /sys/kernel/config/usb_gadget/
sudo mkdir -p g1
cd g1

# Stealth IDs (Mimicking Dell USB Keyboard)
echo 0x413c | sudo tee idVendor
echo 0x2107 | sudo tee idProduct
echo 0x0100 | sudo tee bcdDevice
echo 0x0200 | sudo tee bcdUSB

sudo mkdir -p strings/0x409
echo "1234567890" | sudo tee strings/0x409/serialnumber
echo "Suryaganthan R" | sudo tee strings/0x409/manufacturer
echo "HID Keyboard Device" | sudo tee strings/0x409/product

sudo mkdir -p configs/c.1/strings/0x409
echo "Config 1: USB HID" | sudo tee configs/c.1/strings/0x409/configuration
echo 250 | sudo tee configs/c.1/MaxPower

sudo mkdir -p functions/hid.usb0
echo 1 | sudo tee functions/hid.usb0/protocol
echo 1 | sudo tee functions/hid.usb0/subclass
echo 8 | sudo tee functions/hid.usb0/report_length
echo -ne \\x05\\x01\\x09\\x06\\xa1\\x01\\x05\\x07\\x19\\xe0\\x29\\xe7\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\x95\\x01\\x75\\x08\\x81\\x03\\x95\\x05\\x75\\x01\\x05\\x08\\x19\\x01\\x29\\x05\\x91\\x02\\x95\\x01\\x75\\x03\\x91\\x03\\x95\\x06\\x75\\x08\\x15\\x00\\x25\\x65\\x05\\x07\\x19\\x00\\x29\\x65\\x81\\x00\\xc0 | sudo tee functions/hid.usb0/report_desc

sudo ln -s functions/hid.usb0 configs/c.1/
ls /sys/class/udc | sudo tee UDC
echo "Gadget /dev/hidg0 created successfully."
