
---@param planet_name string
local function create_nether_portal(planet_name)
    ---@type data.SimpleEntityPrototype
    local netherPortal = {
        type = "simple-entity",
        name = planet_name .. "-nether-portal",
        icon = "__factorio-nether__/graphics/nether_portal_icon.png",
        icon_size = 904,
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
                    filename = "__factorio-nether__/graphics/portal_animation_block_16px.png",
                    width = 16,
                    height = 16,
                    variation_count = 31,
                    frame_count = 31,
                    shift = { -.5, -1 }, --top left
                    scale = 2,
                    animation_speed = .3
                },
                {
                    filename = "__factorio-nether__/graphics/portal_animation_block_16px.png",
                    width = 16,
                    height = 16,
                    variation_count = 31,
                    frame_count = 31,
                    shift = { .5, -1 }, --top right
                    scale = 2,
                    animation_speed = .3
                },
                {
                    filename = "__factorio-nether__/graphics/portal_animation_block_16px.png",
                    width = 16,
                    height = 16,
                    variation_count = 31,
                    frame_count = 31,
                    shift = { -.5, 0 }, --middle left
                    scale = 2,
                    animation_speed = .3
                },
                {
                    filename = "__factorio-nether__/graphics/portal_animation_block_16px.png",
                    width = 16,
                    height = 16,
                    variation_count = 31,
                    frame_count = 31,
                    shift = { .5, 0 }, --middle right
                    scale = 2,
                    animation_speed = .3
                },
                {
                    filename = "__factorio-nether__/graphics/portal_animation_block_16px.png",
                    width = 16,
                    height = 16,
                    variation_count = 31,
                    frame_count = 31,
                    shift = { -.5, 1 }, --bottom left
                    scale = 2,
                    animation_speed = .3
                },
                {
                    filename = "__factorio-nether__/graphics/portal_animation_block_16px.png",
                    width = 16,
                    height = 16,
                    variation_count = 31,
                    frame_count = 31,
                    shift = { .5, 1 }, --bottom right
                    scale = 2,
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
        random_variation_on_create = true,
        collision_box = { { -2, -2.5 }, { 2, 2.5 } },
        collision_mask = { layers = { item = true, object = true, water_tile = true } },
        selection_box = { { -2, -2.5 }, { 2, 2.5 } },
        render_layer = "floor",
        map_color = { r = 142, g = 70, b = 218 },
        remove_decoratives = "true",
        allow_copy_paste = false,
        working_sound =
        {
            sound =
            {
                filename = "__factorio-nether__/sounds/portal.ogg",
                volume = 0.75
            },
            audible_distance_modifier = 0.8,
            probability = 1 / (2 * 60), -- average pause between the sound is 2 seconds
            fade_in_ticks = 4,
            fade_out_ticks = 20
        },
        minable = {
            mining_time = 1,
            results = { { type = "item", name = planet_name .. "-nether-portal", amount = 1 } }
        },
        max_health = 64000,
        flags = {
            "placeable-neutral",
            "placeable-player",
            "player-creation",
            "not-upgradable",
            "no-copy-paste",
            "not-blueprintable",
            "not-deconstructable",
        },
        localised_name = { "entity-name.nether-portal", { "space-location-name." .. planet_name } },
        localised_description = { "entity-description.nether-portal", { "space-location-name." .. planet_name } },
        order = data.raw["planet"][planet_name].order,
    }
    if feature_flags["space_travel"] then
        local surface_property_name = planet_name .. "-nether-travel"
        ---@type data.SurfacePropertyPrototype
        local surface_property = {
            type = "surface-property",
            name = surface_property_name,
            default_value = 0,
            hidden = true,
            hidden_in_factoriopedia = true,
            localised_name = "",
            localised_unit_key = "",
            -- localised_name = { "entity-name.nether-portal", { "space-location-name." .. planet_name } },
            -- localised_unit_key = "surface-property-unit.nether-portal-surface-property",
        }
        netherPortal.surface_conditions = {
            {
                property = surface_property_name,
                min = 1,
                max = 1,
            }
        }
        data.raw["planet"][planet_name].surface_properties = data.raw["planet"][planet_name].surface_properties or {}
        data.raw["planet"][planet_name].surface_properties[surface_property_name] = 1
        data:extend({ surface_property })
    end
    ---@type data.ItemPrototype
    local netherPortalItem = {
        type = "item",
        name = planet_name .. "-nether-portal",
        icon = "__factorio-nether__/graphics/nether_portal_icon.png",
        icon_size = 904,
        stack_size = 1,
        place_result = planet_name .. "-nether-portal",
        subgroup = "space-related",
        order = data.raw["planet"][planet_name].order,
    }
    ---@type data.RecipePrototype
    local netherPortalRecipe = {
        type = "recipe",
        name = planet_name .. "-nether-portal",
        category = "advanced-crafting",
        energy_required = 64,
        ingredients = {
            { type = "item", name = "obsidian",          amount = 10 },
            { type = "item", name = "steel-plate",       amount = 1 },
            { type = "item", name = "flamethrower-ammo", amount = 1 }
        },
        results = { { type = "item", name = planet_name .. "-nether-portal", amount = 1 } },
        enabled = false,
    }
    ---@type data.TechnologyPrototype
    local netherPortalTechnology = {
        type = "technology",
        name = planet_name .. "-nether-portal",
        icon = "__factorio-nether__/graphics/nether_portal_icon.png",
        icon_size = 904,
        unit = {
            count = 150,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                -- {"chemical-science-pack", 1},
                { "military-science-pack",   1 }
            },
            time = 30
        },
        prerequisites = { "steel-processing", "flamethrower", "concrete" },
        effects = {
            {
                type   = "unlock-recipe",
                recipe = planet_name .. "-nether-portal"
            },
            {
                type   = "unlock-recipe",
                recipe = "obsidian-recipe"
            },
            {
                type   = "unlock-recipe",
                recipe = "lava-water-obsidian-recipe"
            }
        }
    }
    for _, tech in pairs(data.raw["technology"]) do
        if tech.effects then
            for _, effect in pairs(tech.effects) do
                if effect.type == "unlock-space-location" then
                    if effect.space_location == planet_name then
                        table.insert(netherPortalTechnology.prerequisites, tech.name)
                        break
                    end
                end
            end
        end
    end
    data:extend({
        netherPortal,
        netherPortalItem,
        netherPortalRecipe,
        netherPortalTechnology
    })
end

for _, planet in pairs(data.raw["planet"]) do
    local planet_name = planet.name
    if planet_name ~= "nether" then
        create_nether_portal(planet_name)
    end
end

---@type data.StickerPrototype
local netherPortalLandmineSticker = {
    type = "sticker",
    name = "nether-portal-landmine-sticker",
    --icon = "__base__/graphics/icons/slowdown-sticker.png",
    flags = {},
    animation = util.empty_sprite(),
    duration_in_ticks = 6,
    --target_movement_modifier = 1
    hidden = true,
    hidden_in_factoriopedia = true,
}

local dataRawPortalLandmine = util.table.deepcopy(data.raw["land-mine"]["land-mine"])
dataRawPortalLandmine.name = "nether-portal-landmine"
dataRawPortalLandmine.max_health = 99999
dataRawPortalLandmine.force_die_on_attack = false
dataRawPortalLandmine.trigger_radius = 1.25
-- dataRawPortalLandmine.trigger_force = "all"
dataRawPortalLandmine.timeout = 0
dataRawPortalLandmine.picture_safe = util.empty_sprite()
dataRawPortalLandmine.picture_set = util.empty_sprite()
dataRawPortalLandmine.picture_set_enemy = util.empty_sprite()
dataRawPortalLandmine.action = {
    type = "direct",
    action_delivery = {
        type = "instant",
        target_effects = {
            {
                type = "create-sticker",
                sticker = "nether-portal-landmine-sticker",
                trigger_created_entity = true
            }
        }
    }
}

---@type data.AnimationPrototype
local portalParticleAnimation = {
    name = "nether-portal-particle-animation",
    type = "animation",
    filename = "__factorio-nether__/graphics/particles/nether_portal_particles.png",
    size = 8,
    scale = 4,
    frame_count = 8,
    animation_speed = 1 / 8,
    tint = { r = 161, g = 52, b = 235, a = .5 },
    draw_as_glow = true
}

---@type data.ParticlePrototype
local portalOptimizedParticle = {
    name = "nether-portal-optimized-particle",
    type = "optimized-particle",
    pictures = {
        filename = "__factorio-nether__/graphics/particles/nether_portal_particles.png",
        size = 8,
        scale = 4,
        frame_count = 8,
        animation_speed = 1 / 8,
        tint = { r = 161, g = 52, b = 235, a = .5 },
        -- draw_as_glow = true
    },
    life_time = 64,
}

---@type data.TrivialSmokePrototype
local portalTrivialSmokeParticles = {
    name = "nether-portal-trivial-smoke-particles",
    type = "trivial-smoke",
    animation = {
        filename = "__factorio-nether__/graphics/particles/nether_portal_particles.png",
        size = 8,
        scale = 1.5,
        frame_count = 8,
        animation_speed = 1 / 4,
        tint = { r = 161, g = 52, b = 235, a = 10 },
    },
    duration = 512,
    cyclic = true,
    affected_by_wind = false,
    show_when_smoke_off = false,
    fade_in_duration = 128,
    fade_away_duration = 256
}

---@type data.ParticleSourcePrototype
local portalParticleSource = {
    name = "nether-portal-particle-source",
    type = "particle-source",
    height = .1,
    -- height_deviation = .5,
    horizontal_speed = .25,
    horizontal_speed_deviation = .5,
    time_before_start = 0,
    time_to_live = 240,
    vertical_speed = .075,
    icon = "__factorio-nether__/thumbnail.png",
    icon_size = 250,
    -- particle = "nether-portal-optimized-particle",
    smoke = { {
        name = "nether-portal-trivial-smoke-particles",
        -- frequency = .25,
        -- height_deviation = 1,
        -- -- offset = 1,
        north_position = { 0, -1 },
        east_position = { 1, 0 },
        south_position = { 0, 1 },
        west_position = { -1, 0 },
        frequency = 0.25, --0.25,
        position = { 0.0, 0 }, -- -0.8},
        starting_frame_deviation = 30,
        starting_vertical_speed = 0.025,
        starting_vertical_speed_deviation = 0.01,
        vertical_speed_slowdown = 1, -- 0.99
    } },
}


data:extend({
    dataRawPortalLandmine,
    netherPortalLandmineSticker,
    portalParticleAnimation,
    portalOptimizedParticle,
    portalTrivialSmokeParticles,
    portalParticleSource
})
