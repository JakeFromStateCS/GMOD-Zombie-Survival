local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Bodies";
MODULE.Stored = {};
MODULE.Config = {};
MODULE.DraggingTab = {};
MODULE.EatingTab = {};
MODULE.EatingTimes = {};
MODULE.Config.FoodSounds = {
	"npc/barnacle/barnacle_crunch2.wav",
	"npc/barnacle/barnacle_crunch3.wav",
	"npc/barnacle/barnacle_pull4.wav"
};
MODULE.Config.DecayTime = 300;
MODULE.Config.EatingInterval = 2;
MODULE.Config.BurnModel = "models/Humans/Charple01.mdl";
MODULE.Config.Police = {
	"Citizen"
}

function MODULE:SpawnRagdoll( client )
	local ragdoll = ents.Create( "prop_ragdoll" );
	ragdoll:SetModel( client:GetModel() );
	ragdoll:SetPos( client:GetPos() );
	ragdoll:SetAngles( client:GetAngles() );
	ragdoll:Spawn();
	ragdoll.Edible = true
	ragdoll:SetCollisionGroup( COLLISION_GROUP_WEAPON );
	ragdoll:SetRenderMode( 1 );
	ragdoll.DeathTime = CurTime();
	ragdoll.HealthNum = math.random( 1, 100 );
	ragdoll.Owner = client;
	local num = ragdoll:GetPhysicsObjectCount() - 1;

	for i=0, num do
		local bone = ragdoll:GetPhysicsObjectNum( i );
		if( bone:IsValid() ) then
			local bp, ba = client:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) );
			if( bp and ba ) then
				bone:SetPos( bp );
				bone:SetAngles( ba );
			end;

			bone:SetVelocity( client:GetVelocity() );
		end;
	end;

	self.Stored[client] = ragdoll;
	return ragdoll;
end;

function MODULE:RemoveRagdoll( client )
	local ragdoll = self.Stored[client];
	if( ragdoll ) then
		if( ragdoll:IsValid() ) then
			ragdoll:Remove();
		end;
	end;
	self.Stored[client] = nil;
end;

function MODULE:GiveWeapons( client )
	if( client.TempWeps ) then
		for _,wepClass in pairs( client.TempWeps ) do
			local activeWep = nil;
			local ammoTab = client.TempAmmo[wepClass];
			client:Give( wepClass );
			local weapon = client:GetWeapon( wepClass );
			if( weapon ) then
				if( weapon:IsValid() ) then
					if( weapon:GetClass() == client.ActiveWeapon ) then
						client.ActiveWeapon = weapon;
					end;
					if( ammoTab ) then
						client:SetAmmo( weapon:GetPrimaryAmmoType(), ammoTab[1] );
						client:SetAmmo( weapon:GetSecondaryAmmoType(), ammoTab[2] );
					end;
				end;
			end;
			
		end;

		timer.Simple( 1, function()
			client:SetActiveWeapon( client.ActiveWeapon );
			client.ActiveWeapon = nil;
		end );

		client.TempWeps = nil;
		client.TempAmmo = nil;
		client:SetSuppressPickupNotices( false );
	end;
end;

function MODULE:StoreWeapons( client )
	client.TempWeps = client:GetWeapons();
	client.TempAmmo = {};
	client.ActiveWeapon = client:GetActiveWeapon();
	if( client.ActiveWeapon:IsValid() ) then
		client.ActiveWeapon = client.ActiveWeapon:GetClass();
	end;
	for index,weapon in pairs( client.TempWeps ) do
		local wepClass = weapon:GetClass();
		if( weapon:IsValid() ) then
			client.TempAmmo[wepClass] = {
				client:GetAmmoCount( weapon:GetPrimaryAmmoType() ),
				client:GetAmmoCount( weapon:GetSecondaryAmmoType() )
			};
		end;
		client.TempWeps[index] = wepClass;
	end;
	client:SetSuppressPickupNotices( true );
end;

function MODULE:RagdollColors()
	for client, ragdoll in pairs( self.Stored ) do
		if( ragdoll:IsValid() ) then
			local incriment = 255 / self.Config.DecayTime + 0.25;
			local alpha = ( ( ragdoll.DeathTime + self.Config.DecayTime ) - CurTime() ) * incriment;
			if( ragdoll.HealthNum ) then
				alpha = math.Clamp( alpha - ( 100 - ragdoll.HealthNum ), 0, 255 );
			end;
			ragdoll:SetColor( Color( 255, 255, 255, alpha ) );
		end;
	end;
end;

function MODULE:DecayTimers( )
	for client, ragdoll in pairs( self.Stored ) do
		if( ragdoll:IsValid() ) then
			if( ragdoll.DeathTime + self.Config.DecayTime < CurTime() ) then
				ragdoll:Remove();
				self.Stored[client] = nil;
				Base.Modules:NetMessage( "RemoveRagdoll", client );
			end;
		end;
	end;
end;

function MODULE:Eating()
	for client, ragdoll in pairs( self.EatingTab ) do
		if( ragdoll:IsValid() and ragdoll.Edible and client:GetJob() == "Hobo" ) then
			local dist = client:GetPos():Distance( ragdoll:GetPos() );
			local eatingTime = self.EatingTimes[client];
			
			if( dist > 100 and !client:KeyDown( IN_USE ) ) then
				self.EatingTab[client] = nil;
				self.EatingTimes[client] = nil;
				return;
			end;
			
			if( eatingTime == nil or eatingTime < CurTime() ) then
				local heal = math.random( 0, ragdoll.HealthNum );
				
				
				client:EmitSound( table.Random( self.Config.FoodSounds ), 100, 100 );
				self.EatingTimes[client] = CurTime() + self.Config.EatingInterval;
				ragdoll.HealthNum = math.Clamp( ragdoll.HealthNum - heal, 0, 100 );
				
				
				if( ragdoll.HealthNum == 0 ) then
					if( self.Stored[client] == ragdoll ) then
						client:Kill();
						local effect = EffectData()
						effect:SetOrigin( client:GetPos() )
						util.Effect( "Moneybomb", effect, true, true )
						
						sound.Play( "ambient/explosions/explode_3.wav", client:GetPos() )
						util.ScreenShake( client:GetPos(), 10, 10, 4, 2500 )
						--util.BlastDamage( client, client, client:GetPos(), 400, 200 )
					end
					ragdoll:Remove();
				end;
				
				
				client:SetHealth( math.Clamp( client:Health() + heal, 0, client:GetMaxHealth() * 2.5 ) );
			end;
		end;
	end;
end;

function MODULE:Dragging()
	for client,ragdoll in pairs( self.DraggingTab ) do
		if( client:IsValid() and ragdoll:IsValid() ) then
			local dist = client:GetShootPos():Distance( ragdoll:GetPos() );
			if( dist < 68 and client:KeyDown( IN_USE ) ) then
				local physObj = ragdoll:GetPhysicsObject();
				if( physObj ) then
					local eyeTrace = client:GetEyeTrace();
					local hitPos = client:GetShootPos() + eyeTrace.Normal * 15;
					local dist = client:GetShootPos():Distance( ragdoll:GetPos() ) / 17;
					local vel = ( hitPos - ragdoll:GetPos() + client:GetForward() * 10 + client:GetUp() * physObj:GetMass() ) * dist;
					--vel.z = math.Clamp( vel.z, 100, 500 );
					physObj:SetVelocity( vel );
				end;
			else
				self.DraggingTab[client] = nil;
				self:GiveWeapons( client );
			end;
		else
			self:GiveWeapons( client );
			self.DraggingTab[client] = nil;
		end;
	end;
end;

function MODULE.Hooks:OnReloaded()
	for _,ent in pairs( ents.FindByClass( "prop_ragdoll" ) ) do
		ent:Remove();
	end;
end;
function MODULE.Hooks:PlayerDeath( client, inflictor, killer )
	self:RemoveRagdoll( client );
	local ragdoll = self:SpawnRagdoll( client );
	if( killer:IsPlayer() ) then
		local weapon = killer:GetActiveWeapon();
		ragdoll.deathData = {
			killer = killer,
			weapon = weapon,
			deathTime = CurTime()
		};
	end;
	client:GetRagdollEntity():Remove();
	client:Spectate( OBS_MODE_CHASE );
	client:SpectateEntity( ragdoll );
	timer.Simple( 1, function()
		Base.Modules:NetMessage( "Ragdoll", client, ragdoll );
		Base.Modules:NetMessage( "DeathInfo", client, killer );
	end );
end;

function MODULE.Hooks:KeyPress( client, key )
	if( key == IN_USE ) then
		local ragdoll = client:GetEyeTrace().Entity;
		if( ragdoll ) then
			if( ragdoll:IsValid() ) then
				if( ragdoll:GetPos():Distance( client:GetShootPos() ) > 65 ) then
					return;
				end;
				if( ragdoll:GetClass() == "prop_ragdoll" ) then
					local jobID = client:GetJob();
					print( jobID );
					if( !client:KeyDown( IN_DUCK ) ) then
						self.DraggingTab[client] = ragdoll;
						self:StoreWeapons( client );
						client:StripWeapons();
					elseif( jobID == "Hobo" ) then
						self.EatingTab[client] = ragdoll;
					elseif( table.HasValue( self.Config.Police, jobID ) or client:IsAdmin() ) then
						Base.Modules:NetMessage( client, "OpenMenu", ragdoll.Owner );
					end;
				end;
			end;
		end;
	else
	end;
end;

function MODULE.Hooks:PlayerSpawn( client )
	client:UnSpectate();
end;

function MODULE.Hooks:Think()
	self:DecayTimers();
	self:RagdollColors();
	self:Dragging();
	self:Eating();
end;

function MODULE.Nets:BodyWantPlayer( client )
	
	local killer = net.ReadEntity();
	local victim = net.ReadEntity();
--	print( client, killer, victim );
	if( table.HasValue( self.Config.Police, client:Team() ) ) then
		client:wanted( killer, "For the murder of " .. victim:Nick() .. "!" )
	end;
end;

Base.Modules:RegisterModule( MODULE );