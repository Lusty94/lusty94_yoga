fx_version 'cerulean'

game 'gta5'

author 'Lusty94'

name "lusty94_yoga"

description 'Yoga Activity Script For QB Core'

version '1.0.0'

lua54 'yes'

client_script {
    'client/yoga_client.lua',
    'shared/targets.lua',
}


server_scripts { 
    'server/yoga_server.lua',
}


shared_scripts { 
	'shared/config.lua',
    '@ox_lib/init.lua'
}

escrow_ignore {
    'client/**.lua',
    'server/**.lua',
    'shared/**.lua',
}