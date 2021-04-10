![Catalyst logo](logotype_inline.png)
# Catalyst
![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)

### Catalyst is a blockchain-based marketplace catered to small, domestic goods manufacturers.

Being based on blockchain and having many additional well-thought-out features, it ensures review integrity, and enables small businesses to stand out in an ever-growing market.

# Running

The build process remains the same regardless of your operating system of choice.

   1. Clone an up-to-date version of the `master` branch;
   2. Ensure the following dependencies have been installed:
      - `Flutter SDK`;
      - `Android SDK`;
      - `Ganache (GUI Client)`;
      - `nodejs`;
      - `npm`, as well as the packages `truffle`, `<ipfs deps>, ...`.
   3. Connect your physical device via the `adb` utility, or launch the Android System Emulator. Verify connectivity by typing `flutter devices` in the command line;
   4. Launch the Ganache GUI Client and create an empty workspace.
   4. Run `build.sh`. **This may take a while**.