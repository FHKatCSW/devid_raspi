import re
import json
import subprocess

class HsmObjects:
    def __init__(self, slot_num, pin):
        self.private_keys = {}
        self.public_keys = {}
        self.slot_num = slot_num
        self.pin = pin
        objects = self.list_objects_on_hsm()
        self.parse_input_str(objects)

    def list_objects_on_hsm(self):
        # Run the bash script and capture the output
        result = subprocess.check_output(["./bash/list_objects.sh",  str(self.slot_num), self.pin])
        result_str = result.decode('utf-8')  # decode bytes object to string
        return result_str

    def parse_input_str(self, input_str):
        pattern = r'^\s*([^:]+):\s*(.*?)\s*$'

        current_obj_type = None
        current_obj_label = None
        current_obj_id = None
        current_obj_usage = None
        current_obj_access = None

        for line in input_str.split('\n'):
            match = re.match(r'^\s*(Private|Public) Key Object;\s*(RSA.*)$', line)
            if match:
                current_obj_type = match.group(1).lower()
                current_obj_label = None
                continue

            match = re.match(pattern, line)
            if match:
                key = match.group(1)
                value = match.group(2)
                if key == 'label':
                    current_obj_label = value
                elif key == 'ID':
                    current_obj_id = value
                elif key == 'Usage':
                    current_obj_usage = value
                elif key == 'Access':
                    current_obj_access = value
                    if current_obj_label and current_obj_id and current_obj_usage and current_obj_access:
                        obj_data = {
                            'ID': current_obj_id,
                            'Usage': current_obj_usage,
                            'Access': current_obj_access,
                        }
                        if current_obj_type == 'private':
                            self.private_keys[current_obj_label] = obj_data
                        elif current_obj_type == 'public':
                            self.public_keys[current_obj_label] = obj_data
                        current_obj_label = None
                        current_obj_id = None
                        current_obj_usage = None
                        current_obj_access = None

    def to_dict(self):
        return {
            'private_keys': self.private_keys,
            'public_keys': self.public_keys,
        }

    def to_json(self):
        return json.dumps(self.to_dict(), indent=4)

    def filter_id_by_label(self, key_label):
        keys = self.to_json()
        keys_str = json.loads(keys)
        for key_type in ["private_keys", "public_keys"]:
            if key_label in keys_str[key_type]:
                return keys_str[key_type][key_label]["ID"]

    def delete_all_keys(self):
        keys = self.to_dict()
        for key_type in keys:
            priv_pub_key = "priv" if key_type == "private_keys" else "pub"
            for key_name in keys[key_type]:
                key_data = keys[key_type][key_name]
                self.delete_key(priv_pub_key, key_data['ID'])

    def delete_key_by_label(self, key_label):
        self.filter_id_by_label(key_label)

    def delete_key(self, priv_pub_key, key_id):
        subprocess.call(
            ['./bash/delete_keys_on_hsm.sh',
             priv_pub_key,
             f'-i={key_id}',
             self.pin
        ])


def main():
    print("--- Print Objects ---")
    hsm_objects = HsmObjects(
        slot_num=0,
        pin='1234'
    )
    print(hsm_objects.to_dict())
    print(hsm_objects.to_json())
    #print(hsm_objects.to_dict())
    print("--- Get key ID ---")
    print("ID: {}".format(hsm_objects.filter_id_by_label(key_label="my_rsa_pvt_86599")))

if __name__ == "__main__":
    main()
