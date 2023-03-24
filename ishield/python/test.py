from generate_csr import GenerateCsr


if __name__ == "__main__":
    print("--- Generate CSR ---")
    csr_generate = GenerateCsr(
        library_path='/usr/lib/opensc-pkcs11.so',
        slot_num=0,
        pin='1234',
        key_id='4',
        output_file='/home/admin/csr_{}.csr'.format(random_id)
    )
    csr_generate.generate_csr(cn="test_cn_{}".format(random_cn),
                              serial_number=random_cn)