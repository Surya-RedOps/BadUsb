import time
import keymap
import sys

HID_DEV = "/dev/hidg0"

def send_report(report):
    with open(HID_DEV, 'rb+') as fd:
        fd.write(report.encode('latin-1'))

def press_key(key_name):
    if key_name in keymap.keys:
        mod, code = keymap.keys[key_name]
        send_report(mod + '\x00' + code + '\x00' * 5)
        send_report('\x00' * 8)
        time.sleep(0.01)
    else:
        print(f"Key '{key_name}' unknown.")

def type_string(text):
    for char in text:
        press_key(char)

def parse_line(line):
    line = line.strip()
    if not line or line.startswith("REM"):
        return

    parts = line.split(' ')
    cmd = parts[0].upper()
    args = " ".join(parts[1:])

    if cmd == "STRING":
        type_string(args)
    elif cmd == "DELAY":
        time.sleep(int(args) / 1000)
    elif cmd == "ENTER":
        press_key("ENTER")
    elif cmd == "GUI" or cmd == "WINDOWS":
        if args.lower() == "r": press_key("GUI_R")
        else: press_key("GUI_R") # Default to GUI_R for common tasks
    elif cmd == "ALT" and args.upper() == "F4":
        press_key("ALT_F4")
    elif cmd == "TAB":
        press_key("TAB")
    elif cmd in keymap.keys:
        press_key(cmd)

def main():
    filename = "my_payload.txt"
    print(f"Parsing {filename}...")
    try:
        with open(filename, 'r') as f:
            for line in f:
                parse_line(line)
    except FileNotFoundError:
        print("Error: my_payload.txt not found.")

if __name__ == "__main__":
    time.sleep(5) # Final safety delay before execution
    main()
