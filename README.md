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

![pushover_userKey](https://user-images.githubusercontent.com/29752700/132647922-ac812fb4-351d-4541-a617-a83aa74873e2.png)


7. From your Pushover account, create an "Application/API Token" and copy the app's "API Token/Key" into the "App API Token" field

![pushover_appToken](https://user-images.githubusercontent.com/29752700/132647937-de2c493d-00ee-4814-bf16-feb54e148e0a.png)


8. Enable the check boxes for the events you want to receive notifications for
9. Optionally fill in the priority, sound and device field for notification customization

Examples setup:

![pushover_setup](https://user-images.githubusercontent.com/29752700/132647952-73792c66-af0d-44b4-a573-768a681c9458.png)



## Notes
- The name of one of the sounds needs to be supported by the device clients. Sound names can be found here - https://pushover.net/api#sounds

Using the sound name on the left without spaces and in lowercase.

![pushover_sound](https://user-images.githubusercontent.com/29752700/132641581-e2184b5c-e3f0-4cd7-bf18-67365da2f4d6.png)

- Priority: Send as -2 to generate no notification/alert, -1 to always send as a quiet notification, 1 to display as high-priority and bypass the user's quiet hours, or 2 to also require confirmation from the user.
- The Retry parameter specifies how often (in seconds) the Pushover servers will send the same notification to the user. This parameter must have a value of at least 30 seconds between retries.
- The Expire parameter specifies how many seconds your notification will continue to be retried for (every retry seconds). This parameter must have a maximum value of at most 10800 seconds (3 hours).
- If Priority is set to 2, by default Retry will be set to 30 seconds

- When notifications are enabled for Studio Mode and Scene Change, OBS triggers two scene change events when disabling Studio Mode which does send two Pushover notification.


## Disclaimer
I am not a developer by profession.
I usually just code things for personal use.
I've never worked with LUA before.
