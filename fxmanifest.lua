fx_version 'cerulean'

game 'gta5'
lua54 'yes'
author 'ESX / Edited By Space V'
use_experimental_fxv2_oal 'yes'
description 'ESX Service'

version '1.0'
legacyversion '1.9.1'

shared_script '@es_extended/imports.lua'

server_scripts {
	'server/main.lua',
	'server/callbacks.lua'
}

client_scripts {
	'client/main.lua'
}

dependency 'es_extended'