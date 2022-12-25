
ESX = nil

local utiliser = nil

Citizen.CreateThread(function()

        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)

        while ESX == nil do Citizen.Wait(0) end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()

	local startermap = AddBlipForCoord(Config.Blips)

	SetBlipSprite(startermap, 586)
	SetBlipColour(startermap, 47)
	SetBlipScale(startermap, 0.8)
	SetBlipAsShortRange(startermap, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString("Starter Pack")
	EndTextCommandSetBlipName(startermap)
end)


function MenuStarter()
    local MainMenu = RageUI.CreateMenu("Menu Arrivée", "rDev")
    MainMenu:SetRectangleBanner(11, 11, 11, 0)
	        RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))
            while MainMenu do
            Wait(0)

RageUI.IsVisible(MainMenu, true, true, true, function()
    RageUI.Separator("~s~ →→ ~b~ Votre ID : ~y~"..GetPlayerServerId(PlayerId())..' ~s~←←')
    RageUI.Separator("~s~ →→ ~b~ Votre Nom : ~y~"..GetPlayerName(PlayerId())..' ~s~←←')

    if utiliser == false then
        RageUI.ButtonWithStyle("Pack Démarrage", Config.Demarrage.descriptionM, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if (Selected) then
                TriggerServerEvent('rxn:starterpack')
                TriggerServerEvent('rxn:validhavepack', 1)
                ESX.ShowAdvancedNotification("rdev", "Pack Démarrage", "Vous avez reçu : ~r~votre pack", 'CHAR_MP_FM_CONTACT', 1)
                ESX.ShowAdvancedNotification("rdev", "Pack Démarrage", "Contient : ~b~ 300 crédit, 3000€, 5 Pains et eaux", 'CHAR_MP_FM_CONTACT', 1)
                utiliser = true
            end
        end)
    else
        RageUI.Separator("")
        RageUI.Separator("→→ ~r~Vous avez déjà pris votre pack ~s~←←")
        RageUI.Separator("")
    end
end, function()
end)
    if not RageUI.Visible(MainMenu) then
        MainMenu = RMenu:DeleteType("MainMenu", true)
    end
end
end



Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plyPos = GetEntityCoords(PlayerPedId())
        local dist = #(plyPos-Config.PosMenu)
        if dist <= 10.0 then
         Timer = 0
         DrawMarker(22, Config.PosMenu, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
        end
        if dist <= 3.0 then
            Timer = 0
            RageUI.Text({ message = "Appuyez sur ~r~[E]~s~ pour prendre votre pack", time_display = 1 })
            if IsControlJustPressed(1,51) then
                ESX.TriggerServerCallback('rxn:getplayerstarter', function(starter)
                    utiliser = starter
                    MenuStarter()
                end)
            end
         end
    Citizen.Wait(Timer)
    end
end)