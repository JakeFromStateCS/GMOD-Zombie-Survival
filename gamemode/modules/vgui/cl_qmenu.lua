local PANEL = {};

function PANEL:Init()
	self:SetTitle( "BLRP" );
	self:MenuButtonVisible( false );
	self:SetDraggable( false );
	self:SetCallback( function()
		print( "gg" );
	end );
	self:SetThemeColor( Color( 50, 50, 50 ) );
	self:SetSize( 321, 300 );
	self:Center();
	self.SelectNumberMax = 100;
	self.SelectNumber = 0;
	
	self.JobsFrame = vgui.Create( "flatUI_Frame" );
	self.JobsFrame:SetTitle( "Job Titles" );
	self.JobsFrame:SetDraggable( false );
	self.JobsFrame:MenuButtonVisible( false );
	self.JobsFrame:SetCallback( function()
		print( "GG Scrub" );
	end );
	self.JobsFrame:SetThemeColor( Color( 50, 50, 50 ) );
	self.JobsFrame:SetSize( 321, 300 );
	self.JobsFrame:SetPos( ScrW() / 2 - self.JobsFrame:GetWide() / 2, ScrH() / 2 - self:GetTall() / 2 );
	self.JobsFrame:MoveToBack();
	self.JobsFrame.InBack = true;
	self.JobsFrame.Container = vgui.Create( "flatUI_Container", self.JobsFrame );
	self.JobsFrame.Container:SetSize( self.JobsFrame:GetWide(), self.JobsFrame:GetTall() - ( 38 + 35 ) );
	self.JobsFrame.Container:SetPos( 3, 38 );
	
	
	self.ResourceFrame = vgui.Create( "flatUI_Frame" );
	self.ResourceFrame:SetTitle( "Resources" );
	self.ResourceFrame:SetDraggable( false );
	self.ResourceFrame:MenuButtonVisible( false );
	self.ResourceFrame:SetCallback( function()
	
	end );
	self.ResourceFrame:MoveToBack();
	
	self.ResourceFrame:SetThemeColor( Color( 50, 50, 50 ) );
	self.ResourceFrame:SetSize( 321, 300 );
	self.ResourceFrame:SetPos( ScrW() / 2 - self.ResourceFrame:GetWide() / 2, ScrH() / 2 - self:GetTall() / 2 );
	self.ResourceFrame:MoveToBack();
	self.ResourceFrame.InBack = true;
	self.ResourceFrame.Container = vgui.Create( "flatUI_Container", self.ResourceFrame );
	self.ResourceFrame.Container:SetSize( self.JobsFrame:GetWide(), self.JobsFrame:GetTall() - 38 + 35 );
	self.ResourceFrame.Container:SetPos( 3, 38 );
	
	
	self.PropertySheet = vgui.Create( "flatUI_PropertySheet", self );
	self.PropertySheet:SetSize( self:GetWide(), self:GetTall() - 35 - 8 );
	self.PropertySheet:SetPos( 0, 39 );
	self.PropertySheet:SetTabSpacing( 5 );
	
	--self.Jobs = self.PropertySheet:AddTab( "Jobs", vgui.Create( "DPanel" ) );
	--self.Container = vgui.Create( "flatUI_Container", self.Jobs );
	--self.Container:SetSize( self:GetWide(), self:GetTall() - 38 + 35 );
	--self.Container:SetPos( 3, 0 );
	
	--self.Items = self.PropertySheet:AddTab( "Items", vgui.Create( "DPanel" ) );
	--self.ItemCont = vgui.Create( "flatUI_Container", self.Items );
	--self.ItemCont:SetSize( self.Items:GetWide(), self.Items:GetTall() );
	--self.ItemCont:SetPos( 3, 0 );
	
	self.Skills = self.PropertySheet:AddTab( "Skills", vgui.Create( "DPanel" ) );
	self.SkillsCont = vgui.Create( "flatUI_Container", self.Skills );
	self.SkillsCont:SetSize( self.Skills:GetWide() - 4, self.Skills:GetTall() );
	self.SkillsCont:SetPos( 3, 0 );
	function self.Skills:OnSetActive()
		local parent = self:GetParent();
		local frame = parent:GetParent();
		--frame.JobsFrame:MoveTo( ScrW() / 2 + frame.JobsFrame:GetWide() / 2, ScrH() / 2 - frame.JobsFrame:GetTall() / 2, 0.15 );
	end;
	function self.Skills:OnLoseActive()
		local parent = self:GetParent();
		local frame = parent:GetParent();
		frame.JobsFrame:MoveTo( ScrW() / 2 - frame.JobsFrame:GetWide() / 2, ScrH() / 2 - frame.JobsFrame:GetTall() / 2, 0.15 );
		
	end;

	
	
	self.Resources = self.PropertySheet:AddTab( "Pocket", vgui.Create( "DPanel" ) );
	function self.Resources:Paint( w, h )
		surface.SetDrawColor( Color( 0, 0, 0 ) );
		surface.DrawRect( 0, 0, w, h );
	end;
	self.Crafting = vgui.Create( "flatUI_craft",  self.Resources );
	self.ResourceCont = vgui.Create( "flatUI_Container", self.ResourceFrame );
	self.ResourceCont:SetSize( self.Resources:GetWide() - 4, self.Resources:GetTall() );
	self.ResourceCont:SetPos( 3, 39 );
	function self.Resources:OnLoseActive()
		local parent = self:GetParent();
		local frame = parent:GetParent();
		frame.ResourceFrame:MoveTo( ScrW() / 2 - frame.ResourceFrame:GetWide() / 2, ScrH() / 2 - frame.ResourceFrame:GetTall() / 2, 0.15 );
	end;
	function self.Resources:OnSetActive()
		local parent = self:GetParent();
		local frame = parent:GetParent();
		frame.ResourceFrame:MoveTo( ScrW() / 2 - frame.ResourceFrame:GetWide() * 1.5, ScrH() / 2 - frame.ResourceFrame:GetTall() / 2, 0.15 );
	end;
	
	--self:PopulateItems();
	self:PopulateSkills();
	self:PopulateResources();
	self.PropertySheet:SetActiveTab( "Skills" );
end;

function PANEL:PopulateSkills()
	local skills = Base.Skill:GetPlayerSkills( LocalPlayer() );
	for name,skill in pairs( skills ) do
		self:AddSkill( name, skill );
	end;
	--timer.Simple( 0.2, function()
		self.SkillsCont:SizeToContents();
	--end );
end;

function PANEL:PopulateResources()
	local resources = Base.Resource:GetPlayerResources( LocalPlayer() );
	for name,resource in pairs( resources ) do
		self:AddResource( name, resource );
	end;
	self.ResourceCont:SizeToContents();
end;

function PANEL:PopulateItems()
	for name,ITEM in pairs( Base.Items.Stored ) do
		self:AddItem( name, ITEM );
	end;
end;

function PANEL:ClearJobs()
	for k,panel in pairs( self.JobsFrame.Container:GetItems() ) do
		panel:Remove();
		self.JobsFrame.Container.Panels[k] = nil;
	end;
end;

function PANEL:PopulateJobs( name )
	local jobs = Base.Jobs:GetJobsFromSkill( name );
	for _,name in pairs( jobs ) do
		if( name ~= LocalPlayer().jobName ) then
			self:AddJob( name );
		end;
	end;
	self.JobsFrame.Container:SizeToContents();
end;

function PANEL:AddResource( name, amount )
	local RESOURCE = Base.Resource.Stored[name];
	if( RESOURCE ) then
		local button = self.ResourceCont:Add( "flatUI_Button" );
		button:SetSize( self.ResourceCont:GetWide() - 2, 40 );
		button:SetText( name .. " " .. amount );
		button:SetAnimateBar( false );
		button:SetClickable( true );
		button:SetDrawBar( false );
		button:SetAlpha( 220 );
		button:SetBarColor( Color( 50, 50, 50 ) ); 
		button.backgroundColor = RESOURCE.Color;
		button:SetCallback( function( button )
			if( !self.ResourceFrame.InBack ) then
			else
				
				--self.ResourceFrame:MoveTo( ScrW() / 2 + self.ResourceFrame:GetWide() / 2, ScrH() / 2 - self.ResourceFrame:GetTall() / 2, 0.15 );
				self.ResourceFrame.InBack = false;
			end;
		end );
	end;
end;

function PANEL:AddSkill( name, amount )
	local exp = Base.Skill:GetPlayerExperience( LocalPlayer(), name );
	local maxExp = Base.Skill.Config.BaseExp + ( amount * Base.Skill.Config.BaseExp + ( 100 * amount ) );
	local button = self.SkillsCont:Add( "flatUI_ProgressButton" );
	button:SetSize( self.SkillsCont:GetWide() - 2, 40 );
	button:SetText( name .. " - " .. amount );
	button:SetProgText( exp .. "/" .. maxExp );
	button:SetAnimateBar( false );
	button:SetClickable( true );
	button:SetDrawBar( true );
	button.barWidth = ( self:GetWide() / maxExp * exp );
	button:SetAlpha( 220 );
	button:SetBarColor( Color( 50, 50, 50 ) ); 
	button.backgroundColor = Color( 150, 150, 150 );
	button:SetCallback( function( button )
		if( !self.JobsFrame.InBack ) then
			self.JobsFrame:MoveTo( ScrW() / 2 - self.JobsFrame:GetWide() / 2, ScrH() / 2 - self.JobsFrame:GetTall() / 2, 0.15, 0, -1, function()
				self:ClearJobs();
				self:PopulateJobs( name );
				self.JobsFrame:MoveTo( ScrW() / 2 + self.JobsFrame:GetWide() / 2, ScrH() / 2 - self.JobsFrame:GetTall() / 2, 0.15 );
				--self.JobsFrame.Container:SetFocus( true ); 
			end );
		else
			self:PopulateJobs( name );
			self.JobsFrame:MoveTo( ScrW() / 2 + self.JobsFrame:GetWide() / 2, ScrH() / 2 - self.JobsFrame:GetTall() / 2, 0.15 );
			self.JobsFrame.InBack = false;
			--self.JobsFrame.Container:SetFocus( true );
			--self.JobsFrame.Container:MoveToBack();
		end;
	end );
end;

function PANEL:AddItem( name, ITEM )
	local modelButton = self.ItemCont:Add( "flatUI_Button" );
	modelButton:SetSize( 78, 78 );
	modelButton:SetText( name );
	modelButton:SetAnimateBar( false );
	modelButton:SetClickable( true );
	modelButton:SetDrawBar( false );
	modelButton:SetAlpha( 220 );
	modelButton:SetBarColor( Color( 50, 50, 50 ) );
	modelButton:SetCallback( function( button )
		Base.Modules:NetMessage( "SpawnItem", name );
	end );
	
	local textPos = modelButton:GetTextPos();
	modelButton:SetTextPos( 5, textPos.y );
end;

function PANEL:AddRecipe( name )
	local RECIPE = Base.Crafting.Stored[name];
	if( RECIPE ) then
		local button = self.ResourceFrame.Container:Add( "flatUI_Button" );
		button:SetSize( self.ResourceFrame.Container:GetWide() - 2, 40 );
		button:SetText( name );
		button:SetAnimateBar( false );
		button:SetClickable( true );
		button:SetDrawBar( false );
		button:SetAlpha( 220 );
		button.backgroundColor = RECIPE.Color;
		button:SetCallback( function( button )
			print( "Hello" );
		end );
	end;
end;

function PANEL:AddJob( name )
	local JOB = Base.Jobs.Stored[name];
	if( JOB ) then
		local button = self.JobsFrame.Container:Add( "flatUI_Button" );
		button:SetSize( self.JobsFrame.Container:GetWide() - 2, 40 );
		button:SetText( name );
		button:SetAnimateBar( false );
		button:SetClickable( true );
		button:SetDrawBar( false );
		button:SetAlpha( 220 );
		button.backgroundColor = JOB.Color;
		button:SetCallback( function( button )
			Base.Modules:NetMessage( "SetJob", name );
			timer.Simple( 0.25, function()
				if( self.JobsFrame ~= nil ) then
					if( !self.JobsFrame.InBack ) then
						self.JobsFrame:MoveTo( ScrW() / 2 - self.JobsFrame:GetWide() / 2, ScrH() / 2 - self.JobsFrame:GetTall() / 2, 0.15, 0, -1, function()
							self:ClearJobs();
							self:PopulateJobs( name );
							self.JobsFrame:MoveTo( ScrW() / 2 + self.JobsFrame:GetWide() / 2, ScrH() / 2 - self.JobsFrame:GetTall() / 2, 0.15 );
							
						end );
					else
						self:PopulateJobs( name );
						self.JobsFrame:MoveTo( ScrW() / 2 + self.JobsFrame:GetWide() / 2, ScrH() / 2 - self.JobsFrame:GetTall() / 2, 0.15 );
						self.JobsFrame.InBack = false;
						
					end;
				end;
			end );
		end );
	end;
end;

vgui.Register( "BLRP_QMenu", PANEL, "flatUI_Frame" );