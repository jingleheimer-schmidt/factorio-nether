
require("util")

local lava_tile_deepcopy = util.table.deepcopy(data.raw.tile["water"])
lava_tile_deepcopy.name = "lava"
-- lava_tile_deepcopy.layer = data.raw.tile.water.layer
lava_tile_deepcopy.variants.main = {
  {
    picture = "__factorio-nether__/graphics/nether_lava_1x1.png",
    count = 10,
    size = 1,
    x = 0,
    y = 0,
    -- line_length = 16,

    -- hr_version = {
    --   picture = "__factorio-nether__/graphics/lava/hr-lava1.png",
    --   count = 8,
    --   scale = 0.5,
    --   size = 1,
    -- },
  },
  -- {
  --   picture = "__factorio-nether__/graphics/nether_lava_2x2.png",
  --   count = 10,
  --   size = 2,
  --   x = 0,
  --   y = 0,
  --   -- line_length = 16,
  --
  --   -- hr_version = {
  --   --   picture = "__factorio-nether__/graphics/lava/hr-lava1.png",
  --   --   count = 8,
  --   --   scale = 0.5,
  --   --   size = 1,
  --   -- },
  -- },
  -- {
  --   picture = "__factorio-nether__/graphics/nether_lava_4x4.png",
  --   count = 10,
  --   size = 4,
  --   x = 0,
  --   y = 0,
  --   -- line_length = 16,
  --
  --   -- hr_version = {
  --   --   picture = "__factorio-nether__/graphics/lava/hr-lava1.png",
  --   --   count = 8,
  --   --   scale = 0.5,
  --   --   size = 1,
  --   -- },
  -- },
  -- {
  --   picture = "__factorio-nether__/graphics/lava/lava1.png",
  --   count = 8,
  --   size = 1,
  --   hr_version = {
  --     picture = "__factorio-nether__/graphics/lava/hr-lava1.png",
  --     count = 8,
  --     scale = 0.5,
  --     size = 1,
  --   },
  -- },
  -- {
  --   picture = "__factorio-nether__/graphics/lava/lava2.png",
  --   count = 8,
  --   size = 2,
  --   hr_version = {
  --     picture = "__factorio-nether__/graphics/lava/hr-lava2.png",
  --     count = 8,
  --     scale = 0.5,
  --     size = 2,
  --   },
  -- },
  -- {
  --   picture = "__factorio-nether__/graphics/lava/lava4.png",
  --   count = 8,
  --   size = 4,
  --   hr_version =
  --   {
  --     picture = "__factorio-nether__/graphics/lava/hr-lava4.png",
  --     count = 8,
  --     scale = 0.5,
  --     size = 4,
  --   },
  -- },
}
lava_tile_deepcopy.map_color = {239, 83, 18, }
lava_tile_deepcopy.pollution_absorption_per_second = -0.05
lava_tile_deepcopy.effect = "water"
lava_tile_deepcopy.effect_color = {239, 83, 18, 155}
lava_tile_deepcopy.effect_color_secondary = {255, 208, 0, }
lava_tile_deepcopy.effect_is_opaque = false
lava_tile_deepcopy.autoplace.default_enabled = false
-- lava_tile_deepcopy.autoplace.tile_restriction = {"nether", }
-- lava_tile_deepcopy.layer_group = "water"
-- lava_tile_deepcopy.draw_in_water_layer = true
-- lava_tile_deepcopy.draw_in_water_layer = false
-- data.raw.tile.water.effect_color = {255, 80, 0, }
-- lava_tile_deepcopy.variants.inner_corner_mask = nil
-- lava_tile_deepcopy.variants.outer_corner_mask = nil
-- lava_tile_deepcopy.variants.side_mask = nil
-- lava_tile_deepcopy.variants.u_transition_mask = nil
-- lava_tile_deepcopy.variants.o_transition_mask = nil
-- lava_tile_deepcopy.variants.material_background = nil
--

-- local lava_tile = {
--   name = "lava",
--   type = "tile",
--   collision_mask = {
--     -- same as water tile:
--     "water-tile",
--     "item-layer",
--     "resource-layer",
--     "player-layer",
--     "doodad-layer"
--   },
--   layer = 64,
--   variants = {
--     main = {
--       {
--         picture = "__factorio-nether__/graphics/lava/lava1.png",
--         count = 1,
--         size = 1,
--         hr_version = {
--           picture = "__factorio-nether__/graphics/lava/hr-lava1.png",
--           count = 1,
--           scale = 0.5,
--           size = 1,
--         },
--       },
--       {
--         picture = "__factorio-nether__/graphics/lava/lava2.png",
--         count = 1,
--         size = 2,
--         hr_version = {
--           picture = "__factorio-nether__/graphics/lava/hr-lava2.png",
--           count = 1,
--           scale = 0.5,
--           size = 2,
--         },
--       },
--       {
--         picture = "__factorio-nether__/graphics/lava/lava4.png",
--         count = 1,
--         size = 4,
--         hr_version =
--         {
--           picture = "__factorio-nether__/graphics/lava/hr-lava4.png",
--           count = 1,
--           scale = 0.5,
--           size = 4,
--         },
--       },
--     },
--     empty_transitions = true,
--   },
--   transitions = { water_to_out_of_map_transition },
--   map_color={r=239, g=83, b=18},
--   pollution_absorption_per_second = -0.05,
-- }

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
        end
      end
    end
  end
end


data:extend({
  -- lava_tile,
  lava_tile_deepcopy,
})
log(serpent.block(data.raw.tile.lava))