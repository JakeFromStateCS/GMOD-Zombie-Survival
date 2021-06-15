local MODULE = {};
MODULE.Name = "Flashlight";
MODULE.Hooks = MODULE.Hooks or {};
MODULE.Nets = MODULE.Nets or {};
MODULE.Config = {};
MODULE.Config.CanFlashlight = Base.Config.CanFlashlight;

function MODULE.Hooks:PlayerSwitchFlashlight( client, enabled )
	return self.Config.CanFlashlight;
end;

Base.Modules:RegisterModule( MODULE );