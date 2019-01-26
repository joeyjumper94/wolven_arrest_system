local tbl=wolven_arrest_system and wolven_arrest_system.LTAP or {}--don't touch this line

wolven_arrest_system={
	looting={
		model="models/props_wasteland/prison_toilet01.mdl",--what model should be default for this entity?
		time=120,--after tying to get loot, how long before the same player can loot again?
		need_arrested=true,--does a player have to be arrested to loot the prison?
		loadout={--a list of weapons arrested players spawn with
			"pocket",
		},
		whitelist={-- a list of weapons a player can pick up.
			weapon_sh_doorcharge_detonator=true,
			med_kit=true,
			weapon_medkit=true,
			weapon_bugbait=true,
		},
		loot={
			"pro_lockpick",
			"weapon_blowtorch",
			"weapon_hl2pipe",
			"weapon_hl2bottle",
			function(ply,self,whitelist)--it can also be a function
				--first argument is the player who is searching the looting entity
				--second is the looting entity itself
				--this is the whitelist table
				ply:addMoney(1000)--$1,000 is pretty good
				DarkRP.notify(ply,0,4,DarkRP.getPhrase("found_money",DarkRP.formatMoney(1000)))
			end,
			function(ply,self,whitelist)--something really good like possibly getting out of jail free
				if math.random(1,100)<=5 then--pass this check and get out of jail free
					if ply:isArrested() then
						ply:unArrest(ply)
						ply:Spawn()
						DarkRP.notifyAll(1,8,ply:Name().." hit the looting system jackpot and got out of jail free")
						DarkRP.notify(ply,3,8,"get out of jail free card")
					else
						DarkRP.notifyAll(1,8,ply:Name().." hit the looting system jackpot but wasn't arrested")
					end
				else
					DarkRP.notify(ply,3,8,"no jackpot this time")
				end
			end,
			function(ply,self,whitelist)--it can also be a bad thing, like 10 damage
				local CTakeDamageInfo=DamageInfo()
				CTakeDamageInfo:SetDamage(10)
				CTakeDamageInfo:SetDamageType(DMG_SLASH)
				CTakeDamageInfo:SetAttacker(self)
				CTakeDamageInfo:SetInflictor(self)
				ply:TakeDamageInfo(CTakeDamageInfo)
				DarkRP.notify(ply,1,8,"Ouch! seems like you cut yourself on something")
			end,
			function(ply,self,whitelist)--exponential damage
				local cur,max=ply:Health(),ply:GetMaxHealth()
				local amount=max-cur
				if amount>0 then
					if amount>=cur then
						amount=cur-1
						DarkRP.notify(ply,1,8,"You are now a walking corpse.")
					end
					local CTakeDamageInfo=DamageInfo()
					CTakeDamageInfo:SetDamage(amount)
					CTakeDamageInfo:SetDamageType(DMG_BURN)
					CTakeDamageInfo:SetAttacker(self)
					CTakeDamageInfo:SetInflictor(self)
					ply:TakeDamageInfo(CTakeDamageInfo)
					DarkRP.notify(ply,1,8,"The dirt you reached into infected your wounds.")
				else
					DarkRP.notify(ply,1,8,"The dirt you reached into was quite disgusting.")
				end
			end,
			function(ply,self,whitelist)--a message telling them they got nothing
				DarkRP.notify(ply,1,8,"Nothing doing.")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"Found nothing.")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"Turned up zilch.")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"Jack.. and shit. Literally.")
				whitelist.weapon_bugbait=true
				ply:Give("weapon_bugbait")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,2,8,"when life gives you shit, throw it at people")
				whitelist.weapon_bugbait=true
				ply:Give("weapon_bugbait")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"Nope.")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"Nada.")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"sorry.")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"Nothing but a bad smell on your hands.")
			end,--[[
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"bupkis.")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"Empty.")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"No dice.")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"bad luck.")
			end,
			function(ply,self,whitelist)
				DarkRP.notify(ply,1,8,"Sorry.")
			end,--]]
		},
	},
	stungun={
		autogive=true,--automatically give the police issue taser to those who (would normally )have arrest batons?
		stun_duration=10,--how long is a player stunned?
		recharge_time=30,--how long does it take the stungun to rechage?
		police_damage=0,--how much damage does the police taser do?
		police_distance=480,--16 hammer units per foot*30 feet for police issue taser
		civilian_damage=0,--how much damage does the civilian taser do?
		civilian_distance=240,--16*15=240 for a civilian issue taser
		taser_hud=true,--should we draw a hud with the taser?
		disallow_suicide_police=true,--disallow suicide if a player was tased by a police issue taser?
		disallow_suicide_civilian=false,--disallow suicide if a player was tased by a civilian issue taser?
		untaze_on_death_police=true,--remove the taze effect from police taser on death
		untaze_on_death_civilian=true,--remove the taze effect from civilian taser on death
	},
	cuffs={
		NoDrive=true,--prevent players from entering vehicles,
		finished_message="press E on a cuffed player to drag them,\npress E on them again to stop dragging",--message to send to someone when they finish cuffing
		autogive=true,--automatically give the handcuffs and keys to those who (would normally )have arrest batons?
		distance=60,--how close do you need to be to (un)cuff?
		time=2,--long does it take to put the cuffs on?
		drawhud=true,--should the word "HANDCUFFED" be drawn on a handcuffed player?
		allow_drag=true,--allow dragging of handcuffed players?
		draw_rope=true,--draw the drag ropes?
		force_walk=true,--force cuffed players to only walk?
		no_run=true,--disallow running while cuffed?
		drag_no_move=true,--disable all move keys when being dragged?
		slack=150,--how far can the dragger and the target go before the rope pulls them together?
		dragger_force_multiplier=.1,--multiplier for the force applied to a player who is dragging someone
		target_force_multiplier=1,--multiplier for the force applied to a player who is being dragged
		cuff_timer=900,--maximum time that cuffs can be on, after that, the cuffs are automatically removed
		adrenaline_max=60,--after breaking away from someone, what's the maximum time for the adrenaline rush?
		adrenaline_min=30,--after breaking away from someone, what's the minimum time for the adrenaline rush?
		reset_adrenaline=true,--reset adrenaline if dragging starts again?
		handcuff_progress=15,--how many buttons does a player have to correctly press to break away from being dragged?
		keys={--see https://wiki.garrysmod.com/page/Enums/BUTTON_CODE for the enums we are using.
			{k=MOUSE_LEFT,t="Left click"},
			{k=MOUSE_RIGHT,t="Right click"},
		},
		remember_arrested=true,--arrest people if they dc and rejoin while cuffed?
	},
	booking={
		target_notify=[[you have your pocket and anything in it, maybe you can use something in there to break out
the bail unit will allow you to buy your way out of jail, it costs one to ten percent of you total wallet
the looting system may give you somthing that you can break yourself out with
though it could also be something totally useless
if you make it out the door, your arrested status will be removed, though you will automatically be wanted]],
		model="models/props_combine/combine_interface002.mdl",--what model should be default for this entity?
		distance=150,--how close does someone have to be to a booking unit to arrest via proximity mode?
		--if a cop uses the unit, and isn't dragging someone, it checks if there are any nearby people that can be arrested then evaluates if they can be arrested
		--if a cop is dragging someone, only the player they are dragging is evaluated for arrest
		time=2,--after use, how many seconds before it can be used again?
		arrest_cp=true,--allow arresting of CPs at all?
		arrest_chief=false,--allow arresting of the chief?
		booking_only=false,--only allow by the booking unit?
		reward=2000,--pay cops this much when arresting someone
		noabaton=false,--remove arrest batons from people?
		remember_arrested=true,--remember who is arrested incase they try rejoining to get out of jail?
	},
	bail={
		model="models/props_phx/rt_screen.mdl",--what model should be default for this entity?
		time=600,--how long until your bail price hits the minimum
		wanted_reason="Escaping prison.",--wanted reason when someone tries to walk out of the jail area
		escape_notify_self="you escaped jail, but the cops may be after you now",--message shown to players who escape jail
		escape_notify_other="{{NAME}} has escaped from jail",--message shown to everyone else when someone escapes jail, {{NAME}} is replaced with the escapee's name
		unarrest_zones={--map name is the key and the value is a table
			rp_downtown_em_hs_15={--each value in here is a table
				{--this table has 2 vectors
					Vector(-2351,371,106),
					Vector(-2297,269,-23),
				},
			},
			rp_downtown_em_hs_16={--each value in here is a table
				{--front door
					Vector(-2351,371,106),
					Vector(-2297,269,-23),
				},
				{--balcony door
					Vector(-3217,92,312),
					Vector(-3120,69,453),
				},
			},
			rp_downtown_v4c_v6={
				{--window
					Vector(-1442.550049,23.490604,141.599915),
					Vector(-1486.639771,151.750778,67.993301),
				},
				{--door
					Vector(-1473.834473,130.070694,-38.486290),
					Vector(-1428.337036,64.954643,-178.605026),
				}
			},
		}
	},
	--misc stuff
	log_access={--a list of ranks that can see the cuff/taser logs appear in their console
		["t-mod"]=true,
		tmod=true,
		mod=true,
		moderator=true,
		helper=true,
	},
	ent_replacement={--the model of a map entity is the key and the value is the classname of the ent to replace it
		["models/props_wasteland/prison_toilet01.mdl"]="revenants_prison_looting",
--		["models/props_c17/furnituretoilet001a.mdl"]="revenants_prison_looting",
--		["models/props/cs_militia/toilet.mdl"]="revenants_prison_looting",
--		["models/props_2fort/sink001.mdl"]="revenants_prison_looting",
--		["models/props_c17/furnituresink001a.mdl"]="revenants_prison_looting",
--		["models/props_interiors/sinkkitchen01a.mdl"]="revenants_prison_looting",
--		["models/props_wasteland/prison_sink001a.mdl"]="revenants_prison_looting",
--		["models/props_wasteland/prison_sink001b.mdl"]="revenants_prison_looting",

--		["models/props_combine/combine_interface001.mdl"]="revenants_booking_station",
--		["models/props_combine/combine_interface001a.mdl"]="revenants_booking_station",--probably an HL2 EP1 prop
		["models/props_combine/combine_interface002.mdl"]="revenants_booking_station",
--		["models/props_combine/combine_interface003.mdl"]="revenants_booking_station",

--		["models/props_combine/combine_intmonitor001.mdl"]="revenants_bail_unit",
--		["models/props_combine/combine_intmonitor003.mdl"]="revenants_bail_unit",
		["models/props_phx/rt_screen.mdl"]="revenants_bail_unit",
--		["models/props_phx/sp_screen.mdl"]="revenants_bail_unit",
	},
}
--don't touch the stuff below
wolven_arrest_system.LTAP=tbl
local FILES,FOLDERS=file.Find("wolven_arrest_system/*.lua","LUA")
for k,FILE in ipairs(FILES)do
	AddCSLuaFile("wolven_arrest_system/"..FILE)--send it to the client
	include("wolven_arrest_system/"..FILE)--run it
end
