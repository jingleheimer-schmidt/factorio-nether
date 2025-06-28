
local collision_mask_util = require("collision-mask-util")
local layer = collision_mask_util.get_first_unused_layer()

for a,b in pairs(data.raw.tile["lava"].collision_mask) do
  if b == "player-layer" then
    collision_mask_util.remove_layer(data.raw.tile["lava"].collision_mask, b)
    -- table.remove(data.raw.tile["lava"].collision_mask, a)
  end
  collision_mask_util.add_layer(data.raw.tile["lava"].collision_mask, layer)
end

for a,b in pairs(data.raw["unit"]) do
  local mask = collision_mask_util.get_mask(b)
  collision_mask_util.add_layer(mask, layer)
  b.collision_mask = mask
end

for a,b in pairs(data.raw["car"]) do
  local mask = collision_mask_util.get_mask(b)
  collision_mask_util.add_layer(mask, layer)
  b.collision_mask = mask
end

for a,b in pairs(data.raw["spider-vehicle"]) do
  local mask = collision_mask_util.get_mask(b)
  collision_mask_util.add_layer(mask, layer)
  b.collision_mask = mask
end

for a,b in pairs(data.raw["spider-leg"]) do
  local mask = collision_mask_util.get_mask(b)
  collision_mask_util.add_layer(mask, layer)
  b.collision_mask = mask
end
