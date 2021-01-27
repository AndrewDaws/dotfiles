#!/bin/bash
# Returns 0 if desktop (GUI-capable) client or 1 if it is not

# @todo Improve Desktop Client Logic
# @body Add more checks such as VNC, X-org, etc.
if [[ -n "${SSH_CLIENT}" ]]; then
    # SSH client
    exit 1
else
    # Desktop client
    exit 0
fi
