local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Enemies";
MODULE.Stored = {};
MODULE.Config = {};
MODULE.Enemies = {};

function MODULE:AddEnemy( client, enemy )
	if( self.Enemies[client] == nil ) then
		self.Enemies[client] = {
			threats = {};
			enemies = {};
		};
	end;
	if( self.Enemies[enemy] == nil ) then
		self.Enemies[enemy] = {
			threats = {};
			enemies = {};
		};
	end;
	
	self.Enemies[client].enemies[enemy] = true;
	self.Enemies[enemy].threats[client] = true;	
end;

function MODULE.Hooks:EntityFireBullets( ent, bullet )
	if( !ent:IsValid() ) then
		return;
	end;
	local attacker = bullet.Attacker;
	if( !attacker:IsValid() ) then
		return;
	end;
	print( attacker );
	local couldDamage = ents.FindInCone( attacker:GetShootPos(), attacker:GetForward(), 1000, math.max( bullet.Spread.x, bullet.Spread.y ) / 2 );
	for k,client in pairs( couldDamage ) do
		if( !client:IsPlayer() or client:IsWeapon() or client == attacker ) then
			print( k );
			couldDamage[k] = nil;
			--table.remove( couldDamage, k );
		elseif( client:IsPlayer() ) then
			self:AddEnemy( attacker, client );
		end;
	end;
	PrintTable( couldDamage );
	Base.Modules:NetMessage( couldDamge, "AddEnemy", attacker );
end;

Base.Modules:RegisterModule( MODULE );