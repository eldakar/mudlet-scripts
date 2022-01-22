eld.enemynames = eld.enemynames or {
  triggers = {},
  state = {}
}

function scripts.ui.window_modifiers.replace(strTo)
  return function(windowName, position, text)
      moveCursor(windowName, position.x, position.y)
      creplace(windowName, strTo)
      moveCursor(windowName, 1, position.y)
  end
end


function eld.enemynames:highlight_state()
--  local anyone_to_guard = self:find_weakest()
--  local nick_to_guard = 0

    for v, k in pairs(ateam.team) do
      local tmp_nick = ""
      if v == ateam.my_id then
        tmp_nick = ateam.options.own_name
      elseif type(v) == "number" then
        tmp_nick = ateam.objs[v]["desc"]
      end

      --tmp_nick = string.sub(tmp_nick, 1, scripts.utils.real_len(tmp_nick)-1)

      --local new_nick = new_nick.sub(2, scripts.utils.real_len(new_nick)-1)
      
      
      local new_nick = tmp_nick:gsub("o","")
      new_nick = new_nick:gsub("i","")
      new_nick = new_nick:gsub("e","")
      new_nick = new_nick:gsub("u","")
      new_nick = new_nick:gsub("a","")

      scripts.ui.window_modify(scripts.ui.states_window_name, tmp_nick, scripts.ui.window_modifiers.replace(new_nick))
    end




    --ateam.team_enemies TODO

    for v, k in pairs(ateam.normal_ids) do
      local tmp_nick = ""
      if type(v) == "number" and v > 100 then
        tmp_nick = ateam.objs[v]["desc"]
      
        --new_nick = new_nick.sub(2, scripts.utils.real_len(new_nick)-1)
        --tmp_nick = string.sub(tmp_nick, 2, scripts.utils.real_len(tmp_nick)-1)
        
        local new_nick = tmp_nick:gsub("o","")
        new_nick = new_nick:gsub("i","")
        new_nick = new_nick:gsub("e","")
        new_nick = new_nick:gsub("u","")
        new_nick = new_nick:gsub("a","")

        scripts.ui.window_modify(scripts.ui.states_window_name, tmp_nick, scripts.ui.window_modifiers.replace(new_nick))
      end
    end

    for v, k in pairs(ateam.current_enemies) do
      local tmp_nick = ""
      if type(v) == "number" and k == true then
        tmp_nick = ateam.objs[v]["desc"]
      
        --new_nick = new_nick.sub(2, scripts.utils.real_len(new_nick)-1)
        --tmp_nick = string.sub(tmp_nick, 2, scripts.utils.real_len(tmp_nick)-1)
        
        local new_nick = tmp_nick:gsub("o","")
        new_nick = new_nick:gsub("i","")
        new_nick = new_nick:gsub("e","")
        new_nick = new_nick:gsub("u","")
        new_nick = new_nick:gsub("a","")

        scripts.ui.window_modify(scripts.ui.states_window_name, tmp_nick, scripts.ui.window_modifiers.replace(new_nick))
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
