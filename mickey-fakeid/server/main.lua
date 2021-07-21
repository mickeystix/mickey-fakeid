--[[Made by Mickeystix with love <3]]
QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

--Code
RegisterServerEvent('mickey-fakeid:server:requestId')
AddEventHandler('mickey-fakeid:server:requestId', function(identityData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cashAmount = Player.Functions.GetItemByName('cash').amount
    local price = Config.Price

    if cashAmount >= price then
		Player.Functions.RemoveMoney('cash', price, "new-id")
        local gender = Player.PlayerData.charinfo.gender
        local info = {}
        if identityData.item == "driver_license" then
            info.firstname = fetchNames(gender, "firstname")
            info.lastname = fetchNames(gender, "lastname")
            info.birthdate = fetchBirthday()
            info.type = fetchType()
        end

        if info.firstname ~= nil and info.firstname ~= 'undefined' and info.lastname ~= nil and info.lastname ~= 'undefined' then
            Player.Functions.AddItem(identityData.item, 1, nil, info)

            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[identityData.item], 'add')
            TriggerClientEvent('mickey-fakeid:client:sendDriverEmail', src)
        else 
            TriggerClientEvent('QBCore:Notify', src, 'The printer ran into an issue - you have been refunded.', 'error')
            Player.Functions.AddMoney('cash', price, "new-id")
        end

        
	else
		TriggerClientEvent('QBCore:Notify', src, 'You need $' ..Config.Price.. ' to buy this.', 'error')
	end
end)

--Functions
function fetchType()
    local type = "A1-A2-A | AM-B | C1-C-CE"
    local select = math.random(1, 5)
    if select == 1 then
        type = "A1-A2-A | AMB | C1-C-C3"
    elseif select == 2 then
        type = "A1-A2-A | AMB | Ci-C-CE"
    elseif select == 3 then
        type = "A1-AZ-A | AMB | C1-C-CE"
    elseif select == 4 then
        type = "Ai-A2-A | AMB | C1-C-CE"
    elseif select == 5 then
        type = "A1-A2-A | ANB | C1-C-CE"
    end

    return type
end

function fetchNames(gender, nametype)

    if gender == 0 and nametype == "firstname" then
        local keyset = {}
        for k in pairs(Config.FNameMale) do
            table.insert(keyset, k)
        end
        -- now you can reliably return a random key
        name = Config.FNameMale[keyset[math.random(#keyset)]]
    
        return name
    elseif gender == 1 and nametype == "firstname" then
        local keyset = {}
        for k in pairs(Config.FNameFemale) do
            table.insert(keyset, k)
        end
        -- now you can reliably return a random key
        name = Config.FNameFemale[keyset[math.random(#keyset)]]
    
        return name
    elseif nametype == "lastname" then
        local keyset = {}
        for k in pairs(Config.LName) do
            table.insert(keyset, k)
        end
        -- now you can reliably return a random key
        name = Config.LName[keyset[math.random(#keyset)]]
    
        return name
    end
    Citizen.Wait(400)
end

function fetchBirthday()
    local bday = "1989-06-12"
    local year = tostring(math.random(1930,2000))
    local day = math.random(1,30)

    if day <=9 then
        day = tostring(day)
        day = ("0"..day.."")
    end

    month = math.random(1,12)

    if month <=9 then
        month = tostring(month)
        month = ("0"..month.."")
    end
    bday = (""..year.."-"..day.."-"..month.."")
    return bday
end