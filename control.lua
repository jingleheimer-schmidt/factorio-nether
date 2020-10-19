
-- create "nether" surface the first time mod is loaded
script.on_init(function()
  game.create_surface("nether")
end)

-- -- every 120 ticks check if player is near portal, if yes then teleport
-- -- code modified from original by Bilka: https://github.com/Bilka2/Portals/blob/master/control.lua
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
-- -- code modified from original by Bilka: https://github.com/Bilka2/Portals/blob/master/control.lua
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

-- runs when landmine is armed
script.on_event(defines.events.on_land_mine_armed, function(mine)
  if mine.name == "nether-portal-landmine" then
    game.surfaces[mine.surface.name].play_sound{
      path = "trigger-sound",
      position = mine.position,
      volume_modifier = 1
    }
  end
end)

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
-- end)

script.on_event(defines.events.on_trigger_created_entity, function(event)
  local entity = event.entity
  if not (entity and entity.valid) then return end
  if entity.name ~= "nether-portal-landmine-sticker" then return end
  local source = event.source
  if not (source and source.valid) then return end
  local stuck_to = entity.sticked_to
  if not (stuck_to and stuck_to.valid) then return end
  local is_on_portal = is_on_portal(stuck_to)
  if is_on_portal == "yes" then
    into_portal(stuck_to)
  end
end)

-- creates landmine when portal is placed by player
script.on_event(defines.events.on_built_entity, function(event)
  if event.created_entity.name == "nether-portal" then
    game.surfaces[event.created_entity.surface.name].create_entity(
    {
      name = "nether-portal-landmine",
      position = event.created_entity.position
    })
  end
end)

-- creates landmine when portal is placed by robot
script.on_event(defines.events.on_robot_built_entity, function(event)
  if event.created_entity.name == "nether-portal" then
    game.surfaces[event.created_entity.surface.name].create_entity(
    {
      name = "nether-portal-landmine",
      position = event.created_entity.position
    })
  end
end)

-- destroys landmine when portal is mined by player
script.on_event(defines.events.on_player_mined_entity, function(event)
  if event.entity.name == "nether-portal" then
    local found_landmine = game.surfaces[event.entity.surface.name].find_entities_filtered(
      {
        position = event.entity.position,
        radius = 2,
        name = "nether-portal-landmine",
        limit = 1
      })
    if found_landmine[1] then
      found_landmine.destory()
    end
  end
end)

-- destroys landmine when portal is mined by robot
script.on_event(defines.events.on_robot_mined_entity, function(event)
  if event.entity.name == "nether-portal" then
    local found_landmine = game.surfaces[event.entity.surface.name].find_entities_filtered(
      {
        position = event.entity.position,
        radius = 2,
        name = "nether-portal-landmine",
        limit = 1
      })
    if found_landmine[1] then
      found_landmine.destory()
    end
  end
end)

-- is player on portal?
function is_on_portal(traveler)
  local nearby_portals = traveler.surface.find_entities_filtered(
  {
    position = traveler.position,
    radius = 2,
    name = "nether-portal",
    limit = 1
  })
  if nearby_portals[1] then
    local is_on_portal = "yes"
    return is_on_portal
  else
    local is_on_portal = "no"
    return is_on_portal
  end
end

-- teleport player through portal
function into_portal(traveler)
  local current_surface = traveler.surface
  if current_surface.name == "nauvis" then
    local destination_coordinates = calculate_coordinates(traveler)
    local destination_portal = find_portal(traveler, destination_coordinates)
    traveler.teleport(destination_portal.position, destination_portal.surface)
    game.surfaces[traveler.surface.name].play_sound{
      path = "travel-sound",
      position = player.position,
      volume_modifier = 1
    }
  elseif current_surface.name == "nether" then
    local destination_coordinates = calculate_coordinates(traveler)
    local destination_portal = find_portal(traveler, destination_coordinates)
    traveler.teleport(destination_portal.position, destination_portal.surface)
    game.surfaces[traveler.surface.name].play_sound{
      path = "travel-sound",
      position = player.position,
      volume_modifier = 1
    }
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
    return destination_coordinates
  elseif current_surface.name == "nether" then
    local destination_coordinates = {
      position = {
        x = traveler.position.x*nether_scale,
        y = traveler.position.y*nether_scale
      },
      surface = "nauvis"
    }
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
        return closest_portal
      else
        local new_portal = create_portal(traveler, destination_coordinates)
        return new_portal
      end
    else
      game.surfaces["nauvis"].request_to_generate_chunks(chunk_position, 3)
      game.surfaces["nauvis"].force_generate_chunk_requests()
      local new_portal = create_portal(traveler, destination_coordinates)
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
        return closest_portal
      else
        local new_portal = create_portal(traveler, destination_coordinates)
        return new_portal
      end
    else
      game.surfaces["nether"].request_to_generate_chunks(chunk_position, 3)
      game.surfaces["nether"].force_generate_chunk_requests()
      local new_portal = create_portal(traveler, destination_coordinates)
      return new_portal
    end
  end
end

-- create a new portal
function create_portal(traveler, destination_coordinates)
  if destination_coordinates.surface == "nauvis" then
    local new_portal_position = game.surfaces["nauvis"].find_non_colliding_position("nether-portal", destination_coordinates.position, 0, 1)
    local new_portal = game.surfaces["nauvis"].create_entity(
    {
      name = "nether-portal",
      position = new_portal_position,
      player = traveler
    })
    game.surfaces["nauvis"].create_entity(
    {
      name = "nether-portal-landmine",
      position = new_portal_position
    })
    return new_portal
  elseif destination_coordinates.surface == "nether" then
    local new_portal_position = game.surfaces["nether"].find_non_colliding_position("nether-portal", destination_coordinates.position, 0, 1)
    local new_portal = game.surfaces["nether"].create_entity(
    {
      name = "nether-portal",
      position = new_portal_position,
      player = traveler
    })
    game.surfaces["nether"].create_entity(
    {
      name = "nether-portal-landmine",
      position = new_portal_position
    })
    return new_portal
  end
end
