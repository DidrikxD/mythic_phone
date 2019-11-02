resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

name 'Mythic Phone'
description 'Custom Phone Written For Mythic Roleplay'
author 'Alzar - https://github.com/Alzar'
version 'v1.0.0'
url 'https://github.com/mythicrp/mythic_phone'

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/css/*.min.css',
	'ui/html/apps/*.html',
    
    'ui/js/build.js',

    'ui/libs/*.min.css',
    'ui/libs/*.min.js',

	'html/webfonts/*.eot',
	'html/webfonts/*.svg',
	'html/webfonts/*.ttf',
	'html/webfonts/*.woff',
	'html/webfonts/*.woff2',

    'ui/imgs/*.png',
}

client_script {
    'config/*.lua',
    'client/main.lua',
    'client/animation.lua',
    'client/settings.lua',
	'client/apps/*.lua',
}

server_script {
    'config/*.lua',
    'server/main.lua',
    'server/commands.lua',
	'server/apps/*.lua',
}

dependencies {
    'mythic_base',
    'mythic_inventory',
}