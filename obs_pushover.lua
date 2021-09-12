-- MIT License
--
-- Copyright (c) Ruvann Beukes
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--
-- Released on GitHub by Ruvann Beukes

obs = obslua
settings = {}

-- Script hook for defining the script description
function script_description()
    return [[
Send a pushover notification on successful events in OBS Studio.
The Pushover notification "Title" is the current OBS Profile.

- Sound: Optional (E.g.: bike, magic, siren) - https://pushover.net/api#sounds
- Device: Name of device to receive the notification. Empty = All devices
- Priority: Optional (-2,-1,0,1,2  = Low, Moderate, Normal, High, Emergency). Default = Normal
- Emergency Priority Retry: How often (in seconds) the same notification will be sent. Min value of 30 or greater.
- Emergency Priority Expire: How many seconds the notification will continue to be retried for (every retry seconds). Max value of 10800 seconds (3 hours) or less.
]]
end

-- Script settings
function script_properties()
    local props = obs.obs_properties_create()

    obs.obs_properties_add_text(props, "user_key", "User Key", obs.OBS_TEXT_PASSWORD)
    obs.obs_properties_add_text(props, "app_token", "App API Token", obs.OBS_TEXT_PASSWORD)
    obs.obs_properties_add_int_slider(props, "priority", "Pushover Priority", -2, 2, 1)
    obs.obs_properties_add_text(props, "sound", "Pushover Sound", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "device", "Pushover Device", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_int(props, "retry", "Emergency Priority Retry", 30, 10800, 1)
    obs.obs_properties_add_int(props, "expire", "Emergency Priority Expire", 0, 10800, 1)

    obs.obs_properties_add_bool(props, "scene_change", "Scene Change")
    obs.obs_properties_add_bool(props, "stream_started", "Stream Started")
    obs.obs_properties_add_bool(props, "stream_stopped", "Stream Stopped")
    obs.obs_properties_add_bool(props, "recording_started", "Recording Started")
    obs.obs_properties_add_bool(props, "recording_stopped", "Recording Stopped")
    obs.obs_properties_add_bool(props, "recording_paused", "Recording Paused")
    obs.obs_properties_add_bool(props, "recording_unpaused", "Recording Unpaused")
    obs.obs_properties_add_bool(props, "buffer_started", "Replay Buffer Started")
    obs.obs_properties_add_bool(props, "buffer_stopped", "Replay Buffer Stopped")
    obs.obs_properties_add_bool(props, "vcam_started", "Virtual Cam Started")
    obs.obs_properties_add_bool(props, "vcam_stopped", "Virtual Cam Stopped")
    obs.obs_properties_add_bool(props, "scene_col_changed", "Scene Collection Changed")
    obs.obs_properties_add_bool(props, "profile_changed", "Profile Changed")
    obs.obs_properties_add_bool(props, "program_exit", "Program Exit")
    obs.obs_properties_add_bool(props, "studio_enabled", "Studio Mode Enabled")
    obs.obs_properties_add_bool(props, "studio_disabled", "Studio Mode Disabled")

    return props
end

-- Update settings
function script_update(_settings)
    settings = _settings
end

function script_load(settings)
    obs.obs_frontend_add_event_callback(handle_event)
end

-- Events to listen for and send notifications for
function handle_event(event)
    obs.script_log(obs.LOG_INFO, event)
    if (event == obs.OBS_FRONTEND_EVENT_SCENE_CHANGED) and
            (obs.obs_data_get_bool(settings, "scene_change") == true) then
        local scene_ref = obs.obs_frontend_get_current_scene()
        local scene_name = obs.obs_source_get_name(scene_ref)
        local message = "Scene change - " .. scene_name
        pushover(message)
    end

    if (event == obs.OBS_FRONTEND_EVENT_STREAMING_STARTED) and
            (obs.obs_data_get_bool(settings, "stream_started") == true) then
        pushover("Streaming started")
    end

    if (event == obs.OBS_FRONTEND_EVENT_STREAMING_STOPPED) and
            (obs.obs_data_get_bool(settings, "stream_stopped") == true) then
        pushover("Streaming stopped")
    end

    if (event == obs.OBS_FRONTEND_EVENT_RECORDING_STARTED) and
            (obs.obs_data_get_bool(settings, "recording_started") == true) then
        pushover("Recording started")
    end

    if (event == obs.OBS_FRONTEND_EVENT_RECORDING_STOPPED) and
            (obs.obs_data_get_bool(settings, "recording_stopped") == true) then
        pushover("Recording stopped")
    end

    if (event == obs.OBS_FRONTEND_EVENT_RECORDING_PAUSED) and
            (obs.obs_data_get_bool(settings, "recording_paused") == true) then
        pushover("Recording paused")
    end

    if (event == obs.OBS_FRONTEND_EVENT_RECORDING_UNPAUSED) and
            (obs.obs_data_get_bool(settings, "recording_unpaused") == true) then
        pushover("Recording unpaused")
    end

    if (event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_STARTED) and
            (obs.obs_data_get_bool(settings, "buffer_started") == true) then
        pushover("Replay Buffer started")
    end

    if (event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_STOPPED) and
            (obs.obs_data_get_bool(settings, "buffer_stopped") == true) then
        pushover("Replay Buffer stopped")
    end

    if (event == obs.OBS_FRONTEND_EVENT_VIRTUALCAM_STARTED) and
            (obs.obs_data_get_bool(settings, "vcam_started") == true) then
        pushover("Virtual Cam started")
    end

    if (event == obs.OBS_FRONTEND_EVENT_VIRTUALCAM_STOPPED) and
            (obs.obs_data_get_bool(settings, "vcam_stopped") == true) then
        pushover("Virtual Cam stopped")
    end

    if (event == obs.OBS_FRONTEND_EVENT_SCENE_COLLECTION_CHANGED) and
            (obs.obs_data_get_bool(settings, "scene_col_changed") == true) then
        local scence_col_ref = obs.obs_frontend_get_current_scene_collection()
        local scene_col_name = obs.obs_source_get_name(scence_col_ref)
        local message = "Scene Collection change - " .. scene_col_name
        pushover(message)
    end

    if (event == obs.OBS_FRONTEND_EVENT_PROFILE_CHANGED) and
            (obs.obs_data_get_bool(settings, "profile_changed") == true) then
        pushover("Profile changed")
    end

    if (event == obs.OBS_FRONTEND_EVENT_EXIT) and
            (obs.obs_data_get_bool(settings, "program_exit") == true) then
        pushover("Program is exiting")
    end

    if (event == obs.OBS_FRONTEND_EVENT_STUDIO_MODE_ENABLED) and
            (obs.obs_data_get_bool(settings, "studio_enabled") == true) then
        pushover("Studio Mode Enabled")
    end

    if (event == obs.OBS_FRONTEND_EVENT_STUDIO_MODE_DISABLED) and
            (obs.obs_data_get_bool(settings, "studio_disabled") == true) then
        pushover("Studio Mode Disabled")
    end
end

function pushover(message)
    local title = obs.obs_frontend_get_current_profile()
    local sound = string.lower(obs.obs_data_get_string(settings, "sound"))
    local device = obs.obs_data_get_string(settings, "device")
    local user_key = obs.obs_data_get_string(settings, "user_key")
    local app_token = obs.obs_data_get_string(settings, "app_token")
    local priority = obs.obs_data_get_int(settings, "priority")
    local retry = obs.obs_data_get_int(settings, "retry")
    local expire = obs.obs_data_get_int(settings, "expire")
    local command = 'curl --data "token=' .. app_token .. '&user=' .. user_key .. '&title=' .. title .. '&message=' .. message .. '&priority=' .. priority .. '&sound=' .. sound .. '&device=' .. device .. '" https://api.pushover.net/1/messages.json'

    if priority == 2
    then
        --[[ If Retry is not altered after adding the script, "obs_properties_add_int" initially sets its value to 0.
        Check added here to ensure a min value is correct otherwise curl fails]]
        if retry < 30
        then
            retry = 30
        end
        command = 'curl --data "token=' .. app_token .. '&user=' .. user_key .. '&title=' .. title .. '&message=' .. message .. '&priority=' .. priority .. '&retry=' .. retry .. '&expire=' .. expire .. '&sound=' .. sound .. '&device=' .. device .. '" https://api.pushover.net/1/messages.json'
    end

    obs.script_log(obs.LOG_INFO, title .. ", " .. message)
    obs.script_log(obs.LOG_INFO, command:gsub(user_key, "***"):gsub(app_token, "***"))

    f = assert(io.popen(command))
    for line in f:lines() do
        obs.script_log(obs.LOG_INFO, line)
    end
    f:close()

end
