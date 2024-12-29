# reset-id-cursor

## MacOS
- Permission: chmod +x file.sh
- ./file.sh

## Windows
-
-

----

Installation Instructions:

Navigate to the configuration file location:
- Windows: %APPDATA%\Cursor\User\globalStorage\storage.json
- macOS: ~/Library/Application Support/Cursor/User/globalStorage/storage.json
- Linux: ~/.config/Cursor/User/globalStorage/storage.json

Create a backup of storage.json

Edit storage.json and update these fields with your new key:
```json
{
  "telemetry.machineId": "b18401b5-14ab-4910-9a0c-be8fdcd6e722",
  "telemetry.macMachineId": "b18401b5-14ab-4910-9a0c-be8fdcd6e722",
  "telemetry.sqmId": "b18401b5-14ab-4910-9a0c-be8fdcd6e722",
  "telemetry.devDeviceId": "b18401b5-14ab-4910-9a0c-be8fdcd6e722",
  "lastModified": "2024-01-01T00:00:00.000Z",
  "version": "1.0.1"
}
```
Save the file and restart Cursor
