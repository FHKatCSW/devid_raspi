import sys
from cryptography import x509
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.serialization import load_pem_private_key
from cryptography.x509.oid import NameOID
from pyhsm import libhsm
from pyhsm.hsmclient import HsmClient
import random


class HsmCreateCsr:
    def __init__(self, slot, pin, library_path, key_id, subject, output_filename):
        self.slot = slot
        self.pin = pin
        self.library_path = library_path
        self.key_id = key_id
        self.subject = subject
        self.output_filename = output_filename

    def generate_csr(subject, pin, key_id, output_filename):
        # Load the private key from the HSM
        hsm = libhsm.LibHSM()
        slot = hsm.getSlot(0)
        session = slot.login(pin)
        priv_key = session.getPrivateKey(key_id)

        # Generate the CSR
        csr_builder = x509.CertificateSigningRequestBuilder()
        csr_builder = csr_builder.subject_name(x509.Name([
            x509.NameAttribute(NameOID.COUNTRY_NAME, u"US"),
            x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, u"California"),
            x509.NameAttribute(NameOID.LOCALITY_NAME, u"San Francisco"),
            x509.NameAttribute(NameOID.ORGANIZATION_NAME, u"Example Corp"),
            x509.NameAttribute(NameOID.COMMON_NAME, subject),
        ]))
        csr_builder = csr_builder.add_extension(
            x509.BasicConstraints(ca=False, path_length=None), critical=True,
        )
        csr = csr_builder.sign(
            private_key=priv_key, algorithm=hashes.SHA256(),
            backend=default_backend(),
        )

        # Save the CSR to a file
        with open(output_filename, "wb") as f:
            f.write(csr.public_bytes(Encoding.PEM))

        print(f"CSR generated and saved to {output_filename}")