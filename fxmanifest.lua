fx_version 'adamant'
games { 'gta5' }

author 'Owen Bower Adams'
description 'Get out and push your damn vehicle'
version '0.1'

client_script {
    './src/table_helpers.lua',
    './config/config.lua',
    './src/vehicle.lua',
    './src/player.lua',
    './client/client.lua'
}

server_script {
 }