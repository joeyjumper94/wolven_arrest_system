local cfg=wolven_arrest_system.booking
local ENT={
	base="base_entity",
	Type = "anim",
	PrintName = "Booking statoion",
	Category = "Revenants arrest system",
	Author = "revenant moon",
	Information = "a station to arrest people",
	Spawnable = true,
	ClassName="revenants_booking_station",
}
function ENT:Initialize()
	if SERVER then
		if self:GetModel()=="models/error.mdl" then
			self:SetModel(cfg.model or "models/props_combine/combine_interface002.mdl")
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
	if self.Cooldown and self.Cooldown>CurTime() then return end
	if ply:isCP() then
		local supress_hint,count,target=false,0,ply:GetNWEntity("handcuff_drag")
		if target and target:IsValid() then
			supress_hint,jailed=self:Arrest(target,ply)
		end
		for k,target in ipairs(player.GetAll()) do
			if target:GetPos():DistToSqr(self:GetPos()) < cfg.distance*cfg.distance then
				local add,jailed=self:Arrest(target,ply)
				count=count+add
				supress_hint=supress_hint or jailed
			end
		end
		if not supress_hint then
			DarkRP.notify(ply,3,8,"There are no nearby handcuffed players.\nBring a handcuffed player here then press E on this to arrest them.")
		elseif count>0 and cfg.reward and cfg.reward>0 then
			ply:addMoney(cfg.reward*count)
			DarkRP.notify(ply,2,8,
				"You arrested "..count.." player"..(count!=1 and "s\n" or "\n")..
				"You've been paid "..DarkRP.formatMoney(cfg.reward*count)
			)
		end
	else
		DarkRP.notify(ply,3,8,"only cops can use the booking station")
	end
	self.Cooldown=CurTime()+cfg.time
end
function ENT:Arrest(target,ply)
	if target:isArrested() then
		target:arrest()
		hook.Run("playerArrested",target,time,ply)
		return 0,true
	end
	local weapon=target:GetActiveWeapon()
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed" then
		if not cfg.arrest_cp and target:isCP() then
			weapon:Remove()
			DarkRP.notify(ply,1,8,DarkRP.getPhrase("cant_arrest_other_cp"))
		elseif not cfg.arrest_chief and target:isChief() then
			weapon:Remove()
			DarkRP.notify(ply,1,8,"you can't arrest the "..team.GetName(target:Team()))
		elseif target:isMayor() then
			weapon:Remove()
			DarkRP.notify(ply,1,8,"you can't arrest the "..team.GetName(target:Team()))
		else
			local can,reason=hook.Run("canArrest",ply,target,true)
			if can==false then
				weapon:Remove()
				DarkRP.notify(ply,1,8,reason or "you cannot arrest this player")
			else
				local time=GAMEMODE.Config and GAMEMODE.Config.jailtimer or 120
				target:arrest(time,ply)
				if cfg.target_notify then
					DarkRP.notify(target,2,8,"check your console")
					target:SendLua("wolven_arrest_system.booking_arrest_msg()")
				end
				hook.Run("playerArrested",target,time,ply)
				local log=ply:Name().." ("..ply:SteamID()..") arrested "..target:Name()
				if DarkRP then
					DarkRP.log(log, Color(0, 255, 255))
				end
				ServerLog(log.."\n")
				return 1,true
			end
		end
	end
	return 0,false
end
scripted_ents.Register(ENT,ENT.ClassName)
hook.Add("canArrest","booking_hooks",function(cop,ply,by_unit)
	if ply:isArrested() then return end--already arrested, let them put them back in their cell
	if not cfg.booking_only or by_unit then
		return--allow arrest
	end
	return false,"you can only arrest by the booking unit"
end)
gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "handcuff_hooks", function( data )
	if SERVER and data.userid then
		local ply=Player(data.userid)
		if ply and ply:IsValid() and cfg.remember_arrested then
			if ply:isArrested() then
				wolven_arrest_system.LTAP[ply:SteamID()]=true
			end
		end
	end
end)
hook.Add("PlayerLoadout","booking_hooks",function(ply)
	if cfg.noabaton then
		timer.Simple(0,function()
			if ply:IsValid() and ply:HasWeapon("arrest_stick") then
				ply:StripWeapon("arrest_stick")
			end
		end)
	end
end)