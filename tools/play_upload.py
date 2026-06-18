#!/usr/bin/env python3
"""Upload an AAB to Google Play Store using a service account."""

import sys
import subprocess
import importlib
import importlib.util
import site

def ensure_packages():
    packages = [
        ("google-api-python-client", "googleapiclient"),
        ("google-auth", "google.oauth2"),
    ]
    installed_any = False
    for pkg, import_name in packages:
        if importlib.util.find_spec(import_name.split(".")[0]) is None:
            print(f"Installing {pkg}...")
            subprocess.check_call([sys.executable, "-m", "pip", "install", pkg, "-q", "--user"])
            installed_any = True

    if installed_any:
        importlib.invalidate_caches()
        user_site = site.getusersitepackages()
        if user_site not in sys.path:
            sys.path.insert(0, user_site)

ensure_packages()

import argparse
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from google.oauth2 import service_account

def upload(service_account_json, package_name, aab_path, track):
    credentials = service_account.Credentials.from_service_account_file(
        service_account_json,
        scopes=["https://www.googleapis.com/auth/androidpublisher"],
    )
    service = build("androidpublisher", "v3", credentials=credentials)
    edits = service.edits()

    edit = edits.insert(packageName=package_name, body={}).execute()
    edit_id = edit["id"]
    print(f"Edit created: {edit_id}")

    media = MediaFileUpload(aab_path, mimetype="application/octet-stream", resumable=True)
    bundle = edits.bundles().upload(
        packageName=package_name,
        editId=edit_id,
        media_body=media,
    ).execute()
    version_code = bundle["versionCode"]
    print(f"Uploaded bundle version code: {version_code}")

    edits.tracks().update(
        packageName=package_name,
        editId=edit_id,
        track=track,
        body={"releases": [{"versionCodes": [version_code], "status": "completed"}]},
    ).execute()
    print(f"Track '{track}' updated")

    edits.commit(packageName=package_name, editId=edit_id).execute()
    print("Edit committed — upload complete!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--service-account", required=True)
    parser.add_argument("--package-name", required=True)
    parser.add_argument("--aab", required=True)
    parser.add_argument("--track", default="internal")
    args = parser.parse_args()

    upload(args.service_account, args.package_name, args.aab, args.track)