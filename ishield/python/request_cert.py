import json
import requests
from requests_pkcs12 import Pkcs12Adapter
import logger

class CertRequest:
    def __init__(self, base_url, p12_file, p12_pass, csr_file):
        self.logger = logger.get_logger("CertRequest")

        self.base_url = base_url
        self.p12_file = p12_file
        self.p12_pass = p12_pass
        self.csr_file = csr_file

        # Read CSR from file
        with open(csr_file, 'r') as f:
            self.csr = f.read()

    def request_certificate(self, cert_file, certificate_profile_name, end_entity_profile_name, certificate_authority_name):
        # Create JSON payload

        payload = {
            'certificate_request': self.csr,
            'certificate_profile_name': certificate_profile_name,
            'end_entity_profile_name': end_entity_profile_name,
            'certificate_authority_name': certificate_authority_name,
        }
        json_payload = json.dumps(payload)

        url = f'https://{self.base_url}/ejbca/ejbca-rest-api/v1/certificate/pkcs10enroll'

        # Send request
        session = requests.Session()
        session.mount(url, Pkcs12Adapter(max_retries=3, pkcs12_filename=self.p12_file, pkcs12_password=self.p12_pass))
        response = session.post(
            url=url,
            headers={'Content-Type': 'application/json', 'Accept': 'application/json'},
            data=json_payload,
            verify=False
        )
        self.logger.info("-Save certificate")
        self.logger.info("--Path: {}".format(cert_file))

        # Save certificate to file
        with open(cert_file, 'w') as f:
            f.write(response.text)

        # Print response
        print('Response:')
        print(response.text)



if __name__ == "__main__":
    cert_req = CertRequest(
        base_url='campuspki.germanywestcentral.cloudapp.azure.com',
        p12_file='/home/admin/fhk_hmi_setup_v3.p12',
        p12_pass='foo123',
        csr_file='/home/admin/certs/setup_test_5.csr',
    )

    cert_req.request_certificate(cert_file='/home/admin/my_cert.pem',
                                 certificate_profile_name='DeviceIdentity-Raspberry',
                                 end_entity_profile_name='KF-CS-EE-DeviceIdentity-Raspberry',
                                 certificate_authority_name='KF-CS-HMI-2023-CA')
