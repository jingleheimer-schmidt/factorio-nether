local netherPortal = {
  type = "simple-entity",
  name = "nether-portal",
  icon = "__factorio-nether__/graphics/Nether_portal_squish.png",
  icon_size = 150,
  animations = {
    sheets = {
      {
        filename = "__factorio-nether__/graphics/portal_frame_variations_block.png",
        width = 64,
        height = 80,
        variation_count = 31,
        frame_count = 31,
        scale = 2,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block.png",
        width = 16,
        height = 16,
        variation_count = 31,
        frame_count = 31,
        shift = {-.5, -1}, --top left
        scale = 2,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block.png",
        width = 16,
        height = 16,
        variation_count = 31,
        frame_count = 31,
        shift = {.5, -1}, --top right
        scale = 2,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block.png",
        width = 16,
        height = 16,
        variation_count = 31,
        frame_count = 31,
        shift = {-.5, 0}, --middle left
        scale = 2,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block.png",
        width = 16,
        height = 16,
        variation_count = 31,
        frame_count = 31,
        shift = {.5, 0}, --middle right
        scale = 2,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block.png",
        width = 16,
        height = 16,
        variation_count = 31,
        frame_count = 31,
        shift = {-.5, 1}, --bottom left
        scale = 2,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block.png",
        width = 16,
        height = 16,
        variation_count = 31,
        frame_count = 31,
        shift = {.5, 1}, --bottom right
        scale = 2,
        animation_speed = .3
      }
    }
  },
  random_variation_on_create = "true",
  collision_box = {{-2, -2.5}, {2, 2.5}},
  collision_mask = {"item-layer", "object-layer", "water-tile"},
  selection_box = {{-2, -2.5}, {2, 2.5}}
}

data:extend({
  netherPortal
})
