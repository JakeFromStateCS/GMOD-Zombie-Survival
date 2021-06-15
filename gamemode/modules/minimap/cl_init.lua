local MODULE = {};
MODULE.Hooks = {};
MODULE.Name = "Minimap";
MODULE.Stored = {};
MODULE.Config = {};
MODULE.Config.DotSize = 11;
MODULE.Config.RadarSize = 800;
MODULE.Config.RadarPos = {
	x = ScrW() - MODULE.Config.RadarSize,
	y = MODULE.Config.RadarSize
};
MODULE.Realm = "cl_";

surface.CreateFont( "HUDXSmall_Alpha", {
	size = 20, 
	antialias = true,
	weight = 400,
	font = "default"
} );

surface.CreateFont( "HUDXTiny_Alpha", {
	size = 16,
	antialias = true,
	weight = 400,
	font = "default"
} );


function Rotate( ang, x1, y1 )
	local x, y = x1, y1;
	local c = math.cos( ang );
	local s = math.sin( ang );
	x = c * x1 - s * y1;
	y = s * x1 + c * y1;
	return {
		x = x,
		y = y
	};
	
end;

function MODULE:OnLoad()
	Base.Minimap = self;
end;

function MODULE:DrawPos()
	local backgroundColor = Color( 0, 0, 0, 200 );
	local themeColor = Color( 0, 0, 0, 200 );
	local pos = LocalPlayer():GetPos();
		--surface.SetDrawColor( themeColor );
		--surface.DrawOutlinedRect( ScrW() - 200, 1, 200, 200 );
	surface.SetTextColor( Color( 255, 255, 255 ) );
	surface.SetFont( "HUDXTiny_Alpha" );
	surface.SetTextPos( ScrW() - 200, 205 );
	surface.DrawText( math.Round( pos.x ) .. ", " .. math.Round( pos.y ) .. ", " .. math.Round( pos.z ) );
end;

function MODULE:DrawInfo( client )
	local scrPos = client:EyePos():ToScreen();
	--local teamID = client:GetTeamID();
	--local lobbyID = client:GetLobbyID();
	--local TEAM = client:GetMinigameTeam();
	if( TEAM ) then
		
		surface.SetFont( "HUDXSmall_Alpha" );
		local teamColor = Color( TEAM.color.r, TEAM.color.g, TEAM.color.b );
		local drawColor = Color( TEAM.color.r, TEAM.color.g, TEAM.color.b );
		
		local w, h = surface.GetTextSize( client:Nick() );
		
		surface.SetFont( "HUDXTiny_Alpha" );
		local teamW, teamH = surface.GetTextSize( teamID );
		
		
		w = math.Max( w, teamW );
		h = h + teamH;--math.Max( h, teamH );
	
		scrPos.x = math.Clamp( scrPos.x, w / 2 + 4, ScrW() - w );
		scrPos.y = math.Clamp( scrPos.y, h + 16, ScrH() + 10 ) - 20;

		local dist = math.sqrt( ( ScrW() / 2 - scrPos.x ) ^2 + ( ScrH() / 2 - scrPos.y ) ^2 );
		
		drawColor.a = math.Clamp( 255 - dist, 0, 255 );
		
		surface.SetDrawColor( Color( 255, 255, 255 ) );
		
		if( Base.VGUI ) then
			if( Base.VGUI.Config.colors.background ) then
				surface.SetDrawColor( Base.VGUI.Config.colors.background );
			end;
		end;
		
		surface.DrawRect( scrPos.x - 5 - w / 2, scrPos.y - 2 - h / 2 - 10, w + 10, h );
		
		teamColor.a = 255;
		surface.SetDrawColor( teamColor );
		surface.DrawRect( scrPos.x - 5 - w / 2, scrPos.y - 2 - h / 2 - 10, 4, h );
		surface.DrawRect( scrPos.x - w / 2, scrPos.y - h + teamH + 4, w + 4, 1 );
		
		--draw.RoundedBox( 2, scrPos.x - self.Config.DotSize, scrPos.y - self.Config.DotSize , self.Config.DotSize, self.Config.DotSize + 1, teamColor );
		
		surface.SetFont( "HUDXSmall_Alpha" );
		surface.SetTextColor( Color( 0, 0, 0, teamColor.a ) );
		surface.SetTextPos( scrPos.x - w / 2 + 2, scrPos.y - 5 - ( h - teamH ) / 2 );
		surface.DrawText( client:Nick() );
		
		surface.SetTextColor( teamColor );
		surface.SetTextPos( scrPos.x - w / 2 + 2, scrPos.y - 5 - ( h - teamH ) / 2 );
		surface.DrawText( client:Nick() );
		
		surface.SetFont( "HUDXTiny_Alpha" );
		surface.SetTextPos( scrPos.x - w / 2 + 2, scrPos.y - h + 5 );
		surface.DrawText( teamID );
		
		drawColor.a = 255;
	end;
end;

function MODULE:ShouldDrawPos( vec )
	local pos = LocalPlayer():GetPos();
	pos = self:GetRadarPos( pos );
	local dist = math.sqrt( ( pos.y - vec.y )^2 + ( pos.x - vec.x )^2 );

	if( dist > self.Config.RadarSize / 8 ) then
		return false;
	end;

	return true;
end;

function MODULE:GetRadarPos( vec )
	local pos = LocalPlayer():GetPos();
	local ang = LocalPlayer():GetAngles();

	pos.x = pos.x - vec.x;
	pos.y = pos.y - vec.y;

	pos.x = pos.x / 8;
	pos.y = pos.y / 8;

	pos = Rotate( -ang.y / 60 + 30, pos.x, pos.y );

	pos.x = ScrW() - 100 + pos.x;
	pos.y = 100 - pos.y;

	return pos;
end;

function MODULE:DrawRadarBlip( client )
	if ( hook.Run( "ShouldDrawRadarBlip", client ) ~= false ) then
		local pos = client:GetPos();
		local ang = LocalPlayer():EyeAngles();
		local col = Color( 255, 255, 255 );
		if( client:IsPlayer() ) then
			col = team.GetColor( client:Team() );
		end;
		pos = self:GetRadarPos( pos );
		if( self:ShouldDrawPos( pos ) ) then

			--surface.SetDrawColor( col );
			--surface.DrawRect( pos.x - 3, pos.y - 3, 6, 6 );
			draw.RoundedBox( 4, pos.x - 3, pos.y - 3, 6, 6, col );
		end;
	end
end;

function MODULE:DrawRadarFrame()
	local backgroundColor = Color( 0, 0, 0,60 );
	local themeColor = Color( 0, 0, 0, 200 );

	surface.SetDrawColor( themeColor );
	surface.DrawOutlinedRect( ScrW() - 201, 1, 200, 200 );
	
	surface.SetDrawColor( backgroundColor );
	surface.DrawRect( ScrW() - 201, 1, 200, 200 );
end;

function MODULE.Hooks:HUDPaint()
	/*
	hook.Call( "PreMinimapDraw" );
		self:DrawRadarFrame();
		self:DrawPos();
	hook.Call( "PostMinimapDraw" );

	hook.Call( "PreBlipDraw" );
	local clients = player.GetAll();
	for _,client in pairs( clients ) do
		if( client:IsValid() ) then
			self:DrawRadarBlip( client );
			hook.Call( "PlayerBlip",  GAMEMODE, { client } );
		end;
	end;

	hook.Call( "PostBlipDraw" );
	*/
end;

Base.Modules:RegisterModule( MODULE );