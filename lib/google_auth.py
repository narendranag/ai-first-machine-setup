"""OAuth for the gcal / gmail / gdrive wrappers.

One OAuth client (Desktop app) and one token shared by all three wrappers, both in Bitwarden:
  system-manager/google-credentials   secure note: the downloaded credentials.json
  system-manager/google-token         secure note: the authorised token (written by the first run)

Nothing is written to disk. First run opens a browser for consent (the human does this).
"""

from __future__ import annotations

import json

import sm

SCOPES = [
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/calendar.events",
    "https://www.googleapis.com/auth/drive",
]


def credentials():
    from google.auth.transport.requests import Request
    from google.oauth2.credentials import Credentials
    from google_auth_oauthlib.flow import InstalledAppFlow

    creds = None
    try:
        creds = Credentials.from_authorized_user_info(json.loads(sm.secret("google-token", "notes")), SCOPES)
    except sm.SMError as e:
        if e.code != sm.EX_CONFIG:
            raise

    if creds and creds.valid:
        return creds
    if creds and creds.expired and creds.refresh_token:
        creds.refresh(Request())
    else:
        client = json.loads(sm.secret("google-credentials", "notes"))
        flow = InstalledAppFlow.from_client_config(client, SCOPES)
        creds = flow.run_local_server(port=0, open_browser=True)
    sm.set_note("google-token", creds.to_json())
    return creds


def service(name: str, version: str):
    from googleapiclient.discovery import build

    return build(name, version, credentials=credentials(), cache_discovery=False)
