local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Draw";
MODULE.Data = {};
MODULE.Stored = {};
MODULE.Config = {};

local math = math
local surface = surface
local ValidPanel = ValidPanel

function math.CeilPower2(n)
	return math.pow(2, math.ceil(math.log(n) / math.log(2)))
end


function draw.HTMLTexture( panel, w, h, x, y )

	if not ( panel and ValidPanel(panel) and w and h ) then return end
	
	panel:UpdateHTMLTexture()

	local pw, ph = panel:GetSize()

	-- Convert to scalar
	w = w / pw
	h = h / ph

	-- Fix for non-power-of-two html panel size
	pw = math.CeilPower2(pw)
	ph = math.CeilPower2(ph)

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( panel:GetHTMLMaterial() )
	surface.DrawTexturedRect( x, y, w * pw, h * ph )

end

Base.Modules:RegisterModule( MODULE );