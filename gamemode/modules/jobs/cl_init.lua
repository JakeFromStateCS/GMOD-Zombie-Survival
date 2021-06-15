local MODULE = {};
MODULE.Name = "Jobs";
MODULE.Hooks = {};
MODULE.Nets = {};
MODULE.Stored = {};
MODULE.Config = {};

function MODULE:LoadNotice( JOB )
	MsgC( Base.Config.ConsoleColor, "        (" );
	MsgC( Base.Config.NetColor, "job" );
	MsgC( Base.Config.ConsoleColor, ") " );
	MsgC( JOB.Color, JOB.Name .. "\n" );
end;

function MODULE:HookRegisterNotice( hookName )
	MsgC( Base.Config.ConsoleColor, "     - (" );
	MsgC( Base.Config.HookColor, "hook" );
	MsgC( Base.Config.ConsoleColor, ") " .. hookName .. "\n" );--.. " from" );
end;

function MODULE:NetRegisterNotice( realm, modName, netName )
	MsgC( Base.Config.ConsoleColor, "     - (" );
	MsgC( Base.Config.NetColor, "net" );
	MsgC( Base.Config.ConsoleColor, ") " .. netName .. "\n" );
end;

function MODULE:OnLoad()
	Base.Jobs = self;
	self:LoadJobs();
end;

function MODULE:LoadJobs()
	local folder = "blrp/gamemode/jobs/";
	for _,file in pairs( file.Find( folder .. "*.lua", "LUA" ) ) do
		if( SERVER ) then
			AddCSLuaFile( folder .. file );
			include( folder .. file );
		else
			include( folder .. file );
		end;
	end;
end;

function MODULE:RegisterJob( JOB )
	if( JOB.Name ) then
		self.Stored[JOB.Name] = JOB;
		self:LoadNotice( JOB );
	end;
end;

function MODULE:GetJobs()
	return self.Stored;
end;



function MODULE:GetJobsFromSkill( name )
	local jobs = {};
	for jobName,JOB in pairs( self.Stored ) do
		if( JOB.SkillReqs ) then
			if( JOB.SkillReqs[name] ) then
				table.insert( jobs, jobName );
			end;
		elseif( JOB.Default ) then
			table.insert( jobs, jobName );
		end;
	end;
	return jobs;
end;



function MODULE:HasJobRequirements( name )
	local JOB = self.Stored[name];
	if( JOB ) then
		if( JOB.SkillReqs ) then
			for skillName,req in pairs( JOB.SkillReqs ) do
				local skillLevel = LocalPlayer():GetSkill( skillName );
				if( skillLevel < req ) then
					return false;
				end;
			end;
			return true;
		end;
	end;
	return false;
end;



function MODULE.Hooks:CanTool( client, trace, tool )
	if( client.jobName == "Builder" ) then
		return true;
	end;
end;

function MODULE.Nets:SetJob()
	local client = net.ReadEntity();
	local jobName = net.ReadString();
	local JOB = self.Stored[jobName];
	if( JOB ) then
		client.jobName = jobName;
	end;
end;

Base.Modules:RegisterModule( MODULE );