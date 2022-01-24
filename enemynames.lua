eld.enemynames = eld.enemynames or {
  triggers = {},
  state = {}
}

function scripts.ui.window_modifiers.creplace(strTo)
  return function(windowName, position, text)
      moveCursor(windowName, position.x, position.y)
      creplace(windowName, strTo)
      moveCursor(windowName, 1, position.y)
  end
end

function scripts.ui.window_modifiers.replace(strTo)
  return function(windowName, position, text)
      moveCursor(windowName, position.x, position.y)
      replace(windowName, strTo, true)
      moveCursor(windowName, 1, position.y)
  end
end

function eld.enemynames:highlight_state()

    for k, v in pairs(ateam.team_enemies) do
      display(k)
      local tmp_nick = ""
      -- TODO: max width moved to cfg
      if scripts.utils.real_len(ateam.objs[k]["desc"]) > 8 then
        tmp_nick = string.sub(ateam.objs[k]["desc"], scripts.utils.real_len(ateam.objs[k]["desc"])-8, scripts.utils.real_len(ateam.objs[k]["desc"]))

        
        scripts.ui.window_modify(scripts.ui.states_window_name, ateam.objs[k]["desc"], scripts.ui.window_modifiers.surround("", tmp_nick))
        scripts.ui.window_modify(scripts.ui.states_window_name, ateam.objs[k]["desc"], scripts.ui.window_modifiers.replace(""))
      end

    end

end


function eld.enemynames:clear_state()
  self.state = {}
end

function eld.enemynames:init()
  self.statesHandler = scripts.event_register:register_singleton_event_handler(self.statesHandler, "printStatusDone", function() self:highlight_state() end)
end

--eld.enemynames:init()
