from pyhsm.hsmclient import HsmClient
import json

def list_available_slots(library_path):

    result = []
    with HsmClient(pkcs11_lib=library_path) as c:
        for s in c.get_slot_info():
            print(s)
            # slot_info = {
            #     "slot_description": s.slot_description,
            #     "manufacturer_id": s.manufacturer_id,
            #     "firmware_version": s.firmware_version,
            #     "hardware_version": s.hardware_version,
            #     "flags": s.flags,
            #     "is_token_present": s.is_token_present,
            #     "is_token_initialized": s.is_token_initialized,
            #     "is_session_open": s.is_session_open,
            #     "is_user_authenticated": s.is_user_authenticated,
            #     "is_secure_boot_supported": s.is_secure_boot_supported
            # }
            # result.append(slot_info)
    return json.dumps(result)

if __name__ == "__main__":
    list_available_slots(library_path='/usr/lib/opensc-pkcs11.so')