if CLIENT then 
	wolven_arrest_system.booking_arrest_msg=function()
		LocalPlayer():PrintMessage(HUD_PRINTTALK,wolven_arrest_system.booking.target_notify)
	end
	net.Receive("wolven_arrest_system.console_log",function(len,ply)
		MsgC(unpack(net.ReadTable()))
	end)
	return
end
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
				n:Spawn()
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
	local reason=blacklist[ent:GetClass()]
	if reason then
		return false,type(reason)=="string" and reason
	end
end)
hook.Add("PlayerInitialSpawn","wolven_arrest_system_general_hooks",function(ply)
	timer.Simple(0,function()
		if ply and ply:IsValid() and wolven_arrest_system.LTAP[ply:SteamID()] then
			local time=GAMEMODE.Config and GAMEMODE.Config.jailtimer or 120
			ply:arrest(time,ply)
			hook.Run("playerArrested",ply,time,ply)
			wolven_arrest_system.LTAP[ply:SteamID()]=nil--now they have received their punishment, 
		end
	end)
end)
