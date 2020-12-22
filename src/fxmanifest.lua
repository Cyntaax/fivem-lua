fx_version 'bodacious'

version  '1.1.1'

games { 'gta5' }

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua'
}

shared_scripts {
    'shared/*.lua'
}

