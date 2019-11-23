# gpg_wrapper
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

A *simple* encryption/decryption tool suitable for use as a contractor in elementaryos

![Screenshot](/data/screenshots/Decrypt.png?raw=true "Encrypt and Decrypt context menu options")

Can also be used from the command line:

##To Encrypt
`com.github.jeremypw.gpg-wrapper -e [PATHS to files requiring encryption]`

Files will be individually encrypted using the user's default gpg key, adding `.gpg` as an extension.
PATHS may contains wild cards. The original files remain.

##To Decrypt
`com.github.jeremypw.gpg-wrapper -d [PATHS to gpg encrypted files]`

A dialog requiring input of the passphrase for the user's default key will appear. Upon its entry, files
will be decrypted, removing any `.gpg` extension. The encrypted files remain.  It is assumed that the files
submitted to the tool have been encrypted by gpg with the default key.

### Dependencies
These dependencies must be present before building
 - `valac`
 - `meson`
 - `glib-2.0`

 You can install these on a Ubuntu-based system by executing this command:

 `sudo apt install valac meson libglib2.0-dev`

### Building
```
meson build --prefix=/usr  --buildtype=release
cd build
ninja
```

### Installing & executing
```
sudo ninja install
```

You will now find that the context menu in Pantheon Files shows an extra entry when more than one file item
has been selected. Clicking on this option results in the renamer window being launched with the selected files
appearing in the "Old Name" list.  You can also lauch the renamer from the command line with:
```