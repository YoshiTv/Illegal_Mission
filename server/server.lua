ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("borsa", function(item)
    exports.ox_inventory:RemoveItem(source, Config.Item, item, false, false)
    exports.ox_inventory:AddItem(source, 'BLACK_MONEY', Config.QuantitaRicevere, false, false)
end)

RegisterServerEvent("cerca", function(item)
    exports.ox_inventory:AddItem(source, 'BORSA', Config.BorsaRicevere, false, false)
end)