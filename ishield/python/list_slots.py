import pkcs11


def list_available_slots(library_path):
    pkcs11 = pkcs11.lib(library_path)
    slots = pkcs11.get_slots()

    for slot in slots:
        print(f'Slot {slot.slot_number}: {slot.slot_info.manufacturerID} {slot.slot_info.description}')

if __name__ == "__main__":
    list_available_slots(library_path='/usr/lib/opensc-pkcs11.so')