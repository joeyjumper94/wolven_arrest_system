local disabled_til=0
hook.Add("PhysgunPickup","_rp_downtown_em_hs_lua",function(Ply,Ent)
	if disabled_til>CurTime() then return end
	if Ent and Ent:IsValid() and Ent:GetNWBool("wolven_arrest_system_replacement",false) then return false end
end)
hook.Add("CanDrive","_rp_downtown_em_hs_lua",function(Ply,Ent)
	if disabled_til>CurTime() then return end
	if Ent and Ent:IsValid() and Ent:GetNWBool("wolven_arrest_system_replacement",false) then return false end
end)
hook.Add("CanTool","_rp_downtown_em_hs_lua",function(Ply,trace,tool)
	if disabled_til>CurTime() then return end
	if !trace then return false end
	local Ent=trace.Entity
	if Ent and Ent:IsValid() and Ent:GetNWBool("wolven_arrest_system_replacement",false) then return false end
end)
hook.Add("CanProperty","_rp_downtown_em_hs_lua",function(Ply,property,Ent)
	if disabled_til>CurTime() then return end
	if Ent and Ent:IsValid() and Ent:GetNWBool("wolven_arrest_system_replacement",false) then return false end
end)
hook.Add("CanEditVariable","_rp_downtown_em_hs_lua",function(Ent,Ply)
	if disabled_til>CurTime() then return end
	if Ent and Ent:IsValid() and Ent:GetNWBool("wolven_arrest_system_replacement",false) then return false end
end)
hook.Add("OnPhysgunReload","_rp_downtown_em_hs_lua",function(Physgun,Ply)
	if disabled_til>CurTime() then return end
	if !(Ply and Ply:IsValid()) then return false end
	local trace=Ply:GetEyeTrace()
	if !trace then return false end
	local Ent=trace.Entity
	if Ent and Ent:IsValid() and Ent:GetNWBool("wolven_arrest_system_replacement",false) then return false end
end)
hook.Add("PlayerUse","_rp_downtown_em_hs_lua",function(Ply,Ent)
--		if Ent and Ent:IsValid() and Ent:GetNWBool("wolven_arrest_system_replacement",false) then return false end
end)
hook.Add("CanPlayerUnfreeze","_rp_downtown_em_hs_lua",function(Ply,Ent,PhysObj)
	if disabled_til>CurTime() then return end
	if Ent and Ent:IsValid() and Ent:GetNWBool("wolven_arrest_system_replacement",false) then return false end
end)

if CLIENT then 
	concommand.Add("wolven_arrest_system_disable_protection",function(ply,cmd,args)
		net.Start("wolven_arrest_system_disable_protection")
		net.SendToServer()
	end)
	net.Receive("wolven_arrest_system_disable_protection",function(len,ply)
		disabled_til=net.ReadFloat()
	end)
	wolven_arrest_system.booking_arrest_msg=function()
		LocalPlayer():PrintMessage(HUD_PRINTTALK,wolven_arrest_system.booking.target_notify)
	end
	net.Receive("wolven_arrest_system.console_log",function(len,ply)
		MsgC(unpack(net.ReadTable()))
	end)
	return
end
net.Receive("wolven_arrest_system_disable_protection",function(len,ply)
	if ply:IsSuperAdmin() or ply.IsListenServerHost and ply:IsListenServerHost() then
		disabled_til=CurTime()+10
		net.Start("wolven_arrest_system_disable_protection")
		net.WriteFloat(disabled_til)
		net.Broadcast()
	end
end)
util.AddNetworkString("wolven_arrest_system_disable_protection")
util.AddNetworkString("wolven_arrest_system.console_log")
wolven_arrest_system.console_log=function(log)
	local send={}
	for k,ply in ipairs(player.GetAll()) do
		if !game.IsDedicated() and ply:IsListenServerHost() then continue end--if the player is the server host, it will appear in their console when we print to the server console
		if ply:IsAdmin() or wolven_arrest_system.log_access and wolven_arrest_system.log_access[ply:GetUserGroup()] then
			table.insert(send,ply)
		end
	end
	if #send!=0 then-- if the list is empty, why bother writing a net message that will be sent to nobody?
		net.Start("wolven_arrest_system.console_log")
		net.WriteTable(log)
		net.Send(send)
	end
	MsgC(unpack(log))
end
local func=function()
	for k,v in ipairs(ents.GetAll())do
		local e=v:MapCreationID()!=-1 and wolven_arrest_system.ent_replacement[v:GetModel()]
		if e then
			local n=ents.Create(e)
			if n:IsValid()then
				n:SetPos(v:GetPos())
				n:SetModel(v:GetModel())
				n:SetAngles(v:GetAngles())
				n:SetParent(v:GetParent())
				n:Spawn()
				n:SetNWBool("wolven_arrest_system_replacement",true)
				v:Remove()
			end
		end
	end
end
hook.Add("PostCleanupMap","wolven_arrest_system_general_hooks",func)
hook.Add("InitPostEntity","wolven_arrest_system_general_hooks",func)
local blacklist={
	revenants_prison_looting="i don't think i want to put that in my pocket",
	revenants_booking_station="it's secured in place",
	revenants_bail_unit="it's bolted to the wall",
	spawned_money="money is supposed to go into your wallet"
}
hook.Add("canPocket","wolven_arrest_system_general_hooks",function(ply,ent)
	local reason=blacklist[ent:IsValid() and ent:GetClass()]
	if reason then
		return false,type(reason)=="string" and reason
	end
end)
hook.Add("PlayerInitialSpawn","wolven_arrest_system_general_hooks",function(ply)
	timer.Simple(0,function()
		if ply and ply:IsValid() and wolven_arrest_system.LTAP[ply:SteamID()] then
			local time=GAMEMODE.Config and GAMEMODE.Config.jailtimer or 120
			ply:arrest(time,ply)
			wolven_arrest_system.LTAP[ply:SteamID()]=nil--now they have received their punishment, 
		end
	end)
end)
