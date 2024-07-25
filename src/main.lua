local Players = PlayerService.getPlayers();
local PlayerExtraDamage = {};

local Time = 5;

local function GiveExtraDamage()
    while task.wait(Time) do
        local RandomPlayer = Players[math.random(#Players)];
        MessageService.broadcast(RandomPlayer.displayName.. " now deals 1 more damage!");
        PlayerExtraDamage[RandomPlayer] = PlayerExtraDamage[RandomPlayer] + 1;
    end
end

local function GameStart()
    for _, Player in pairs(Players) do
        PlayerExtraDamage[Player] = 0;
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

Events.EntityDamage(OnDamage);