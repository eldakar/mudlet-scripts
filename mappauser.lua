eld.mappauser = eld.mappauser or {
    triggers = {},
    state = {}
}

function eld.mappauser:check_for_paralyzed()
    local own_data = gmcp.objects.data[tostring(ateam.my_id)]
    if own_data and own_data.paralyzed ~= nil then
        self:toggle(own_data.paralyzed)
    end
    if own_data and own_data.editing ~= nil then
        self:toggle(own_data.editing)
    end
end

function eld.mappauser:toggle(state)
    if state then
        self:on()
    else
        self:off()
    end
end

function eld.mappauser:on()
    if scripts.character.bind_paralysis_breaker == true then
        scripts.utils.bind_functional("przestan", silent)
    end
    eld.mappauser:dim_map_on()
end

function eld.mappauser:off()
    eld.mappauser:dim_map_off()
end

function eld.mappauser:dim_map_on()
    testlabel = Geyser.Label:new({
        name = "dimmedMapLabel",
        x = "0", y = "0",
        width = "100%", height = "100%",
    },scripts.ui.bottom)

    --name = "scripts.ui.bottom",
    testlabel:setColor(100,0,0,80)
end

function eld.mappauser:dim_map_off()
    if testlabel then
        testlabel:hide()
    end
end


function eld.mappauser:clear_state()
    self.state = {}
end

function eld.mappauser:init()
    self.handler_data  = scripts.event_register:register_singleton_event_handler(self.handler_data, "gmcp.objects.data", function() self:check_for_paralyzed() end)
end

eld.mappauser:init()
