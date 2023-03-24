from generate_csr import GenerateCsr
from request_cert import CertRequest
import random


if __name__ == "__main__":
    random_id = random.randint(1000, 9999)
    csr_file = '/home/admin/csr_{}.csr'.format(random_id)
    print("--- Generate CSR ---")
    csr_generate = GenerateCsr(
        library_path='/usr/lib/opensc-pkcs11.so',
        slot_num=0,
        pin='1234',
        key_id='9016cb947f0000001000000000000000',
        output_file= csr_file
    )
    csr_generate.generate_csr(cn="test_cn_{}".format(random_id),
                              serial_number=random_id)

    cert_req = CertRequest(
        base_url='campuspki.germanywestcentral.cloudapp.azure.com',
        p12_file='/home/admin/fhk_hmi_setup_v3.p12',
        p12_pass='foo123',
        csr_file=csr_file,
    )

    cert_req.request_certificate(cert_file='/home/admin/my_cert_{}.pem'.format(random_id),
                                 certificate_profile_name='DeviceIdentity-Raspberry',
                                 end_entity_profile_name='KF-CS-EE-DeviceIdentity-Raspberry',
                                 certificate_authority_name='KF-CS-HMI-2023-CA')
