local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Stored = {};
MODULE.Name = "Death Notice";

function MODULE:OnLoad()
	Base.DeathNotice = self;
end;

if( SERVER ) then
	function MODULE:Add( ... )
		local clients = {};
		local args = { ... };
		if( type( args[1] ) == "Player" ) then
			clients = args[1];
			table.remove( args, 1 );
		elseif( type( args[1] ) == "table" ) then
			if( args[1].r == nil ) then
				for k,v in pairs( args[1] ) do
					if( type( v ) == "Player" ) then
						clients[#clients + 1] = v;
					end;
				end;

				table.remove( args, 1 );
			else
				clients = player.GetAll();
			end;
		elseif( type( args[1] ) == "Entity" ) then
			if( args[1]:IsValid() ) then
				local text = "";

				for k,v in pairs( args ) do
					if( type( v ) == "string" ) then
						text = text .. v;
					end;
				end;

				Msg( "(BLParkour) " .. text .. "\n" );

				return;
			end;
		else
			clients = player.GetAll();
		end;

		
		Base.Modules:NetMessage( clients, "AddDeathNotice", args );

	end;

	function MODULE:BroadcastNotification( client, text, color, time )

	end;
	
	function MODULE.Hooks:PlayerDeath( client, inflictor, killer )
		local text = "Worldspawn";
		if( killer:IsPlayer() ) then
			text = killer:Nick();
		end;
		Base.DeathNotice:Add( player.GetAll(), text .. " -> " .. client:Nick() );
	end;
else
	MODULE.Config = {
		offset = {
			x = ScrW() - 20,
			y = 190
		}
	};

	function MODULE:Add( text )
		local panel = vgui.Create( "flatUI_Notification" );
		panel:SetText( text );
		table.insert( self.Stored, panel );
		return self.Stored[#self.Stored];
	end;

	function MODULE.Nets:AddDeathNotice()
		--print( net.ReadData() );
		local args = net.ReadTable();
		--local col = net.ReadTable();
		--local time = net.ReadBit();
		local panel = self:Add( args[1] );
		if( args[2] ) then
			panel:SetThemeColor( args[2] );
		end;
		panel:MoveToBack();
	end;

	function MODULE.Hooks:Think()
		for index,panel in pairs( self.Stored ) do
			if( CurTime() > panel.RemoveTime ) then
				panel:Remove();
				table.remove( self.Stored, index );
			else
				local x, y = panel:GetPos();
				local w, h = panel:GetSize();
				if( h < 40 ) then
					h = 50;
				else
					h = h + 10;
				end;

				local yPos = self.Config.offset.y + h * index;

				panel:SetPos( self.Config.offset.x - panel:GetWide(), math.Approach( y, yPos, 6 ) );
			end;
		end;
	end;

end;

Base.Modules:RegisterModule( MODULE );