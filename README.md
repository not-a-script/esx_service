ESX Service with statebags

## Usage
```lua
-- Initialize the service for a specific job (server-side)
local service = exports.esx_service
-- Activate the service for "police" with a limit of 10 players who can be in service at the same time
service:ActivateService("police", 10)

-- Assign a player to the service
local playerSource = 1
-- Mark the player as being in service for the "police"
service:EnableServiceForPlayer(playerSource, "police")

-- Remove a player from the service
-- Mark the player as not being in service for the "police"
service:DisableServiceForPlayer(playerSource, "police")

-- Retrieve the number of players currently in service for a specific job
local serviceCount = service:GetInServiceCount("police")
print(serviceCount) -- Outputs the count of players in service

-- Send a notification to all players in a specific service
service:NotifyAllInService("police", "Emergency, go to Vinewood. Code-6")

-- Disable the service system for a specific job
service:DeactivateService("police")

-- Check if the player is in service (client-side)
local ply = LocalPlayer.state

if ply.inService then
    print("The player is in service.")
end
```
