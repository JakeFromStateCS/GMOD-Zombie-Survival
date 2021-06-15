local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Zombies";
MODULE.Zombies = {};
MODULE.Config = {};
MODULE.Config.Zombies = {
	health = 200,
	runSpeed = 600,
	walkSpeed = 400,
	model = "models/player/zombie_classic.mdl",
	weapons = {
		"weapon_blfists"
	}
}
MODULE.ZombieMode = false;

function MODULE:OnLoad()
	Base.Zombies = self;
end;

/*
	Sets a client to a zombie and does all the dohickies that it needs to with their stuff
*/
function MODULE:SetZombie( client )
	client:SetModel( self.Config.Zombies.model );
	client:SetRunSpeed( self.Config.Zombies.runSpeed );
	client:SetWalkSpeed( self.Config.Zombies.walkSpeed );
	client:SetHealth( self.Config.Zombies.health );
end;

function MODULE:SetHuman( client )
	local tab = self.Zombies[client];
	if( tab ~= nil ) then
		client:SetRunSpeed( tab.runSpeed );
		client:SetWalkSpeed( tab.walkSpeed );
		client:SetModel( tab.model );
		client:SetHealth( tab.health );
		for _,tab in pairs( tab.weapons ) do
			client:Give( tab.class );
			local weapon = client:GetWeapon( tab.class );
			if( weapon:IsValid() ) then
				client:SetAmmo( weapon:GetPrimaryAmmoType(), tab.primaryCount );
				client:SetAmmo( weapon:GetSecondaryAmmoType(), tab.secondaryCount );
			end;
		end;
	end;
end;

/*
	StartZombies:
		Starts the zombie invasion, aka turning players into zombies and whatnot
		Turns on lockdown and sets zombie mode to true;
*/
function MODULE:StartZombies()
	self.ZombieMode = true;
	DarkRP.lockdown( Entity( 0 ) );
	Base.Modules:NetMessage( "Zombie_Status", self.ZombieMode );
	local zombie = table.Random( player.GetAll() );
	self:SetZombie( zombie );
	self.Zombies[zombie] = {
		time = CurTime(),
		model = zombie:GetModel(),
		runSpeed = zombie:GetRunSpeed(),
		walkSpeed = zombie:GetWalkSpeed(),
		health = zombie:Health()
	};
	local weapons = zombie:GetWeapons();
	local weps = {};
	for id,weapon in pairs( weapons ) do
		local tab = {
			class = weapon:GetClass(),
			primaryCount = zombie:GetAmmoCount( weapon:GetPrimaryAmmoType() ),
			secondaryCount = zombie:GetAmmoCount( weapon:GetSecondaryAmmoType() )
		};
		weps[id] = tab;
	end;
	self.Zombies[zombie].weapons = weps;
	zombie:Spawn();
end;



/*
	EndZombies:
		Ends the zombie invasion
		Stops any lockdown and sets zombie mode to false
*/
function MODULE:EndZombies()
	for _,client in pairs( player.GetAll() ) do
		self:SetHuman( client );
	end;
	self.ZombieMode = false;
	DarkRP.unLockdown( Entity( 0 ) );
	Base.Modules:NetMessage( "Zombie_Status", self.ZombieMode );
end;



/*
	Hook
		PlayerSpawn:
			Checks if the player is a zombie, if they are
			set their variables such as health, runspeed, model
*/
function MODULE.Hooks:PlayerSpawn( client )
	local tab = self.Zombies[client];
	if( tab ~= nil ) then
--		print( client );
		self:SetZombie( client );
	end;
end;



/*
	Hook
		PlayerLoadout:
			Gives the client ( zombie ) all the weapons in the config table
*/
function MODULE.Hooks:PlayerLoadout( client )
	if( self.ZombieMode ) then
		local tab = self.Zombies[client];
		if( tab ~= nil ) then
			client:StripWeapons();
			for _,class in pairs( self.Config.Zombies.weapons ) do
				client:Give( class );
				local weapon = client:GetWeapon( class );
				if( weapon:IsValid() ) then
					local ammo = weapon:GetPrimaryAmmoType();
					if( ammo ) then
						client:GiveAmmo( ammo, 999 );
					end;
				end;
			end;
			return true;
		end;
	end;
end;

function MODULE.Hooks:PlayerDeath( client, inflictor, attacker )
	if( self.ZombieMode ) then
		if( self.Zombies[client] == nil ) then
			self.Zombies[client] = {
				time = CurTime(),
				model = client:GetModel(),
				runSpeed = client:GetRunSpeed(),
				walkSpeed = client:GetWalkSpeed(),
				health = client:Health()
			};
		end;
	end;
end;

Base.Modules:RegisterModule( MODULE );

