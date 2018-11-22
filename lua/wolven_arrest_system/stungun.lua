local cfg=wolven_arrest_system.stungun
do
	local SWEP={
		ClassName="revenants_stungun_police",--Entity class name of the SWEP(file or folder name of your SWEP). This is set automatically
		Category="Revenants arrest system",--(Clientside) Category the SWEP is in--Default: "Other"
		Spawnable=true,--Whether this SWEP should be displayed in the Q menu--Default: false
		AdminOnly=true,--Whether or not only admins can spawn the SWEP from their Q menu--Default: false
		PrintName="police issue taser",--Nice name of the SWEP--Default: "Scripted Weapon"
		Base="weapon_base",--The base weapon to derive from. This must be a Lua weapon--Default: "weapon_base"
		m_WeaponDeploySpeed=1,--Multiplier of deploy speed--Default: 1
	--	Owner--The entity that owns/wields this SWEP, if any
		Author="Revenant Moon",--(Clientside) The author of the SWEP to be shown in weapon selection--Default: ""
		Contact="",--(Clientside) The contacts of the SWEP creator to be shown in weapon selection--Default: ""
		Purpose="stun players to help arresting or discipline",--(Clientside) The purpose of the SWEP creator to be shown in weapon selection--Default: ""
		Instructions="",--(Clientside) How to use your weapon, to be shown in weapon selection--Default: ""
		ViewModel="models/weapons/c_pistol.mdl",--Path to the view model for your SWEP(what the wielder will see)--Default: "models/weapons/v_pistol.mdl"
		ViewModelFlip=false,--(Clientside) Should we flip the view model? This is needed for some CS:S view models--Default: false
		ViewModelFlip1=false,--(Clientside) Same as ViewModelFlip, but for the second viewmodel--Default: false
		ViewModelFlip2=false,--(Clientside) Same as ViewModelFlip, but for the third viewmodel--Default: false
		ViewModelFOV=90,--(Clientside) An angle of FOV used for the view model(Half-Life value is 90; Half-Life 2 is 54; Counter-Strike: Source is 74; Day of Defeat is 45)--Default: 62
		WorldModel="models/weapons/w_pistol.mdl",--The world model for your SWEP(what you will see in other players hands)--Default: "models/weapons/w_357.mdl"
		AutoSwitchFrom=true,--(Serverside) Whether this weapon can be autoswitched away from when the player runs out of ammo in this weapon or picks up another weapon or ammo--Default: true
		AutoSwitchTo=true,--(Serverside) Whether this weapon can be autoswitched to when the player runs out of ammo in their current weapon or they pick this weapon up--Default: true
		Weight=5,--(Serverside) Decides whether we should switch from/to this--Default: 5
		BobScale=1,--(Clientside) The scale of the viewmodel bob(viewmodel movement from left to right when walking around)--Default: 1
		SwayScale=1,--(Clientside) The scale of the viewmodel sway(viewmodel position lerp when looking around).--Default: 1
		BounceWeaponIcon=true,--(Clientside) Should the weapon icon bounce in weapon selection?--Default: true
		DrawWeaponInfoBox=true,--(Clientside) Should draw the weapon selection info box, containing SWEP.Instructions, etc.--Default: true
		DrawAmmo=false,--(Clientside) Should we draw the default HL2 ammo counter?--Default: true
		DrawCrosshair=false,--(Clientside) Should we draw the default crosshair?--Default: true
		RenderGroup=RENDERGROUP_OPAQUE,--(Clientside) The SWEP render group, see RENDERGROUP_ Enums--Default: RENDERGROUP_OPAQUE
		Slot=2,--Slot in the weapon selection menu, starts with 0--Default: 0
		SlotPos=10,--Position in the slot, should be in the range 0-128--Default: 10
		SpeechBubbleLid=surface and surface.GetTextureID and surface.GetTextureID("gui/speech_lid" ),--(Clientside) Internal variable for drawing the info box in weapon selection--Default: surface.GetTextureID("gui/speech_lid" )
		WepSelectIcon=surface and surface.GetTextureID and surface.GetTextureID("weapons/swep" ),--(Clientside) Path to an texture. Override this in your SWEP to set the icon in the weapon selection. This must be the texture ID, see surface.GetTextureID--Default: surface.GetTextureID("weapons/swep" )
		CSMuzzleFlashes=false,--(Clientside) Should we use Counter-Strike muzzle flashes upon firing? This is required for DoD:S or CS:S view models to fix their muzzle flashes.--Default: false
		CSMuzzleX=false,--(Clientside) Use the X shape muzzle flash instead of the default Counter-Strike muzzle flash. Requires CSMuzzleFlashes to be set to true--Default: false
		Primary={--Primary attack settings. The table contains these fields:--    
			Ammo="none",-- - Ammo type("Pistol", "SMG1" etc)
			ClipSize=-1,-- - The maximum amount of bullets one clip can hold
			DefaultClip=-1,-- - Default ammo in the clip, making it higher than ClipSize will give player additional ammo on spawn
			Automatic=false,-- - If true makes the weapon shoot automatically as long as the player has primary attack button held down --
		},	
		Secondary={--Secondary attack settings, has same fields as Primary attack settings
			Ammo="none",-- - Ammo type("Pistol", "SMG1" etc)
			ClipSize=-1,-- - The maximum amount of bullets one clip can hold
			DefaultClip=-1,-- - Default ammo in the clip, making it higher than ClipSize will give player additional ammo on spawn
			Automatic=false,-- - If true makes the weapon shoot automatically as long as the player has primary attack button held down --
		},
		UseHands=true,--(Clientside) Makes the player models hands bonemerged onto the view model
		--WARNING The gamemode and view models must support this feature for it to work!
		--You can find more information here: Using Viewmodel Hands--Default: false
	--	Folder="????"--The folder from where the weapon was loaded. This should always be "weapons/weapon_myweapon", regardless whether your SWEP is stored as a file, or multiple files in a folder. It is set automatically on load
		AccurateCrosshair=false,--(Clientside) Makes the default SWEP crosshair be positioned in 3D space where your aim actually is(like on Jeep), instead of simply sitting in the middle of the screen at all times--Default: false
		DisableDuplicator=true,--Disable the ability for players to duplicate this SWEP--Default: false
		ScriptedEntityType="weapon",--(Clientside) Sets the spawnmenu content icon type for the entity, used by spawnmenu in the Sandbox-derived gamemodes. See spawnmenu.AddContentType for more information.--Default: "weapon"
		m_bPlayPickupSound=true,--If set to false, the weapon will not play the weapon pick up sound when picked up.--Default: true --
		Initialize=function(self)
			self:SetColor(Color(255,255,0))
			self.CoolDown=CurTime()+cfg.recharge_time
		end,
		PrimaryAttack=function(self)
			if self.CoolDown and self.CoolDown>CurTime() then
				self:EmitSound("Weapon_Pistol.Empty" )
				return
			end
			self:EmitSound"Weapon_M4A1.Silenced"
			local Owner=self.Owner
			if Owner:IsPlayer() then
				Owner:LagCompensation(true )
			end
			local trace=util.TraceLine({
				start=Owner:GetShootPos(),
				endpos=Owner:GetShootPos()+Owner:GetAimVector()*cfg.police_distance,
				filter={
					Owner,
				}
			})
			if Owner:IsPlayer() then
				Owner:LagCompensation(false )
			end
			if SERVER then
				local target=trace.Entity
				if target and target:IsValid() and target:IsPlayer() then
					if target:GetMoveType()==MOVETYPE_NOCLIP and !target:InVehicle() then--trying to taze admins?
						target=Owner--shame and taze on you
 					end
					if hook.Run("CanTase",Owner,trace,target,self)==false then return end
					target:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")
					local r,g,b=Color(255,0,0),Color(0,255,0),Color(255,255,0)
					wolven_arrest_system.console_log({r,Owner:Name(),b," (",r,Owner:SteamID(),b,") <",r,team.GetName(Owner:Team()),b,"> {",r,Owner:getDarkRPVar("job"),b,"} tazed ",g,target:Name(),b," <",g,team.GetName(target:Team()),b,"> {",g,target:getDarkRPVar("job"),b,"} with a ",g,self.PrintName,"\n"})
					local log=Owner:Name().." ("..Owner:SteamID()..") <"..team.GetName(Owner:Team()).."> {"..Owner:getDarkRPVar("job").."} tazed "..target:Name().." <"..team.GetName(target:Team()).."> {"..target:getDarkRPVar("job").."} with a "..self.PrintName
					if DarkRP then
						--DarkRP.log(log, Color(0, 255, 255))
					end
					ServerLog(log.."\n")
					target:Freeze(true)
					if cfg.police_damage and cfg.police_damage>0 then
						local CTakeDamageInfo=DamageInfo()
						CTakeDamageInfo:SetDamage(cfg.police_damage)
						CTakeDamageInfo:SetDamageType(DMG_SHOCK)
						CTakeDamageInfo:SetAttacker(Owner)
						CTakeDamageInfo:SetInflictor(self)
						target:TakeDamageInfo(CTakeDamageInfo)
					end
					if target:InVehicle() then 
						target:ExitVehicle()
					end
					target.tazed_police=true
					timer.Create("stungun_stun"..target:SteamID64(),cfg.stun_duration,1,function()
						if target and target:IsValid() then
							target.tazed_police=nil
							target:Freeze(false)
						end
					end)
				end
			end
			if !IsFirstTimePredicted() then return end
			local effectdata = EffectData()
			effectdata:SetOrigin(trace.HitPos )
			effectdata:SetNormal(trace.HitNormal )
			effectdata:SetEntity(trace.Entity )
			effectdata:SetAttachment(trace.PhysicsBone )
			util.Effect(trace.Entity and trace.Entity:IsValid() and trace.Entity:IsPlayer() and "cball_explode" or "MuzzleFlash", effectdata)
			local effectdata = EffectData()
			effectdata:SetOrigin(trace.HitPos )
			effectdata:SetStart(self.Owner:GetShootPos() )
			effectdata:SetAttachment(1 )
			effectdata:SetEntity(self )
			util.Effect("ToolTracer", effectdata )
			self.CoolDown=CurTime()+cfg.recharge_time
		end,
		DrawHUD=function(self)
			if !cfg.taser_hud then return end
			local left=(self.CoolDown or 0)-CurTime()
			hook.Run("taser_time_left",left)
			if hook.Run("HUDShouldDraw","taser_hud")==false then return end
			if left>0 then
				cam.Start2D()
				draw.DrawText("time till full charge: "..math.ceil(left),"Trebuchet24",ScrW()*0.9,ScrH()*.7,Color(255,0,0),TEXT_ALIGN_CENTER)
				cam.End2D()
			end
		end,
		SecondaryAttack=function(self)
		end,
	}
	weapons.Register(SWEP,SWEP.ClassName)--the police issue has a lot in common with the next
end
do
	local SWEP={
		ClassName="revenants_stungun_civilian",--Entity class name of the SWEP(file or folder name of your SWEP). This is set automatically
		Category="Revenants arrest system",--(Clientside) Category the SWEP is in--Default: "Other"
		Spawnable=true,--Whether this SWEP should be displayed in the Q menu--Default: false
		AdminOnly=true,--Whether or not only admins can spawn the SWEP from their Q menu--Default: false
		PrintName="civilian issue taser",--Nice name of the SWEP--Default: "Scripted Weapon"
		Base="weapon_base",--The base weapon to derive from. This must be a Lua weapon--Default: "weapon_base"
		m_WeaponDeploySpeed=1,--Multiplier of deploy speed--Default: 1
	--	Owner--The entity that owns/wields this SWEP, if any
		Author="Revenant Moon",--(Clientside) The author of the SWEP to be shown in weapon selection--Default: ""
		Contact="",--(Clientside) The contacts of the SWEP creator to be shown in weapon selection--Default: ""
		Purpose="stun players to help arresting or discipline",--(Clientside) The purpose of the SWEP creator to be shown in weapon selection--Default: ""
		Instructions="",--(Clientside) How to use your weapon, to be shown in weapon selection--Default: ""
		ViewModel="models/weapons/c_pistol.mdl",--Path to the view model for your SWEP(what the wielder will see)--Default: "models/weapons/v_pistol.mdl"
		ViewModelFlip=false,--(Clientside) Should we flip the view model? This is needed for some CS:S view models--Default: false
		ViewModelFlip1=false,--(Clientside) Same as ViewModelFlip, but for the second viewmodel--Default: false
		ViewModelFlip2=false,--(Clientside) Same as ViewModelFlip, but for the third viewmodel--Default: false
		ViewModelFOV=90,--(Clientside) An angle of FOV used for the view model(Half-Life value is 90; Half-Life 2 is 54; Counter-Strike: Source is 74; Day of Defeat is 45)--Default: 62
		WorldModel="models/weapons/w_pistol.mdl",--The world model for your SWEP(what you will see in other players hands)--Default: "models/weapons/w_357.mdl"
		AutoSwitchFrom=true,--(Serverside) Whether this weapon can be autoswitched away from when the player runs out of ammo in this weapon or picks up another weapon or ammo--Default: true
		AutoSwitchTo=true,--(Serverside) Whether this weapon can be autoswitched to when the player runs out of ammo in their current weapon or they pick this weapon up--Default: true
		Weight=5,--(Serverside) Decides whether we should switch from/to this--Default: 5
		BobScale=1,--(Clientside) The scale of the viewmodel bob(viewmodel movement from left to right when walking around)--Default: 1
		SwayScale=1,--(Clientside) The scale of the viewmodel sway(viewmodel position lerp when looking around).--Default: 1
		BounceWeaponIcon=true,--(Clientside) Should the weapon icon bounce in weapon selection?--Default: true
		DrawWeaponInfoBox=true,--(Clientside) Should draw the weapon selection info box, containing SWEP.Instructions, etc.--Default: true
		DrawAmmo=false,--(Clientside) Should we draw the default HL2 ammo counter?--Default: true
		DrawCrosshair=false,--(Clientside) Should we draw the default crosshair?--Default: true
		RenderGroup=RENDERGROUP_OPAQUE,--(Clientside) The SWEP render group, see RENDERGROUP_ Enums--Default: RENDERGROUP_OPAQUE
		Slot=2,--Slot in the weapon selection menu, starts with 0--Default: 0
		SlotPos=10,--Position in the slot, should be in the range 0-128--Default: 10
		SpeechBubbleLid=surface and surface.GetTextureID and surface.GetTextureID("gui/speech_lid" ),--(Clientside) Internal variable for drawing the info box in weapon selection--Default: surface.GetTextureID("gui/speech_lid" )
		WepSelectIcon=surface and surface.GetTextureID and surface.GetTextureID("weapons/swep" ),--(Clientside) Path to an texture. Override this in your SWEP to set the icon in the weapon selection. This must be the texture ID, see surface.GetTextureID--Default: surface.GetTextureID("weapons/swep" )
		CSMuzzleFlashes=false,--(Clientside) Should we use Counter-Strike muzzle flashes upon firing? This is required for DoD:S or CS:S view models to fix their muzzle flashes.--Default: false
		CSMuzzleX=false,--(Clientside) Use the X shape muzzle flash instead of the default Counter-Strike muzzle flash. Requires CSMuzzleFlashes to be set to true--Default: false
		Primary={--Primary attack settings. The table contains these fields:--    
			Ammo="none",-- - Ammo type("Pistol", "SMG1" etc)
			ClipSize=-1,-- - The maximum amount of bullets one clip can hold
			DefaultClip=-1,-- - Default ammo in the clip, making it higher than ClipSize will give player additional ammo on spawn
			Automatic=false,-- - If true makes the weapon shoot automatically as long as the player has primary attack button held down --
		},	
		Secondary={--Secondary attack settings, has same fields as Primary attack settings
			Ammo="none",-- - Ammo type("Pistol", "SMG1" etc)
			ClipSize=-1,-- - The maximum amount of bullets one clip can hold
			DefaultClip=-1,-- - Default ammo in the clip, making it higher than ClipSize will give player additional ammo on spawn
			Automatic=false,-- - If true makes the weapon shoot automatically as long as the player has primary attack button held down --
		},
		UseHands=true,--(Clientside) Makes the player models hands bonemerged onto the view model
		--WARNING The gamemode and view models must support this feature for it to work!
		--You can find more information here: Using Viewmodel Hands--Default: false
	--	Folder="????"--The folder from where the weapon was loaded. This should always be "weapons/weapon_myweapon", regardless whether your SWEP is stored as a file, or multiple files in a folder. It is set automatically on load
		AccurateCrosshair=false,--(Clientside) Makes the default SWEP crosshair be positioned in 3D space where your aim actually is(like on Jeep), instead of simply sitting in the middle of the screen at all times--Default: false
		DisableDuplicator=true,--Disable the ability for players to duplicate this SWEP--Default: false
		ScriptedEntityType="weapon",--(Clientside) Sets the spawnmenu content icon type for the entity, used by spawnmenu in the Sandbox-derived gamemodes. See spawnmenu.AddContentType for more information.--Default: "weapon"
		m_bPlayPickupSound=true,--If set to false, the weapon will not play the weapon pick up sound when picked up.--Default: true --
		Initialize=function(self)
			self.CoolDown=CurTime()+cfg.recharge_time
		end,
		PrimaryAttack=function(self)
			if self.CoolDown and self.CoolDown>CurTime() then
				self:EmitSound("Weapon_Pistol.Empty" )
				return
			end
			self:EmitSound"Weapon_M4A1.Silenced"
			local Owner=self.Owner
			if Owner:IsPlayer() then
				Owner:LagCompensation(true )
			end
			local trace=util.TraceLine({
				start=Owner:GetShootPos(),
				endpos=Owner:GetShootPos()+Owner:GetAimVector()*cfg.civilian_distance,
				filter={
					Owner,
				}
			})
			if Owner:IsPlayer() then
				Owner:LagCompensation(false)
			end
			if SERVER then
				local target=trace.Entity
				if target and target:IsValid() and target:IsPlayer() then
					if target:GetMoveType()==MOVETYPE_NOCLIP and !target:InVehicle() then--trying to taze admins?
						target=Owner--shame and taze on you
 					end
					if hook.Run("CanTase",Owner,trace,target,self)==false then return end
					target:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")
					local r,g,b=Color(255,0,0),Color(0,255,0),Color(0,255,255)
					wolven_arrest_system.console_log({r,Owner:Name(),b," (",r,Owner:SteamID(),b,") <",r,team.GetName(Owner:Team()),b,"> {",r,Owner:getDarkRPVar("job"),b,"} tazed ",g,target:Name(),b," <",g,team.GetName(target:Team()),b,"> {",g,target:getDarkRPVar("job"),b,"} with a ",g,self.PrintName,"\n"})
					local log=Owner:Name().." ("..Owner:SteamID()..") <"..team.GetName(Owner:Team()).."> {"..Owner:getDarkRPVar("job").."} tazed "..target:Name().." <"..team.GetName(target:Team()).."> {"..target:getDarkRPVar("job").."} with a "..self.PrintName
					if DarkRP then
						--DarkRP.log(log, Color(0, 255, 255))
					end
					ServerLog(log.."\n")
					target:Freeze(true)
					if cfg.civilian_damage and cfg.civilian_damage>0 then
						local CTakeDamageInfo=DamageInfo()
						CTakeDamageInfo:SetDamage(cfg.civilian_damage)
						CTakeDamageInfo:SetDamageType(DMG_SHOCK)
						CTakeDamageInfo:SetAttacker(Owner)
						CTakeDamageInfo:SetInflictor(self)
						target:TakeDamageInfo(CTakeDamageInfo)
					end
					if target:InVehicle() then 
						target:ExitVehicle()
					end
					target.tazed_civilian=true
					timer.Create("stungun_stun"..target:SteamID64(),cfg.stun_duration,1,function()
						if target and target:IsValid() then
							target.tazed_civilian=nil
							target:Freeze(false)
						end
					end)
				end
			end
			if !IsFirstTimePredicted() then return end
			local effectdata = EffectData()
			effectdata:SetOrigin(trace.HitPos )
			effectdata:SetNormal(trace.HitNormal )
			effectdata:SetEntity(trace.Entity )
			effectdata:SetAttachment(trace.PhysicsBone )
			util.Effect(trace.Entity and trace.Entity:IsValid() and trace.Entity:IsPlayer() and "cball_explode" or "MuzzleFlash", effectdata)
			local effectdata = EffectData()
			effectdata:SetOrigin(trace.HitPos )
			effectdata:SetStart(self.Owner:GetShootPos() )
			effectdata:SetAttachment(1 )
			effectdata:SetEntity(self )
			util.Effect("ToolTracer", effectdata )
			self.CoolDown=CurTime()+cfg.recharge_time
		end,
		DrawHUD=function(self)
			if !cfg.taser_hud then return end
			local left=(self.CoolDown or 0)-CurTime()
			hook.Run("taser_time_left",left)
			if hook.Run("HUDShouldDraw","taser_hud")==false then return end
			if left>0 then
				cam.Start2D()
				draw.DrawText("time till full charge: "..math.ceil(left),"Trebuchet24",ScrW()*0.9,ScrH()*.7,Color(255,0,0),TEXT_ALIGN_CENTER)
				cam.End2D()
			end
		end,
		Deploy=function(self)
			self:SetMaterial"phoenix_storms/stripes"
			return true
		end,
		Holster=function(self)
			self:SetColor(Color(255,255,255,255))
			self:SetMaterial""
			return true
		end,
		SecondaryAttack=function(self)
		end,
	}
	weapons.Register(SWEP,SWEP.ClassName)
end
hook.Add("CanPlayerSuicide","taser_hooks",function(target)
	if target.tazed_police and cfg.disallow_suicide_police then
		DarkRP.notify(target,1,8,"wait until the stun effect wears off")
		return false
	elseif target.tazed_civilian and cfg.disallow_suicide_civilian then
		DarkRP.notify(target,1,8,"wait until the stun effect wears off")
		return false
	end
end)
local togive={}
hook.Add("PlayerLoadout","taser_hooks",function(ply)
	local TEAM=ply:Team()
	if togive[TEAM]==nil and cfg.autogive  then
		togive[TEAM]=table.HasValue(ply:getJobTable().weapons,"arrest_stick")
	end
	if togive[TEAM] and cfg.autogive  then
		ply:Give("revenants_stungun_police")
	end
end)