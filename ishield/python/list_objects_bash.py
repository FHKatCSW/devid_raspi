import subprocess
import json

def list_objects_on_hsm(library_path, slot_num, pin):
    # Run the bash script and capture the output
    result = subprocess.check_output(["./bash/list_objects.sh", library_path, str(slot_num), pin])

    # Decode the JSON-encoded object list
    object_list = json.loads(result)

    # Return the object list as a Python list of dictionaries
    return object_list

if __name__ == "__main__":
    list_objects_on_hsm(
        library_path='/usr/lib/opensc-pkcs11.so',
        slot_num=0,
        pin='1234'
    )