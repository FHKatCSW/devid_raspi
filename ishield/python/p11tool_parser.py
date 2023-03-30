import json
import re
import subprocess

class P11ToolParser:
    def __init__(self, pin):
        self.pin = pin
        self.output = None

    def list_keys(self):
        cmd = ['p11tool', '--provider=/usr/lib/opensc-pkcs11.so', '--list-keys', '--login', '--set-pin={}'.format(self.pin)]
        self.output = subprocess.check_output(cmd, universal_newlines=True)
        return self.keys_to_json()

    def parse_keys(self):
        pattern = r"Object (\d+):\n\s+URL: (.+)\n\s+Type: (.+)\n\s+Label: (.+)\n\s+Flags: (.+)\n\s+ID: (.+)"
        objects = []
        for match in re.finditer(pattern, self.output):
            obj = {
                "index": match.group(1),
                "url": match.group(2),
                "type": match.group(3),
                "label": match.group(4),
                "flags": match.group(5),
                "id": match.group(6),
            }
            objects.append(obj)
        return objects

    def keys_to_json(self):
        objects = self.parse_keys()
        return json.dumps(objects, indent=4)

def main():
    p11_keys = P11ToolParser(pin="1234")
    keys = p11_keys.list_keys()
    print(keys)

if __name__ == "__main__":
    main()
