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


Base.Modules:RegisterModule( MODULE );

