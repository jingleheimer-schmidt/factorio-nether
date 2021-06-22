
local obsidian_recipe = {
  type = "recipe",
  name = "obsidian-recipe",
  category = "advanced-crafting",
  energy_required = 64,
  ingredients = {
    {type = "item", name = "refined-concrete", amount = 256},
    {type = "item", name = "stone", amount = 64},
    {type = "fluid", name = "steam", amount = 4096}
  },
  result = "obsidian",
  subgroup = "raw-material",
  order = "l[obsidian]", -- l ordering so it shows up after uranium-processing which is k ordering
  enabled = false,
}

local obsidianItem = {
  type = "item",
  name = "obsidian",
  icon = "__factorio-nether__/graphics/Obsidian_item_icon.png",
  icon_size = 300,
  stack_size = 64,
  -- place_result = "nether-portal"
}

-- local enderPearlRecipe = {
--     type = "recipe",
--     name = "enderpearl-recipe",
--     subgroup = "transport",
--     order = "b[personal-transport]-c[spidertron]-b[remote]-a[enderpearl]",
--     ingredients = {
--         {"grenade",1},
--         {"uranium-238",3},
--         {"electronic-circuit",2}
--     },
--     energy_required = .5,
--     result = "enderpearl",
--     enabled = "false"
-- }

data:extend({
  obsidian_recipe,
  obsidianItem,
})
