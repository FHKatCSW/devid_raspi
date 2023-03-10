from pyhsm.hsmclient import HsmClient
import json

def list_available_slots(library_path):
    """
    This function takes in the path of the PKCS#11 library as a parameter and returns a JSON-encoded string that contains the slot information as a list of dictionaries. Each dictionary represents the information for a single slot and contains the following keys:

    slot_description: A string that describes the slot.
    manufacturer_id: A string that specifies the manufacturer of the token in the slot.
    firmware_version: A string that specifies the firmware version of the token in the slot.
    hardware_version: A string that specifies the hardware version of the token in the slot.
    flags: An integer that specifies the slot flags.
    is_token_present: A boolean that indicates whether a token is present in the slot.
    is_token_initialized: A boolean that indicates whether the token in the slot is initialized.
    is_session_open: A boolean that indicates whether a session is currently open on the slot.
    is_user_authenticated: A boolean that indicates whether the user is authenticated on the slot.
    is_secure_boot_supported: A boolean that indicates whether the token in the slot supports secure boot.
    :param library_path:
    :return:
    """

    result = []
    with HsmClient(pkcs11_lib=library_path) as c:
        for s in c.get_slot_info():
            slot_info = {
                "slot_description": s.slot_description,
                "manufacturer_id": s.manufacturer_id,
                "firmware_version": s.firmware_version,
                "hardware_version": s.hardware_version,
                "flags": s.flags,
                "is_token_present": s.is_token_present,
                "is_token_initialized": s.is_token_initialized,
                "is_session_open": s.is_session_open,
                "is_user_authenticated": s.is_user_authenticated,
                "is_secure_boot_supported": s.is_secure_boot_supported
            }
            result.append(slot_info)
    return json.dumps(result)

if __name__ == "__main__":
    list_available_slots(library_path='/usr/lib/opensc-pkcs11.so')