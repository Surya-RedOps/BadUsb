import time
import keymap

HID_DEV = "/dev/hidg0"

def send_report(report):
    """Writes the 8-byte HID report to the device."""
    try:
        with open(HID_DEV, 'rb+') as fd:
            fd.write(report.encode('latin-1'))
    except Exception as e:
        print(f"Failed to write to HID device: {e}")

def press_key(key_name):
    """Handles single key presses and releases."""
    if key_name in keymap.keys:
        mod, code = keymap.keys[key_name]
        # Press
        send_report(mod + '\x00' + code + '\x00' * 5)
        # Release
        send_report('\x00' * 8)
    else:
        print(f"Key '{key_name}' not found in keymap.")

def type_string(text):
    """Types out a full string character by character."""
    for char in text:
        press_key(char)
        time.sleep(0.01) # Small delay for host stability

# --- EXECUTION ---
print("Payload will fire in 5 seconds...")
time.sleep(5)

# 1. Open Run Dialog
press_key('GUI_R')
time.sleep(0.6)

# 2. Type Notepad and Open it
type_string("notepad")
press_key('ENTER')
time.sleep(1.2) # Give Notepad time to focus

# 3. Type the Final Message
type_string("Success! This BadUSB is live.")
press_key('ENTER')
type_string("Built by: Suryaganthan R")
press_key('ENTER')

print("Payload completed.")
