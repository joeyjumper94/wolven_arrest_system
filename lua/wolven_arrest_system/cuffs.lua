local cfg=wolven_arrest_system.cuffs
do
	local SWEP={
		ClassName="revenants_handcuffed",--Entity class name of the SWEP (file or folder name of your SWEP). This is set automatically
		Category="Revenants arrest system",--(Clientside) Category the SWEP is in--Default: "Other"
		Spawnable=true,--Whether this SWEP should be displayed in the Q menu--Default: false
		AdminOnly=false,--Whether or not only admins can spawn the SWEP from their Q menu--Default: false
		PrintName="Handcuffed",--Nice name of the SWEP--Default: "Scripted Weapon"
		Base="weapon_base",--The base weapon to derive from. This must be a Lua weapon--Default: "weapon_base"
		m_WeaponDeploySpeed=10,--Multiplier of deploy speed--Default: 1
		--Owner--The entity that owns/wields this SWEP, if any
		Author="Revenant Moon",--(Clientside) The author of the SWEP to be shown in weapon selection--Default: ""
		Contact="",--(Clientside) The contacts of the SWEP creator to be shown in weapon selection--Default: ""
		Purpose="stun players to help arresting or discipline",--(Clientside) The purpose of the SWEP creator to be shown in weapon selection--Default: ""
		Instructions="",--(Clientside) How to use your weapon, to be shown in weapon selection--Default: ""
		ViewModel="models/weapons/c_bugbait.mdl",--Path to the view model for your SWEP (what the wielder will see)--Default: "models/weapons/v_pistol.mdl"
		ViewModelFlip=false,--(Clientside) Should we flip the view model? This is needed for some CS:S view models--Default: false
		ViewModelFlip1=false,--(Clientside) Same as ViewModelFlip, but for the second viewmodel--Default: false
		ViewModelFlip2=false,--(Clientside) Same as ViewModelFlip, but for the third viewmodel--Default: false
		ViewModelFOV=90,--(Clientside) An angle of FOV used for the view model (Half-Life value is 90; Half-Life 2 is 54; Counter-Strike: Source is 74; Day of Defeat is 45)--Default: 62
		WorldModel="models/weapons/w_bugbait.mdl",--The world model for your SWEP (what you will see in other players hands)--Default: "models/weapons/w_357.mdl"
		AutoSwitchFrom=true,--(Serverside) Whether this weapon can be autoswitched away from when the player runs out of ammo in this weapon or picks up another weapon or ammo--Default: true
		AutoSwitchTo=true,--(Serverside) Whether this weapon can be autoswitched to when the player runs out of ammo in their current weapon or they pick this weapon up--Default: true
		Weight=5,--(Serverside) Decides whether we should switch from/to this--Default: 5
		BobScale=1,--(Clientside) The scale of the viewmodel bob (viewmodel movement from left to right when walking around)--Default: 1
		SwayScale=1,--(Clientside) The scale of the viewmodel sway (viewmodel position lerp when looking around).--Default: 1
		BounceWeaponIcon=true,--(Clientside) Should the weapon icon bounce in weapon selection?--Default: true
		DrawWeaponInfoBox=true,--(Clientside) Should draw the weapon selection info box, containing SWEP.Instructions, etc.--Default: true
		DrawAmmo=false,--(Clientside) Should we draw the default HL2 ammo counter?--Default: true
		DrawCrosshair=false,--(Clientside) Should we draw the default crosshair?--Default: true
		RenderGroup=RENDERGROUP_TRANSLUCENT,--(Clientside) The SWEP render group, see RENDERGROUP_ Enums--Default: RENDERGROUP_OPAQUE
		Slot=2,--Slot in the weapon selection menu, starts with 0--Default: 0
		SlotPos=10,--Position in the slot, should be in the range 0-128--Default: 10
		SpeechBubbleLid=surface and surface.GetTextureID and surface.GetTextureID( "gui/speech_lid" ),--(Clientside) Internal variable for drawing the info box in weapon selection--Default: surface.GetTextureID( "gui/speech_lid" )
		WepSelectIcon=surface and surface.GetTextureID and surface.GetTextureID( "weapons/swep" ),--(Clientside) Path to an texture. Override this in your SWEP to set the icon in the weapon selection. This must be the texture ID, see surface.GetTextureID--Default: surface.GetTextureID( "weapons/swep" )
		CSMuzzleFlashes=false,--(Clientside) Should we use Counter-Strike muzzle flashes upon firing? This is required for DoD:S or CS:S view models to fix their muzzle flashes.--Default: false
		CSMuzzleX=false,--(Clientside) Use the X shape muzzle flash instead of the default Counter-Strike muzzle flash. Requires CSMuzzleFlashes to be set to true--Default: false
		Primary={--Primary attack settings. The table contains these fields:--    
			Ammo="none",-- - Ammo type ("Pistol", "SMG1" etc)
			ClipSize=-1,-- - The maximum amount of bullets one clip can hold
			DefaultClip=-1,-- - Default ammo in the clip, making it higher than ClipSize will give player additional ammo on spawn
			Automatic=false,-- - If true makes the weapon shoot automatically as long as the player has primary attack button held down --
		},	
		Secondary={--Secondary attack settings, has same fields as Primary attack settings
			Ammo="none",-- - Ammo type ("Pistol", "SMG1" etc)
			ClipSize=-1,-- - The maximum amount of bullets one clip can hold
			DefaultClip=-1,-- - Default ammo in the clip, making it higher than ClipSize will give player additional ammo on spawn
			Automatic=false,-- - If true makes the weapon shoot automatically as long as the player has primary attack button held down --
		},
		UseHands=true,--(Clientside) Makes the player models hands bonemerged onto the view model
		--WARNING The gamemode and view models must support this feature for it to work!
		--You can find more information here: Using Viewmodel Hands--Default: false
		--Folder="????"--The folder from where the weapon was loaded. This should always be "weapons/weapon_myweapon", regardless whether your SWEP is stored as a file, or multiple files in a folder. It is set automatically on load
		AccurateCrosshair=false,--(Clientside) Makes the default SWEP crosshair be positioned in 3D space where your aim actually is (like on Jeep), instead of simply sitting in the middle of the screen at all times--Default: false
		DisableDuplicator=true,--Disable the ability for players to duplicate this SWEP--Default: false
		ScriptedEntityType="weapon",--(Clientside) Sets the spawnmenu content icon type for the entity, used by spawnmenu in the Sandbox-derived gamemodes. See spawnmenu.AddContentType for more information.--Default: "weapon"
		m_bPlayPickupSound=true,--If set to false, the weapon will not play the weapon pick up sound when picked up.--Default: true --
		OnRemove=function(self)
			if CLIENT and LocalPlayer()==self.Owner then
				RunConsoleCommand"lastinv"
			end
			timer.Remove(self:EntIndex().." removal timer")
		end,
		PrimaryAttack=function(self) end,
		SecondaryAttack=function(self) end,
		Reload=function(self) end,
		Initialize=function(self)
			self:SetColor(Color(0,0,0,0))
			self:SetMaterial("models/effects/vol_light001")
			self:SetHoldType("duel")
		end,
		DrawWorldModel=function()end,
		PreDrawViewModel=function(self,vm,weapon,ply)
			local hands=ply:GetHands()
			if hook.Run("PreDrawPlayerHands",hands,vm,ply,weapon) then
				return true
			end
			hands:DrawModel()
			hook.Run("PostDrawPlayerHands",hands,vm,ply,weapon)
			return true
		end,
		DrawHUD=function(self)
			local Owner=self.Owner
			local left=math.Round(Owner:GetNWFloat("handcuff_adrenaline",0)-CurTime(),2)
			if left>0 then
				cam.Start2D()
				draw.DrawText("Adrenaline left: "..left,"Trebuchet24",ScrW()*0.9,ScrH()*.7,Color(255,0,0),TEXT_ALIGN_CENTER)
				cam.End2D()
			end
		end,
	}
	weapons.Register(SWEP,SWEP.ClassName)
end
--[[
local meta=FindMetaTable("CUserCmd")
meta.AddKey=function(CUserCmd,KEY)
	CUserCmd:SetButtons(bit.bor(CUserCmd:GetButtons(),IN_WALK))
end--]]
hook.Add("canArrest","handcuff_hooks",function(cop,ply)
	if ply:isArrested() then return end--already arrested, let them put them back in their cell
	local weapon=ply:GetActiveWeapon()
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
		return--allow arrest
	end
	return false,"it's customary to put the cuffs on when arresting someone"
end)
hook.Add("canDropWeapon","handcuff_hooks",function(ply,weapon)
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
		return false--prevent dropping
	end
end)
hook.Add("canLockpick","handcuff_hooks",function(ply,ent,trace)
	local weapon=ent:IsValid() and ent:IsPlayer() and ent:GetActiveWeapon()
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
		return true
	end
end)
hook.Add("CanPlayerEnterVehicle","handcuff_hooks",function(ply,vehicle,role)
	local weapon=cfg.NoDrive and ply:GetActiveWeapon()
	if vehicle and weapon and vehicle:IsValid() and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed" and vehicle:GetClass()=="prop_vehicle_prisoner_pod" then
		return false--vehicle entry
	end
end)
hook.Add("CanPlayerSuicide","handcuff_hooks",function(ply)
	local weapon=ply:GetActiveWeapon()
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
		DarkRP.notify(ply,1,8,"you cannot suicide while cuffed")
		return false--prevent suicide
	end
end)
hook.Add("HUDPaint","handcuff_hooks",function()
	for k,ply in ipairs(player.GetAll()) do
		cam.Start3D()
		local target=cfg.draw_rope and ply:GetNWEntity("handcuff_drag_ply",NULL)
		if target and target:IsValid() then
			local tpos=(target:GetShootPos()*3+target:GetPos())*0.25
			local ppos=(ply:GetShootPos()*3+target:GetPos())*0.25
			render.SetMaterial(Material("cable/cable2"))
			render.DrawBeam(ppos,tpos,1,0,0,Color(255,255,255))
		end
		cam.End3D()
		if cfg.drawhud then
			if ply!=LocalPlayer() then
				local pos=(vector_up*40+ply:GetPos()):ToScreen()
				if LocalPlayer():GetPos():DistToSqr(ply:GetPos())<250000 then
					local weapon=ply:GetActiveWeapon()
					if weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed" then
						local trace=util.TraceLine{
							start=LocalPlayer():GetShootPos(),
							endpos=ply:GetShootPos(),
							filter={
								ply,
								LocalPlayer(),
							},
						}
						if !trace.Hit then
							draw.DrawText("HANDCUFFED","Trebuchet24",pos.x,pos.y,Color(255,0,0),TEXT_ALIGN_CENTER)
						end
					end
				end
			end
		end
	end
end)
local ULX_FUNC=function()
	if ulx and ULib then
		local CATEGORY_NAME="Revenant's extensions"
		function ulx.uncuff(admin,targets)
			local affected={}
			for k,target in ipairs(targets) do
				local weapon=target:GetActiveWeapon()
				if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed" then
					weapon:Remove()
					table.insert(affected,target)
				end
			end
			if #affected!=0 then
				ulx.fancyLogAdmin(admin,"#A forcibly uncuffed #T",affected)
			else
				ULib.tsayError(admin,"nobody on the server that you targeted with the command had cuffs on",true)
			end
		end
		local uncuff = ulx.command( CATEGORY_NAME, "ulx uncuff", ulx.uncuff, "!uncuff", false, false, true )
		uncuff:addParam{type=ULib.cmds.PlayersArg}
		uncuff:defaultAccess( ULib.ACCESS_ADMIN)
		uncuff:help( "command to uncuff players" )
	end
end
hook.Add("Initialize","handcuff_hooks",ULX_FUNC)
if GAMEMODE and GAMEMODE.Config or player.GetAll()[1] then ULX_FUNC() end
hook.Add("onLockpickCompleted","handcuff_hooks",function(Owner,success,target)
	local weapon=SERVER and success and target:IsValid() and target:IsPlayer() and target:GetActiveWeapon()
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
		local r,g,b=Color(255,0,0),Color(0,255,0),Color(0,255,255)
		wolven_arrest_system.console_log({r,Owner:Name(),b," (",r,Owner:SteamID(),b,") <",r,team.GetName(Owner:Team()),b,"> {",r,Owner:getDarkRPVar("job"),b,"} uncuffed ",g,target:Name(),b," <",g,team.GetName(target:Team()),b,"> {",g,target:getDarkRPVar("job"),b,"} with a lockpick","\n"})
		local log=Owner:Name().." ("..Owner:SteamID()..") <"..team.GetName(Owner:Team()).."> {"..Owner:getDarkRPVar("job").."} uncuffed "..target:Name().." <"..team.GetName(target:Team()).."> {"..target:getDarkRPVar("job").."} with a lockpick"
		if DarkRP then
			--DarkRP.log(log, Color(0, 255, 255))
		end
		ServerLog(log.."\n")
		weapon:Remove()
	end
end)
hook.Add("OnPlayerHitGround","handcuff_hooks",function(ply,inWater,onFloater,speed)
	if ply:GetNWEntity("handcuff_drag_ply",NULL):IsValid() then
		return true
	end
end)
local keys=cfg.keys
local valid={}
for int,tbl in ipairs(keys) do
	valid[tbl.k]=true
end
hook.Add("PlayerButtonDown","handcuff_hooks",function(target,button)
	local ply=SERVER and target:GetNWEntity("handcuff_drag_ply",NULL)
	if ply and ply:IsValid() then
		if button==target.handcuff_button then
			target.handcuff_progress=(target.handcuff_progress or 0)+1
			if target.handcuff_progress>=cfg.handcuff_progress then
				ply:SetNWEntity("handcuff_drag",NULL)
				target:SetNWEntity("handcuff_drag_ply",NULL)
				target.handcuff_button=nil
				target.handcuff_progress=nil
				if cfg.adrenaline_max then
					local adrenaline=math.Rand(cfg.adrenaline_min,cfg.adrenaline_max)
					target:SetNWFloat("handcuff_adrenaline",CurTime()+adrenaline)
					target:PrintMessage(HUD_PRINTCENTER,"you broke away\nAdrenaline Rush!!\n"..math.Round(adrenaline,3).." seconds worth of adrenaline")
				else
					target:PrintMessage(HUD_PRINTCENTER,"you broke away")
				end
			end
		elseif valid[button] then
			target.handcuff_progress=math.Clamp((target.handcuff_progress or 0)-1,0,cfg.handcuff_progress)
		else
			target.handcuff_progress=target.handcuff_progress or 0
		end
		local tbl=keys[math.random(1,#keys)]
		if target.handcuff_progress then
			target:PrintMessage(HUD_PRINTCENTER,"Escape progress: "..target.handcuff_progress.." / "..cfg.handcuff_progress.."\n"..tbl.t)
		end
		target.handcuff_button=tbl.k
	end
end)
hook.Add("playerCanChangeTeam","handcuff_hooks",function(ply,team,force)
	if force==true then return end
	local weapon=ply:GetActiveWeapon()
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
		return false,"get someone to break you out of these cuffs first"--job change and tell why
	end
end)
hook.Add("PlayerCanPickupWeapon","handcuff_hooks",function(ply,weapon)
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed" and ply:isArrested() then
		return true
	end
end)
hook.Add("PlayerDeath","handcuff_hooks",function(ply,weapon,killer)
	local target=ply:GetNWEntity("handcuff_drag",NULL)
	if target:IsValid() then
		target:SetNWEntity("handcuff_drag_ply",NULL)
		ply:SetNWEntity("handcuff_drag",NULL)
	end
end)
gameevent.Listen( "player_disconnect" )
hook.Add("player_disconnect","handcuff_hooks",function(data)
	if SERVER and data.userid then
	local ply=Player(data.userid)
		if ply and ply:IsValid() and cfg.remember_arrested then
			local weapon=ply:GetActiveWeapon()
			if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed" then
				wolven_arrest_system.LTAP[ply:SteamID()]=true
			end
		end
	end
end)
hook.Add("PlayerGiveSWEP","handcuff_hooks",function(ply,class,SWEP)
	if class=="revenants_handcuffed" then
--		return true
	end
end)
hook.Add("PlayerSpawnObject","handcuff_hooks",function(ply)
	local weapon=ply:GetActiveWeapon()
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
		return false--prevent spawning stuff
	end
end)
hook.Add("PlayerSwitchWeapon","handcuff_hooks",function(ply,old,new)
	local weapon=ply:GetActiveWeapon()
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
		return true--prevent switching
	end
end)
hook.Add("PlayerTick","handcuff_hooks",function(ply,mv)
	if !cfg.allow_drag then return end
	local target=ply:GetNWEntity("handcuff_drag")
	if target:IsValid() then--are they being dragged
		local weapon=target:GetActiveWeapon()
		if weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed" then
			ppos=ply:GetShootPos()
			tpos=target:GetPos()
			if tpos:DistToSqr(ppos)>cfg.slack*cfg.slack then
				target:SetVelocity((ppos-tpos)*cfg.target_force_multiplier-target:GetVelocity()*0)
				ply:SetVelocity((tpos-ppos)*cfg.dragger_force_multiplier)
			end
			if ply.handcuff_drag_cleanup and ply.handcuff_drag_cleanup>CurTime() then return end
			ply.handcuff_drag_cleanup=CurTime()+1
			if target:GetNWEntity("handcuff_drag_ply")!=ply then
				ply:SetNWEntity("handcuff_drag",NULL)
			end
		else
			target:SetNWEntity("handcuff_drag_ply",NULL)
			ply:SetNWEntity("handcuff_drag",NULL)
		end
	end
end)
local doors={
	prop_door_rotating=true,
	func_door_rotating=true,
	func_door=true,
	func_button=true,
	func_rot_button=true,
}
hook.Add("PlayerUse","handcuff_hooks",function(ply,target)
	if !cfg.allow_drag then return end
	if ply.handcuff_drag_use and ply.handcuff_drag_use>CurTime() then return end
	if doors[target:GetClass()] then return end
	local weapon=target.GetActiveWeapon and target:GetActiveWeapon()
	
	if ply:GetNWEntity("handcuff_drag",NULL):IsValid() then
		local old_target=ply:GetNWEntity("handcuff_drag",NULL)
		if old_target:IsValid() then
			old_target:SetNWEntity("handcuff_drag_ply",NULL)
		end
		ply:SetNWEntity("handcuff_drag",NULL)
		ply.handcuff_drag_use=CurTime()+5
	elseif weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed" then
		local original=target:GetNWEntity("handcuff_drag_ply",NULL)
		if original:IsValid() then
			--being dragged by someone else
		else
			ply:SetNWEntity("handcuff_drag",target)
			target:SetNWEntity("handcuff_drag_ply",ply)
		end
		ply.handcuff_drag_use=CurTime()+5
	end
end)
local togive={}
hook.Add("PlayerLoadout","handcuff_hooks",function(ply)
	local TEAM=ply:Team()
	if togive[TEAM]==nil and cfg.autogive then
		togive[TEAM]=table.HasValue(ply:getJobTable().weapons,"arrest_stick")
	end
	if togive[TEAM] and cfg.autogive then
		ply:Give("revenants_handcuffs_and_keys")
	end
end)
hook.Add("StartCommand","handcuff_hooks",function(ply,CUserCmd)
	local weapon=ply:GetMoveType()!=MOVETYPE_NOCLIP and ply:GetActiveWeapon()
	if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed" and ply:GetNWFloat("handcuff_adrenaline",0)<CurTime() then
		--print(CUserCmd:GetButtons())
		if cfg.no_run then
			CUserCmd:RemoveKey(IN_SPEED)--make their client and the server think they are not holding their run key
		end
		if cfg.no_run or cfg.force_walk then
			CUserCmd:SetButtons(bit.bor(CUserCmd:GetButtons(),IN_WALK))--make their client and the server think they are holding their walk key
		end
		if cfg.drag_no_move and ply:GetNWEntity("handcuff_drag_ply",NULL):IsValid() then
			CUserCmd:ClearMovement()--remove all move keys
		end
		CUserCmd:RemoveKey(IN_JUMP)--no jumping while cuffed
		--print(CUserCmd:GetButtons())
	end
end)
hook.Add("WeaponEquip","handcuff_hooks",function(weapon,ply)
	if weapon and ply and weapon:IsValid() and ply:IsValid() and weapon:GetClass()=="revenants_handcuffed" then
		if ply:InVehicle() then ply:ExitVehicle() end--if in a vehicle exit so the stuff below works
		timer.Simple(0,function()
			if weapon and ply and weapon:IsValid() and ply:IsValid() and weapon:GetClass()=="revenants_handcuffed" then
				ply:SelectWeapon("revenants_handcuffed")
				if ply:isArrested() then
					timer.Create(weapon:EntIndex().." removal timer",30,1,function()
						if weapon and weapon:IsValid() then
							weapon:Remove()
						end
					end)
				elseif cfg.cuff_timer then
					timer.Create(weapon:EntIndex().." removal timer",cfg.cuff_timer,1,function()
						if weapon and weapon:IsValid() then
							weapon:Remove()
						end
					end)
				end
			end
		end)
	end
end)
do
	local SWEP={
		ClassName="revenants_handcuffs_and_keys",--Entity class name of the SWEP (file or folder name of your SWEP). This is set automatically
		Category="Revenants arrest system",--(Clientside) Category the SWEP is in--Default: "Other"
		Spawnable=true,--Whether this SWEP should be displayed in the Q menu--Default: false
		AdminOnly=true,--Whether or not only admins can spawn the SWEP from their Q menu--Default: false
		PrintName="Handcuffs and Keys",--Nice name of the SWEP--Default: "Scripted Weapon"
		Base="weapon_base",--The base weapon to derive from. This must be a Lua weapon--Default: "weapon_base"
		m_WeaponDeploySpeed=1,--Multiplier of deploy speed--Default: 1
		--Owner--The entity that owns/wields this SWEP, if any
		Author="Revenant Moon",--(Clientside) The author of the SWEP to be shown in weapon selection--Default: ""
		Contact="",--(Clientside) The contacts of the SWEP creator to be shown in weapon selection--Default: ""
		Purpose="police issue handcuffs used for arresting",--(Clientside) The purpose of the SWEP creator to be shown in weapon selection--Default: ""
		Instructions="right click to cuff\nleft click to uncuff",--(Clientside) How to use your weapon, to be shown in weapon selection--Default: ""
		ViewModel="models/weapons/c_pistol.mdl",--Path to the view model for your SWEP (what the wielder will see)--Default: "models/weapons/v_pistol.mdl"
		ViewModelFlip=false,--(Clientside) Should we flip the view model? This is needed for some CS:S view models--Default: false
		ViewModelFlip1=false,--(Clientside) Same as ViewModelFlip, but for the second viewmodel--Default: false
		ViewModelFlip2=false,--(Clientside) Same as ViewModelFlip, but for the third viewmodel--Default: false
		ViewModelFOV=90,--(Clientside) An angle of FOV used for the view model (Half-Life value is 90; Half-Life 2 is 54; Counter-Strike: Source is 74; Day of Defeat is 45)--Default: 62
		WorldModel="models/weapons/w_bugbait.mdl",--The world model for your SWEP (what you will see in other players hands)--Default: "models/weapons/w_357.mdl"
		AutoSwitchFrom=true,--(Serverside) Whether this weapon can be autoswitched away from when the player runs out of ammo in this weapon or picks up another weapon or ammo--Default: true
		AutoSwitchTo=true,--(Serverside) Whether this weapon can be autoswitched to when the player runs out of ammo in their current weapon or they pick this weapon up--Default: true
		Weight=5,--(Serverside) Decides whether we should switch from/to this--Default: 5
		BobScale=1,--(Clientside) The scale of the viewmodel bob (viewmodel movement from left to right when walking around)--Default: 1
		SwayScale=1,--(Clientside) The scale of the viewmodel sway (viewmodel position lerp when looking around).--Default: 1
		BounceWeaponIcon=true,--(Clientside) Should the weapon icon bounce in weapon selection?--Default: true
		DrawWeaponInfoBox=true,--(Clientside) Should draw the weapon selection info box, containing SWEP.Instructions, etc.--Default: true
		DrawAmmo=false,--(Clientside) Should we draw the default HL2 ammo counter?--Default: true
		DrawCrosshair=false,--(Clientside) Should we draw the default crosshair?--Default: true
		RenderGroup=RENDERGROUP_OPAQUE,--(Clientside) The SWEP render group, see RENDERGROUP_ Enums--Default: RENDERGROUP_OPAQUE
		Slot=2,--Slot in the weapon selection menu, starts with 0--Default: 0
		SlotPos=10,--Position in the slot, should be in the range 0-128--Default: 10
		SpeechBubbleLid=surface and surface.GetTextureID and surface.GetTextureID( "gui/speech_lid" ),--(Clientside) Internal variable for drawing the info box in weapon selection--Default: surface.GetTextureID( "gui/speech_lid" )
		WepSelectIcon=surface and surface.GetTextureID and surface.GetTextureID( "weapons/swep" ),--(Clientside) Path to an texture. Override this in your SWEP to set the icon in the weapon selection. This must be the texture ID, see surface.GetTextureID--Default: surface.GetTextureID( "weapons/swep" )
		CSMuzzleFlashes=false,--(Clientside) Should we use Counter-Strike muzzle flashes upon firing? This is required for DoD:S or CS:S view models to fix their muzzle flashes.--Default: false
		CSMuzzleX=false,--(Clientside) Use the X shape muzzle flash instead of the default Counter-Strike muzzle flash. Requires CSMuzzleFlashes to be set to true--Default: false
		Primary={--Primary attack settings. The table contains these fields:--    
			Ammo="none",-- - Ammo type ("Pistol", "SMG1" etc)
			ClipSize=-1,-- - The maximum amount of bullets one clip can hold
			DefaultClip=-1,-- - Default ammo in the clip, making it higher than ClipSize will give player additional ammo on spawn
			Automatic=true,-- - If true makes the weapon shoot automatically as long as the player has primary attack button held down --
		},	
		Secondary={--Secondary attack settings, has same fields as Primary attack settings
			Ammo="none",-- - Ammo type ("Pistol", "SMG1" etc)
			ClipSize=-1,-- - The maximum amount of bullets one clip can hold
			DefaultClip=-1,-- - Default ammo in the clip, making it higher than ClipSize will give player additional ammo on spawn
			Automatic=false,-- - If true makes the weapon shoot automatically as long as the player has secondary attack button held down --
		},
		UseHands=true,--(Clientside) Makes the player models hands bonemerged onto the view model
		--WARNING The gamemode and view models must support this feature for it to work!
		--You can find more information here: Using Viewmodel Hands--Default: false
		--Folder="????"--The folder from where the weapon was loaded. This should always be "weapons/weapon_myweapon", regardless whether your SWEP is stored as a file, or multiple files in a folder. It is set automatically on load
		AccurateCrosshair=false,--(Clientside) Makes the default SWEP crosshair be positioned in 3D space where your aim actually is (like on Jeep), instead of simply sitting in the middle of the screen at all times--Default: false
		DisableDuplicator=true,--Disable the ability for players to duplicate this SWEP--Default: false
		ScriptedEntityType="weapon",--(Clientside) Sets the spawnmenu content icon type for the entity, used by spawnmenu in the Sandbox-derived gamemodes. See spawnmenu.AddContentType for more information.--Default: "weapon"
		m_bPlayPickupSound=true,--If set to false, the weapon will not play the weapon pick up sound when picked up.--Default: true --
		PrimaryAttack=function(self)
			if self.Cuffing then return end-- in the process of cuffing already
			local Owner=self.Owner
			local trace=Owner and Owner:IsValid() and Owner:GetEyeTrace()
			local target=trace and trace.Entity
			if hook.Run("CanCuff",Owner,trace,target,self)==false then return end
			if target and target:IsValid() and target:IsPlayer() and target:GetPos():DistToSqr(Owner:GetPos())<=cfg.distance*cfg.distance then
				self.Cuffing={
					time=CurTime()+cfg.time,
					Entity=target,
				}
				self.NextSound=CurTime()+cfg.time*0.1
			end
		end,
		SecondaryAttack=function(self)
			if CLIENT then return end
			local Owner=self.Owner
			local trace=Owner and Owner:IsValid() and Owner:GetEyeTrace()
			local target=trace and trace.Entity
			if target and target:IsValid() and target:IsPlayer() and target:GetPos():DistToSqr(Owner:GetPos())<=cfg.distance*cfg.distance then
				local weapon=target:GetActiveWeapon()
				if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
					local r,g,b=Color(255,0,0),Color(0,255,0),Color(0,255,255)
					wolven_arrest_system.console_log({r,Owner:Name(),b," (",r,Owner:SteamID(),b,") <",r,team.GetName(Owner:Team()),b,"> {",r,Owner:getDarkRPVar("job"),b,"} uncuffed ",g,target:Name(),b," <",g,team.GetName(target:Team()),b,"> {",g,target:getDarkRPVar("job"),b,"} with a ",g,self.PrintName,"\n"})
					local log=Owner:Name().." ("..Owner:SteamID()..") <"..team.GetName(Owner:Team()).."> {"..Owner:getDarkRPVar("job").."} uncuffed "..target:Name().." <"..team.GetName(target:Team()).."> {"..target:getDarkRPVar("job").."} with a "..self.PrintName
					if DarkRP then
						--DarkRP.log(log, Color(0, 255, 255))
					end
					ServerLog(log.."\n")
					weapon:Remove()
				end
			end
		end,
		Think=function(self)
			if self.Cuffing and self.Cuffing.Entity:IsValid() then
				local Owner=self.Owner
				local trace=Owner and Owner:IsValid() and Owner:GetEyeTrace()
				local target=trace and trace.Entity
				if target and target:IsValid() and target:IsPlayer() and target:GetPos():DistToSqr(Owner:GetPos())<=cfg.distance*cfg.distance then
					if self.Cuffing.time<=CurTime() then
						if SERVER then
							if cfg.finished_message then
								DarkRP.notify(Owner,2,8,cfg.finished_message)
							end
							local r,g,b=Color(255,0,0),Color(0,255,0),Color(0,255,255)
							wolven_arrest_system.console_log({r,Owner:Name(),b," (",r,Owner:SteamID(),b,") <",r,team.GetName(Owner:Team()),b,"> {",r,Owner:getDarkRPVar("job"),b,"} handcuffed ",g,target:Name(),b," <",g,team.GetName(target:Team()),b,"> {",g,target:getDarkRPVar("job"),b,"} with a ",g,self.PrintName,"\n"})
							local log=Owner:Name().." ("..Owner:SteamID()..") <"..team.GetName(Owner:Team()).."> {"..Owner:getDarkRPVar("job").."} handcuffed "..target:Name().." <"..team.GetName(target:Team()).."> {"..target:getDarkRPVar("job").."} with a "..self.PrintName
							if DarkRP then
								--DarkRP.log(log, Color(0, 255, 255))
							end
							ServerLog(log.."\n")
							self.Cuffing.Entity:Give("revenants_handcuffed")
						end
						self.Cuffing=nil
					end
					if self.NextSound and self.NextSound>=CurTime() then return end
					self.NextSound=CurTime()+cfg.time*0.8
					local snd={1,3,4}
					self:EmitSound("weapons/357/357_reload"..snd[math.random(1,#snd)]..".wav",50,100)
				else
					self.Cuffing=nil
				end
			elseif self.Cuffing then
				self.Cuffing=nil
			end
		end,
		DrawWorldModel=function(self)
			--self:DrawModel()
		end,
		PreDrawViewModel=function(self,vm,weapon,ply)
			local hands=ply:GetHands()
			if hook.Run("PreDrawPlayerHands",hands,vm,ply,weapon) then
				return true
			end
			hands:DrawModel()
			hook.Run("PostDrawPlayerHands",hands,vm,ply,weapon)
			return true
		end,
	}
	weapons.Register(SWEP,SWEP.ClassName)
end
do
	local SWEP={
		ClassName="revenants_keys_only",--Entity class name of the SWEP (file or folder name of your SWEP). This is set automatically
		Category="Revenants arrest system",--(Clientside) Category the SWEP is in--Default: "Other"
		Spawnable=true,--Whether this SWEP should be displayed in the Q menu--Default: false
		AdminOnly=true,--Whether or not only admins can spawn the SWEP from their Q menu--Default: false
		PrintName="Handcuff keys",--Nice name of the SWEP--Default: "Scripted Weapon"
		Base="weapon_base",--The base weapon to derive from. This must be a Lua weapon--Default: "weapon_base"
		m_WeaponDeploySpeed=1,--Multiplier of deploy speed--Default: 1
		--Owner--The entity that owns/wields this SWEP, if any
		Author="Revenant Moon",--(Clientside) The author of the SWEP to be shown in weapon selection--Default: ""
		Contact="",--(Clientside) The contacts of the SWEP creator to be shown in weapon selection--Default: ""
		Purpose="police issue handcuffs used for arresting",--(Clientside) The purpose of the SWEP creator to be shown in weapon selection--Default: ""
		Instructions="right click to cuff\nleft click to uncuff",--(Clientside) How to use your weapon, to be shown in weapon selection--Default: ""
		ViewModel="models/weapons/c_bugbait.mdl",--Path to the view model for your SWEP (what the wielder will see)--Default: "models/weapons/v_pistol.mdl"
		ViewModelFlip=false,--(Clientside) Should we flip the view model? This is needed for some CS:S view models--Default: false
		ViewModelFlip1=false,--(Clientside) Same as ViewModelFlip, but for the second viewmodel--Default: false
		ViewModelFlip2=false,--(Clientside) Same as ViewModelFlip, but for the third viewmodel--Default: false
		ViewModelFOV=90,--(Clientside) An angle of FOV used for the view model (Half-Life value is 90; Half-Life 2 is 54; Counter-Strike: Source is 74; Day of Defeat is 45)--Default: 62
		WorldModel="models/weapons/W_bugbait.mdl",--The world model for your SWEP (what you will see in other players hands)--Default: "models/weapons/w_357.mdl"
		AutoSwitchFrom=true,--(Serverside) Whether this weapon can be autoswitched away from when the player runs out of ammo in this weapon or picks up another weapon or ammo--Default: true
		AutoSwitchTo=true,--(Serverside) Whether this weapon can be autoswitched to when the player runs out of ammo in their current weapon or they pick this weapon up--Default: true
		Weight=5,--(Serverside) Decides whether we should switch from/to this--Default: 5
		BobScale=1,--(Clientside) The scale of the viewmodel bob (viewmodel movement from left to right when walking around)--Default: 1
		SwayScale=1,--(Clientside) The scale of the viewmodel sway (viewmodel position lerp when looking around).--Default: 1
		BounceWeaponIcon=true,--(Clientside) Should the weapon icon bounce in weapon selection?--Default: true
		DrawWeaponInfoBox=true,--(Clientside) Should draw the weapon selection info box, containing SWEP.Instructions, etc.--Default: true
		DrawAmmo=false,--(Clientside) Should we draw the default HL2 ammo counter?--Default: true
		DrawCrosshair=false,--(Clientside) Should we draw the default crosshair?--Default: true
		RenderGroup=RENDERGROUP_OPAQUE,--(Clientside) The SWEP render group, see RENDERGROUP_ Enums--Default: RENDERGROUP_OPAQUE
		Slot=2,--Slot in the weapon selection menu, starts with 0--Default: 0
		SlotPos=10,--Position in the slot, should be in the range 0-128--Default: 10
		SpeechBubbleLid=surface and surface.GetTextureID and surface.GetTextureID( "gui/speech_lid" ),--(Clientside) Internal variable for drawing the info box in weapon selection--Default: surface.GetTextureID( "gui/speech_lid" )
		WepSelectIcon=surface and surface.GetTextureID and surface.GetTextureID( "weapons/swep" ),--(Clientside) Path to an texture. Override this in your SWEP to set the icon in the weapon selection. This must be the texture ID, see surface.GetTextureID--Default: surface.GetTextureID( "weapons/swep" )
		CSMuzzleFlashes=false,--(Clientside) Should we use Counter-Strike muzzle flashes upon firing? This is required for DoD:S or CS:S view models to fix their muzzle flashes.--Default: false
		CSMuzzleX=false,--(Clientside) Use the X shape muzzle flash instead of the default Counter-Strike muzzle flash. Requires CSMuzzleFlashes to be set to true--Default: false
		Primary={--Primary attack settings. The table contains these fields:--    
			Ammo="none",-- - Ammo type ("Pistol", "SMG1" etc)
			ClipSize=-1,-- - The maximum amount of bullets one clip can hold
			DefaultClip=-1,-- - Default ammo in the clip, making it higher than ClipSize will give player additional ammo on spawn
			Automatic=false,-- - If true makes the weapon shoot automatically as long as the player has primary attack button held down --
		},	
		Secondary={--Secondary attack settings, has same fields as Primary attack settings
			Ammo="none",-- - Ammo type ("Pistol", "SMG1" etc)
			ClipSize=-1,-- - The maximum amount of bullets one clip can hold
			DefaultClip=-1,-- - Default ammo in the clip, making it higher than ClipSize will give player additional ammo on spawn
			Automatic=false,-- - If true makes the weapon shoot automatically as long as the player has primary attack button held down --
		},
		UseHands=true,--(Clientside) Makes the player models hands bonemerged onto the view model
		--WARNING The gamemode and view models must support this feature for it to work!
		--You can find more information here: Using Viewmodel Hands--Default: false
		--Folder="????"--The folder from where the weapon was loaded. This should always be "weapons/weapon_myweapon", regardless whether your SWEP is stored as a file, or multiple files in a folder. It is set automatically on load
		AccurateCrosshair=false,--(Clientside) Makes the default SWEP crosshair be positioned in 3D space where your aim actually is (like on Jeep), instead of simply sitting in the middle of the screen at all times--Default: false
		DisableDuplicator=true,--Disable the ability for players to duplicate this SWEP--Default: false
		ScriptedEntityType="weapon",--(Clientside) Sets the spawnmenu content icon type for the entity, used by spawnmenu in the Sandbox-derived gamemodes. See spawnmenu.AddContentType for more information.--Default: "weapon"
		m_bPlayPickupSound=true,--If set to false, the weapon will not play the weapon pick up sound when picked up.--Default: true --
		PrimaryAttack=function(self)
			if CLIENT then return end
			local Owner=self.Owner
			local trace=Owner and Owner:IsValid() and Owner:GetEyeTrace()
			local target=trace and trace.Entity
			if target and target:IsValid() and target:IsPlayer() and target:GetPos():DistToSqr(Owner:GetPos())<=cfg.distance*cfg.distance then
				local weapon=target:GetActiveWeapon()
				if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
					local r,g,b=Color(255,0,0),Color(0,255,0),Color(0,255,255)
--					wolven_arrest_system.console_log({r,Owner:Name(),b," (",r,Owner:SteamID(),b,") <",r,team.GetName(Owner:Team()),b,"> {",r,Owner:getDarkRPVar("job"),b,"} uncuffed ",g,target:Name(),b," <",g,team.GetName(target:Team()),b,"> {",g,target:getDarkRPVar("job"),b,"} with a ",g,self.PrintName,"\n"})
					local log=Owner:Name().." ("..Owner:SteamID()..") <"..team.GetName(Owner:Team()).."> {"..Owner:getDarkRPVar("job").."} uncuffed "..target:Name().." <"..team.GetName(target:Team()).."> {"..target:getDarkRPVar("job").."} with a "..self.PrintName
					if DarkRP then
						--DarkRP.log(log, Color(0, 255, 255))
					end
					ServerLog(log.."\n")
					weapon:Remove()
				end
			end
		end,
		SecondaryAttack=function(self)
			if CLIENT then return end
			local Owner=self.Owner
			local trace=Owner and Owner:IsValid() and Owner:GetEyeTrace()
			local target=trace and trace.Entity
			if target and target:IsValid() and target:IsPlayer() and target:GetPos():DistToSqr(Owner:GetPos())<=cfg.distance*cfg.distance then
				local weapon=target:GetActiveWeapon()
				if weapon and weapon:IsValid() and weapon:GetClass()=="revenants_handcuffed"then
					local r,g,b=Color(255,0,0),Color(0,255,0),Color(0,255,255)
					wolven_arrest_system.console_log({r,Owner:Name(),b," (",r,Owner:SteamID(),b,") <",r,team.GetName(Owner:Team()),b,"> {",r,Owner:getDarkRPVar("job"),b,"} uncuffed ",g,target:Name(),b," <",g,team.GetName(target:Team()),b,"> {",g,target:getDarkRPVar("job"),b,"} with a ",g,self.PrintName,"\n"})
					local log=Owner:Name().." ("..Owner:SteamID()..") <"..team.GetName(Owner:Team()).."> {"..Owner:getDarkRPVar("job").."} uncuffed "..target:Name().." <"..team.GetName(target:Team()).."> {"..target:getDarkRPVar("job").."} with a "..self.PrintName
					if DarkRP then
						--DarkRP.log(log, Color(0, 255, 255))
					end
					ServerLog(log.."\n")
					weapon:Remove()
				end
			end
		end,
		DrawWorldModel=function(self)
			self:DrawModel()
		end,
		PreDrawViewModel=function(self,vm,weapon,ply)
			local hands=ply:GetHands()
			if hook.Run("PreDrawPlayerHands",hands,vm,ply,weapon) then
				return true
			end
			hands:DrawModel()
			hook.Run("PostDrawPlayerHands",hands,vm,ply,weapon)
			return true
		end,
	}
	weapons.Register(SWEP,SWEP.ClassName)
end
