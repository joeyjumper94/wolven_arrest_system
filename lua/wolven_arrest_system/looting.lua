local cfg=wolven_arrest_system.looting
local ENT={
	base="base_entity",
	Type = "anim",
	PrintName = "prison looting",
	Category = "Revenants arrest system",
	Author = "revenant moon",
	Information = "a possible method for someone to escape jail",
	Spawnable = true,
	ClassName="revenants_prison_looting",
}
local cooldowns={}
function ENT:Initialize()
	if SERVER then
		if self:GetModel()=="models/error.mdl" then
			self:SetModel(cfg.model or "models/props_wasteland/prison_toilet01.mdl")
		end
		if not self:PhysicsInit(SOLID_VPHYSICS) then
			self:PhysicsInitBox(Vector(-50,-50,0),Vector(50,50,20))
		end
		local PhysOject=self:GetPhysicsObject()
		if PhysOject and PhysOject:IsValid() then
			PhysOject:EnableMotion(false)
		end
		self:SetUseType(SIMPLE_USE)
	end
end
function ENT:Use(activator,ply,useType,value)
	local cooldown=self[ply:SteamID64()]
	if cooldown and cooldown>CurTime() then
		DarkRP.notify(ply,1,8,"you have already searched this\nPlease wait "..math.Round(cooldown-CurTime(),3).." seconds")
	elseif cfg.need_arrested and not ply:isArrested() then
		DarkRP.notify(ply,3,8,"if you are arrested, you can search this and possibly get something to escape with")
	else
		local i=math.random(1,#cfg.loot)
		local item=cfg.loot[i]
		print(i,item)
		if type(item)=="string" then
			if item!="" then
				local tbl=weapons.GetStored(item)
				DarkRP.notify(ply,0,8,"you found a "..(tbl and tbl.PrintName or item))
				ply:Give(item)
				ply:SelectWeapon(item)
			end
		elseif type(item)=="function" then
			item(ply,self)
		end
		self[ply:SteamID64()]=CurTime()+cfg.time
	end
end
scripted_ents.Register(ENT,ENT.ClassName)

for int,class in ipairs(cfg.loadout) do--add the items on their loadout to the whitelist so they can equip them
	cfg.whitelist[class]=true
end
for int,string in ipairs(cfg.loot) do--parse through the loot table
	if type(string)=="string" then--if the item is a string, add it to the whitelist
		cfg.whitelist[string]=true
	end
end
hook.Add("PlayerSpawn","looting_hooks",function(ply)
	for int,class in ipairs(cfg.loadout) do
		ply:Give(class)
	end
end)
hook.Add("PlayerCanPickupWeapon","looting_hooks",function(ply,weapon)
	if weapon and weapon:IsValid() and cfg.whitelist[weapon:GetClass()] and ply:isArrested() then
		return true
	end
end)
