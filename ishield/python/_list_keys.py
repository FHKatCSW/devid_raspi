import json
import subprocess

# Execute the p11tool command and capture its output
cmd = ['p11tool', '--provider=/usr/lib/opensc-pkcs11.so', '--list-keys', '--login', '--set-pin=1234']
output = subprocess.check_output(cmd, universal_newlines=True)

# Parse the output into a list of dictionaries
lines = output.strip().split('\n')
keys = []
for i in range(0, len(lines), 3):
    label = lines[i].split(':')[1].strip()
    id = lines[i+1].split(':')[1].strip()
    keys.append({'label': label, 'id': id})

# Convert the list of dictionaries into a JSON object
json_output = json.dumps(keys)

# Print the JSON object
print(json_output)