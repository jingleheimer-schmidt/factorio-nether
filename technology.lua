
local netherPortalTechnology = {
  type = "technology",
  name = "nether-portal-technology",
  icon = "__factorio-nether__/graphics/nether_portal_icon.png",
  icon_size = 904,
  unit = {
    count = 150,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1},
      -- {"chemical-science-pack", 1},
      {"military-science-pack", 1}
    },
    time = 30
  },
  prerequisites = {"steel-processing", "flamethrower", "concrete"},
  effects = {
    {
      type  = "unlock-recipe",
      recipe = "nether-portal-recipe"
    },
    {
      type  = "unlock-recipe",
      recipe = "obsidian-recipe"
    }
  }
}

data:extend({
  netherPortalTechnology,
})
