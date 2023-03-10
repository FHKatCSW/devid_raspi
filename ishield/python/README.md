
Todo

Install jq for

```
apt-get install -y jq
```

Make the scripts executable

```
chmod +x ./bash/list_objects.sh
```

target='
{Private Key Object; RSA:
[
{"label": "my_priv_rsa",
"ID": "68c962b61000000068c962b610000000",
"Usage": "decrypt, sign, unwrap",
"Access": "none"
}
]
Public Key Object; RSA 2048 bits:
[
{"label": "my_rsa_pub",
"ID": "68c962b61000000068c962b610000000",
"Usage": "encrypt, verify, wrap",
"Access": "none",
}
]
}
'


'Private Key Object; RSA \n    
    label:      my_priv_rsa\n  
    ID:         68c962b61000000068c962b610000000\n  
    Usage:      decrypt, sign, unwrap\n  
    Access:     none\n
Public Key Object; RSA 2048 bits\n  
    label:      my_rsa_pub\n  
    ID:         68c962b61000000068c962b610000000\n  
    Usage:      encrypt, verify, wrap\n  
    Access:     none\n
Private Key Object; RSA \n  
    label:      test\n  
    ID:         02\n  
    Usage:      decrypt, sign\n  
    Access:     none\n
Private Key Object; RSA \n  
    label:      test-2\n  
    ID:         03\n  
    Usage:      decrypt, sign\n  
    Access:     none\n
Public Key Object; RSA 2048 bits\n  
    label:      test\n  
    ID:         02\n  
    Usage:      encrypt, verify\n  
    Access:     none\n
Public Key Object; RSA 2048 bits\n  
    label:      test-2\n  
    ID:         03\n  
    Usage:      encrypt, verify\n  
    Access:     none\n
Profile object 3031686432\n  
profile_id:          CKP_PUBLIC_CERTIFICATES_TOKEN (4)\n'


"Private ": "Key ": "Object; ": "RSA ": "label"my_priv_rsa ": "ID"68c962b61000000068c962b610000000 ": "Usage"decrypt, ": "sign, ": "unwrap ": "Access"none ": "Public ": "Key ": "Object; ": "RSA ": "2048 ": "bits ": "label"my_rsa_pub ": "ID"68c962b61000000068c962b610000000 ": "Usage"encrypt, ": "verify, ": "wrap ": "Access"none ": "Private ": "Key ": "Object; ": "RSA ": "label"test ": "ID"02 ": "Usage"decrypt, ": "sign ": "Access"none ": "Public ": "Key ": "Object; ": "RSA ": "2048 ": "bits ": "label"test ": "ID"02 ": "Usage"encrypt, ": "verify ": "Access"none ": "Profile ": "object ": "3031686432 ": "profile_id"CKP_PUBLIC_CERTIFICATES_TOKEN ": "(4) ":\n'