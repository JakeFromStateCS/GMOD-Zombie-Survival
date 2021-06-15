local MODULE = {};
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Name = "Crafting";
MODULE.Stored = {};
MODULE.Config = {};

function MODULE:OnLoad()
	Base.Crafting = self;
end;

function MODULE:RegisterRecipe( RECIPE )
	if( RECIPE.Name ) then
		self.Stored[RECIPE.Name] = RECIPE;
	end;
end;

function MODULE:GetPlayerRecipes( client )
	local recipes = {};
	for name,_ in pairs( self.Stored ) do
		if( self:PlayerHasResources( client, name ) ) then
			table.insert( recipes, name );
		end;
	end;
	return recipes;
end;

function MODULE:PlayerHasResources( client, recipeName )
	local RECIPE = self.Stored[recipeName];
	if( RECIPE ) then
		if( RECIPE.Resources ) then
			for name,amount in pairs( Resources ) do
				local resource = Base.Resource:GetPlayerResource( client, name );
				if( resource < amount ) then
					return false;
				end;
			end;
		end;
	end;
	return true;
end;

function MODULE:PlayerCraftItem( client, recipeName )
	local RECIPE = self.Stored[recipeName];
	if( RECIPE ) then
		if( RECIPE.OnCraft ) then
			RECIPE:OnCraft( client );
		end;
	end;
end;

function MODULE.Nets:PlayerCraftItem( client )
	local recipeName = net.ReadString();
	self:PlayerCraftItem( client, recipeName );
end;



Base.Modules:RegisterModule( MODULE );

