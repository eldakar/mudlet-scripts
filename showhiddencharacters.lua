eld.showhiddencharacters = eld.showhiddencharacters or {
  triggers = {},
  state = {}
}


function eld.showhiddencharacters:highlight_state()
    for k, v in pairs(ateam.team) do
        if ateam.objs[k] and ateam.objs[k]["hidden"] then
            if ateam.my_id == k then
                scripts.ui.window_modify(scripts.ui.states_window_name, ateam.options.own_name, scripts.ui.window_modifiers.surround("[", "]"))  
            else
                scripts.ui.window_modify(scripts.ui.states_window_name, ateam.objs[k]["desc"], scripts.ui.window_modifiers.surround("[", "]"))
            end
        end
    end
end


function eld.showhiddencharacters:clear_state()
  self.state = {}
end

function eld.showhiddencharacters:init()
  self.statesHandler = scripts.event_register:register_singleton_event_handler(self.statesHandler, "printStatusDone", function() self:highlight_state() end)
end

eld.showhiddencharacters:init()
