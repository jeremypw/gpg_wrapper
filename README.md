# GNU Privacy Guard Wrapper
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

A *simple* encryption/decryption tool suitable for use as a contractor in Elementary OS
When installed on Elementary OS, you will find that the context menu in Pantheon Files shows an extra entry
"Encrypt (GPG)" when at least one file item has been selected. Clicking on this option results in each of the
selected files being encrypted with the user's default gpg key and saved to a new file with `.gpg` add as an extension
to the original file name.

If the selected files are *all* of the mime-type `application/pgp-encrypted` then another option "Decrypt (GPG)" also
appears. Clicking on this option results in a dialog asking for the passphrase of the user's default gpg key.  Upon
successful entry, the selected files are each decrypted and saved to a new file with `.decrypted` added as an extension
to the original file name. Successful decryption requires that the files have been encrypted with the user's default
GPG key.

![Screenshot](/data/screenshots/Decrypt.png?raw=true "Encrypt and Decrypt context menu options")

The tool can also be used from the command line:

## To Encrypt
`com.github.jeremypw.gpg-wrapper -e [PATHS to files requiring encryption]`

## To Decrypt
`com.github.jeremypw.gpg-wrapper -d [PATHS to gpg encrypted files]`

## Building from source

### Dependencies
These dependencies must be present before building
 - `valac`
 - `meson`
 - `glib-2.0`

 You can install these on a Ubuntu-based system by executing this command:

 `sudo apt install valac meson libglib2.0-dev`

### To build

```
meson build --prefix=/usr  --buildtype=release
cd build
ninja

```

### To install

`sudo ninja install`
