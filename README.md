# Chrome OS Policy Editor

This is a Python program which is able to modify the device policies on a Chrome OS system, based on [lilac](https://github.com/MercuryWorkshop/lilac).

## Downloads:
You can find the latest pyinstaller'd binaries at: [nightly.link (main)](https://nightly.link/kosuke14/policyedit_autoupd/workflows/build/main).<br/>
For `/etc/opt/chrome/policies`-compatible JSON format: [nightly.link (mngjson)](https://nightly.link/kosuke14/policyedit_autoupd/workflows/build/mngjson)

## Installation:
You must have Python 3 installed on Linux, with support for virtual environments and pip. 

Clone this repository, and run the following commands:
```
python3 -m venv .venv
source .venv/bin/activate
pip3 install -r requirements.txt
```

## Usage:
```
usage: main.py [-h] {view,patch} ...

positional arguments:
  {view,patch}
    view        Read the device settings without modifying anything.
    patch       Patch an existing device policy file.

options:
  -h, --help    show this help message and exit
```
To import `policies.json` (not `policy.json` like pollen), add `--policy-json` argument and specify the path to `policies.json`.<br/>
Please note that `policies.json` is different with `policy.json` like pollen, the `policies.json` is an json file which is exported from `chrome://policy`.<br/>
**For more detailed informations about policies**, see [ChromiumOS Docs - ChromeOS Local Policy Testing Tools](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/components/policy/tools/fake_dmserver/chromeos_instructions.md).<br/><br/>

**On an enrolled device, you may need to turn off Wi-Fi to be persist because ChromeOS tries to fetch and sync policies every time when Chrome starts up.** <br/>
> ⚠️ It won't be shown as online on GAC while policies are edited.

### On Real Chrome OS:
1. Make sure you are in developer mode and have rootfs verification off.
2. Add `--disable-policy-key-verification` to the end of `/etc/chrome_dev.conf`.
3. Edit `/etc/lsb-release` to change the release channel to `testimage-channel`.
4. Run `main.py` with the correct arguments, specifying any policy files that are in `/var/lib/devicesettings/`.
5. Copy the public key to `/var/lib/devicesettings/owner.key`.
6. Overwrite the original policy files with the patched versions.

### On Linux-ChromiumOS:
1. Locate the user data directory (this defaults to `~/.config/chromium`) or explicitly set it with `--user-data-dir=DATA_DIR`.
2. Run `main.py`, specifying the policy file at `DATA_DIR/stub_device_policy`.
3. Overwrite the original policy with the patched version.
4. Copy the public key to `DATA_DIR/stub_owner.key`.

## Copyright:

This repository is licensed under the GNU GPL v3.

```
ading2210/policyedit - A program to modify Chrome OS device policies
Copyright (C) 2024 ading2210

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```
