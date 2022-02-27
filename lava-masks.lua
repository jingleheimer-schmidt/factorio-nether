
local collision_mask_util = require("collision-mask-util")
local layer = collision_mask_util.get_first_unused_layer()

for a,b in pairs(data.raw.tile["lava"].collision_mask) do
  if b == "player-layer" then
    table.remove(data.raw.tile["lava"].collision_mask, a)
    collision_mask_util.add_layer(data.raw.tile["lava"].collision_mask, layer)
  end
end

for a,b in pairs(data.raw["unit"]) do
  if b.collision_mask then
    collision_mask_util.add_layer(data.raw["unit"][a].collision_mask, layer)
  else
    data.raw["unit"][a].collision_mask = {}
    collision_mask_util.add_layer(data.raw["unit"][a].collision_mask, layer)
  end
end

for a,b in pairs(data.raw["car"]) do
  if b.collision_mask then
    collision_mask_util.add_layer(data.raw["car"][a].collision_mask, layer)
  else
    data.raw["car"][a].collision_mask = {}
    collision_mask_util.add_layer(data.raw["car"][a].collision_mask, layer)
  end
end

for a,b in pairs(data.raw["spider-vehicle"]) do
  if b.collision_mask then
    collision_mask_util.add_layer(data.raw["spider-vehicle"][a].collision_mask, layer)
  else
    data.raw["spider-vehicle"][a].collision_mask = {}
    collision_mask_util.add_layer(data.raw["spider-vehicle"][a].collision_mask, layer)
  end
end

for a,b in pairs(data.raw["spider-leg"]) do
  if b.collision_mask then
    collision_mask_util.add_layer(data.raw["spider-leg"][a].collision_mask, layer)
  else
    data.raw["spider-leg"][a].collision_mask = {}
    collision_mask_util.add_layer(data.raw["spider-leg"][a].collision_mask, layer)
  end
end
