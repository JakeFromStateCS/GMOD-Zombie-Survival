local PANEL = {};

function PANEL:Init()
	self:SetSize( 250, 250 );
	self:SetTitle( "Info" );
	self:MenuButtonVisible( false );
	self:SetDraggable( false );
	self:SetCallback( function()
		print( "gg" );
	end );
	self:SetThemeColor( Color( 50, 50, 50 ) );

	--Close Button
	self.CloseButton = vgui.Create( "flatUI_Button", self );
	self.CloseButton:SetSize( 150, 70 );
	self.CloseButton:SetPos( self:GetWide() / 2 - self.CloseButton:GetWide() / 2, self:GetTall() - self.CloseButton:GetTall() - 10 );
	self.CloseButton:SetText( "Close" );
	self.CloseButton:SetCenterText( true );
	local pos = self.CloseButton:GetTextPos();
	self.CloseButton:SetTextPos( pos.x + 25, pos.y );
	self.CloseButton:SetDrawBar( false );
	self.CloseButton:SetCallback( function()
		self:Remove();
		gui.EnableScreenClicker( false );
	end );
	
	self.NameContainer = vgui.Create( "flatUI_Container", self );
	self.NameContainer:SetSize( self:GetWide() - 10, 32 );
	local x, y = self.CloseButton:GetPos();
	pos = { x = x, y = y };
	self.NameContainer:SetPos( 5, 40 );
	
	self.InfoContainer = vgui.Create( "flatUI_Container", self );
	self.InfoContainer:SetSize( self:GetWide() - 10, 80 );
	self.InfoContainer:SetPos( 5, 80 );
	self.InfoContainer:SetXSpacing( 3 );
	self.InfoContainer:SetYSpacing( 0 );
	gui.EnableScreenClicker( true );
end;

function PANEL:SetWeapon( infoTab )
	self.infoTab = infoTab;
	local name = infoTab.name;
	local model = infoTab.weaponModel;
	local button = self.InfoContainer:Add( "flatUI_Button" );
	button:SetSize( 78, 78 );
	button:SetText( "" );
	button:SetAnimateBar( false );
	button:SetClickable( false );
	button:SetDrawBar( false );
	button:SetAlpha( 220 );
	button:SetBarColor( Color( 50, 50, 50 ) );
	button:SetCallback( function( button )
		print( "Test" );
	end );
	if( name and model ) then
		local modelPanel = vgui.Create( "DModelPanel", button );
		modelPanel:SetSize( button:GetWide() - 4, button:GetTall() - 4 );
		modelPanel:SetPos( 2, 2 );
		modelPanel:SetModel( model );
		if( !modelPanel.Entity ) then
			modelPanel:Remove();
			return;
		end;
		local pos = modelPanel.Entity:GetPos();
		local prevMins, prevMaxs = modelPanel.Entity:GetRenderBounds();
		modelPanel:SetLookAt( (prevMaxs + prevMins) / 2 );
		modelPanel:SetCamPos( prevMins:Distance(prevMaxs) * Vector(0.5, 0.5, 0.5) );
		modelPanel:Dock( FILL );
		modelPanel:SetToolTip( name );
		function modelPanel:LayoutEntity()
	
		end;
	end;
	self.InfoContainer:SizeToContents();
end;

function PANEL:SetTimeDead( time )
	surface.SetFont( "flatUI TitleText medium" );
	local W, H = surface.GetTextSize( time );
	if( self.timeDeadButton == nil ) then
		self.timeDeadButton = self.InfoContainer:Add( "flatUI_Button" );
		self.timeDeadButton:SetSize( 78, 78 );
		self.timeDeadButton:SetText( time );
		self.timeDeadButton:SetCenterText( true );
		local pos = self.timeDeadButton:GetTextPos();
		self.timeDeadButton:SetTextPos( self.timeDeadButton:GetWide() / 2 - W / 2, pos.y );
		self.timeDeadButton:SetAnimateBar( false );
		self.timeDeadButton:SetClickable( false );
		self.timeDeadButton:SetDrawBar( false );
		self.timeDeadButton:SetAlpha( 220 );
		self.timeDeadButton:SetBarColor( Color( 50, 50, 50 ) );
		self.timeDeadButton:SetCallback( function( button )
			print( "Test" );
		end );
		self.timeDeadButton:SetToolTip( "Time since death." );
		self.InfoContainer:SizeToContents();
	else
		self.timeDeadButton:SetText( time );
		local pos = self.timeDeadButton:GetTextPos();
		self.timeDeadButton:SetTextPos( self.timeDeadButton:GetWide() / 2 - W / 2, pos.y );
	end;
end;

function PANEL:SetClient( client )
	local button = self.NameContainer:Add( "flatUI_Button" );
	button:SetSize( self.NameContainer:GetWide() - 2, 30 );
	button:SetText( client:Nick() );
	button:SetAnimateBar( false );
	button:SetClickable( true );
	button:SetDrawBar( false );
	button:SetCenterText( true );
	local pos = button:GetTextPos();
	surface.SetFont( "flatUI TitleText medium" );
	local W, H = surface.GetTextSize( client:Nick() );
	button:SetTextPos( button:GetWide() / 2 - W / 2, pos.y );
	button:SetAlpha( 255 );
	button:SetBarColor( Color( 50, 50, 50 ) );
	button:SetCallback( function( button )
		print( "Test" );
	end );
	self.NameContainer:SizeToContents();
end;

function PANEL:SetKiller( client )
	local modelButton = self.InfoContainer:Add( "flatUI_Button" );
	modelButton:SetSize( 78, 78 );
	modelButton:SetText( "" );
	modelButton:SetAnimateBar( false );
	modelButton:SetClickable( false );
	modelButton:SetDrawBar( false );
	modelButton:SetAlpha( 220 );
	modelButton:SetBarColor( Color( 50, 50, 50 ) );
	modelButton:SetCallback( function( button )
		print( "Test" );
	end );
	
	local modelPanel = vgui.Create( "DModelPanel", modelButton );
	modelPanel:SetSize( modelButton:GetWide() - 4, modelButton:GetTall() - 4 );
	modelPanel:SetPos( 2, 2 );
	modelPanel:SetModel( client:GetModel() );
	local eyepos = modelPanel.Entity:GetBonePosition( modelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) );
	eyepos:Add( Vector( 0, 0, 2 ) )
	local prevMins, prevMaxs = modelPanel.Entity:GetRenderBounds();
	modelPanel:SetLookAt( eyepos );
	modelPanel:SetCamPos( eyepos - Vector( -12, 0, 0 ) );
	modelPanel:Dock( FILL );
	modelPanel:SetToolTip( client:Nick() );
	local oldDraw = modelPanel.Paint;
	function modelPanel:LayoutEntity()
	
	end;
	function modelPanel:DoClick()
		local parent = self:GetParent():GetParent():GetParent();
--		print( parent.infoTab );
		if( parent.infoTab ) then
			Base.Modules:NetMessage( "BodyWantPlayer", client, parent.infoTab.client );
		end;
	end;
	/*--
	function modelPanel:Paint()
		local mat = CreateMaterial("GARGAMEL!!!", "UnlitGeneric", {["$basetexture"] = "models/debug/debugwhite"})
		render.ClearStencil()
		render.SetStencilEnable( true );
			render.SetMaterial( mat );
			render.DrawScreenQuad()
			--render.SetStencilZFailOperation( STENCILOPRATION_REPLACE );
			render.SetStencilReferenceValue( 1 );
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL );
			render.SetStencilPassOperation( STENCILOPERATION_ZERO );
			render.SetStencilFailOperation( STENCILOPERATION_KEEP );
			render.SetBlend( 0.5 );
				oldDraw( self );
			render.SetBlend( 1 );
		render.SetStencilEnable( false );
	end;
	*/
	self.InfoContainer:SizeToContents();
end;

function PANEL:Think()
	if( self.infoTab ) then
		local time = math.Round( CurTime() - self.infoTab.time );
		self:SetTimeDead( time );
	end;
end;

vgui.Register( "DarkRP_BodyInfo", PANEL, "flatUI_Frame" );