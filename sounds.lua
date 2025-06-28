
---@type data.SoundPrototype
local trigger = {
    name = "trigger-sound",
    type = "sound",
    filename = "__factorio-nether__/sounds/trigger.ogg",
    volume = 1
}

---@type data.SoundPrototype
local portal = {
    name = "portal-sound",
    type = "sound",
    filename = "__factorio-nether__/sounds/portal.ogg",
    volume = 1
}

---@type data.SoundPrototype
local travel = {
    name = "travel-sound",
    type = "sound",
    filename = "__factorio-nether__/sounds/travel.ogg",
    volume = 1
}

data:extend({
    trigger,
    portal,
    travel
})
