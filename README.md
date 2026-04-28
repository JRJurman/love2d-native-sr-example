# love2d-native-sr-example

This Project is an example that shows a love2d project that uses [SRAL](https://github.com/m1maker/SRAL) to add screen reader and text to speech support. It was originally built to validate and text SRAL's ability to work with Love2d on iOS and Android.

This project has two files:
* `sral.lua` - uses `ffi` to load SRAL, and creates the `speak(text)` function
* `main.lua` - draws four boxes that the user can hover and click on, calls the `speak` function

The `speak(text)` function will determine and use the device's Screen Reader or TTS (text-to-speech) system to read aloud the text passed in. These are often already pre-configured by the user for a rate, accent, and pitch that the user is already comfortable with.

> [!important]
> The project shows simple hover and click affordances that are optimized for mobile. A true blind friendly experience should have keyboard support as well, but for the purposes of this demo, may be missing.
