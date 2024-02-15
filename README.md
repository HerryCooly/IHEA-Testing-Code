# Frontend Development
This is the folder responsible for the front end flutter code.
You can open this folder specifically as a android studio project, or
open the whole directory as a vscode project.

## Flutter Install:
Note: I suggest installing the flutter sdk under `C:\`, such that your SDK path is `C:\flutter\bin`
1. Get and install the SDK from [here](https://docs.flutter.dev/get-started/install/windows/desktop?tab=download)
2. Add the path variable for `C:\flutter\bin` in environment variables under `PATH` as per flutter docs.
3. Install the plugin for [VSCODE](https://docs.flutter.dev/get-started/editor?tab=vscode) or [Android Studio](https://docs.flutter.dev/get-started/editor?tab=androidstudio)
4. In your IDE or terminal, run `flutter doctor` and correct all issues besides the visual studio warning.
5. If you see the ending comments on components, ie `/drawer` and `/scaffold`, you have succesfully installed flutter.
6. If doctor reports issues, you may need to run `flutter upgrade` and update your IDE or plugins.
7. Navigate to `C:\flutter\packages\flutter_tools\gradle\src\main\groovy`.
8. Open `flutter.groovy` in an editor
9. Set the minSdkVersion from 19 to 26 (line ~47): `static int minSdkVersion = 26`

## Firebase Install (Link: [Firebase Doc](https://firebase.google.com/docs/flutter/setup?platform=android)):
1. Install NodeJS with NVM Windows (Google/MS recommended):[NVM-Windows](https://github.com/coreybutler/nvm-windows)
2. Run `nvm install latest` in a terminal to install the latest NodeJS
3. Run `nvm on` to enable nvm and use the latest version of node. It should auto set PATH.
4. Run `npm install -g firebase-tools` in a terminal
5. Run the command from step 1 in any dir: `dart pub global activate flutterfire_cli`.
6. You will get a warning message saying that it installed to somewhere outside your PATH environment
7. Open up windows environment variables and add that path under path, similar to how you added the flutter bin above.
8. main.dart should no longer have firebase dependency issues :)

## Revision:
Last revised by Dylan S at 01/26/2024 @ 2:06pm