local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "HitMarkers";
MODULE.Stored = {};
MODULE.Config = {};
MODULE.Config.FadeTime = 5

function MODULE.Hooks:HUDPaint()
	for id,marker in pairs( self.Stored ) do
		local pos = marker.pos:ToScreen();
		local alpha = math.Round( ( 255 / self.Config.FadeTime ) * ( marker.fadeTime - CurTime() ) );
		local posX = math.sin( alpha / 10 ) * 25;
		local posY = 255 - alpha;
		if( alpha > 0 ) then
			local col = Color( 255, 255, 255, alpha );
			draw.SimpleTextOutlined( marker.amount, "flatUI TitleText large", pos.x + posX, pos.y - posY, col, 1, 1, 1, Color( 0, 0, 0, alpha ) );
		else
			self.Stored[id] = nil;
		end;
	end;
end;

function MODULE.Nets:HitMarker()
	local pos = net.ReadVector();
	local damage = net.ReadFloat();

	local marker = {
		pos = pos,
		amount = damage,
		fadeTime = CurTime() + self.Config.FadeTime
	};

	table.insert( self.Stored, marker );
end;

Base.Modules:RegisterModule( MODULE );