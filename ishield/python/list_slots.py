from pyhsm.hsmclient import HsmClient

def list_available_slots(library_path):
    print(library_path)
    with HsmClient(pkcs11_lib=library_path) as c:
        for s in c.get_slot_info():
            print("----------------------------------------")
            print(s.to_string())

if __name__ == "__main__":
    list_available_slots(library_path='/usr/lib/opensc-pkcs11.so')