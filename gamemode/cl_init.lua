include( "sh_init.lua" );

hook.Add( "ContextMenuCreated", "Base.ContextMenu", function( context )
	Base.ContextMenu = context;
end );

function GM:OnUndo( name, strCustomString )

	
    if ( !strCustomString ) then
        --self:AddNotify( "#Undone_"..name, NOTIFY_UNDO, 2 )
    else    
        --self:AddNotify( strCustomString, NOTIFY_UNDO, 2 )
    end
    
    // Find a better sound :X
    surface.PlaySound( "buttons/button15.wav" )
	
end;