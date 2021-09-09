# OBS-Pushover
Pushover notifications triggered by events in OBS Studio

This is very useful for anyone like me that runs OBS Studio on a headless machine and can't see whether commands sent to OBS through websockets from my PC successfully triggered events.

# Requirements
You need to have a Pushover account
https://pushover.net/

## Installation
1. Download the zip file
2. Extract the files from the zip file into a location where it can remain
3. In OBS, go to "Tools" -> "Scripts"
4. Click the "+" icon and select the "obs_pushover.lua" file
5. Select the script under 'Loaded scripts'
6. From your Pushover account, copy "Your User Key" into the "User Key" field
![pushover_userKey](https://user-images.githubusercontent.com/29752700/132640343-102e1092-da74-4c4f-8c6d-de567b11a860.png)
7. From your Pushover account, create an "Application/API Token" and copy the app's "API Token/Key" into the "App API Token" field
![pushover_appToken](https://user-images.githubusercontent.com/29752700/132640368-000daa0d-7830-42d6-8585-cb4d3465576b.png)
8. Enable the check boxes for the events you want to receive notifications for
9. Optionally fill in the priority, sound and device field for nofitication customization

Examples setup:

![pushover_setup](https://user-images.githubusercontent.com/29752700/132640734-11fb0d64-5248-46bd-8b72-b5f948d82f59.png)


## Notes
- The name of one of the sounds needs to be supported by the device clients.
- Priority: Send as -2 to generate no notification/alert, -1 to always send as a quiet notification, 1 to display as high-priority and bypass the user's quiet hours, or 2 to also require confirmation from the user.
- The Retry parameter specifies how often (in seconds) the Pushover servers will send the same notification to the user. This parameter must have a value of at least 30 seconds between retries.
- The Expire parameter specifies how many seconds your notification will continue to be retried for (every retry seconds). This parameter must have a maximum value of at most 10800 seconds (3 hours).
- If Priority is set to 2, by default Retry will be set to 30 seconds

- When notifications are enabled for Studio Mode and Scene Change, OBS triggers two scene change events when disabling Studio Mode which does send two Pushover notification.


## Disclaimer
I am not a developer by profession.
I usually just code things for personal use.
I've never worked with LUA before.
