local netherPortal = {
  type = "simple-entity",
  name = "nether-portal",
  icon = "__factorio-nether__/graphics/Nether_portal_squish.png",
  icon_size = 250,
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
        filename = "__factorio-nether__/graphics/portal_animation_block_32px.png",
        width = 32,
        height = 32,
        variation_count = 31,
        frame_count = 31,
        shift = {-.5, -1}, --top left
        scale = 1,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block_32px.png",
        width = 32,
        height = 32,
        variation_count = 31,
        frame_count = 31,
        shift = {.5, -1}, --top right
        scale = 1,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block_32px.png",
        width = 32,
        height = 32,
        variation_count = 31,
        frame_count = 31,
        shift = {-.5, 0}, --middle left
        scale = 1,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block_32px.png",
        width = 32,
        height = 32,
        variation_count = 31,
        frame_count = 31,
        shift = {.5, 0}, --middle right
        scale = 1,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block_32px.png",
        width = 32,
        height = 32,
        variation_count = 31,
        frame_count = 31,
        shift = {-.5, 1}, --bottom left
        scale = 1,
        animation_speed = .3
      },
      {
        filename = "__factorio-nether__/graphics/portal_animation_block_32px.png",
        width = 32,
        height = 32,
        variation_count = 31,
        frame_count = 31,
        shift = {.5, 1}, --bottom right
        scale = 1,
        animation_speed = .3
      }
    }
  },
  random_variation_on_create = "true",
  collision_box = {{-2, -2.5}, {2, 2.5}},
  collision_mask = {"item-layer", "object-layer", "water-tile"},
  selection_box = {{-2, -2.5}, {2, 2.5}},
  render_layer = "floor",
  map_color = {r=142, g=70, b=218}, -- don't define alpha
  remove_decoratives = "true",
  allow_copy_paste = "false",
  minable = {
    mining_time = 32,
    result = "nether-portal-item"
  },
  flage = {
    "placeable-player",
    "no-copy-paste"
  }
}

local netherPortalItem = {
  type = "item",
  name = "nether-portal-item",
  icon = "__factorio-nether__/graphics/Nether_portal_squish.png",
  icon_size = 250,
  stack_size = 1,
  place_result = "nether-portal"
}

data:extend({
  netherPortal,
  netherPortalItem
})
