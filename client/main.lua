RegisterNetEvent('esx_service:notify', function(notification)
	local playerPed = PlayerPedId()
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(playerPed)

	ESX.ShowAdvancedNotification(notification.title, notification.subject, notification.msg, mugshotStr, notification.iconType)
	UnregisterPedheadshot(mugshot)
end)