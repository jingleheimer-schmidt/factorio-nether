local netherPortal = {
  type = "simple-entity",
  name = "nether-portal",
  icon = "__factorio-nether__/graphics/Nether_portal_squish.png",
  icon_size = 150,
  picture = {
    filename = "__factorio-nether__/graphics/Nether_portal_squish.png",
    width = 150,
    height = 150
  },
  collision_box = {{-2, -2}, {2, 2}}
}

data:extend({
  netherPortal
})
