local PANEL = {};

function PANEL:Init()
	self:SetTitle( "Build" );
	self:MenuButtonVisible( false );
	self:SetDraggable( false );
	self:SetCallback( function()
		print( "gg" );
	end );
	self:SetThemeColor( Color( 50, 50, 50 ) );
	self:SetSize( 321, 440 );
	self:Center();
	self.SelectNumberMax = 100;
	self.SelectNumber = 0;

	
	self.ToolData = {};
	self.Categories = {};
	
	self.PropertySheet = vgui.Create( "flatUI_PropertySheet", self );
	self.PropertySheet:SetSize( self:GetWide(), self:GetTall() - 35 );
	self.PropertySheet:SetPos( 0, 39 );
	self.PropertySheet:SetTabSpacing( 5 );
	
	self.Tools = self.PropertySheet:AddTab( "Tools", vgui.Create( "DPanel" ) );
	self.Tools:SetSize( self:GetWide(), self:GetTall() - ( 35 + 40 ) );
	self.ToolCont = vgui.Create( "flatUI_Container", self.Tools );
	self.ToolCont:SetSize( self:GetWide() - 6, self:GetTall() - ( 38 + 35 + 40 ) );
	self.ToolCont:SetPos( 3, 0 );

	self.ToolPageCont = vgui.Create( "flatUI_Container", self.Tools );
	self.ToolPageCont:SetSize( self:GetWide(), 40 );
	self.ToolPageCont:SetPos( 3, self.Tools:GetTall() - 46  );
	self.ToolPageCont:SetXSpacing( 12 );
	
	self.Props = self.PropertySheet:AddTab( "Props", vgui.Create( "DPanel" ) );
	self.Props:SetSize( self:GetWide(), self:GetTall() -  35 - 40 );
	self.Container = vgui.Create( "flatUI_Container", self.Props );
	self.Container:SetSize( self.Props:GetWide(), self.Props:GetTall() - ( 35 + 40 ) );
	self.Container:SetPos( 3, 0 );

	self.PageCont = vgui.Create( "flatUI_Container", self.Props );
	self.PageCont:SetSize( self:GetWide(), 40 );
	self.PageCont:SetPos( 3, self.Props:GetTall() - 46  );
	self.PageCont:SetXSpacing( 15 );

	self:AddPageButtons();
	self:AddToolPageButtons();
	self:PopulateProps();
	self:PopulateCategories();
	self.PropertySheet:SetActiveTab( "Props" );
	self.Container:SetSize( self.Props:GetWide(), self.Props:GetTall() - 49 );
	self.ToolCont:SetSize( self:GetWide() - 6, self.Tools:GetTall() - 49 );

end;

function PANEL:ForwardPage()
	self.Container:OnMouseWheeled( -self.Container:GetTall() / 30 );
end;

function PANEL:BackwardPage()
	self.Container:OnMouseWheeled( self.Container:GetTall() / 30 );
end;

function PANEL:ForwardTools()
	self.ToolCont:OnMouseWheeled( -self.ToolCont:GetTall() / 30 );
end;

function PANEL:BackwardTools()
	self.ToolCont:OnMouseWheeled( self.ToolCont:GetTall() / 30 );
end;

function PANEL:PopulateProps()
	for model,_ in pairs( Base.Props.Config.Models ) do
		self:AddProp( model );
	end;
	self.Container:SizeToContents();
end;

function PANEL:AddPageButtons()
	local forwardButton = self.PageCont:Add( "flatUI_Button" );
	forwardButton:SetSize( self.PageCont:GetWide() / 2 - 10, 40 );
	forwardButton:SetCenterText( true );
	forwardButton:SetText( "Forward" );
	forwardButton:SetAnimateBar( false );
	forwardButton:SetClickable( true );
	forwardButton:SetDrawBar( false );
	forwardButton:SetAlpha( 220 );
	forwardButton:SetBarColor( Color( 70, 70, 70 ) );
	forwardButton.backgroundColor = Color( 50, 50, 50 );
	forwardButton:SetCallback( function( button )
		self:ForwardPage();
	end );
	local backwardButton = self.PageCont:Add( "flatUI_Button" );
	backwardButton:SetSize( self.PageCont:GetWide() / 2 - 10, 40 );
	backwardButton:SetCenterText( true );
	backwardButton:SetText( "Back" );
	backwardButton:SetAnimateBar( false );
	backwardButton:SetClickable( true );
	backwardButton:SetDrawBar( false );
	backwardButton:SetAlpha( 220 );
	backwardButton:SetBarColor( Color( 70, 70, 70 ) );
	backwardButton.backgroundColor = Color( 50, 50, 50 );
	backwardButton:SetCallback( function( button )
		self:BackwardPage();
	end );

	self.PageCont:SizeToContents();
end;

function PANEL:AddToolPageButtons()
	local forwardButton = self.ToolPageCont:Add( "flatUI_Button" );
	forwardButton:SetSize( self.ToolPageCont:GetWide() / 2 - 10, 40 );
	forwardButton:SetCenterText( true );
	forwardButton:SetText( "Forward" );
	forwardButton:SetAnimateBar( false );
	forwardButton:SetClickable( true );
	forwardButton:SetDrawBar( false );
	forwardButton:SetAlpha( 220 );
	forwardButton:SetBarColor( Color( 70, 70, 70 ) );
	forwardButton.backgroundColor = Color( 50, 50, 50 );
	forwardButton:SetCallback( function( button )
		self:ForwardTools();
	end );
	local backwardButton = self.ToolPageCont:Add( "flatUI_Button" );
	backwardButton:SetSize( self.ToolPageCont:GetWide() / 2 - 10, 40 );
	backwardButton:SetCenterText( true );
	backwardButton:SetText( "Back" );
	backwardButton:SetAnimateBar( false );
	backwardButton:SetClickable( true );
	backwardButton:SetDrawBar( false );
	backwardButton:SetAlpha( 220 );
	backwardButton:SetBarColor( Color( 70, 70, 70 ) );
	backwardButton.backgroundColor = Color( 50, 50, 50 );
	backwardButton:SetCallback( function( button )
		self:BackwardTools();
	end );

	self.ToolPageCont:SizeToContents();
end;


function PANEL:AddTools()
	for category,tools in pairs( self.ToolData ) do
		self:AddCategory( self.Categories[category] );
		for _,tool in pairs( tools ) do
			self:AddTool( tool.name, tool.cmd );
		end;
	end;
	self.ToolCont:SizeToContents();
end;

function PANEL:PopulateCategories()
	local toolgun = LocalPlayer():GetWeapon( "gmod_tool" );
	local tools = toolgun.Tool;
	for k,v in pairs( tools ) do
		local category = v.Category;
		if( category ) then
			local id = string.byte(string.Left(category, 3), 1, 2);
			if( self.ToolData[id] == nil ) then
				self.ToolData[id] = {};
				self.Categories[id] = category;
			end;
			table.insert( self.ToolData[id], {
				name = v.Name,
				cmd = v.Mode,
				category = category
			} );
		end;
	end;
	self:AddTools();
end;

function PANEL:AddCategory( name )
	local button = self.ToolCont:Add( "flatUI_Button" );
	button:SetSize( self.ToolCont:GetWide(), 40 );
	button:SetText( ( name or "undefined" ) );
	button:SetAnimateBar( false );
	button:SetClickable( false );
	button:SetDrawBar( false );
	button:SetAlpha( 220 );
	button:SetBarColor( Color( 70, 70, 70 ) );
	button.backgroundColor = Color( 50, 50, 50 );
	button:SetCallback( function( button )
		RunConsoleCommand( "gmod_toolmode", cmd );
	end );
end;

function PANEL:AddTool( name, cmd )
	local button = self.ToolCont:Add( "flatUI_Button" );
	button:SetSize( self.ToolCont:GetWide(), 40 );
	button:SetText( ( name or "undefined" ) );
	button:SetAnimateBar( false );
	button:SetClickable( true );
	button:SetDrawBar( false );
	button:SetAlpha( 220 );
	button:SetBarColor( Color( 50, 50, 50 ) ); 
	button:SetCallback( function( button )
		RunConsoleCommand( "gmod_toolmode", cmd );
	end );
end;

function PANEL:AddProp( model )
	local modelButton = self.Container:Add( "flatUI_Button" );
	modelButton:SetSize( 78, 78 );
	modelButton:SetText( "" );
	modelButton:SetAnimateBar( false );
	modelButton:SetClickable( true );
	modelButton:SetDrawBar( false );
	modelButton:SetAlpha( 220 );
	modelButton:SetBarColor( Color( 50, 50, 50 ) );
	modelButton:SetCallback( function( button )
		Base.Modules:NetMessage( "SpawnProp", model );
	end );
	

	local modelPanel = vgui.Create( "DModelPanel", modelButton );
	modelPanel:SetSize( modelButton:GetWide() - 4, modelButton:GetTall() - 4 );
	modelPanel:SetPos( 2, 2 );
	modelPanel:SetModel( model );
	local prevMins, prevMaxs = modelPanel.Entity:GetRenderBounds();
	modelPanel:SetCamPos( prevMins:Distance( prevMaxs ) * Vector( 0.5, 0.5, 0.5 ) );
	modelPanel:SetLookAt( ( prevMins + prevMaxs ) / 2 );
	modelPanel:Dock( FILL );
	modelPanel:SetToolTip( model );
	function modelPanel:LayoutEntity()
	
	end;
	function modelPanel:DoClick()
		modelButton:OnMousePressed();
		modelButton:DoClick();
		timer.Simple( 0.2, function()
			if( modelButton:IsVisible() ) then
				modelButton:OnMouseReleased();
			end;
		end );
	end;
	
end;

vgui.Register( "BLRP_PropMenu", PANEL, "flatUI_Frame" );