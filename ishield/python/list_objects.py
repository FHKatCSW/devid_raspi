from pkcs11 import PKCS11Lib, ObjectClass


def list_objects_on_hsm(library_path, token_label, user_pin):
    pkcs11 = PKCS11Lib().load(library_path)
    slot = pkcs11.get_token_slots(token_label=token_label)[0]
    session = slot.open(user_pin=user_pin)

    objects = session.get_objects({
        ObjectClass: ObjectClass.DATA,
    })

    for obj in objects:
        print(f'Label: {obj.label}, Class: {obj.object_class}')


if __name__ == "__main__":
    list_objects_on_hsm(
        library_path='/usr/lib/opensc-pkcs11.so',
        token_label='MyToken',
        user_pin='1234'
    )