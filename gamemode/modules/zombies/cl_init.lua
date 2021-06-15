local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Zombies";
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

function MODULE.Nets:Killer()
	local client = net.ReadEntity();
	local killer = net.ReadEntity();

	if( self.DeathData[client] == nil ) then
		self.DeathData[client] = {
			time = CurTime()
		};
	end;
	local reason = "Murder";
	if( client == killer ) then
		reason = "Suicide";
	end;

	self.DeathData[client].reason = reason;
end;

function MODULE.Nets:SpawnRagdoll()
	local client = net.ReadEntity();
	local ragdoll =  net.ReadEntity();

--	print( client, ragdoll );
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