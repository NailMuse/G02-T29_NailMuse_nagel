# Fonts

Lora (headings) and Poppins (body, buttons). Both use the SIL Open Font License.
The font files are bundled in the app, so no extra package is needed and the app works offline.

Add this to `src/pubspec.yaml`, inside the `flutter:` section (keep the spaces exactly):

```yaml
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
    - family: Lora
      fonts:
        - asset: assets/fonts/Lora-Regular.ttf
        - asset: assets/fonts/Lora-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Lora-Bold.ttf
          weight: 700
```

Tested: the theme runs in Flutter 3.47 on Chrome (`flutter run -d chrome`).
