local MODULE = MODULE or {};
MODULE.Hooks = MODULE.Hooks or {};

local PANEL = {};

function PANEL:Init()
	self:SetTitle( "Experience" );
	self:MenuButtonVisible( false );
	self:SetDraggable( false );
	self:SetCallback( function()
		print( "gg" );
	end );
	self:SetThemeColor( Color( 50, 50, 50 ) );
	self:SetSize( 250, 80 );
	self.ExpBarCont = vgui.Create( "flatUI_Container", self );
	self.ExpBarCont:SetSize( self:GetWide() - 4, self:GetTall() - 35 );
	self.ExpBarCont:SetPos( 2, 35 );
	
	self.button = self.ExpBarCont:Add( "flatUI_ProgressButton" );
	self.button:SetSize( self.ExpBarCont:GetWide() - 2, 40 );
	self.button:SetText( "N/A" .. " - " .. 0 );
	self.button:SetProgText( 0 .. "/" .. 0 );
	self.button:SetAnimateBar( false );
	self.button:SetClickable( true );
	self.button:SetDrawBar( true );
	self.button.barWidth = ( self:GetWide() / 1 * 1 );
	self.button:SetAlpha( 220 );
	self.button:SetBarColor( Color( 50, 50, 50 ) ); 
	self.button.backgroundColor = Color( 150, 150, 150 );
	self.button:SetCallback( function( button )
		
	end );
	self.button:Center();
	
end;

function PANEL:SetData( name, data )
	local level = Base.Skill:GetPlayerSkill( LocalPlayer(), name );
	local exp = Base.Skill:GetPlayerExperience( LocalPlayer(), name );
	local maxExp = Base.Skill.Config.BaseExp + ( level * Base.Skill.Config.BaseExp + ( 100 * level ) );
	self:SetTitle( name .. " - " .. level );
	self.button.barWidth = ( self:GetWide() / maxExp * data );
	self.button:SetText( name .. " - " .. data );
	self.button:SetProgText( exp .. "/" .. maxExp );
end;


vgui.Register( "BLRP_EXPInfo", PANEL, "flatUI_Frame" );