RegisterNetEvent("esx_service:activateService", function(jobName, count)
    if (source) then
        print(("Player with the id: %s is trying to execute the event activateService."):format(source))
        return
    end
    ActivateService(jobName, count)
end)


--- Enable a service for a player. Callback for backward compatibility.
---@param source number The player's source ID.
---@param cb function The callback function to return the result.
---@param serviceName string The name of the service to be enabled.
ESX.RegisterServerCallback('esx_service:enableService', function(source, cb, serviceName)
    local enabled, maxOrMessage, count = EnableServiceForPlayer(source, serviceName)
    if enabled then
        cb(true, count) -- On success, return true and the current count
    else
        cb(false, maxOrMessage) -- On failure, return false and the error message
    end
end)

--- Check if a player is currently in a service. Callback for backward compatibility.
---@param source number The player's source ID.
---@param cb function The callback function to return the result.
---@param serviceName string The name of the service to check.
ESX.RegisterServerCallback('esx_service:isInService', function(source, cb, serviceName)
    local plyState = Player(source).state
    local isInService = plyState['inService'] == serviceName
    cb(isInService)
end)

--- Disable a service for a player. Callback for backward compatibility.
--- Integrate this functionality as needed based on your system's design.
--- There is no direct callback example for disabling a service since it typically doesn't require a response,
--- but ensure any necessary cleanup or state update is communicated to clients as needed.

--- Get the count of players in a service. Callback for backward compatibility.
---@param source number The player's source ID (unused here but required for callback structure).
---@param cb function The callback function to return the result.
---@param serviceName string The name of the service to get the count for.
ESX.RegisterServerCallback('esx_service:getServiceCount', function(source, cb, serviceName)
    local serviceCount = GetInServiceCount(serviceName)
    cb(serviceCount)
end)