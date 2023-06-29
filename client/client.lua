ESX = exports["es_extended"]:getSharedObject()
local incarico = false
local tempo = false
local npckill = nil
local options = {
    {
        name = 'ox:option1',
        event = 'incarico:persona',
        icon = Config.Icon.ox,
        label = 'Chiedi Incarico',
    },
    {
        name = 'ox:option1',
        event = 'vendi:borsa',
        icon = Config.Icon.borsa,
        label = 'Vendi Borsa',
    },
}
local mission = { 
    Config.Ped.name
}
exports.ox_target:addModel(mission, options)
 
ydblip = AddBlipForCoord(Config.Blip.coords)
SetBlipSprite(ydblip, Config.Blip.sprite)
SetBlipScale(ydblip, Config.Blip.scale)
SetBlipColour(ydblip, Config.Blip.colour)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString(Config.Blip.name)
EndTextCommandSetBlipName(ydblip)

Citizen.CreateThread(function()
  if not HasModelLoaded(Config.Ped.name) then
     RequestModel(Config.Ped.name)
     while not HasModelLoaded(Config.Ped.name) do
        Citizen.Wait(5)
     end
  end

npc = CreatePed(4, Config.Ped.name, Config.Ped.coords, false, true)
FreezeEntityPosition(npc, true)
SetEntityInvincible(npc, true)
SetBlockingOfNonTemporaryEvents(npc, true)
end)
-------------------------------------------------------------------------------------------------
-----------------------------------FUNZIONI ILLEGAL MISSION ---------------------------------------
-------------------------------------------------------------------------------------------------
RegisterNetEvent('incarico:persona', function()
    ESX.ShowNotification("Raggiungi la posizione e uccidi la persona indicata!")
    ESX.Game.SpawnVehicle(Config.Veh.name, Config.Veh.coords, 92.4997, function(vehicle)
        incarico = SetNewWaypoint(Config.Blip.persona)
        blipincarico = AddBlipForCoord(Config.Blip.persona)
        SetBlipSprite (blipincarico, 310)
        SetBlipScale  (blipincarico, 0.8)
        SetBlipColour (blipincarico, 1)
        SetBlipAsShortRange(blipincarico, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Blip.nameinc)
        EndTextCommandSetBlipName(blipincarico)
    end)
    if not HasModelLoaded(Config.Ped.person) then
       RequestModel(Config.Ped.person)
       while not HasModelLoaded(Config.Ped.person) do
          Citizen.Wait(5)
       end
    end
    
    npckill = CreatePed(4, Config.Ped.person, Config.Ped.perscoords, false, true)
    FreezeEntityPosition(npckill, true)
    SetEntityInvincible(npckill, false)
    SetBlockingOfNonTemporaryEvents(npckill, true)
end)

RegisterNetEvent('vendi:borsa', function()
    local borsa = exports.ox_inventory:Search('count', Config.Item)
    if borsa >= 1 then
        if lib.progressCircle({
            duration = Config.Progress.vendi,
            label = 'Contando i Soldi Della Borsa',
            position = 'botton',
            useWhileDead = false,
            canCancel = true,
        }) then TriggerServerEvent('borsa', 1) end
        ESX.ShowNotification("Hai ricevuto "..Config.QuantitaRicevere.."$")
    else
        ESX.ShowNotification("Non hai borse da vendere")
    end
    RemoveBlip(blipincarico)
end)
-------------------------------------------------------------------------------------------------
-----------------------------------FUNZIONI ILLEGAL PERQUISIZIONE ---------------------------------------
-------------------------------------------------------------------------------------------------
local options = {
    {
        name = 'ox:option1',
        event = 'cerca:tasche',
        icon = Config.Icon.cerca,
        label = 'Cerca Nelle Tasche',
    },
}
local person = { 
    Config.Ped.person
}
exports.ox_target:addModel(person, options)

RegisterNetEvent('cerca:tasche', function()
    if not tempo then
        if IsEntityDead(npckill) then
            tempo = true
            if lib.progressCircle({
                duration = Config.Progress.cerca,
                label = 'Cercando nelle tasche...',
                position = 'botton',
                useWhileDead = false,
                canCancel = true,
                anim = {
                    dict = 'mini@repair',
                    clip = 'fixing_a_ped'
                },
            }) then TriggerServerEvent('cerca', 1) end
            ESX.ShowNotification("Hai trovato una "..Config.Item.." ora portala al gps impostato")
            SetNewWaypoint(Config.Blip.coords)
        else
            ESX.ShowNotification("Devi ucciderlo prima di cercargli nelle tasche")
        end
        Wait(Config.TempoAttesa) -- 30 MINUTI
        tempo = false
    else
        ESX.ShowNotification("Hai già cercato nelle sue tasche")
    end
end)