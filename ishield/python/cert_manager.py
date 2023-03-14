import subprocess

class CertManager:
    def __init__(self, pkcs11_module, cert_id, cert_file, pin=None):
        self.pkcs11_module = pkcs11_module
        self.cert_id = cert_id
        self.cert_file = cert_file
        self.pin = pin

    def insert_certificate(self, certificate_path, hsm_slot, hsm_pin, cert_id, cert_label):
        subprocess.call(['bash', 'insert_cert.sh',
                         '--certificate_path', certificate_path,
                         '--hsm_slot', hsm_slot,
                         '--hsm_pin', hsm_pin,
                         '--id', cert_id,
                         '--label', cert_label])

    def export_certificate(self):
        cmd = ['bash', 'export_cert.sh',
               '--module', self.pkcs11_module,
               '--id', self.cert_id,
               '--output_file', self.cert_file,
               '--pin', self.pin]
        subprocess.call(cmd)

if __name__ == "__main__":
    print("--- Insert Cert ---")
    insert_cert = CertManager(
        certificate_path = "cert.pem",
        hsm_slot = 0,
        hsm_pin = "1234",
        cert_id = 5,
        cert_label= "test_cert"
    )
    insert_cert.insert_certificate()