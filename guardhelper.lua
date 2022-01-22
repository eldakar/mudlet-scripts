eld.guardhelper = eld.guardhelper or {
  triggers = {},
  state = {}
}

-- find the weakest party member, who is being attacked
-- return id or 0
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
  -- ! OPTIONAL ! , can (should?) be commented out
  if not ateam.objs[ateam.my_id]["team_leader"] and savedDefenceTarget > 0 then
    suggestedGuardTarget = savedDefenceTarget
  end

  return suggestedGuardTarget
end


function eld.guardhelper:highlight_state()
  local anyone_to_guard = self:find_weakest()
  local nick_to_guard = 0

  if anyone_to_guard > 0 then
      self.guardId = anyone_to_guard
      if anyone_to_guard == ateam.my_id then
        nick_to_guard = ateam.options.own_name
        scripts.ui.window_modify(scripts.ui.states_window_name, nick_to_guard, scripts.ui.window_modifiers.surround("⛔ ", ""))  
      else
        nick_to_guard = ateam.objs[anyone_to_guard]["desc"]
        scripts.ui.window_modify(scripts.ui.states_window_name, nick_to_guard, scripts.ui.window_modifiers.surround("🛡 ", ""))
      end
  end
end

function eld.guardhelper:za_func()

    if ateam.objs[ateam.my_id]["team_leader"] and eld.guardhelper.respect_attack_flags == "true" then
      if ateam.attack_mode > 2 then
        if ateam.my_id == self.guardId then
          send("rozkaz druzynie zaslonic cie");
        else
          send("rozkaz zaslonic ob_"..self.guardId);
        end
      end
      if ateam.attack_mode > 1 then
        if ateam.my_id == self.guardId then
          send("wskaz siebie jako cel obrony")
        else
          send("wskaz ob_"..self.guardId.." jako cel obrony");
        end
      end
    end

    ateam:za_func(ateam.team[self.guardId])
end

function eld.guardhelper:clear_state()
  self.state = {}
end

function eld.guardhelper:init()
  self.statesHandler = scripts.event_register:register_singleton_event_handler(self.statesHandler, "printStatusDone", function() self:highlight_state() end)
end

eld.guardhelper:init()
