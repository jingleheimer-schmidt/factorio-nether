local function is_water_variant(array)
  local output = false
  local variants = {
    "water",
    "water-shallow",
    "deepwater",
    "water-mud",
    "water-green",
    "deepwater-green",
  }
  for a,b in pairs(array) do
    for c,d in pairs(variants) do
      if b == d then
        output = true
      end
    end
  end
  return output
end

for a,b in pairs(data.raw.tile) do
  if b.transitions then
    for c,d in pairs(b.transitions) do
      if d.to_tiles then
        if is_water_variant(d.to_tiles) then
          table.insert(data.raw.tile[a].transitions[c].to_tiles, "lava")
        elseif mods["alien-biomes"] and not b.name == "lava" then
          table.insert(data.raw.tile[a].transitions[c].to_tiles, "lava")
        end
      end
    end
  end
  if b.transitions_between_transitions then
    for c,d in pairs(b.transitions_between_transitions) do
      if d.to_tiles then
        if is_water_variant(d.to_tiles) then
          table.insert(data.raw.tile[a].transitions_between_transitions[c].to_tiles, "lava")
        elseif mods["alien-biomes"] and not b.name == "lava" then
          table.insert(data.raw.tile[a].transitions_between_transitions[c].to_tiles, "lava")
        end
      end
    end
  end
end

if data.raw.tile["water"] then
  data.raw.tile["lava"].layer = data.raw.tile["water"].layer
end
data.raw.tile["lava"].effect = "water"
-- data.raw.tile["lava"].effect_color = {239, 83, 18, 155}
data.raw.tile["lava"].effect_color = {239, 83, 18, 165}
data.raw.tile["lava"].effect_color_secondary = nil -- pollution shader color
data.raw.tile["lava"].effect_is_opaque = false
