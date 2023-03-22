import random
from create_key import HsmKey
from generate_csr import GenerateCsr
from request_cert import CertRequest
from cert_handler import CertHandler
import os
import logger

class BootstrapDevId:
    def __init__(self, pin, slot, id=None):

        self.logger = logger.get_logger("Bootstrap DevID")
        self.pin = pin
        self.slot = slot
        self.key_generated = False
        self.csr_generated = False
        self.cert_path = None

        if id:
            self.id = id
        else:
            self.id = random.randint(10000, 99999)

        self.cn="test_cn_{}".format(self.id)
        self.serial_number=self.id

        self.create_directory("/home/admin/certs")
        self.create_directory("/home/admin/certs/id_{}".format(self.id))

    def create_directory(self, directory_path):

        if not os.path.exists(directory_path):
            os.makedirs(directory_path)
            self.logger.info(f"Created directory at {directory_path}")

    def create_key(self):
        self.logger.info("🔑 Create keypair")
        hsm_key = HsmKey(slot=self.slot,
                         pin=self.pin,
                         public_key_label="my_rsa_pub_{}".format(self.id),
                         private_key_label="my_rsa_pvt_{}".format(self.id))
        hsm_key.generate_rsa_key_pair()
        self.key_generated = True

    def generate_csr(self, key_label=None, cn=None, o=None, ou=None, c=None, serial_number=None):
        self.logger.info("🖋️ Generate CSR")

        if self.key_generated:
            key_label = "my_rsa_pvt_{}".format(self.id)
        else:
            if key_label is None:
                raise Exception("key_label needs to be defined if there was no prior key generation")

        csr_generate = GenerateCsr(
            library_path='/usr/lib/opensc-pkcs11.so',
            slot_num=self.slot,
            pin=self.pin,
            key_label=key_label,
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
        self.logger.info("📄 Request certificate")

        self.cert_path='/home/admin/certs/id_{}/my_cert_{}.cert.pem'.format(self.id, self.id)

        cert_req = CertRequest(
            base_url=base_url,
            p12_file=p12_file,
            p12_pass=p12_pass,
            csr_file='/home/admin/certs/id_{}/csr_{}.csr'.format(self.id, self.id),
        )

        cert_req.request_certificate(cert_file=self.cert_path,
                                     certificate_profile_name=certificate_profile_name,
                                     end_entity_profile_name=end_entity_profile_name,
                                     certificate_authority_name=certificate_authority_name)

    def import_certificate(self):
        self.logger.info("⬆️ Import certificate")

        insert_cert = CertHandler(
            pin=self.pin,
            cert_id=self.id,
        )
        insert_cert.insert_certificate(slot=self.slot,
                                       cert_label=self.cn,
                                       certificate_path=self.cert_path)

def bootstrap_idev():
    bootstrap = BootstrapDevId(pin="1234", slot=0, id=7)
    bootstrap.create_key()
    bootstrap.generate_csr()
    bootstrap.request_cert(base_url='campuspki.germanywestcentral.cloudapp.azure.com',
                           p12_file='/home/admin/fhk_hmi_setup_v3.p12',
                           p12_pass='foo123',
                           certificate_profile_name='DeviceIdentity-Raspberry',
                           end_entity_profile_name='KF-CS-EE-DeviceIdentity-Raspberry',
                           certificate_authority_name='KF-CS-HMI-2023-CA')
    bootstrap.import_certificate()


if __name__ == "__main__":
    bootstrap_idev()