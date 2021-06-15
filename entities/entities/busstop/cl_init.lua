include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Stop = self:GetNetworkedInt( "Stop" ) or 0;
	surface.SetFont("flatUI TitleText large")
	local TextWidth = surface.GetTextSize("Bus Stop")

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local TextAng = Ang

	TextAng:RotateAroundAxis(TextAng:Right(), -90)

	cam.Start3D2D(Pos + Ang:Right() * -15, TextAng, 0.1)
		draw.WordBox(2, -TextWidth*0.5 + 5, -30, "Bus Stop", "flatUI TitleText large", Color(140, 0, 0, 100), Color(255,255,255,255))
		draw.WordBox( 2, -TextWidth*0.5 + 5, -50, Stop, "flatUI TitleText large", Color( 140, 0, 0, 100 ), Color( 255, 255, 255, 255 ) );
	cam.End3D2D()
end

function ENT:Think()
end
