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
  integration_patch = {
    sheet = {
      filename = "__factorio-nether__/graphics/integration_patch_512_v2.png",
      width = 512,
      height = 512,
      frames = 1,
      scale = .5
    }
  },
  integration_patch_render_layer = "ground-patch-higher2",
  random_variation_on_create = "true",
  collision_box = {{-2, -2.5}, {2, 2.5}},
  collision_mask = {"item-layer", "object-layer", "water-tile"},
  selection_box = {{-2, -2.5}, {2, 2.5}},
  render_layer = "floor",
  map_color = {r=142, g=70, b=218}, -- don't define alpha
  remove_decoratives = "true",
  allow_copy_paste = "false",
  -- trigger_radius = 2,
  -- timeout = 230,
  -- action =
  -- {
  --   type = "direct",
  --   action_delivery =
  --   {
  --     type = "instant",
  --     target_effects =
  --     {
  --       {
  --         type = "script",
  --         effect_id = "into-portal"
  --       }
  --     }
  --   }
  -- },
  -- force_die_on_attack = false,
  -- trigger_force = "all",
  minable = {
    mining_time = 32,
    result = "nether-portal-item"
  },
  flage = {
    "placeable-neutral",
    "placeable-player",
    "player-creation",
    "not-upgradable",
    "no-copy-paste",
    "not-blueprintable"
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

local netherPortalLandmine = {
  type = "land-mine",
  name = "nether-portal-landmine",
  icon = "__base__/graphics/icons/land-mine.png",
  icon_size = 64, icon_mipmaps = 4,
  flags =
  {
    "placeable-player",
    "placeable-enemy",
    "player-creation",
    "placeable-off-grid",
    "not-on-map"
  },
  -- minable = {mining_time = 0.5, result = "land-mine"},
  -- mined_sound = { filename = "__core__/sound/deconstruct-small.ogg" },
  -- max_health = 15,
  -- corpse = "land-mine-remnants",
  -- dying_explosion = "land-mine-explosion",
  collision_box = {{-1, -1.5}, {1, 1.5}},
  -- selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  -- damaged_trigger_effect = hit_effects.entity(),
  -- open_sound = sounds.machine_open,
  -- close_sound = sounds.machine_close,
  picture_safe =
  {
    filename = "__base__/graphics/entity/land-mine/hr-land-mine.png",
    priority = "medium",
    width = 64,
    height = 64,
    scale = 0.5
  },
  picture_set =
  {
    filename = "__base__/graphics/entity/land-mine/hr-land-mine-set.png",
    priority = "medium",
    width = 64,
    height = 64,
    scale = 0.5
  },
  picture_set_enemy =
  {
    filename = "__base__/graphics/entity/land-mine/land-mine-set-enemy.png",
    priority = "medium",
    width = 32,
    height = 32
  },
  trigger_radius = 2,
  timeout = 230,
  ammo_category = "landmine",
  force_die_on_attack = "false",
  action =
  -- {
  --   -- runs the teleport script when landmine "explodes":
  --   type = "direct",
  --   action_delivery =
  --   {
  --     type = "instant",
  --     target_effects = {
  --       type = "script",
  --       effect_id = "portal-landmine-trigger"
  --       }
  --   }
  -- }
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      target_effects =
      -- {
      --   {
      --     type = "nested-result",
      --     affects_target = true,
      --     action =
      --     {
      --       type = "direct",
      --       action_delivery =
      --       {
      --         type = "instant",
      --         target_effects =
              {
                {
                  type = "create-sticker",
                  sticker = "nether-portal-landmine-sticker",
                  trigger_created_entity = true
                }
              }
      --       }
      --     }
      --   }
      -- }
    }
  }
}

local netherPortalLandmineSticker = {
  type = "sticker",
  name = "nether-portal-landmine-sticker",
  --icon = "__base__/graphics/icons/slowdown-sticker.png",
  flags = {},
  animation = util.empty_sprite(),
  duration_in_ticks = 1,
  --target_movement_modifier = 1
}

data:extend({
  netherPortal,
  netherPortalItem,
  netherPortalLandmine,
  netherPortalLandmineSticker
})
