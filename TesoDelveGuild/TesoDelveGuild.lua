
-- Track component initialization
TDG                     = {}
TDG.tag = 'TDG'
TDG.name = 'TesoDelveGuild'


TDG.registerEvents = function()

    local inventoryScene = SCENE_MANAGER:GetScene("inventory")
    inventoryScene:RegisterCallback("StateChange", function(oldState, newState)
        if(oldState == 'shown') then
            zo_callLater(TDG.export, 100)
        end
    end)

end

TDG.exportMembers = function(guild_id)
    local members = {}
    local membersCount = GetNumGuildMembers(guild_id)

    for memberIndex=1, membersCount, 1 do

        local memberInfo = {GetGuildMemberInfo(guild_id, memberIndex)}
        local memberDump = {
            GetGuildName(guild_id),
            memberInfo[1],
            memberInfo[2],
            memberInfo[3],
            memberInfo[4],
            memberInfo[5],
            GetTimeStamp(),
            GetWorldName(),
            GetDisplayName(),
        }

        table.insert(members, "GUILDMEMBER:;--;"..table.concat(memberDump, ';--;') .. ";--;")
    end

    return members
end

TDG.d = function(text)
    d(text)
end

TDG.exportRanks = function(guild_id)
    local numGuildRanks = GetNumGuildRanks(guild_id)
    local ranks = {}

    for rankIndex=1, numGuildRanks, 1 do
        local iconIndex = GetGuildRankIconIndex(guild_id, rankIndex)

        local rank = {
            GetGuildName(guild_id),
            GetWorldName(),
            rankIndex,
            GetGuildRankId(guild_id, rankIndex),
            GetGuildRankCustomName(guild_id, rankIndex),
            GetDefaultGuildRankName(guild_id, rankIndex),
            tostring(IsGuildRankGuildMaster(guild_id, rankIndex)),
            GetGuildRankSmallIcon(iconIndex),
            GetGuildRankLargeIcon(iconIndex),
            GetGuildRankListHighlightIcon(iconIndex)
        }

        table.insert(ranks, "GUILDRANK:;--;"..table.concat(rank, ';--;') .. ";--;")
    end

    TDG.vars.ranks[guild_id] = ranks
end

TDG.exportGuilds = function()
    local guilds = {}
    local members = {}
    TDG.vars.ranks = {}

    for i=1, GetNumGuilds(), 1 do
        local guild_id = GetGuildId(i)
        local guildInfo = {GetGuildInfo(guild_id)}
        local guild_id = GetGuildId(i)

        members[guild_id] = TDG.exportMembers(guild_id)
        TDG.exportRanks(guild_id)

        local guild = {
            GetGuildName(guild_id),
            GetGuildDescription(guild_id),
            GetGuildMotD(guild_id),
            GetGuildFoundedDate(guild_id),
            membersCount,
            GetWorldName(),
            GetDisplayName(),
            guild_id,
            GetGuildOwnedKioskInfo(guild_id),
            guildInfo[3],
            GetGuildAlliance(guild_id),
        }

        table.insert(guilds, "GUILD:;--;"..table.concat(guild, ';--;') .. ";--;")
    end

    TDG.vars.guilds = guilds
    TDG.vars.guildMembers = members
end

TDG.export = function()
    TDG.exportGuilds();
end


local function initialize(eventCode, addOnName)

    if ( addOnName ~= TDG.name ) then return end

    TDG.vars = ZO_SavedVars:NewAccountWide(TDG.name, 1, nil, {})
    TDG.registerEvents()
end


-- Hook initialization to EVENT_ADD_ON_LOADED
EVENT_MANAGER:RegisterForEvent(TDG.name .. "_Initialize" , EVENT_ADD_ON_LOADED , initialize )