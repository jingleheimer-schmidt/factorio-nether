
-- CREATE "NETHER" SURFACE THE FIRST TIME MOD IS LOADED
script.on_init(function()
  -- OPTIONAL DEPENDENCY/SUPPORT FOR ALIEN BIOMES AT SOME POINT?
  -- CUSTOMIZE VANILLA WORLD GEN, MAYBE DESERT ONLY? NO TREES OR WATER
  local nether_settings = game.surfaces["nauvis"].map_gen_settings
  local nether_scale = settings.startup["nether-scale-setting"].value
  nether_settings.width = nether_settings.width / nether_scale
  nether_settings.height = nether_settings.height / nether_scale
  nether_settings.seed = math.random(0, 2394967295)
  -- 0 to 4,294,967,295
  -- nether_settings.water = 0
  -- nether_settings.property_expression_names["tile:water:probability"] = -1000
  -- nether_settings.property_expression_names["tile:deepwater:probability"] = -1000
  -- nether_settings.property_expression_names["tile:water-green:probability"] = -1000
  -- nether_settings.property_expression_names["tile:deepwater-green:probability"] = -1000
  -- nether_settings.property_expression_names["tile:water-shallow:probability"] = -1000
  -- nether_settings.property_expression_names["tile:water-mud:probability"] = -1000
  -- -- these two might not work... tbd
  nether_settings.property_expression_names["temperature"] = 150
  nether_settings.property_expression_names["moisture"] = 0
  -- for a,b in pairs(data.raw.tile) do
  --   if not (string.find(b.name, "volcanic") or string.find(b.name, "hot")) then
  --     local temp = "tile:" .. b.name .. ":probability"
  --     nether_settings.property_expression_names[temp] = -1000
  --   end
  -- end
  game.create_surface("nether", nether_settings)
end)

script.on_event(defines.events.on_chunk_generated, function(event)
  if event.surface and event.surface.name == "nether" then
    local chunk_area = event.area
    local chunk_position = event.position
    local surface = event.surface
    local water_tiles = surface.find_tiles_filtered({area = chunk_area, name = {"water", "water-mud", "water-shallow", "water-green", "deepwater", "deepwater-green"}})
    if water_tiles then
      local lava_tiles = {}
      for each, water_tile in pairs(water_tiles) do
        local data = {
          name = "lava",
          position = water_tile.position
        }
        table.insert(lava_tiles, data)
      end
      surface.set_tiles(lava_tiles)
      local fishies = surface.find_entities_filtered({area = chunk_area, type = "fish"})
      for each, fish in pairs(fishies) do
        fish.die()
      end
    end
  end
end)

script.on_event(defines.events.on_trigger_created_entity, function(event)
-- MAKE SURE THE ENTITY WHO GOT STICKERED IS PLAYER CHARACTER
  -- game.print(game.tick .. "landmine created entity")
  -- if not event.entity and event.entity.sticked_to then
  --   return
  -- elseif not (event.entity.sticked_to.type and event.entity.sticked_to.type == "character") then
  --   -- game.print("entity is not character")
  --   return
-- MMAKE SURE CREATED ENTITY WAS THE PORTAL STICKER
  if event.entity.name == "nether-portal-landmine-sticker" then
    -- game.print("trigger created entity was not landmine sticker")
  --   return
  -- end
    -- game.print(game.tick .. "landmine triggered")
    local player = event.entity.sticked_to.player
  -- DON'T DO ANYTHING IF PLAYER JUST TELEPORTED RECENTLY
    -- game.print(game.tick .. "landmine triggered")
    if global.teleport_cooldown then
      if global.teleport_cooldown[player.index] then
        -- game.print("cooldown active, no sound, no trigger")
        return
      end
    end
  -- DON'T DO ANYTHING IF PLAYER IS ALREADY ABOUT TO TELEPORT SOON
    if global.teleport_soon then
      if global.teleport_soon[player.index] then
        -- game.print("global.teleport_soon already exists, no sound no trigger")
        return
      end
    end
    player.surface.play_sound{
      path = "trigger-sound",
      position = player.position,
      volume_modifier = .7
    }
    spawn_particle_cloud(player.surface, player.position)
    -- pre_teleport_surface_preparation(player)
    -- game.print("trigger sound played")
  -- STORE DATA IN GLOBAL SO ON_TICK CAN TELEPORT PLAYER SOON
    if not global.teleport_soon then
      global.teleport_soon = {}
      global.teleport_soon[player.index] = {
        player = player,
        tick = event.tick + 220
      }
      -- game.print("global.teleport_soon set")
    else
      global.teleport_soon[player.index] = {
        player = player,
        tick = event.tick + 220
      }
      -- game.print("global.teleport_soon set")
    end
  end
end)

function fiery_lava()
  for each, player in pairs(game.connected_players) do
  -- local player = game.get_player(event.player_index)
    if player.character then
      local lava_tiles = player.surface.find_tiles_filtered({area = player.character.bounding_box, name = "lava"})
      if lava_tiles[1] then
        -- game.print("catch player on fire")
        local fire = {
          -- name = "fire-flame",
          -- name = "fire-flame-on-tree",
          name = "fire-sticker",
          position = player.position,
          -- direction,
          force = "enemy",
          target = player.character,
          -- source,
          -- fast_replace,
          -- player,
          -- spill,
          raise_built = true,
          create_build_effect_smoke = true,
          spawn_decorations = true,
          move_stuck_players = false,
          -- item,
          initial_ground_flame_count = 3,
        }
        player.surface.create_entity(fire)
      end
    end
  end
end

script.on_event(defines.events.on_tick, function()
  if global.teleport_soon then
    for a,b in pairs(global.teleport_soon) do
      -- game.print("global.teleport_soon exists")
      if b.tick == game.tick then
        -- game.print("it's the teleport tick!")
        local player = b.player
        if player.valid and player.connected then
          -- game.print("player is valid and connected")
          if is_on_portal(player) == "yes" then
            into_portal(player)
            if not global.teleport_cooldown then
              global.teleport_cooldown = {}
              global.teleport_cooldown[player.index] = {
                cooldown_until = game.tick + 420,
                player = player
              }
              -- game.print("global.teleport_cooldown set")
              global.teleport_soon[a] = nil
            else
              global.teleport_cooldown[player.index] = {
                cooldown_until = game.tick + 420,
                player = player
              }
              -- game.print("global.teleport_cooldown set")
              global.teleport_soon[a] = nil
            end
          else
            -- game.print("not on portal, didn't teleport, cleared global.teleport_soon")
            global.teleport_soon[a] = nil
          end
        end
      end
    end
    if next(global.teleport_soon) == nil then
      global.teleport_soon = nil
      -- game.print("global.teleport_soon cleared")
    end
  end
  if global.teleport_cooldown then
    for a,b in pairs(global.teleport_cooldown) do
      -- game.print(b.cooldown_until .. " teleport cooldown active")
      if b.cooldown_until == game.tick then
        global.teleport_cooldown[a] = nil
        -- game.print("teleport cooldown ended")
      end
    end
    if next(global.teleport_cooldown) == nil then
      global.teleport_cooldown = nil
      -- game.print("global.teleport_cooldown cleared")
    end
  end
  fiery_lava()
end)

-- is player on portal?
function is_on_portal(traveler)
  local nearby_portals = traveler.surface.find_entities_filtered(
  {
    position = traveler.position,
    -- radius = 2,
    name = "nether-portal",
    limit = 1
  })
  if nearby_portals[1] then
    local is_on_portal = "yes"
    -- game.print("player is on portal")
    return is_on_portal
  else
    local is_on_portal = "no"
    -- game.print("player is not on portal")
    return is_on_portal
  end
end

function spawn_particle_cloud(surface, position)
  for i = 1, 32 do
    local random_1 = math.random(-2.500, 2.500)
    local random_2 = math.random(-2.500, 2.500)
    local new_position = {
      x = position.x + random_1,
      y = position.y + random_2
    }
    surface.create_trivial_smoke({
      name = "nether-portal-trivial-smoke-particles",
      position = new_position
    })
  end
end

function pre_teleport_surface_preparation(traveler)
  local destination_coordinates = calculate_coordinates(traveler)
  if destination_coordinates.surface == "nauvis" then
    local chunk_position = {
      x = destination_coordinates.position.x/32,
      y = destination_coordinates.position.y/32
    }
    if not game.surfaces["nauvis"].is_chunk_generated(chunk_position) then
      game.surfaces["nauvis"].request_to_generate_chunks(destination_coordinates.position, 1)
    end
  elseif destination_coordinates.surface == "nether" then
    local chunk_position = {
      x = destination_coordinates.position.x/32,
      y = destination_coordinates.position.y/32
    }
    if not game.surfaces["nether"].is_chunk_generated(chunk_position) then
      game.surfaces["nether"].request_to_generate_chunks(destination_coordinates.position, 1)
    end
  end
end

-- teleport player through portal
function into_portal(traveler)
  local current_surface = traveler.surface
  if current_surface.name == "nauvis" then
    local destination_coordinates = calculate_coordinates(traveler)
    local destination_portal = find_portal(traveler, destination_coordinates)
    -- game.print("traveling from nauvis to nether")
    traveler.teleport(destination_portal.position, destination_portal.surface)
    traveler.surface.play_sound{
      path = "travel-sound",
      position = traveler.position,
      volume_modifier = .7
    }
    -- traveler.surface.create_trivial_smoke({
    --   name = "nether-portal-trivial-smoke-particles",
    --   position = traveler.position
    -- })
    spawn_particle_cloud(traveler.surface, traveler.position)
    -- traveler.surface.create_entity(
    -- {
    --   name = "nether-portal-particle-source",
    --   position = traveler.position
    -- })
    -- traveler.surface.create_particle(
  --   traveler.surface.create_trivial_smoke(
  --   {
  --     name = "nether-portal-trivial-smoke-particles",
  --     position = traveler.position,
  --     -- movement = {1,1},
  --     -- height = 1,
  --     -- vertical_speed = .25,
  --     -- frame_speed = 1,
  --   }
  -- )
  elseif current_surface.name == "nether" then
    local destination_coordinates = calculate_coordinates(traveler)
    local destination_portal = find_portal(traveler, destination_coordinates)
    -- game.print("traveling from nether to nauvis")
    traveler.teleport(destination_portal.position, destination_portal.surface)
    traveler.surface.play_sound{
      path = "travel-sound",
      position = traveler.position,
      volume_modifier = .7
    }
    -- traveler.surface.create_trivial_smoke({
    --   name = "nether-portal-trivial-smoke-particles",
    --   position = traveler.position
    -- })
    spawn_particle_cloud(traveler.surface, traveler.position)
  end
end

-- calculate coordinates
function calculate_coordinates(traveler)
  local current_surface = traveler.surface
  local nether_scale = settings.startup["nether-scale-setting"].value
  if current_surface.name == "nauvis" then
    local destination_coordinates = {
      position = {
        x = traveler.position.x/nether_scale,
        y = traveler.position.y/nether_scale
      },
      surface = "nether"
    }
    -- game.print("calculated coordinates")
    -- game.print("from: "..serpent.block(traveler.position))
    -- game.print("to: "..serpent.block(destination_coordinates))
    return destination_coordinates
  elseif current_surface.name == "nether" then
    local destination_coordinates = {
      position = {
        x = traveler.position.x*nether_scale,
        y = traveler.position.y*nether_scale
      },
      surface = "nauvis"
    }
    -- -- game.print("calculated coordinates")
    -- game.print("from: "..serpent.block(traveler.position))
    -- game.print("to: "..serpent.block(destination_coordinates))
    return destination_coordinates
  end
end

-- find closest portal or call to create new one
function find_portal(traveler, destination_coordinates)
  if destination_coordinates.surface == "nauvis" then
    local chunk_position = {
      x = destination_coordinates.position.x/32,
      y = destination_coordinates.position.y/32
    }
    if game.surfaces["nauvis"].is_chunk_generated(chunk_position) then
      local found_portals = game.surfaces["nauvis"].find_entities_filtered(
      {
        position = destination_coordinates.position,
        radius = 96,
        name = "nether-portal"
      })
      if found_portals[1] then
        local closest_portal = game.surfaces["nauvis"].get_closest(destination_coordinates.position, found_portals)
        -- game.print("found a portal on nauvis!")
        return closest_portal
      else
        local new_portal = create_portal(traveler, destination_coordinates)
        -- game.print("no portal found on nauvis, created new one!")
        return new_portal
      end
    else
      game.surfaces["nauvis"].request_to_generate_chunks(destination_coordinates.position, 2)
      game.surfaces["nauvis"].force_generate_chunk_requests()
      local new_portal = create_portal(traveler, destination_coordinates)
      -- game.print("no portal found on nauvis, created new one!")
      return new_portal
    end
  elseif destination_coordinates.surface == "nether" then
    local chunk_position = {
      x = destination_coordinates.position.x/32,
      y = destination_coordinates.position.y/32
    }
    if game.surfaces["nether"].is_chunk_generated(chunk_position) then
      local found_portals = game.surfaces["nether"].find_entities_filtered(
      {
        position = destination_coordinates.position,
        radius = 96,
        name = "nether-portal"
      })
      if found_portals[1] then
        local closest_portal = game.surfaces["nether"].get_closest(destination_coordinates.position, found_portals)
        -- game.print("found a portal in the nether!")
        return closest_portal
      else
        local new_portal = create_portal(traveler, destination_coordinates)
        -- game.print("no portal found in the nether, created new one!")
        return new_portal
      end
    else
      game.surfaces["nether"].request_to_generate_chunks(destination_coordinates.position, 2)
      game.surfaces["nether"].force_generate_chunk_requests()
      local new_portal = create_portal(traveler, destination_coordinates)
      -- game.print("no portal found in the nether, created new one!")
      return new_portal
    end
  end
end

-- create a new portal
function create_portal(traveler, destination_coordinates)
  if destination_coordinates.surface == "nauvis" then
    local new_portal_position = game.surfaces["nauvis"].find_non_colliding_position("nether-portal", destination_coordinates.position, 0, 1, true)
    game.surfaces["nauvis"].create_entity(
    {
      name = "nether-portal-landmine",
      position = new_portal_position,
      player = traveler
    })
    local new_portal = game.surfaces["nauvis"].create_entity(
    {
      name = "nether-portal",
      position = new_portal_position,
      player = traveler
    })
    return new_portal
  elseif destination_coordinates.surface == "nether" then
    local new_portal_position = game.surfaces["nether"].find_non_colliding_position("nether-portal", destination_coordinates.position, 0, 1, true)
    game.surfaces["nether"].create_entity(
    {
      name = "nether-portal-landmine",
      position = new_portal_position,
      player = traveler
    })
    local new_portal = game.surfaces["nether"].create_entity(
    {
      name = "nether-portal",
      position = new_portal_position,
      player = traveler
    })
    return new_portal
  end
end

-- build a special lava version of the offshore-pump if it's placed on a lava tile
function build_lava_pump(event)
  local original_pump = event.created_entity
  -- local player_index = event.player_index
  local surface = original_pump.surface
    -- log("searching for lava tiles")
  -- local found_lava = original_pump.surface.find_tiles_filtered({position = original_pump.position, radius = 2, name = "lava"})
  local found_lava = original_pump.surface.find_tiles_filtered({area = original_pump.bounding_box, name = "lava"})
  -- log(serpent.block(found_lava))
  if found_lava[1] then
    -- log("found lava tiles")
    local lava_pump_data = {
      name = "offshore-lava-pump",
      surface = original_pump.surface,
      position = original_pump.position,
      force = original_pump.force,
      direction = original_pump.direction,
      player = original_pump.last_user,
      raise_built = true,
      create_build_effect_smoke = false,
      move_stuck_players = true
    }
    original_pump.destroy()
    -- log("original pump destroyed")
    surface.create_entity(lava_pump_data)
    -- log("placed lava pump")
  end
end

-- creates landmine when portal is placed by player
script.on_event(defines.events.on_built_entity, function(event)
  -- game.print("player built entity")
  if event.created_entity.name == "nether-portal" then
    event.created_entity.surface.create_entity(
    {
      name = "nether-portal-landmine",
      position = event.created_entity.position
    })
    -- rendering.draw_animation{
    --   animation = "nether-portal-particle-animation",
    --   target = event.created_entity,
    --   surface = event.created_entity.surface
    -- }
    -- game.print("landmine built (player placed portal)")
    -- event.created_entity.surface.create_entity(
    -- {
    --   name = "nether-portal-particle-source",
    --   position = event.created_entity.position
    -- })
  elseif event.created_entity.name == "offshore-pump" then
    build_lava_pump(event)
  end
end)

script.on_event(defines.events.script_raised_built, function(event)
  if event.entity.name == "offshore-pump" then
    local data = {}
    data.created_entity = event.entity
    build_lava_pump(data)
  end
end)

-- creates landmine when portal is placed by robot
script.on_event(defines.events.on_robot_built_entity, function(event)
  if event.created_entity.name == "nether-portal" then
    event.created_entity.surface.create_entity(
    {
      name = "nether-portal-landmine",
      position = event.created_entity.position
    })
    -- game.print("landmine built (robot placed portal)")
  elseif event.created_entity.name == "offshore-pump" then
    build_lava_pump(event)
  end
end)

-- destroys landmine when portal is mined by player
script.on_event(defines.events.on_player_mined_entity, function(event)
  if event.entity.name == "nether-portal" then
    local found_landmine = event.entity.surface.find_entities_filtered(
      {
        position = event.entity.position,
        -- radius = 1,
        name = "nether-portal-landmine",
        limit = 1
      })
      -- game.print("landmine found (player mined portal)")
    if found_landmine[1] then
      found_landmine[1].destroy()
      -- game.print("landmine destroyed (player mined portal)")
    end
  end
end)

-- destroys landmine when portal is mined by robot
script.on_event(defines.events.on_robot_mined_entity, function(event)
  if event.entity.name == "nether-portal" then
    local found_landmine = event.entity.surface.find_entities_filtered(
      {
        position = event.entity.position,
        -- radius = 1,
        name = "nether-portal-landmine",
        limit = 1
      })
      -- game.print("landmine found (robot mined portal)")
    if found_landmine[1] then
      found_landmine[1].destroy()
      -- game.print("landmine destroyed (robot mined portal)")
    end
  end
end)

-- destroys landmine when portal is killed
script.on_event(defines.events.on_entity_died, function(event)
  if event.entity.name == "nether-portal" then
    local found_landmine = event.entity.surface.find_entities_filtered(
      {
        position = event.entity.position,
        -- radius = 1,
        name = "nether-portal-landmine",
        limit = 1
      })
      -- game.print("landmine found (robot mined portal)")
    if found_landmine[1] then
      found_landmine[1].destroy()
      -- game.print("landmine destroyed (robot mined portal)")
    end
  end
end)

-- -- runs when landmine is armed
-- script.on_event(defines.events.on_land_mine_armed, function(mine)
--   if mine.name == "nether-portal-landmine" then
--     game.print("landmine armed, playing portal-trigger sound")
--     game.surfaces[mine.surface.name].play_sound{
--       path = "trigger-sound",
--       position = mine.position,
--       volume_modifier = 1
--     }
--   end
-- end)

-- script.on_event(defines.events.on_trigger_created_entity, function(event)
--   if event.entity.name == "nether-portal-landmine-sticker" then
--     game.print("sticker placed on player")
--     event.entity.surface.play_sound{
--       path = "trigger-sound",
--       position = event.entity.position,
--       volume_modifier = 1
--     }
--     game.print("trigger sound played")
--     local registration_number = script.register_on_entity_destroyed(event.entity)
--     game.print("reg # = " .. registration_number)
--   end
-- end)
--
-- script.on_event(defines.events.on_entity_destroyed, function(event)
--   game.print("entity destroyed, reg # = " .. event.registration_number)
-- end)
--
-- script.on_nth_tick(5, function()
--   if game.get_player("asher_sky").character.stickers then
--     for a,b in pairs(game.get_player("asher_sky").character.stickers) do
--       game.print(a .. b.name)
--     end
--   end
-- end)

-- -- runs when nether portal landmine sticker is created/attached to player
-- script.on_event(defines.events.on_trigger_created_entity, function(event)
--   local entity = event.entity
--   if not (entity and entity.valid) then return end
--   if entity.name ~= "nether-portal-landmine-sticker" then return end
--   game.print("landmine sticker placed on player")
--   local source = event.source
--   if not (source and source.valid) then return end
--   local traveler = entity.sticked_to.player
--   if not (traveler and traveler.valid) then return end
--   local is_on_portal = is_on_portal(traveler)
--   if is_on_portal == "yes" then
--     into_portal(traveler)
--   end
-- end)

-- -- every 120 ticks check if player is near portal, if yes then teleport
-- script.on_nth_tick(120, function()
--   for _, player in pairs(game.connected_players) do
--     if player.character and not player.vehicle then
--       local is_on_portal = is_on_portal(player)
--       if is_on_portal == "yes" then
--         into_portal(player)
--       end
--     end
--   end
-- end)

-- -- every 120 ticks check if player is near portal, if yes then teleport
-- script.on_nth_tick(10, function()
--   for _, player in pairs(game.connected_players) do
--     if player.character and not player.vehicle then
--       local is_on_portal = is_on_portal(player)
--       if is_on_portal == "yes" then
--         does_landmine_exist = find_landmine(player)
--         if does_landmine_exist == "no" then
--           create_landmine(player)
--           game.surfaces[player.surface.name].play_sound{
--             path = "trigger-sound",
--             position = player.position,
--             volume_modifier = 1
--           }
--         -- script.on_event(defines.events.on_tick(), function(event)
--         --   if event.tick == teleport_tick then
--         --   into_portal(player)
--         --   end
--         -- end)
--       end
--     end
--   end
-- end)

-- -- check if landmine already exists
-- function find_landmine(player)
--   local landmine = game.surfaces[player.surface.name].find_entities_filtered(
--     {
--       position = player.position,
--       radius = 2,
--       name = "nether-portal-landmine"
--     })
--   if landmine[1] then
--     local found_landmine = "yes"
--     return found_landmine
--   else
--     local found_landmine = "no"
--     return found_landmine
--   end
-- end

-- -- create landmine
-- function create_landmine(player)
--   game.surfaces[player.surface.name].create_entity(
--   {
--     name = "nether-portal-landmine",
--     position = player.position
--   })
-- end

-- -- runs when player sets off portal land mine
-- script.on_event(defines.events.on_script_trigger_effect, function(event)
--   -- checks if script is triggered by an enderpearl
--   if event.effect_id == "portal-landmine-trigger" then
--     local traveler = event.target_entity
--     local is_on_portal = is_on_portal(traveler)
--     if is_on_portal == "yes" then
--       into_portal(traveler)
--     end
--   end
-- -- end)
