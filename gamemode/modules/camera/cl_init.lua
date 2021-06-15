local MODULE = {};
MODULE.Name = "Camera";
MODULE.Hooks = MODULE.Hooks or {};
MODULE.Nets = MODULE.Nets or {};
MODULE.Config = {
	zoom = 140,
	zoomRate = 6,
	right = 0,
	up = 0,
	yaw = 0,
	pitch = 0
};

CreateConVar( "camera_right", 0 );

local playerMeta = FindMetaTable( "Player" );

function MODULE:OnLoad()
	for k,v in pairs( self.Config ) do
		self[k] = v;
	end;
	self.zoomed = true;
	self.toggled = true;
	self.zoom = 0;
	
	if( IsValid( Base.ContextMenu ) ) then
		if( Base.ContextMenu.ThirdpersonButton == nil ) then
			self.Button = vgui.Create( "DButton" );
			self.Button:SetParent( Base.ContextMenu  );
			self.Button:SetSize( 100, 35 );
			self.Button:SetPos( ScrW() / 4 + 50, ScrH() - 125 )
			self.Button:SetText( "Thirdperson" );
			self.Button.DoClick = function()
				self.zoomed = !self.zoomed;
				self.toggled = !self.toggled;
			end;
			Base.ContextMenu.ThirdpersonButton = self.Button;
		else
		end;
	end
	Base.Camera = self;
end;


function playerMeta:GetViewTrace()
	return Base.Camera:GetEyeTrace( self );
end;

function MODULE:GetBackTrace( client )
	if( self.calcviewAng ) then
		local trace = {};
		trace.start = self.calcviewPos
		trace.endpos = trace.start - self.calcviewAng:Forward() * self.Config.zoom;
		trace.filter = client;
		trace = util.TraceLine( trace );
		return trace;
	end;
	return {};
end;

function MODULE:GetEyeTrace( client )
	if( self.calcviewAng ) then
		local trace = {};
		trace.start = self.calcviewPos
		trace.endpos = trace.start + self.calcviewAng:Forward() * 5000;
		trace.filter = client;
		trace = util.TraceLine( trace );
		return trace;
	end;
	return {};
end;

function MODULE.Hooks:CalcView( client, pos, ang, fov, nearZ, farZ )
	if( !self.zoomed ) then
		local view = {};
		local right = ang:Right() * self.right;
		local angle = Angle( self.pitch, self.yaw, 0 );

		if( GetConVar( "camera_right" ):GetFloat() == 1 ) then
			right = -right + ang:Right() * 20;
			angle.yaw = -angle.yaw;
		end;
		
		view.origin = pos - ( ang:Forward() * self.zoom ) + right + Vector( 0, 0, self.zoom / 10 + self.up );
		view.angles = ang + angle;
		view.fov = fov;

		self.calcviewAng = view.angles;
		self.calcviewPos = view.origin;

		return view;
	else
		self.calcviewAng = ang;
		self.calcviewPos = pos;
	end;
end;

function MODULE.Hooks:ShouldDrawLocalPlayer()
	if( !self.zoomed ) then
		return true;
	else
		return false;
	end;
end;

function MODULE.Hooks:HUDPaint()
		local viewTrace = LocalPlayer():GetEyeTrace();
		local pos = viewTrace.HitPos:ToScreen()--ScrW() / 2, ScrH() / 2;
		local vel = LocalPlayer():GetVelocity():Length();
		local x, y = pos.x, pos.y;
		surface.SetDrawColor( Color( 255, 255, 255 ) );
		--surface.DrawCircle( x, y, 4, Color( 255, 100, 100 ) );
		
		--Top bar on the crosshair13 = ( 4 circle width, 9 bar height );
		surface.DrawRect( x, y - 13 - vel / 10, 2, 9 );
		
		--Bottom bar on the crosshair 7 = ( 4 circle height, 3 bar height );
		surface.DrawRect( x, y + 6 + vel / 10, 2, 9 );
		
		--Left bar 13 = ( 4 circle width, 9 bar width );
		surface.DrawRect( x - 13 - vel / 10, y, 9, 2 );
		
		--Right bar 7 = ( 4 circle width, 3 bar width );
		surface.DrawRect( x + 6 + vel / 10, y, 9, 2 );
		
		
		
		local weapon = LocalPlayer():GetActiveWeapon();
		local health = LocalPlayer():Health();
		surface.SetFont( "flatUI ButtonText fine" );
		if( weapon:IsValid() ) then
			local count = weapon:Clip1();
			local W, H = surface.GetTextSize( count );
			surface.SetTextColor( Color( 232, 187, 103 ) );
			surface.SetTextPos( x + 10 + vel / 10, y - H );
			surface.DrawText( count );
		end;
		
		local W, H = surface.GetTextSize( health );
		surface.SetTextColor( Color( 255, 100, 100 ) );
		surface.SetTextPos( x - W - 10 - vel / 10, y );
		surface.DrawText( health );
		
end;

function MODULE.Hooks:PlayerBindPress( client, bind, press )
	if( client:IsValid() ) then
		if( client:Alive() ) then
			if( client:KeyDown( IN_WALK ) ) then
				local binds = {
					"invprev",
					"invnext",
				};
				
				if( table.HasValue( binds, bind ) ) then
					return true;
				end;
			end;
		end;
	end;
end;

function MODULE.Hooks:CreateMove( cmd )
	if( LocalPlayer():KeyDown( IN_WALK ) ) then
		local scroll = cmd:GetMouseWheel();
		if( scroll != 0 ) then
			self.mouseWheeled = true;
			self.wheelScrolling = true;
			self.zoom = self.zoom - scroll * self.Config.zoomRate;
		else
			self.wheelScrolling = false;
		end;
	end;
end;

function MODULE.Hooks:Think()
	if( LocalPlayer():KeyDown( IN_WALK ) ) then
		if( input.IsMouseDown( MOUSE_MIDDLE ) and !self.toggled ) then
			self.zoomed = !self.zoomed;
			self.toggled = true;
			self.mouseWheeled = false;
		end;
		if( self.zoomed ) then
			self.zoom = math.Approach( self.zoom, 0, -self.Config.zoomRate );
			self.up = math.Approach( self.up, 0, -self.Config.zoomRate );
			self.right = math.Approach( self.right, 0, self.Config.zoomRate );
			if( self.zoom == 0 ) then
				self.toggled = false;
			end;
		else
			
			self.zoom = math.Approach( self.zoom, self.Config.zoom, -self.Config.zoomRate );
			
			self.right = math.Approach( self.right, self.Config.right, self.Config.zoomRate );
			if( self.zoom + 10 >= self.Config.zoom or self.mouseWheeled ) then
				self.toggled = false;
			end;
		end;
	end;
	local backTrace = self:GetBackTrace( LocalPlayer() );
	local hitPos = backTrace.HitPos;
	
	local crouch = 0;
	if( LocalPlayer():KeyDown( IN_DUCK ) ) then
		crouch = 30;
	end;	
	self.up = math.Approach( self.up, self.Config.up + crouch, -self.Config.zoomRate );
	if( hitPos ) then
		local dist = hitPos:Distance( self.calcviewPos );
		if( dist < self.Config.zoom ) then
			if( dist < self.zoom ) then
				self.zoom = dist;
			end;
		else
			if( !self.mouseWheeled ) then
				self.zoom = math.Approach( self.zoom, self.Config.zoom, -self.Config.zoomRate );					
			end;		
		end;
	end;
end;

function MODULE.Hooks:ContextMenuCreated( context )
	
end

function MODULE.Hooks:HUDShouldDraw( name )
	if( name == "CHudCrosshair" ) then
		return false;
	end;
end;

Base.Modules:RegisterModule( MODULE );	