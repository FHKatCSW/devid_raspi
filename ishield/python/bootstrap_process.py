import random
from create_key import HsmKey
from generate_csr import GenerateCsr
from request_cert import CertRequest
import os

class BootstrapIdevId:
    def __init__(self, pin, slot, id=None):

        self.pin = pin
        self.slot = slot

        if id:
            self.id = id
        else:
            self.id = random.randint(10000, 99999)

        self.cn="test_cn_{}".format(self.id)
        self.serial_number=self.id

        self.create_directory("/home/admin/certs")
        self.create_directory("home/admin/certs/id_{}".format(self.id))

    def create_directory(self, directory_path):

        if not os.path.exists(directory_path):
            os.makedirs(directory_path)
            print(f"Created directory at {directory_path}")

    def create_key(self):
        hsm_key = HsmKey(slot=self.slot,
                         pin=self.pin,
                         public_key_label="my_rsa_pub_{}".format(self.id),
                         private_key_label="my_rsa_pvt_{}".format(self.id))
        hsm_key.generate_rsa_key_pair()

    def generate_csr(self, cn=None, o=None, ou=None, c=None, serial_number=None):

        print("--- Generate CSR ---")
        csr_generate = GenerateCsr(
            library_path='/usr/lib/opensc-pkcs11.so',
            slot_num=self.slot,
            pin=self.pin,
            key_id="my_rsa_pvt_{}".format(self.id),
            output_file='/home/admin/certs/id_{}/csr_{}.csr'.format(self.id, self.id)
        )
        if cn:
            self.cn=cn
        if serial_number:
            self.serial_number=serial_number

        csr_generate.generate_csr(cn=self.cn,
                                  serial_number=self.serial_number,
                                  o=o,
                                  ou=ou,
                                  c=c)

    def request_cert(self, base_url, p12_file, p12_pass, certificate_profile_name, end_entity_profile_name, certificate_authority_name):
        cert_req = CertRequest(
            base_url=base_url,
            p12_file=p12_file,
            p12_pass=p12_pass,
            csr_file='/home/admin/certs/id_{}/csr_{}.csr'.format(self.id, self.id),
        )

        cert_req.request_certificate(cert_file='/home/admin/certs/id_{}/my_cert_{}.cert.pem'.format(self.id, self.id),
                                     certificate_profile_name=certificate_profile_name,
                                     end_entity_profile_name=end_entity_profile_name,
                                     certificate_authority_name=certificate_authority_name)

if __name__ == "__main__":
    bootstrap = BootstrapIdevId(pin="1234", slot=0)
    bootstrap.create_key()
    bootstrap.generate_csr()
    bootstrap.request_cert(base_url='campuspki.germanywestcentral.cloudapp.azure.com',
                           p12_file='/home/admin/fhk_hmi_setup_v3.p12',
                           p12_pass='foo123',
                           certificate_profile_name='DeviceIdentity-Raspberry',
                           end_entity_profile_name='KF-CS-EE-DeviceIdentity-Raspberry',
                           certificate_authority_name='KF-CS-HMI-2023-CA')