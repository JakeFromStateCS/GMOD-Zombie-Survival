--[[
	Minigame/Lobby buttons
	Basically the button with a bar
]]--

local PANEL = {};

function PANEL:Init()
	self.barColor = Color( 255, 255, 255 );
	self.textColor = Color( 255, 255, 255 );
	self.backgroundColor = Color( 50, 50, 50, 255 );--Color( self.barColor.r, self.barColor.g, self.barColor.b, 100 );--Color( 153, 153, 153 );
	self.text = "undefined";
	self.progText = "0/0";
	self.font = "flatUI TitleText tiny";
	self.progFont = "flatUI ButtonText tiny";
	self.click = false;
	self.size = 0;
	self.alpha = 150;
	self.barWidth = 30;
	self.clickable = true;
	self.animateBar = true;
	self.drawBar = true;
	self.centerText = false;
	self.HCenterText = false;
	self.textPos = {
		x = 20,
		y = 5
	};
	self.clickTime = CurTime();
end;

function PANEL:PerformLayout()
	--self:SetSize( 200, 70 );
	surface.SetFont( self.font );
	local W,H = surface.GetTextSize( self.text );
	self.textPos.y = self:GetTall() / 2 - H / 2;
end;

function PANEL:SetAlpha( num )
	self.alpha = num;
end;

function PANEL:SetBarColor( color )
	self.barColor = color;
	self.backgroundColor = Color( self.barColor.r, self.barColor.g, self.barColor.b, self.alpha );
end;

function PANEL:SetTextColor( color )
	self.textColor = color;
end;

function PANEL:SetText( text )
	self.text = text;
	if( self.centerText ) then
		surface.SetFont( self.font );
		local W,H = surface.GetTextSize( text );
		self:SetTextPos( self:GetWide() / 2 - W / 2, self:GetTall() / 2 - H / 2 );
	end;
end;

function PANEL:SetProgText( text )
	self.progText = text;
end;

function PANEL:GetTextPos()
	return { x = self.textPos.x, y = self.textPos.y };
end;

function PANEL:SetTextPos( x, y )
	self.textPos.x = x;
	self.textPos.y = y;
end;

function PANEL:SetCenterText( bool )
	self.centerText = bool;
end;

function PANEL:SetHorizontalCenterText( bool )
	self.HCenterText = bool;
end;

function PANEL:SetClickable( bool )
	self.clickable = bool;
end;

function PANEL:SetAnimateBar( bool )
	self.animateBar = bool;
end;

function PANEL:SetDrawBar( bool )
	self.drawBar = bool;
end;

function PANEL:SetBackgroundColor( color )
	self.backgroundColor = color;
end;

function PANEL:SetHovered( hovered )
	self.hovered = hovered;
end;

function PANEL:GetHovered()
	return self.hovered;
end;

function PANEL:OnCursorEntered()
	--local hBackgroundColor = Color( self.backgroundColor.r + 20, self.backgroundColor.g + 20, self.backgroundColor.b + 20 );
	self:SetHovered( true );
	--self.backgroundColor = hBackgroundColor;
end;

function PANEL:OnCursorExited()
	--local hBackgroundColor = Color( self.backgroundColor.r - 20, self.backgroundColor.g - 20, self.backgroundColor.b - 20 );
	self:SetHovered( false );
	--self.backgroundColor = hBackgroundColor;
end;

function PANEL:OnMousePressed( code )
	if( self.clickable ) then
		self:MouseCapture( true );
		self.click = true;
	end;
end;

function PANEL:OnMouseReleased( code )
	self:MouseCapture( false );
	self.click = false;
	
	if( !self:GetHovered() ) then
		return;
	end;
	
	if( self.clickable ) then
		if( code == MOUSE_LEFT and self.DoClick ) then
			self.DoClick( self );
			self.clickTime = CurTime();
		end;
	end;
end;

function PANEL:SetCallback( callback )
	self.DoClick = function( panel )
		callback( panel );
		surface.PlaySound( "buttons/button14.wav" );
	end;
end;

function PANEL:Paint( w, h )
	local x, y = self:GetPos();
	local themeColor = Base.VGUI.Config.colors.theme;
	local highlightColor = Color( math.Clamp( themeColor.r + 20, 0, 255 ), math.Clamp( themeColor.g + 20, 0, 255 ), math.Clamp( themeColor.b + 20, 0, 255 ) );
	if( !themeColor ) then
		--themeColor = --Base.VGUI.ThemeColor;
	end;
	if( !highlightColor ) then
		highlightColor = Base.VGUI.HighlightColor;
	end;
	--local width, height = self:GetSize();
	--local textHeight = draw.GetFontHeight( self.font );
	


	if( self.click ) then
		self.size = math.Approach( self.size, 5, 1.5 );
	else
		if( self.size > 0 ) then
			self.size = math.Approach( self.size, 0, 1.5 );
		end;
	end;

	surface.SetDrawColor( self.backgroundColor );
	surface.DrawRect( self.size, self.size, w - self.size * 2, h - self.size * 2 );
	
	if( self.drawBar ) then
		surface.SetDrawColor( self.barColor );
		surface.DrawRect( self.size, self.size, self.barWidth - self.size, h - self.size * 2 );
	end;

	if( self:GetHovered() ) then
		surface.SetDrawColor( highlightColor );
		surface.DrawRect( 0 + self.size, h - 4 - self.size, w - self.size * 2, 4 );
		surface.DrawRect( 0 + self.size, self.size, w - self.size * 2, 4 );
		surface.DrawRect( w - 4 - self.size, self.size, 4, h - self.size * 2 );
		surface.DrawRect( 0 + self.size, self.size, 4, h - self.size * 2 );
		--self.barWidth = math.Approach( self.barWidth, w - 5, 10 );
		if( self.animateBar ) then
			self.barWidth = math.Clamp( self.barWidth + 1000 * FrameTime(), 30, w - 5 );
		end;
	else
		if( self.animateBar ) then
			self.barWidth = math.Clamp( self.barWidth - 1000 * FrameTime(), 30, w - 5 );
		end;
		--self.barWidth = math.Approach( self.barWidth, 30, 10 );
	end;
	
	--surface.SetDrawColor( bhColor );
	--surface.DrawRect( 0, 0, 30, 2 );
	
	--surface.SetDrawColor( bghColor );
	--surface.DrawLine( 30, 0, w, 0 );
	
	
	--Progress text
	--Need to make it not go outside the button
	surface.SetFont( self.progFont );
	local w, h = surface.GetTextSize( self.progText );
	local progX, progY = math.Clamp( self.barWidth - w / 2, 0, self:GetWide() - w ), self:GetTall() - h - self.size;
	surface.SetTextColor( Color( 255, 255, 255 ) );
	surface.SetTextPos( progX, progY );
	surface.DrawText( self.progText );
	
	surface.SetFont( self.font );
	local w, h = surface.GetTextSize( self.text );
	surface.SetTextColor( Color( 255, 255, 255 ) );
	surface.SetTextPos( 30, 0 + self.size );
	surface.DrawText( self.text );
	
end;

vgui.Register( "flatUI_ProgressButton", PANEL, "DPanel" );
