local cfg=wolven_arrest_system.bail
local ENT={
	base="base_entity",
	Type = "anim",
	PrintName = "bail unit",
	Category = "Revenants arrest system",
	Author = "revenant moon",
	Information = "a way to bail oneself out",
	Spawnable = true,
	ClassName="revenants_bail_unit",
}
function ENT:Initialize()
	if self:GetModel()=="models/error.mdl" then
		self:SetModel(cfg.model or "models/props_phx/rt_screen.mdl")
	end
	if SERVER then
		if not self:PhysicsInit(SOLID_VPHYSICS) then
			self:PhysicsInitBox(Vector(-50,-50,0),Vector(50,50,20))
		end
		local PhysOject=self:GetPhysicsObject()
		if PhysOject and PhysOject:IsValid() then
			PhysOject:EnableMotion(false)
		end
		self:SetUseType(SIMPLE_USE)
	end
	local m=self:GetModel()
	if m=="models/props_phx/rt_screen.mdl" or m=="models/props_phx/sp_screen.mdl" then
		self:SetSubMaterial(1,"tools/toolsblack")--basically remove the RT/screenspace material
	end
end
function ENT:Draw()
	self:DrawModel()
	if self.Drawtimer and self.Drawtimer>CurTime() then return end
	self.Drawtimer=CurTime()+5
end
function ENT:Use(activator,ply,useType,value)
	if ply.bail_amount then
		DarkRP.notify(ply,1,8,"must be really high latency, you somehow used this twice")
	elseif ply:isArrested() then
		local amount=math.Round(ply:getDarkRPVar("money")*ply.bail_cost_multiplier)
		net.Start("revenants_bail_unit")
		ply.bail_amount=amount
		net.WriteUInt(amount,32)
		net.Send(ply)
	else
		DarkRP.notify(ply,3,8,"if you are arrested, press E on this to bail yourself out of jail")
	end
end
if CLIENT then
	net.Receive("revenants_bail_unit",function(len,sender)
		local Panel,amount=vgui.Create( "DFrame" ),net.ReadUInt(32)
		Panel:ShowCloseButton(false)
		Panel:SetSize(400,100)
		Panel:SetTitle("pay "..DarkRP.formatMoney(amount).." for bail?")
		Panel:SetDraggable(false)
		Panel:MakePopup()
		Panel:Center()
		local yes=vgui.Create("DButton",Panel)
		yes:SetText("Yes")
		yes:SetPos(0,25)
		yes:SetSize(175,75)
		yes.DoClick=function()
			RunConsoleCommand("say","yes")
			Panel:Remove()
			net.Start("revenants_bail_unit")
			net.WriteUInt(amount,32)
			net.SendToServer()
		end
		local no=vgui.Create("DButton",Panel)
		no:SetText("no")
		no:SetPos(225,25)
		no:SetSize(175,75)
		no.DoClick=function()
			RunConsoleCommand("say","no")
			Panel:Remove()
			net.Start("revenants_bail_unit")
			net.WriteUInt(0,32)
			net.SendToServer()
		end
	end)
else
	util.AddNetworkString("revenants_bail_unit")
	net.Receive("revenants_bail_unit",function(len,ply)--got a reply from the player
		local amount=net.ReadUInt(32)
		if ply.bail_amount and amount and ply:canAfford(amount) and ply.bail_amount<=amount and ply:isArrested() then
			ply:addMoney(-amount)
			DarkRP.notify(ply,3,8,"you paid "..DarkRP.formatMoney(amount).." for bail")
			ply:unArrest(ply)
			ply:Spawn()
		elseif not ply.bail_amount and not amount then
			ply:Kick("kicked for attempting to exploit \"revenants_bail_unit\"")
		end
		ply.bail_amount=nil
	end)
end
scripted_ents.Register(ENT,ENT.ClassName)
hook.Add("playerArrested","bail_hooks",function(ply,time,cop)
	if ply:isArrested() then return end--re arrested
	timer.Simple(0,function()
		PrintMessage(HUD_PRINTCENTER,ply:Name().." has been arrested")
		umsg.Start("GotArrested",ply)
		umsg.Float(cfg.time)
		umsg.End()
	end)
	ply.bail_cost_multiplier=0.1--starts at 10%
	timer.Create(ply:SteamID64().."bail_timer",cfg.time*0.1,9,function()
		if ply and ply:IsValid() then
			ply.bail_cost_multiplier=math.Clamp(ply.bail_cost_multiplier-0.01,0,1)--decrease it by 0.1%
		end
	end)
end)
hook.Add("playerUnArrested","bail_hooks",function(ply,cop)
	if ply!=cop then
		ply:Spawn()
	end
end)
timer.Create("think_bail_hooks",0.1,0,function()
	local zones=SERVER and cfg.unarrest_zones[game.GetMap()]
	if not zones then timer.Remove("think_bail_hooks") return end
	for k,ply in ipairs(player.GetAll()) do
		if ply:isArrested() then
			for num,tbl in ipairs(zones) do
				if ply:GetPos():WithinAABox(tbl[1],tbl[2]) then
					ply:unArrest(ply)
					ply:wanted(ply,cfg.wanted_reason)
					for k,v in ipairs(player.GetAll()) do
						if ply==v then
							if cfg.escape_notify_self then
								DarkRP.notify(v,2,8,cfg.escape_notify_self or "you escaped jail, but the cops may be after you")
							end
						elseif cfg.escape_notify_other then
							DarkRP.notify(v,2,8,cfg.escape_notify_other:Replace("{{NAME}}",ply:Name()))
						end
					end
				end
			end
		end
	end
end)