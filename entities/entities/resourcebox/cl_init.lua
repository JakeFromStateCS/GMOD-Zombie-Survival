include("shared.lua")

function ENT:GetResourceType()
	return self:GetNWString( "ResourceType" );
end;

function ENT:GetResourceAmount()
	return self:GetNWInt( "ResourceAmount" );
end;

function ENT:Draw()
	self:DrawModel()
	self:DrawInfo();
end

function ENT:DrawInfo()
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local canvSize = { x = 120, y = 100 };

	cam.Start3D2D(Pos + Ang:Up() * 25, Ang, 0.2)
		
	cam.End3D2D()

	Ang:RotateAroundAxis(Ang:Forward(), 90)

	local text = self:GetResourceType();
	local TextWidth = surface.GetTextSize(text)
	
	local amount = self:GetResourceAmount();
	local amountWidth = surface.GetTextSize( amount );

	cam.Start3D2D(Pos + Ang:Up() * 16.5 - Ang:Right() * 22.8 - Ang:Forward() * 11, Ang, 0.20)
		surface.SetDrawColor( Color( 50, 50, 50 ) );
		surface.DrawRect( 0, 0, canvSize.x, canvSize.y );
		
		
		surface.SetFont( "flatUI TitleText large" );
		surface.SetTextColor( Color( 255, 255, 255 ) );
		surface.SetTextPos( -TextWidth / 2 + canvSize.x / 2, canvSize.y / 2 );
		surface.DrawText( text );
		
		surface.SetTextPos( -amountWidth + TextWidth / 2 + canvSize.x / 2, canvSize.y / 10 );
		surface.DrawText( amount );
	cam.End3D2D()
end