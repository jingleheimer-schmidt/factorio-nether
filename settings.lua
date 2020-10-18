
local netherScale = {
  type = "int-setting",
  name = "nether-scale-setting",
  setting_type = "startup",
  default_value = 4,
  minimum_value = 2,
  maximum_value = 12,
  allowed_values = {
    2, 4, 6, 8, 10, 12
  }
}

data:extend({
  netherScale
})
