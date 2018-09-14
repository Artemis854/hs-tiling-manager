json = require('tools/json')

local API_KEY = 'b29287461ad523440ca98d0ec7d09882'
local API_PARAMS = '?maxInfos=10&key=' .. API_KEY
local API_HOST = 'https://drtonline.durhamregiontransit.com/webapi/departures/bystop/'

function show_bustimes(stopID, routes_to_check)
    hs.http.asyncGet(API_HOST .. tostring(stopID) .. API_PARAMS, nil, function(status, body, headers)
        routes = json.decode(body)
        stopName = routes['stopName']
        for k,v in ipairs(routes['departures']) do
            if hs.fnutils.contains(routes_to_check, v['route']) then
                hs.alert(v['route'] .. ': ' .. v['strTime'])
            end
        end
    end)
end