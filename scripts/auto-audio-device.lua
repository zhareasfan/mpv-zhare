local mp = require 'mp'


local auto_change = true
local av_map = {
    ["default"]      = "auto",
    ["DELL U2520D"]  = "coreaudio/AppleUSBAudioEngine:FiiO:DigiHug USB Audio:14300000:3", -- FiiO USB DAC-E10
    ["DELL U2312HM"] = "coreaudio/AppleUSBAudioEngine:FiiO:DigiHug USB Audio:14300000:3", -- FiiO USB DAC-E10
    ["SONY TV  *00"] = "coreaudio/AppleGFXHDAEngineOutputDP:10001:1:{D94D-8204-01010101}", -- HDMI 2
    ["Color LCD"]    = "coreaudio/AppleHDAEngineOutput:1B,0,1,1:0", -- Built-in
}

function set_audio_device(obs_display)
    if not auto_change then
        return
    end

    local display = obs_display or mp.get_property_native("display-names")
    if display == nil then
        return
    end
    if not display or not display[1] then
        print("Unknown display return value: " .. tostring(display))
        return
    end
    print("Display: " .. display[1])

    local new_adev = av_map[display[1]] or av_map["default"]
    local current_adev = mp.get_property("audio-device", av_map["default"])
    if new_adev ~= current_adev then
        mp.osd_message("Audio device: " .. new_adev)
        mp.set_property("audio-device", new_adev)
    end
end

mp.observe_property("display-names", "native", function(name, value) set_audio_device(value) end)
mp.add_key_binding("", "set-audio-device", function() set_audio_device(nil) end)
mp.add_key_binding("", "toggle-switching", function()
    if auto_change then
        set_audio_device({"default"})
    end
    auto_change = not auto_change
    mp.osd_message("Audio device switching: " .. tostring(auto_change))
end)
