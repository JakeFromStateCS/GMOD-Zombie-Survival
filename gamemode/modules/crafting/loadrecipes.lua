local MODULE = MODULE or {};

function MODULE:LoadRecipes()
	local folder = "blrp/gamemode/recipes/";
	for _,file in pairs( file.Find( folder .. "*.lua", "LUA" ) ) do
		if( SERVER ) then
			AddCSLuaFile( folder .. file );
			include( folder .. file );
		else
			include( folder .. file );
		end;
	end;
end;