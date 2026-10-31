function _docsrs_worktree_ports --argument-names env_file --description 'Assign free ports in a copied docs.rs .env'
    command python3 -c '
import contextlib
import re
import socket
import sys

keys = (
    "DOCSRS_POSTGRES_PORT",
    "DOCSRS_S3_PORT",
    "DOCSRS_S3_CONSOLE_PORT",
    "DOCSRS_WEB_PORT",
)

with open(sys.argv[1], encoding="utf-8", newline="") as env_file:
    content = env_file.read()
newline = "\r\n" if "\r\n" in content else "\n"

# Keep all sockets bound until the file is written so the ports are distinct.
with contextlib.ExitStack() as sockets:
    for key in keys:
        listener = sockets.enter_context(socket.socket(socket.AF_INET, socket.SOCK_STREAM))
        listener.bind(("0.0.0.0", 0))
        port = listener.getsockname()[1]
        pattern = rf"^([ \t]*(?:export[ \t]+)?{key}[ \t]*=)[^\r\n]*"
        content, count = re.subn(pattern, lambda match: f"{match[1]}{port}", content, flags=re.MULTILINE)
        if not count:
            if content and not content.endswith("\n"):
                content += newline
            content += f"{key}={port}{newline}"

    with open(sys.argv[1], "w", encoding="utf-8", newline="") as env_file:
        env_file.write(content)
' "$env_file"
end
