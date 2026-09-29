# SMART GST Mart — Troubleshooting & Maintenance Guide

This document contains solutions to common setup, runtime, and platform questions for SMART GST Mart.

---

## 1. Common Scenarios & Resolutions

### A. "Cannot open database / Database locked"
- **Cause**: Another instance of the application is running, holding an exclusive lock on the `.isar` database file.
- **Resolution**: Close other open app windows or terminate any background `smart_gst` process.

### B. "First user enrollment prompt does not appear"
- **Cause**: An existing `UserItem` record already exists in the local database.
- **Resolution**: Login using the previously registered Owner credentials. If resetting the terminal entirely for testing, you can delete the local database file or restore a fresh snapshot from Admin Settings.

### C. "Flutter tester not found on macOS"
- **Cause**: macOS system requires Flutter engine artifacts to be cached.
- **Resolution**: Run `flutter precache --force --macos` in terminal.

### D. "Barcode scanner input not detected"
- **Cause**: POS screen not focused or barcode scanner not configured in HID keyboard wedge mode.
- **Resolution**: USB/Bluetooth barcode scanners act as standard keyboard input devices. Ensure the cursor/focus is in the POS search bar or use the global keyboard listener shortcut (`F2` to focus search).

---

## 2. Re-generating Isar Database Schemas

If you modify any fields in `lib/models/isar/*_model.dart`, re-run the code generator:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 3. Database File Locations

The local Isar `.isar` database files are stored at:
- **macOS / Linux**: `~/Library/Application Support/Smart_GST_POS/smart_gst_pos.isar` (or `~/.local/share/`)
- **Windows**: `%APPDATA%\Smart_GST_POS\smart_gst_pos.isar`
