--- Initialize service tracking tables
---@type table<string, number>
local MaxInService = {}

---Checks if the player's job matches the service they are trying to enable/disable
---@param serviceName string The name of the service
---@param playerSrc number The player's source ID
---@return boolean
local function checkJob(serviceName, playerSrc)
    local plyState = Player(playerSrc).state
    if serviceName ~= plyState.job.name then
        print("The player with the id " .. playerSrc .. " is trying to enable the service for the job " .. serviceName)
        return false
    end
    return true
end

-- Disable the service of a player when he change a job or drop from the server
---@param source number
local function onDrop(source)
    local plyState = Player(source).state
    local serviceName = plyState['inService']
    if serviceName then
        DisableServiceForPlayer(source, serviceName)
    end
end

--- Function to activate a service
---@param name string The name of the service
---@param max number The maximum number of players allowed in this service
function ActivateService(name, max)
    MaxInService[name] = max
    GlobalState['serviceCount_' .. name] = 0
end

--- Function to deactivate a service
--- This function will remove the service from the MaxInService tracking,
--- reset the service count in GlobalState, and optionally handle additional cleanup.
---@param name string The name of the service to be deactivated.
function DeactivateService(name)
    -- Remove the service from the MaxInService tracking
    MaxInService[name] = nil

    -- Reset the service count in GlobalState
    GlobalState['serviceCount_' .. name] = nil

    -- Perform additional cleanup related to the service deactivation
    -- Setting all players inService state for this service to nil
    for _, playerId in ipairs(GetPlayers()) do
        local plyState = Player(playerId).state
        if plyState['inService'] == name then
            plyState:set('inService', nil, true) -- Clear player's in-service state for this service
        end
    end

    -- Optionally notify players or log the service deactivation
    print("Service " .. name .. " has been deactivated.")
end

--- Function to enable service for a player. It returns true if the service was enabled successfully,
--- along with either the max count and the current count, or false and an error message if unsuccessful.
---@param playerSource number The player's source ID.
---@param serviceName string The name of the service to be enabled.
---@return boolean, number|string, number Whether the service was enabled, the max count or an error message, and the current count.
function EnableServiceForPlayer(playerSource, serviceName)
    local plyState = Player(playerSource).state
    local currentCount = GlobalState['serviceCount_' .. serviceName] or 0

    if currentCount < (MaxInService[serviceName] or 0) then
        if not checkJob(serviceName, playerSource) then 
            return false, "Invalid job for this service.", currentCount
        end
        plyState:set('inService', true, true) -- Mark player as in service.
        GlobalState['serviceCount_' .. serviceName] = currentCount + 1
        return true, MaxInService[serviceName], currentCount + 1
    else
        return false, "Service is full", currentCount
    end
end

--- Function to disable service for a player
---@param playerSource number The player's source ID
---@param serviceName string The name of the service to be disabled
function DisableServiceForPlayer(playerSource, serviceName)
    local plyState = Player(playerSource).state
    if plyState['inService'] == serviceName then
        plyState:set('inService', nil, true) -- Clear player's in-service state
        GlobalState['serviceCount_' .. serviceName] = math.max(0, (GlobalState['serviceCount_' .. serviceName] or 1) - 1)
    end
end

--- Function to notify all in-service players
---@param serviceName string The name of the service whose players should be notified
---@param notification string The notification message
function NotifyAllInService(serviceName, notification)
    for _, playerId in ipairs(GetPlayers()) do
        local plyState = Player(playerId).state
        if plyState['inService'] == serviceName then
            local playerId = tonumber(playerId) or 0
            TriggerClientEvent('esx_service:notify', playerId, notification)
        end
    end
end

--- Function to get in-service count
---@param serviceName string The name of the service
---@return number The number of players currently in service
function GetInServiceCount(serviceName)
    return GlobalState['serviceCount_' .. serviceName] or 0
end

-- Register service activation
RegisterServerEvent('esx_service:activateService')
AddEventHandler('esx_service:activateService', ActivateService)

-- Disable service event
RegisterServerEvent('esx_service:disableService')
AddEventHandler('esx_service:disableService', DisableServiceForPlayer)

-- Notify all in-service players event
RegisterServerEvent('esx_service:notifyAllInService')
AddEventHandler('esx_service:notifyAllInService', function(notification, name)
    NotifyAllInService(name, notification)
end)

-- Adjust service count on player drop
AddEventHandler('playerDropped', function()
    onDrop(source)
end)

RegisterNetEvent('esx:setJob', function(player, job, lastJob)
    onDrop(player.source)
end)

exports('ActivateService', ActivateService)
exports('DeactivateService', DeactivateService)
exports('EnableServiceForPlayer', EnableServiceForPlayer)
exports('DisableServiceForPlayer', DisableServiceForPlayer)
exports('NotifyAllInService', NotifyAllInService)
exports('GetInServiceCount', GetInServiceCount)