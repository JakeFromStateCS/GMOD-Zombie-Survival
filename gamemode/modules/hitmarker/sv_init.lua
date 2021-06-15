local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "HitMarkers";
MODULE.Config = {};


function MODULE:OnLoad()

end;

function MODULE.Hooks:EntityTakeDamage( ent, dmgInfo )
	local attacker = dmgInfo:GetAttacker();
	local damage = dmgInfo:GetDamage();
	print( ent, damage );
	print( attacker );
	if( attacker:IsPlayer() ) then
		local pos = attacker:GetEyeTrace().HitPos;
		Base.Modules:NetMessage( "HitMarker", pos, math.ceil( damage ) );
	end;
end;

Base.Modules:RegisterModule( MODULE );

