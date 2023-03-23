import subprocess
import json

class HsmCleaner:
    def __init__(self, json_str):
        self.keys = json.loads(json_str)


