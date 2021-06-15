local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Bodies";
MODULE.Stored = {};
MODULE.DeathData = {};
MODULE.Config = {};

local sin,cos,rad = math.sin,math.cos,math.rad;
local function Circle( x, y, rad, qual )
	local circle = {};
	local tmp = 0;
	for i=1,qual do
		tmp = rad( i * 360 ) / qual;
		circle[i] = { x = x + cos( tmp ) * rad, y = y + sin( tmp ) * radius };
	end;
	return circle;
end;

function MODULE:DrawCircle( ragdoll )
		local scrPos = ragdoll:GetPos():ToScreen();
		
end;

function MODULE.Nets:OpenMenu()
	local client = net.ReadEntity();
	
	local deathData = self.DeathData[client];
	if( deathData ) then
		if( self.Menu ) then
			self.Menu:Remove();
		end;
		
		self.Menu = vgui.Create( "DarkRP_BodyInfo" );
		self.Menu:SetClient( client );
		self.Menu:SetWeapon( deathData );
		self.Menu:SetKiller( deathData.killer );
		self.Menu:Center();
	end;
end;

function MODULE.Nets:DeathInfo()
	local client = net.ReadEntity();
	local killer = net.ReadEntity();
	if( killer:IsPlayer() ) then
		local weapon = killer:GetActiveWeapon();
		
		local reason = "Murder";
		if( client == killer ) then
			reason = "Suicide";
		end;
		
		self.DeathData[client] = {
			client = client,
			time = CurTime(),
			killer = killer,
		};
		self.DeathData[client].reason = reason;
		
		if( weapon:IsValid() ) then
			self.DeathData[client].name = weapon.PrintName;
			self.DeathData[client].weapon = weapon;
			self.DeathData[client].weaponModel = weapon:GetModel();
		end;
	end;
end;

function MODULE.Nets:Ragdoll()
	local client = net.ReadEntity();
	local ragdoll =  net.ReadEntity();

	self.Stored[client] = ragdoll;
end;

function MODULE.Nets:RemoveRagdoll()
	local client = net.ReadEntity();
	self.Stored[client] = nil;
end;

function MODULE.Hooks:PostDrawTranslucentRenderables()
	for client, ragdoll in pairs( self.Stored ) do
		if( ragdoll:IsValid() ) then
			self:DrawCircle( ragdoll );
		end;
	end;
end;

Base.Modules:RegisterModule( MODULE );