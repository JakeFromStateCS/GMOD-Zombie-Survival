local MODULE = MODULE or {};
MODULE.Hooks = MODULE.Hooks or {};

local PANEL = {};

function PANEL:Init()
	local parent = self:GetParent();
	print( parent:GetWide(), parent:GetTall() );
	self.Grid = {};
	
	self:SetSize( parent:GetWide(), parent:GetTall() );
	self:SetPos( 0, 0 )
end;

function PANEL:Paint()
	local columns = 3;
	local padding = 8;
	local parent = self:GetParent();
	local parentW,parentH = parent:GetWide(), parent:GetTall();
	local rectW,rectH = parentW - padding, parentH - padding;
	local rows = 2;
	local squareW,squareH = rectW / columns, rectH / rows;
	for row=1, rows do
		for column=1, columns do
			surface.SetDrawColor( Color( 220, 150, 150 ) );
			surface.DrawRect( padding / 2 + ( column - 1 ) * rectW, padding / 2 + ( row - 1 ) * rectH, rectW - padding, rectH - padding );
		end;
	end;
end;


vgui.Register( "flatUI_craft", PANEL, "flatUI_Container" );