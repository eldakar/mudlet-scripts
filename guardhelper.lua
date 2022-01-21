eld.guardhelper = eld.guardhelper or {
  triggers = {},
  state = {}
}

scripts:print_log("Laduje dodatki Eldka...")

--TODO
--
--Gag na Przestan zaslaniac xxx.
--Gag na ATKAUJE CIE
--Gag na Nikt nie atakuje xyz.
--Gag Nie zaslaniasz nikogo.
--Gag na Przeciez nikt cie nie zaslania.
--Prezstawienie paskow Kondycja,zmeczenie,mana w kolumnie.
--Gag Nie jestes jeszcze gotow do wykonania tego manewru

function follow_path()
    if amap.path_display.destination then
    getPath(amap.curr.id, amap.path_display.destination)
    if speedWalkDir and speedWalkDir[1] then
        if amap.short_to_long[speedWalkDir[1]] then
        amap:keybind_pressed(amap.short_to_long[speedWalkDir[1]])
        else
        send(speedWalkDir[1])
        end
    end
    else
      expandAlias("/idz")
    end
end

function eld.guardhelper:find_weakest()
  local teamWeakestMemberId=0
  local teamWeakestMemberHp=10
  local teamWeakestMemberTeamEnemies=0
  local suggestedGuardTarget=0
  local savedDefenceTarget=0

  -- do nothing if the team is not in combat
  if table.size(ateam.team_enemies) == 0 then
    --print("Nikt nie walczy.")
    return 0
  end

  for v, k in pairs(ateam.team) do
    -- for all endangered team members...
    if type(v) == "number" and table.size(ateam.team_enemies[v]) > 0 then

      -- for the equaly wounded members, pick the most attacked one
      if ateam.objs[v]["hp"] == teamWeakestMemberHp then
        if table.size(ateam.team_enemies[v]) > teamWeakestMemberTeamEnemies then
          teamWeakestMemberId = v
          teamWeakestMemberHp = ateam.objs[v]["hp"]
          teamWeakestMemberTeamEnemies = table.size(ateam.team_enemies[v])
        end

      -- otherwise, find more wounded member
      elseif ateam.objs[v]["hp"] < teamWeakestMemberHp then
        teamWeakestMemberId = v
        teamWeakestMemberHp = ateam.objs[v]["hp"]
        teamWeakestMemberTeamEnemies = table.size(ateam.team_enemies[v])
      end

      -- save the defence target
      if ateam.objs[v]["defence_target"] then
        savedDefenceTarget = v
      end
    end

  end

  -- if found
  if teamWeakestMemberHp < 10 then
    suggestedGuardTarget = teamWeakestMemberId
  end

  -- overwrite the value with the defence_target marked
  if not ateam.objs[ateam.my_id]["team_leader"] and savedDefenceTarget > 0 then
    suggestedGuardTarget = savedDefenceTarget
  end

  --if suggestedGuardTarget == ateam.my_id or suggestedGuardTarget == 0 then
  --  print("Jestes najslabszy, wyluzuj...")
  --else
    --ateam:za_func(ateam.team[suggestedGuardTarget])
  -- print("Zaslonilbys "..suggestedGuardTarget.." czyli: "..ateam.team[suggestedGuardTarget])
  --end

  return suggestedGuardTarget
  --scripts:print_log("Probuje zaslonic: " .. suggestedGuardTarget)
  --send("zaslon ob_" .. suggestedGuardTarget)
  --send("przestan zaslaniac")
end


function eld.guardhelper:highlight_state()
  local anyone_to_guard = self:find_weakest()
  local nick_to_guard = 0

  if anyone_to_guard > 0 then
      self.guardId = anyone_to_guard
      --print("chce podmienic: "..ateam.objs[anyone_to_guard]["desc"])
      --/lua display(ateam.options.own_name)
      if anyone_to_guard == ateam.my_id then
        nick_to_guard = ateam.options.own_name      
      else
        nick_to_guard = ateam.objs[anyone_to_guard]["desc"]
        --myaliasID = tempAlias("^/guardhelper$", function() ateam:za_func(anyone_to_guard) end)

      end
      scripts.ui.window_modify(scripts.ui.states_window_name, nick_to_guard, scripts.ui.window_modifiers.surround("🙏 ", ""))
  end
end


function eld.guardhelper:highlight_state_test()

      scripts.ui.window_modify(scripts.ui.states_window_name, "Eldzio", scripts.ui.window_modifiers.surround("🙏 ", ""))

end

function eld.guardhelper:clear_state()
  self.state = {}
end

function eld.guardhelper:init()
  self.statesHandler = scripts.event_register:register_singleton_event_handler(self.statesHandler, "printStatusDone", function() self:highlight_state() end)
--  self.statesClearHandler = scripts.event_register:register_singleton_event_handler(self.statesClearHandler, "amapNewLocation", function()
--      registerAnonymousEventHandler("gmcp.room.info", function() self.clear_state() end, true)
--  end)
end


eld.guardhelper:init()









  function zaslon_leszcza_ilosc()
    local id_leszcza
    local max_wrogowie_leszcza=0
    local tmpMemberHp=7

    -- check if empty
    if not ateam.team_enemies or table.size(ateam.team_enemies) == 0 then
      return 0
    end
    
    for v, k in pairs(ateam.team) do
      if type(v) == "number" then
        
        if table.size(ateam.team_enemies[v]) > max_wrogowie_leszcza and k ~= '@' then
           
           id_leszcza = v
           max_wrogowie_leszcza = table.size(ateam.team_enemies[v])
       
          end
       end
     end
      
    if id_leszcza then 
    
      send("zaslon ob_" .. id_leszcza)
      send("przestan zaslaniac")
      --ateam:zas_func(id_leszcza)
    
    end
    
  end