import subprocess

from ishield.python.list_objects_bash import HsmObjects


class OpenSSLRunner:
    def __init__(self, slot_num, pin, key_id=None, key_label=None, library_path='/usr/lib/opensc-pkcs11.so'):
        self.key_id = key_id
        self.key_label = key_label
        self.slot_num = slot_num
        self.pin = pin
        self.library_path = library_path

    def get_key_id_by_label(self):
        hsm_objects = HsmObjects(
            library_path=self.library_path,
            slot_num=self.slot_num,
            pin=self.pin
        )
        self.key_id = hsm_objects.filter_id_by_label(key_name=self.key_label)

    def generate_csr(self, output_file , cn, o=None, ou=None, c=None, serial_number=None, dns_names=None, ip_addresses=None):
        # Build command to call the bash script with named arguments
        command = [
            "./bash/generate_csr.sh",
            '--engine',
            'pkcs11',
            '--output',
            output_file,
            '--cn',
            cn,
        ]

        if self.key_label:
            self.get_key_id_by_label()

        command += ['--key', self.key_id]

        if o:
            command += ['--o', o]
        if ou:
            command += ['--ou', ou]
        if c:
            command += ['--c', c]
        if serial_number:
            command += ['--serial', serial_number]

        # Add subject alternative names to the CSR
        # if dns_names or ip_addresses:
        #     san_config = ['[SAN]']
        #     if dns_names:
        #         san_config += ['DNS.{}={}'.format(i + 1, name) for i, name in enumerate(dns_names)]
        #     if ip_addresses:
        #         san_config += ['IP.{}={}'.format(i + 1, ip_address) for i, ip_address in enumerate(ip_addresses)]
        #     san_config_file = output_file + '.san'
        #     with open(san_config_file, 'w') as f:
        #         f.write('\n'.join(san_config))
        #     command += ['-reqexts', 'SAN', '-config', san_config_file]

        # Call the bash script with the command
        subprocess.call(command)
