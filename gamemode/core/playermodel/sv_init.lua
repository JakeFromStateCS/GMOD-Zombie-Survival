local MODULE = {};
MODULE.Name = "Player Models";
MODULE.Hooks = MODULE.Hooks or {};
MODULE.Nets = MODULE.Nets or {};
MODULE.Config = {};
MODULE.Config.Models = {
	"models/player/kleiner.mdl"
};

function MODULE.Hooks:PlayerInitialSpawn( client )
	--client:SetModel( table.Random( self.Config.Models ) );
end;

function MODULE.Hooks:PlayerSpawn( client )
	--client:SetModel( table.Random( self.Config.Models ) );
end;

Base.Modules:RegisterModule( MODULE );