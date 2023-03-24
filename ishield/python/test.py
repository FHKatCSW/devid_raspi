from hsm_objects import HsmObjects


if __name__ == "__main__":
    hsm_objects = HsmObjects(
        slot_num=0,
        pin='1234'
    )

    hsm_objects.delete_ldev_keys()