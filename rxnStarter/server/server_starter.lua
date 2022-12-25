ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterNetEvent("rxn:starterpack")
AddEventHandler("rxn:starterpack", function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local identifier = xPlayer.identifier

    for k,v in pairs(Config.Demarrage.itemsGive) do
        xPlayer.addInventoryItem(v.name, v.count)
    end
    xPlayer.addMoney(Config.Demarrage.Moneycount)
    MySQL.Async.fetchAll('SELECT '..Config.coinTableName..' FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function (result)
        MySQL.Async.execute("UPDATE `users` SET `"..Config.coinTableName.."` = '".. result[1].coin + Config.Demarrage.Coin .."' WHERE `identifier` = '"..identifier.."'", {}, function() end)
    end)
    sendToDiscordWithSpecialURL("Pack Démarrage", xPlayer.getName().." à récupérer son pack", 2061822, Config.weebhook)
end)

local function getDate()
    return os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min
end

function sendToDiscordWithSpecialURL(name,message,color,url)
    local DiscordWebHook = url
	local embeds = {
		{
			["title"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= getDate(),
			},
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('rxn:getplayerstarter', function(source, cb)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	local identifier = xPlayer.identifier
    local starter = false
    MySQL.Async.fetchAll(
        'SELECT identifier FROM rxn_starter WHERE identifier = @identifier',
        {
          ['@identifier'] = identifier,
        },
          function(res)
            if res[1] then
                starter = true
            else
                starter = false
            end
            
            cb(starter)
    end
        )
end)

RegisterNetEvent("rxn:validhavepack")
AddEventHandler("rxn:validhavepack", function(info)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
	local identifier = xPlayer.identifier
    MySQL.Async.execute('INSERT INTO rxn_starter (identifier, starter) VALUES (@identifier, @starter)', {
        ['@identifier'] = identifier,
        ['@starter'] = info,
    })
end)