#!/usr/bin/env python
import re
import tempfile

import requests

URL = "https://pypi.org/simple/"


with tempfile.SpooledTemporaryFile() as html_file:
    with requests.get(URL, stream=True) as r:
        r.raise_for_status()
        for chunk in r.iter_content(chunk_size=8192):
            html_file.write(chunk)

    html_file.seek(0)

    for line in html_file:
        line = line.decode()
        for match in re.finditer(r'"/simple/([^/]+)/"', line):
            print(match.group(1))
