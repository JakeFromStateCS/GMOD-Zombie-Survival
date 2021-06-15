local PANEL = {};

function PANEL:Init()
	self.BackgroundColor = ( Base.VGUI ~= nil and Base.VGUI.Config.colors.background ) or Color( 255, 255, 255 );
	self.ThemeColor = ( Base.VGUI ~= nil and Base.VGUI.Config.colors.theme ) or Color( 255, 255, 255 );
	self.MinHeight = 30;
	self.Text = "Undefined";
	self.Font = "flatUI TitleText tiny";
	self.Icon = Material( "icon16/information.png" );
	self.RemoveTime = CurTime() + 5;
	self.Index = 0;
	surface.SetFont( self.Font );
	local W, H = surface.GetTextSize( self.Text );
	if( H < self.MinHeight ) then
		H = self.MinHeight;
	end;
	self:SetSize( W + 10, H );

	self:SetPos( Base.DeathNotice.Config.offset.x - self:GetWide(), Base.DeathNotice.Config.offset.y );
end;

function PANEL:SetLifeTime( len )
	self.RemoveTime = CurTime() + len;
end;

function PANEL:SetColor( col )
	self.BackgroundColor = col;
end;

function PANEL:SetThemeColor( col )
	self.ThemeColor = col;
end;

function PANEL:SetIcon( iconPath )
	local icon = Material( iconPath );
	if( icon ) then
		self.Icon = icon;
	end;
end;

function PANEL:SetText( text )
	if( text ~= "" ) then
		self.Text = text;
		surface.SetFont( self.Font );
		local W, H = surface.GetTextSize( self.Text );
		if( H < self.MinHeight ) then
			H = self.MinHeight;
		end;
		self:SetSize( W + 14, H );
	end;
end;

function PANEL:SetIndex( num )
	self.Index = num;
end;

function PANEL:Paint( w, h )
	surface.SetDrawColor( self.BackgroundColor );
	surface.DrawRect( 0, 0, w, h );

	surface.SetDrawColor( self.ThemeColor );
	surface.DrawRect( 0, 0, 4, h );
	--surface.DrawRect( 0, 0, w, 2 );
	--surface.DrawRect( 0, 0, 2, h );
	--surface.DrawRect( 0, h - 2, w, 2 );
	--surface.DrawRect( w - 2, 0, 2, h );

	surface.SetFont( self.Font );
	local textW, textH = surface.GetTextSize( self.Text );

	surface.SetTextPos( 7, h / 2 - textH / 2 );
	surface.SetTextColor( Color( 0, 0, 0 ) );
	surface.DrawText( self.Text );
end;

function PANEL:Think()
	
end;

vgui.Register( "flatUI_Notification", PANEL, "DPanel" );