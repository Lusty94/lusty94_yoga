fx_version 'cerulean'

game 'gta5'

author 'Lusty94'

name "lusty94_yoga"

description 'Yoga Activity Script For QB Core'

version '2.0.0'

lua54 'yes'

client_script {
    'client/**.lua',
}


server_scripts { 
    'server/**.lua',
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