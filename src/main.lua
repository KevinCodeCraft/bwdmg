local Settings = require("Settings");

local Players = PlayerService.getPlayers();
local PlayerExtraDamage = {};
local Leaderboard = nil;

local function GiveExtraDamage()
    while task.wait(Settings.Time) do
        local RandomPlayer = Players[math.random(#Players)];
        MessageService.broadcast(RandomPlayer.displayName.. " now deals " .. Settings.ExtraDamage .. " more damage!");
        PlayerExtraDamage[RandomPlayer] = PlayerExtraDamage[RandomPlayer] + Settings.ExtraDamage;

        if not Leaderboard then continue end;
        Leaderboard:addScore(RandomPlayer, Settings.ExtraDamage);
    end
end

local function GameStart()
    if Settings.UseLeaderboard then
        Leaderboard = UIService.createLeaderboard();
    end

    for _, Player in pairs(Players) do
        PlayerExtraDamage[Player] = 0;

        if Leaderboard then
            Leaderboard:addKey(Player, 0);
        end
    end

    task.spawn(GiveExtraDamage);
end

local function OnDamage(event)
    local AttackerEntity = event.fromEntity;
    if not AttackerEntity then return end;

    local Attacker = AttackerEntity:getPlayer();
    if not Attacker then return end;

    event.damage = event.damage + PlayerExtraDamage[Attacker];
end

GameStart();

Events.MatchStart(GameStart);
Events.EntityDamage(OnDamage);