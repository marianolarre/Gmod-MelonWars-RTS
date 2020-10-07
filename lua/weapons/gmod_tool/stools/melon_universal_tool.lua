TOOL.Category = "MelonWars: RTS"
TOOL.Name = "Player Tool"
--TOOL.Tab = "Melon Wars"
TOOL.Command = nil
TOOL.ConfigName = "" --Setting this means that you do not have to create external configuration files to define the layout of the tool config-hud 

//{ CONVARS
CreateClientConVar( "mw_chosen_unit", "1", 0, false )
TOOL.ClientConVar[ "mw_chosen_unit" ] = 1
CreateClientConVar( "mw_context_menu", "0", 0, false )
TOOL.ClientConVar[ "mw_context_menu" ] = 0
CreateClientConVar( "mw_unit_option_rocketeer", "0", 0, true )
TOOL.ClientConVar[ "mw_unit_option_rocketeer" ] = 0
CreateClientConVar( "mw_unit_option_welded", "0", 0, true )
TOOL.ClientConVar[ "mw_unit_option_welded" ] = 0
CreateClientConVar( "mw_team", "1", 1, true )
TOOL.ClientConVar[ "mw_team" ] = 1
CreateClientConVar( "mw_contraption_name", "default", 0, false )
TOOL.ClientConVar[ "mw_contraption_name" ] = "default"

CreateConVar( "mw_enable_skin", "1", FCVAR_ARCHIVE+FCVAR_USERINFO, "Enable or disable your custom skin" )
TOOL.ClientConVar[ "mw_enable_skin" ] = "1"

CreateConVar( "mw_admin_open_permits", "0", 8192, "Whether or not everyone is allowed to use the admin menu" )
TOOL.ClientConVar[ "mw_admin_spawn_time" ] = 0
CreateConVar( "mw_admin_spawn_time", "0", 8192, "Whether or not units take time before spawning" )
TOOL.ClientConVar[ "mw_admin_spawn_time" ] = 1
CreateConVar( "mw_admin_immortality", "0", 8192, "Whether or not units are immortal. Intended for use in photography" )
TOOL.ClientConVar[ "mw_admin_immortality" ] = 1
CreateConVar( "mw_admin_move_any_team", "1", 8192, "If true, everyone can move any melon" )
TOOL.ClientConVar[ "mw_admin_move_any_team" ] = 1
CreateConVar( "mw_admin_allow_free_placing", "1", 8192, "If true, melons can be spawned anywhere" )
TOOL.ClientConVar[ "mw_admin_allow_free_placing" ] = 1
CreateConVar( "mw_admin_playing", "0", 8192, "If false, players cant play and income stops" )
TOOL.ClientConVar[ "mw_admin_playing" ] = 1
CreateConVar( "mw_admin_base_income", "25", 8192, "Amount of income from main buildings. (x2 for grand base)" )
TOOL.ClientConVar[ "mw_admin_base_income" ] = 25
CreateConVar( "mw_admin_cutscene", "0", 8192, "Used in the singleplayer mode" )
TOOL.ClientConVar[ "mw_admin_cutscene" ] = 0
CreateConVar( "mw_admin_credit_cost", "0", 8192, "If false, units are free" )
TOOL.ClientConVar[ "mw_admin_credit_cost" ] = 1
CreateConVar( "mw_admin_max_units", "100", 8192, "The max ammount of melons per team" )
TOOL.ClientConVar[ "mw_admin_max_units" ] = 100
CreateConVar( "mw_admin_starting_credits", "2000", 8192, "The starting credits for a match" )
TOOL.ClientConVar[ "mw_admin_max_units" ] = 2000
CreateConVar( "mw_admin_allow_manual_placing", "1", 8192, "If false, you can place units directly with the toolgun" )
TOOL.ClientConVar[ "mw_admin_allow_manual_placing" ] = 1
CreateConVar( "mw_admin_player_colors", "1", 8192, "If true, players will respawn with their team's color" )
TOOL.ClientConVar[ "mw_admin_player_colors" ] = 1
CreateConVar( "mw_admin_contraptions_beta", "0", 8192, "If true, the beta saving and loading of contraptions will be used" )
TOOL.ClientConVar[ "mw_admin_contraptions_beta" ] = 0

CreateClientConVar( "mw_chosen_prop", "1", 0, true )
TOOL.ClientConVar[ "mw_chosen_prop" ] = 1
CreateClientConVar( "mw_prop_offset", "1", 0, false )
TOOL.ClientConVar[ "mw_prop_offset" ] = 1
CreateClientConVar( "mw_prop_snap", "1", 0, false )
TOOL.ClientConVar[ "mw_prop_snap" ] = 1
CreateClientConVar( "mw_code", "0", 0, false )
TOOL.ClientConVar[ "mw_code" ] = 1
CreateClientConVar( "mw_custom_chat", "1", 1, false )
TOOL.ClientConVar[ "mw_custom_chat" ] = 1
CreateClientConVar( "mw_income_indicator", "1", 1, false )
TOOL.ClientConVar[ "mw_income_indicator" ] = 1

CreateClientConVar( "mw_action", "0", 0, true )
TOOL.ClientConVar[ "mw_action" ] = 0
//}
//mw_team_colors  = {Color(255,50,50,255),Color(50,50,255,255),Color(255,200,50,255),Color(30,200,30,255),Color(100,0,80,255),Color(100,255,255,255),Color(255,120,0,255),Color(255,100,150,255)}
local button_energy_color = Color(255, 255, 80)
local button_barrack_color = Color(200, 255, 255)
//{ UNIT INFO

local IncomeIndicatorClass = {}
IncomeIndicatorClass.time = 0
IncomeIndicatorClass.value = 0

local function IncomeIndicator() --Code is an optional argument.
	local newIncomeIndicator = table.Copy( IncomeIndicatorClass )
	return newIncomeIndicator
end

local incomeIndicators = {
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator(),
	IncomeIndicator()
}
local currentIncomeIndicator = 1

local UnitClass = {}
UnitClass.name = "Marine"
UnitClass.class = "ent_melon_marine"
UnitClass.cost = 50
UnitClass.welded_cost = 20
UnitClass.population = 1
UnitClass.spawn_time = 1
UnitClass.model = "models/props_junk/watermelon01.mdl"
UnitClass.description = "No description set"
UnitClass.offset = Vector(0,0,0)
UnitClass.angle = Angle(0,0,0)
UnitClass.angleSnap = true
UnitClass.normalAngle = false
UnitClass.contraptionPart = false
UnitClass.canOverlap = true
UnitClass.button_color = Color(250,250,250)
UnitClass.energyRange = 0
UnitClass.buildAnywere = false
UnitClass.changeAngles = true
UnitClass.spawnable_on_floor = true

local defaultenergyrange = 200

local function Unit() --Code is an optional argument.
	local newUnit = table.Copy( UnitClass )
	return newUnit
end

local unitCount = 63
mw_units = {}
local u = nil
for i=1, unitCount do
	mw_units[i] = Unit()
end

function BarracksText (number, max)
	return [[This is a building that produces a ]]..mw_units[number].name.." every "..tostring(mw_units[number].spawn_time*3).." seconds, up to "..max.." at any given time, at half the price. Select this building and command it to move somewhere to set a rally point for its deployed units. Look at it and press E to toggle it on and off."
end

local i = 0

i = i+1
u = mw_units[i]
u.name 			= "Marine"			
u.class 		= "ent_melon_marine"
u.cost 			= 75				
u.welded_cost 	= 20				
u.population 	= 1				
u.spawn_time 	= 2	
u.description 	= [[The basic unit.]]	
u.model 		= "models/props_junk/watermelon01.mdl"

i = i+1
u = mw_units[i]
u.name 			= "Medic"			
u.class 		= "ent_melon_medic"
u.cost 			= 180				
u.welded_cost 	= 100				
u.population 	= 1					
u.spawn_time 	= 3
u.description 	= [[The healer of the group, always good to have one around. It can also fix buildings.]]
u.model 		= "models/props_junk/watermelon01.mdl"

i = i+1
u = mw_units[i]
u.name 			= "Jetpack"	
u.class 		= "ent_melon_jetpack"
u.cost 			= 200				
u.welded_cost 	= -1					
u.population 	= 1					
u.spawn_time 	= 4	
u.description 	= [[These marines take to the skies... but not too high. They hover a few meters above ground, enough to make it over enemy walls.]]			
u.model 		= "models/props_junk/watermelon01.mdl"
u.offset 		= Vector(0,0,140)

i = i+1
u = mw_units[i]
u.name 			= "Bomb"				
u.class 		= "ent_melon_bomb"	
u.cost 			= 400				
u.welded_cost 	= -1				
u.population 	= 2					
u.spawn_time 	= 5	
u.description 	= [[Explodes on proximity after 0.3 seconds. Send some cannon fodder in front to keep it alive until it reaches its target. Watch out for friendly fire! If spawned as turret, it will burry itself in the ground (mines only take 1 power).]]	
u.model 		= "models/props_phx/misc/soccerball.mdl"

i = i+1
u = mw_units[i]
u.name 			= "Gunner"			
u.class 		= "ent_melon_gunner"	
u.cost 			= 500				
u.welded_cost 	= 150				
u.population 	= 2				
u.spawn_time 	= 6	
u.description 	= [[Equiped with a minigun, this tougher and slower unit will shoot faster the longer it holds down the trigger. It has some spread, so try getting up close.]]				
u.model 		= "models/Roller.mdl"

i = i+1
u = mw_units[i]
u.name 			= "Missiles"				
u.class 		= "ent_melon_missiles"	
u.cost 			= 500					
u.welded_cost 	= 175					
u.population 	= 2						
u.spawn_time 	= 5	
u.description 	= [[This unit launches medium range homing missiles to suppress hoards of weak units. Good for dealing constant group damage.]]					
u.model 		= "models/xqm/rails/trackball_1.mdl"

i = i+1
u = mw_units[i]
u.name 			= "Sniper"			
u.class 		= "ent_melon_sniper"	
u.cost 			= 800				
u.welded_cost 	= 350				
u.population 	= 2					
u.spawn_time 	= 8		
u.description 	= [[Slow shooting but very powerful. Useful for picking off bigger targets. It cant shoot while moving.]]			
u.model 		= "models/props_junk/propane_tank001a.mdl"
u.offset 		= Vector(0,0,12)

i = i+1
u = mw_units[i]
u.name 			= "Hot Shot"					
u.class 		= "ent_melon_hotshot"		
u.cost 			= 1000					
u.welded_cost 	= 750						
u.population 	= 2					
u.spawn_time 	= 5
u.description 	= [[Shoots a fan of incendiary bullets in a wide spread. Usefull against spread out squads, not as effective against clumped up enemies.]]				
u.model 		= "models/xqm/afterburner1.mdl"
u.offset 		= Vector(0,0,10)

i = i+1
u = mw_units[i]
u.name 			= "Mortar"			
u.class 		= "ent_melon_mortar"	
u.cost 			= 3000				
u.welded_cost 	= 1500				
u.population 	= 3					
u.spawn_time 	= 10
u.description 	= [[Very durable. Launches bombs in an arc. Useful for eliminating enemies behind walls. It cant shoot while moving nor point-blank.]]				
u.model 		= "models/props_borealis/bluebarrel001.mdl"
u.offset 		= Vector(0,0,20)

i = i+1
u = mw_units[i]
u.name 			= "Nuke"					
u.class 		= "ent_melon_nuke"		
u.cost 			= 3000					
u.welded_cost 	= -1						
u.population 	= 4					
u.spawn_time 	= 30
u.description 	= [[Goes BOOM like a baus. Protect it until it gets to the enemy walls, because it doesn't explode as big if it gets killed before detonation. It takes it 1.5 seconds to detonate.]]				
u.model 		= "models/props_phx/cannonball.mdl"
u.offset 		= Vector(0,0,20)

i = i+1
u = mw_units[i]
u.name 			= "Cannon"			
u.class 		= "ent_melon_cannon"	
u.cost 			= 7000				
u.welded_cost 	= 5000			
u.population 	= 5				
u.spawn_time 	= 20
u.description 	= [[Fires a long range fast cannon ball that deals high (yet inconsistent) damage on impact, going through anything not strong enough to stop it. It cant fire while moving. Its shots can collapse defences.]]				
u.model 		= "models/props_c17/oildrum001.mdl"
u.offset 		= Vector(0,0,0)
//u.code 			= "//banned//"
/*
i = i+1
u = mw_units[i]
u.name 			= "Doot"			
u.class 		= "ent_melon_doot"
u.cost 			= 25				
u.welded_cost 	= 20				
u.population 	= 1				
u.spawn_time 	= 0.5//1
u.description 	= [[Such spoops]]	
u.model 		= "models/Gibs/HGIBS.mdl"
*/
i = i+1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Voidling"			
u.class 		= "ent_melon_voidling"
u.cost 			= 15				
u.welded_cost 	= -1				
u.population 	= 1				
u.spawn_time 	= 1
u.description 	= [[A little entity of Void that seeks enthropy and equilibrium. It will throw itself at enemies to deal damage, and die in the process. When sacrificing a voidling to a shredder, you gain a small Water profit.]]	
u.model 		= "models/hunter/misc/sphere025x025.mdl"

i = i+1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Mammoth"			
u.class 		= "ent_melon_void_mamoth"
u.cost 			= 1000				
u.welded_cost 	= -1				
u.population 	= 3				
u.spawn_time 	= 10
u.offset 		= Vector(0,0,10)
u.description 	= [[A big entity of Void, powerful and slow. Has a lot of health, deals extra damage to buildings and captures points quicker.]]	
u.model 		= "models/mechanics/wheels/wheel_spike_48.mdl"

i = i+1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Buck"			
u.class 		= "ent_melon_buck"
u.cost 			= 200				
u.welded_cost 	= 50				
u.population 	= 2
u.spawn_time 	= 15
u.description 	= [[A slow trooper that fires a Shotgun blast in a tight spread, useful for clearing hoards of weak enemies.]]	
u.model 		= "models/props_junk/plasticbucket001a.mdl"

i = i+1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Fighter"			
u.class 		= "ent_melon_fighter"
u.cost 			= 750				
u.welded_cost 	= -1				
u.population 	= 3
u.spawn_time 	= 20
u.description 	= [[A fast fighter jet that flies high and shoots down. It cant fly forever without landing tho.]]	
u.model 		= "models/props_phx/construct/metal_plate1_tri.mdl"
u.code 			= "//banned//"

i = i+1
u = mw_units[i]
u.code 			= "prot"
u.name 			= "Gatling"			
u.class 		= "ent_melon_gatling"
u.cost 			= 450				
u.welded_cost 	= 100				
u.population 	= 3
u.spawn_time 	= 5
u.description 	= [[A gunner that can fire really fast, that is until his gun starts to overheat and it slows down.]]	
u.model 		= "models/Mechanics/gears/gear12x24.mdl"

i = i+1
u = mw_units[i]
u.code 			= "prot"
u.name 			= "Molotov"			
u.class 		= "ent_melon_molotov"
u.cost 			= 200				
u.welded_cost 	= 100				
u.population 	= 2
u.spawn_time 	= 5
u.offset 		= Vector(0,0,10)
u.description 	= [[A bomb that leaves behind a flaming, dangerous area on the floor.]]	
u.model 		= "models/props_junk/propanecanister001a.mdl"

i = i+1
u = mw_units[i]
u.name 			= "Droid"			
u.class 		= "ent_melon_droid"
u.cost 			= 300				
u.welded_cost 	= -1				
u.population 	= 2
u.spawn_time 	= 8
u.offset 		= Vector(0,0,10)
u.description 	= [[A more damaging, tougher Marine that requires energy to fire]]	
u.model 		= "models/props_c17/utilityconnecter006c.mdl"
u.button_color 	= button_energy_color

i = i+1
u = mw_units[i]
u.name 			= "Long-boy"			
u.class 		= "ent_melon_longboy"
u.cost 			= 8000				
u.welded_cost 	= -1				
u.population 	= 5
u.spawn_time 	= 15
u.offset 		= Vector(0,0,0)
u.description 	= [[A very long range superweapon that needs to deploy to attack. It has to be charged with energy and it can be toggled by looking at it and pressing E.]]	
u.model 		= "models/props_trainstation/trainstation_ornament001.mdl"
u.button_color 	= button_energy_color

i = i+1
firstBuilding = i ---------------------------------First building
u = mw_units[i]
u.name 			= "Turret"			
u.class 		= "ent_melon_turret"	
u.cost 			= 350					
u.welded_cost 	= -1					
u.population 	= 2						
u.spawn_time 	= 10	
u.description 	= [[Static defense, a heavy machinegun with good health and firepower]]				
u.model 		= "models/combine_turrets/ground_turret.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(180, 180, 0)

i = i+1
u = mw_units[i]
u.name 			= "Shredder"				
u.class 		= "ent_melon_shredder"
u.cost 			= 100					
u.welded_cost 	= -1					
u.population 	= 0						
u.spawn_time 	= 5
u.description 	= [[A set of spinning blades, used to recycle melons, get resources back, and sometimes make smoothies. It has low health, so use as defense at your own risk. (It doesn't give credits for friendly free units)]]			
u.model 		= "models/props_c17/TrapPropeller_Blade.mdl"
u.offset 		= Vector(0,0,0)

i = i+1
u = mw_units[i]
u.name 			= "Elevator Pad"
u.class 		= "ent_melon_elevator_pad"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A pad you place on the floor and lifts up anything above it. Useful as an elevator.]]
u.model 		= "models/hunter/tubes/circle2x2.mdl"
u.offset 		= Vector(0,0,-5)

i = i+1
u = mw_units[i]
u.name 			= "Loading Bay"
u.class 		= "ent_melon_loading_bay"
u.cost 			= 200
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A pad you place on the floor that loads units on it to the nearest Unit Transport]]
u.model 		= "models/props_phx/construct/metal_plate2x2.mdl"
u.offset 		= Vector(0,0,-5)

i = i+1
u = mw_units[i]
u.name 			= "Gate"
u.class 		= "ent_melon_gate"
u.cost 			= 200
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A gate that can be opened and closed with E.]]
u.model 		= "models/props_phx/construct/metal_plate1x2.mdl"
u.offset 		= Vector(0,0,18.5)
u.angle 		= Angle(90,0,0)

i = i+1
u = mw_units[i]
u.name 			= "Large Gate"
u.class 		= "ent_melon_gate_big"
u.cost 			= 500
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[A bigger gate that can be opened and closed with E, useful to get a big army or a contraption through. Requires energy to open and close.]]
u.model 		= "models/props_phx/construct/metal_plate2x4.mdl"
u.offset 		= Vector(0,0,42)
u.angle 		= Angle(90,0,0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "Tesla Tower"			
u.class 		= "ent_melon_tesla_tower"	
u.cost 			= 300					
u.welded_cost 	= -1					
u.population 	= 1						
u.spawn_time 	= 10	
u.description 	= [[Static defense that consumes energy to zap up to 5 targets at once. Requires energy to fire.]]				
u.model 		= "models/props_c17/FurnitureBoiler001a.mdl"
u.offset 		= Vector(0,0,40)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "Over-Clocker"			
u.class 		= "ent_melon_overclocker"	
u.cost 			= 500					
u.welded_cost 	= -1					
u.population 	= 0						
u.spawn_time 	= 10	
u.description 	= [[Place it right next to a Barracks of any kind. When it's on, it will consume energy and boost the barrack's production rate. (It will disappear if not placed close enough to a barracks)]]				
u.model 		= "models/props_combine/combine_light001a.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "Medical Bay"			
u.class 		= "ent_melon_medical_bay"	
u.cost 			= 600					
u.welded_cost 	= -1					
u.population 	= 1
u.spawn_time 	= 10	
u.description 	= [[This building will slowly heal up to 10 units at a time in a big radius. It requires a lot of energy per target, so area attacks might drain a lot of energy]]				
u.model 		= "models/props_phx/wheels/747wheel.mdl"
u.offset 		= Vector(0,0,-5)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "Charging Station"			
u.class 		= "ent_melon_charging_station"	
u.cost 			= 300					
u.welded_cost 	= -1					
u.population 	= 1						
u.spawn_time 	= 10	
u.description 	= [[Provides energy to nearby energy dependant units.]]				
u.model 		= "models/props_c17/substation_transformer01d.mdl"
u.offset 		= Vector(0,0,24)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "Radar"			
u.class 		= "ent_melon_radar"	
u.cost 			= 100					
u.welded_cost 	= -1					
u.population 	= 0
u.spawn_time 	= 5	
u.description 	= [[If energized, it will alert your team of nearby units no matter where you are. It passively consumes the power output of 2 solar panels]]				
u.model 		= "models/props_trainstation/trainstation_column001.mdl"
u.offset 		= Vector(0,0,-5)
u.angle 		= Angle(0, 0, 0)
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "Marine Barracks"			
u.class 		= "ent_melon_barracks_marine"
u.cost 			= 1500						
u.welded_cost 	= -1							
u.population 	= 1						
u.spawn_time 	= 10
u.description   = BarracksText (1, 10)										
u.model 		= "models/Items/ammocrate_ar2.mdl"
u.offset 		= Vector(0,0,10)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.name 			= "Medic Academy"			
u.class 		= "ent_melon_barracks_medic" 
u.cost 			= 1500						
u.welded_cost 	= -1							
u.population 	= 1							
u.spawn_time 	= 10
u.description 	= BarracksText (2, 5)							
u.model 		= "models/props_junk/wood_crate002a.mdl"
u.offset 		= Vector(0,0,10)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.name 			= "Jetpack Flight School"		
u.class 		= "ent_melon_barracks_jetpack"	
u.cost 			= 2000							
u.welded_cost 	= -1								
u.population 	= 1								
u.spawn_time 	= 10
u.description 	= BarracksText (3, 5)							
u.model 		= "models/props_wasteland/kitchen_stove002a.mdl"
u.offset 		= Vector(0,0,-15)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.name 			= "Bomb Factory"				
u.class 		= "ent_melon_barracks_bomb"	
u.cost 			= 3000						
u.welded_cost 	= -1							
u.population 	= 1							
u.spawn_time 	= 10
u.description 	= BarracksText (4, 3)						
u.model 		= "models/props_wasteland/laundry_basket001.mdl"
u.offset 		= Vector(0,0,10)
u.angle 		= Angle(180,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.name 			= "Gunner Training Camp"		
u.class 		= "ent_melon_barracks_gunner"
u.cost 			= 3000						
u.welded_cost 	= -1							
u.population 	= 1						
u.spawn_time 	= 10	
u.description 	= BarracksText (5, 5)							
u.model 		= "models/props_combine/combine_interface002.mdl"
u.offset 		= Vector(0,0,-25)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.name 			= "Missiles Production Line"		
u.class 		= "ent_melon_barracks_missiles"	
u.cost 			= 3000							
u.welded_cost 	= -1								
u.population 	= 1								
u.spawn_time 	= 15	
u.description 	= BarracksText (6, 4)								
u.model 		= "models/props_interiors/VendingMachineSoda01a.mdl"
u.offset 		= Vector(0,0,10)
u.angle 		= Angle(-90,0,90)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.name 			= "Sniper Shooting Range"		
u.class 		= "ent_melon_barracks_sniper"	
u.cost 			= 3000							
u.welded_cost 	= -1								
u.population 	= 1								
u.spawn_time 	= 15	
u.description 	= BarracksText (7, 3)								
u.model 		= "models/props_wasteland/laundry_cart001.mdl"
u.offset 		= Vector(0,0,15)
u.angle 		= Angle(180, 90, 0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.name 			= "Hot Shot Forge"				
u.class 		= "ent_melon_barracks_hotshot"		
u.cost 			= 4000							
u.welded_cost 	= -1								
u.population 	= 1								
u.spawn_time 	= 15	
u.description 	= BarracksText (8, 3)								
u.model 		= "models/props_wasteland/laundry_dryer002.mdl"
u.offset 		= Vector(0,0,30)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.name 			= "Mortar Production Facility"	
u.class 		= "ent_melon_barracks_mortar"	
u.cost 			= 5000							
u.welded_cost 	= -1								
u.population 	= 1								
u.spawn_time 	= 15	
u.description 	= BarracksText (9, 3)								
u.model 		= "models/XQM/CoasterTrack/train_1.mdl"
u.offset 		= Vector(0,0,-25)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.name 			= "Nuke Assembler"				
u.class 		= "ent_melon_barracks_nuke"		
u.cost 			= 15000							
u.welded_cost 	= -1								
u.population 	= 1								
u.spawn_time 	= 20	
u.description 	= BarracksText (10, 1)								
u.model 		= "models/props_lab/teleportframe.mdl"
u.offset 		= Vector(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color
/*
i = i+1
u = mw_units[i]
u.name 			= "Tombstone"				
u.class 		= "ent_melon_barracks_doot"		
u.cost 			= 300						
u.welded_cost 	= -1								
u.population 	= 1								
u.spawn_time 	= 10	
u.description 	= BarracksText (11, 3)								
u.model 		= "models/props_c17/gravestone002a.mdl"
u.offset 		= Vector(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color
*/
i = i+1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Voidling Spawning Vat"			
u.class 		= "ent_melon_barracks_voidling"
u.cost 			= 500						
u.welded_cost 	= -1							
u.population 	= 1						
u.spawn_time 	= 20
u.description   = BarracksText (12, 5)	
u.model 		= "models/props_lab/teleplatform.mdl"
u.offset 		= Vector(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.code 			= "void"
u.name 			= "Mammoth Spawning Vat"			
u.class 		= "ent_melon_barracks_void_mamoth"
u.cost 			= 5000						
u.welded_cost 	= -1							
u.population 	= 1						
u.spawn_time 	= 30
u.description   = BarracksText (13, 3)	
u.model 		= "models/props_combine/masterinterface.mdl"
u.offset 		= Vector(0,0,-10)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Buck University"			
u.class 		= "ent_melon_barracks_buck"
u.cost 			= 4000						
u.welded_cost 	= -1							
u.population 	= 1						
u.spawn_time 	= 40
u.description   = BarracksText (14, 5)	
u.model 		= "models/hunter/misc/roundthing2.mdl"
u.offset 		= Vector(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.code 			= "full"
u.name 			= "Fighter University"			
u.class 		= "ent_melon_barracks_fighter"
u.cost 			= 8000						
u.welded_cost 	= -1							
u.population 	= 1						
u.spawn_time 	= 40
u.description   = BarracksText (15, 4)	
u.model 		= "models/phxtended/trieq2x2x2solid.mdl"
u.offset 		= Vector(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.code 			= "prot"
u.name 			= "Gatling Depot"			
u.class 		= "ent_melon_barracks_gatling"
u.cost 			= 4000						
u.welded_cost 	= -1							
u.population 	= 1						
u.spawn_time 	= 20
u.description   = BarracksText (16, 5)	
u.model 		= "models/props_wasteland/kitchen_stove001a.mdl"
u.offset 		= Vector(0,0,-10)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.code 			= "prot"
u.name 			= "Molotov Depot"			
u.class 		= "ent_melon_barracks_molotov"
u.cost 			= 4000						
u.welded_cost 	= -1							
u.population 	= 1						
u.spawn_time 	= 20
u.description   = BarracksText (17, 3)	
u.model 		= "models/props_industrial/oil_storage.mdl"
u.offset 		= Vector(0,0,-10)
u.canOverlap 	= false
u.button_color 	= button_barrack_color

i = i+1
u = mw_units[i]
u.name 			= "Contraption Assembler"
u.class 		= "ent_melon_contraption_assembler"
u.cost 			= 1000
u.welded_cost 	= -1
u.population 	= 1
u.spawn_time 	= 20
u.description 	= [[Produces contraptions. Cost and building time is deduced from the cost of the props and units that form the contraption. Press E on it to see a list of your saved contraptions.]]
u.model 		= "models/props_phx/construct/metal_plate4x4.mdl"
u.offset 		= Vector(0,0,-5)
u.angle 		= Angle(0,0,0)
u.angleSnap		= true
u.canOverlap 	= false
u.energy 		= true
u.button_color 	= button_barrack_color

i = i+1
firstEnergy = i ----------------------------------First energy
u = mw_units[i]
u.name 			= "Relay"
u.class 		= "ent_melon_energy_relay"
u.cost 			= 75
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[This post will transport energy between connections]]
u.model 		= "models/props_docks/dock01_pole01a_128.mdl"
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "Big Relay"
u.class 		= "ent_melon_energy_relay_large"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[This post will transport energy between way longer connections. Can only connect to other Big Relays or Relays. It can be built anywere on the map]]
u.model 		= "models/props_docks/dock01_pole01a_256.mdl"
u.offset 		= Vector(0,0,100)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= 1000
u.buildAnywere  = true

i = i+1
u = mw_units[i]
u.name 			= "Switch"
u.class 		= "ent_melon_energy_switch"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[Use the switch to connect and disconnect networks]]
u.model 		= "models/props_trainstation/trashcan_indoor001b.mdl"
u.offset 		= Vector(0,0,16)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "S Battery"
u.class 		= "ent_melon_energy_capacitor"
u.cost 			= 350
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[The battery will store up to 500 energy units. Be careful, as it explodes when destroyed! The explosion is more powerful the more charge the battery had at the time.]]
u.model 		= "models/props_phx/wheels/drugster_back.mdl"
u.offset 		= Vector(0,0,-5)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "M Battery"
u.class 		= "ent_melon_energy_capacitor_medium"
u.cost 			= 1000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[The battery will store up to 2000 energy units. Be careful, as it explodes when destroyed! The explosion is more powerful the more charge the battery had at the time.]]
u.model 		= "models/props_phx/wheels/monster_truck.mdl"
u.offset 		= Vector(0,0,-5)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "L Battery"
u.class 		= "ent_melon_energy_capacitor_large"
u.cost 			= 6000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[The battery will store up to 15000 energy units. Be careful, as it explodes when destroyed! The explosion is more powerful the more charge the battery had at the time.]]
u.model 		= "models/props_combine/combine_train02a.mdl"
u.offset 		= Vector(0,0,100)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "Solar Panel"
u.class 		= "ent_melon_energy_solar_panel"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 3
u.description 	= [[Solar panels produce 1 energy every 2 seconds]]
u.model 		= "models/props_combine/weaponstripper.mdl"
u.offset 		= Vector(-62.5,0,0)
u.angle 		= Angle(-90,180,0)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange
u.changeAngles  = false

i = i+1
u = mw_units[i]
u.name 			= "Steam Generator"
u.class 		= "ent_melon_energy_steam_plant"
u.cost 			= 2250
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[Steam generators can be turned on and off using E. When on, they transform 10 Water into 20 Energy per second]]
u.model 		= "models/mechanics/roboticslarge/claw_hub_8l.mdl"
u.offset 		= Vector(0,0,50)
u.angle 		= Angle(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "Nuclear Plant"
u.class 		= "ent_melon_energy_nuclear_plant"
u.cost 			= 8000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 10
u.description 	= [[Nuclear plants can be turned on and off using E. When on, they transform a 25 Water to 100 Energy per second. It blows up big when destroyed]]
u.model 		= "models/props_combine/combine_booth_med01a.mdl"
u.offset 		= Vector(0,0,20)
u.angle 		= Angle(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
u = mw_units[i]
u.name 			= "Water Pump"
u.class 		= "ent_melon_energy_water_pump"
u.cost 			= 2000
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 20
u.description 	= [[Water pumps consume energy to produce water. They use 5 energy to make 5 water every second.]]
u.model 		= "models/props_buildings/watertower_001c.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0,0,0)
u.canOverlap 	= false
u.button_color 	= button_energy_color
u.energyRange	= defaultenergyrange

i = i+1
firstContraption = i ---------------------------- First Contraption
u = mw_units[i]
u.name 			= "Thruster"
u.class 		= "ent_melon_engine"
u.cost 			= 200
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 1
u.description 	= [[Place this while looking in the direction you want 'forward' to be on your contraption. It will be the one to move and direct your vehicle.]]
u.model 		= "models/thrusters/jetpack.mdl"
u.offset 		= Vector(0,0.8,0)
u.angle 		= Angle(90,180,0)
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false

i = i+1
u = mw_units[i]
u.name 			= "Large Thruster"
u.class 		= "ent_melon_engine_large"
u.cost 			= 500
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 1
u.description 	= [[Place this while looking in the direction you want 'forward' to be on your contraption. It will be the one to move and direct your vehicle. It has less max speed than the Thruster, but it has more force. Useful for bigger contraptions.]]
u.model 		= "models/props_c17/trappropeller_engine.mdl"
u.offset 		= Vector(0,0.8,0)
u.angle 		= Angle(90,180,0)
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false

i = i+1
u = mw_units[i]
u.name 			= "Propeller"
u.class 		= "ent_melon_propeller"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 1
u.description 	= [[Propellers will keep your contraption a few meter off the ground]]
u.model 		= "models/maxofs2d/hover_propeller.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0,0,0)
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false

i = i+1
u = mw_units[i]
u.name 			= "Hover Pad"
u.class 		= "ent_melon_hover"
u.cost 			= 100
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 1
u.description 	= [[Hover pads will keep your contraption a few centimeters off the ground]]
u.model 		= "models/props_c17/pulleywheels_small01.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(90,0,0)
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false

i = i+1
u = mw_units[i]
u.name 			= "Wheel"
u.class 		= "ent_melon_wheel"
u.cost 			= 50
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 1
u.description 	= [[Better that sliding on the ground, i'd say. Wheels don't actually produce any force, but they will help your vehicle roll easier. They apply breaks when the vehicle should stop.]]
u.model 		= "models/XQM/airplanewheel1.mdl"
u.offset 		= Vector(0,0,0)
u.angle 		= Angle(0,0,0)
u.normalAngle   = true
u.angleSnap		= false
u.contraptionPart = true
u.spawnable_on_floor = false

i = i+1
u = mw_units[i]
u.name 			= "Unit Transport"
u.class 		= "ent_melon_unit_transport"
u.cost 			= 150
u.welded_cost 	= -1
u.population 	= 0
u.spawn_time 	= 2
u.description 	= [[I bet you can fit 10 units in this crate. Press E on it to free the units inside it.]]
u.model 		= "models/props_junk/wood_crate002a.mdl"
u.offset 		= Vector(0,0,10)
u.angle 		= Angle(0,0,0)
u.angleSnap		= false
u.canOverlap 	= false

mw_unit_ids = {}
for k, v in pairs(mw_units) do
	mw_unit_ids[v.class] = k
end

teamgrid = {
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false},
	{false,false,false,false,false,false,false,false}
}

local BasePropClass = {}
BasePropClass.name = "Prop"
BasePropClass.model = "models/hunter/blocks/cube05x1x05.mdl"
BasePropClass.offset = Vector(0,0,0)
BasePropClass.angle = Angle(0,0,0)
BasePropClass.cost = 1
BasePropClass.hp = 1
BasePropClass.spawn_time = 2

local function BaseProp() --Code is an optional argument.
	local newProp = table.Copy( BasePropClass )
	return newProp
end

local basePropCount = 23
mw_base_props = {}
local u = nil
for i=1, basePropCount do
	mw_base_props[i] = BaseProp()
end

i = 0

i = i+1
u = mw_base_props[i]
u.name = "Blast Door"
u.model = "models/props_lab/blastdoor001c.mdl"
u.offset = Vector(0,0,0)
u.angle = Angle(0,0,0)
u.cost = 200
u.hp = 150

i = i+1
u = mw_base_props[i]
u.name = "Barricade"
u.model = "models/props_wasteland/barricade002a.mdl"
u.offset = Vector(0,0,12)
u.angle = Angle(0,90,0)
u.cost = 15
u.hp = 40

i = i+1
u = mw_base_props[i]
u.name = "Fence"
u.model = "models/props_wasteland/wood_fence01a.mdl"
u.offset = Vector(0,0,40)
u.angle = Angle(0,90,0)
u.cost = 40
u.hp = 100

i = i+1
u = mw_base_props[i]
u.name = "Pallet"
u.model = "models/props_junk/wood_pallet001a.mdl"
u.offset = Vector(0,0,32)
u.angle = Angle(90,0,0)
u.cost = 25
u.hp = 50

i = i+1
u = mw_base_props[i]
u.name = "Brick"
u.model = "models/hunter/blocks/cube05x1x05.mdl"
u.offset = Vector(0,0,12)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 35

i = i+1
u = mw_base_props[i]
u.name = "Half Block"
u.model = "models/hunter/blocks/cube1x1x05.mdl"
u.offset = Vector(0,0,12)
u.angle = Angle(0,0,0)
u.cost = 35
u.hp = 50

i = i+1
u = mw_base_props[i]
u.name = "Block"
u.model = "models/hunter/blocks/cube1x1x1.mdl"
u.offset = Vector(0,0,24)
u.angle = Angle(0,0,0)
u.cost = 75
u.hp = 100

i = i+1
u = mw_base_props[i]
u.name = "Half Platform"
u.model = "models/hunter/blocks/cube2x2x05.mdl"
u.offset = Vector(47,0,10.5)
u.angle = Angle(0,0,0)
u.cost = 115
u.hp = 150

i = i+1
u = mw_base_props[i]
u.name = "Platform"
u.model = "models/hunter/blocks/cube2x2x1.mdl"
u.offset = Vector(47,0,24)
u.angle = Angle(0,0,0)
u.cost = 150
u.hp = 200

i = i+1
u = mw_base_props[i]
u.name = "Concrete Barrier"
u.model = "models/props_c17/concrete_barrier001a.mdl"
u.offset = Vector(0,0,0)
u.angle = Angle(0,0,0)
u.cost = 75
u.hp = 150

i = i+1
u = mw_base_props[i]
u.name = "Wall"
u.model = "models/hunter/blocks/cube2x2x05.mdl"
u.offset = Vector(0,0,48)
u.angle = Angle(90,0,0)
u.cost = 100
u.hp = 175

i = i+1
u = mw_base_props[i]
u.name = "Long Wall"
u.model = "models/hunter/blocks/cube1x4x05.mdl"
u.offset = Vector(0,0,24)
u.angle = Angle(90,0,0)
u.cost = 100
u.hp = 175

i = i+1
u = mw_base_props[i]
u.name = "Flat Platform"
u.model = "models/hunter/plates/plate2x2.mdl"
u.offset = Vector(47,0,-2.5)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 35

i = i+1
u = mw_base_props[i]
u.name = "Short Ramp"
u.model = "models/hunter/plates/plate1x2.mdl"
u.offset = Vector(23,0,4.5)
u.angle = Angle(-17,0,0)
u.cost = 25
u.hp = 25

i = i+1
u = mw_base_props[i]
u.name = "Slim Half Ramp"
u.model = "models/hunter/plates/plate1x2.mdl"
u.offset = Vector(33,0,7.3)
u.angle = Angle(0,90,-17)
u.cost = 25
u.hp = 25

i = i+1
u = mw_base_props[i]
u.name = "Half Ramp"
u.model = "models/hunter/plates/plate2x2.mdl"
u.offset = Vector(33,0,7.3)
u.angle = Angle(0,90,-17)
u.cost = 50
u.hp = 40

i = i+1
u = mw_base_props[i]
u.name = "Slim Full Ramp"
u.model = "models/hunter/triangles/2x1x1.mdl"
u.offset = Vector(48.3,0,23.1)
u.angle = Angle(0,90,0)
u.cost = 75
u.hp = 75

i = i+1
u = mw_base_props[i]
u.name = "Barrel"
u.model = "models/props_c17/oildrum001.mdl"
u.offset = Vector(0,0,0)
u.angle = Angle(0,0,0)
u.cost = 25
u.hp = 50

i = i+1
u = mw_base_props[i]
u.name = "3D Frame"
u.model = "models/props_phx/construct/metal_wire1x2x2b.mdl"
u.offset = Vector(-70,24,0)
u.angle = Angle(0,0,0)
u.cost = 20
u.hp = 20
/*
i = i+1
u = mw_base_props[i]
u.name = "Square Frame"
u.model = "models/props_phx/construct/metal_wire2x2b.mdl"
u.offset = Vector(-46,0,0)
u.angle = Angle(0,0,0)
u.cost = 10
u.hp = 10
*//*
i = i+1
u = mw_base_props[i]
u.name = "Rectangular Frame"
u.model = "models/props_phx/construct/metal_wire1x2b.mdl"
u.offset = Vector(-22,24,0)
u.angle = Angle(0,180,0)
u.cost = 8
u.hp = 8
*//*
i = i+1
u = mw_base_props[i]
u.name = "Railing"
u.model = "models/PHXtended/bar2x.mdl"
u.offset = Vector(2,48,5.5)
u.angle = Angle(90,180,0)
u.cost = 8
u.hp = 5
*/
i = i+1
u = mw_base_props[i]
u.name = "Half Pipe"
u.model = "models/props_phx/construct/metal_plate_curve180.mdl"
u.offset = Vector(-46,0,48)
u.angle = Angle(180,0,0)	
u.cost = 50
u.hp = 75

i = i+1
u = mw_base_props[i]
u.name = "Pole"
u.model = "models/props_docks/dock01_pole01a_128.mdl"
u.offset = Vector(0,0,64)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 15

i = i+1
u = mw_base_props[i]
u.name = "Disk"
u.model = "models/props_phx/construct/metal_angle360.mdl"
u.offset = Vector(-48,0,0)
u.angle = Angle(0,0,0)
u.cost = 15
u.hp = 15

i = i+1
u = mw_base_props[i]
u.name = "Half Disk"
u.model = "models/props_phx/construct/metal_angle180.mdl"
u.offset = Vector(-48,0,0)
u.angle = Angle(180,0,0)
u.cost = 8
u.hp = 8

local w = 700
local h = 500

function TOOL:MenuButton (pl, y, h, text, number)
	local button = vgui.Create("DButton", pl.mw_frame)
		button:SetSize(100,h)
		button:SetPos(10,y)
		button:SetText(text)
		button:SetFont("CloseCaption_Normal")
		function button:DoClick()
			pl.panel:Remove()
			pl.mw_menu = number
			_CreatePanel()
		end
end

function TOOL:Reload()
	if (cvars.Bool("mw_admin_cutscene")) then return end
	if (CLIENT) then		
		local pl = LocalPlayer()

		//{ CREATE FRAME
		if (pl.mw_frame == nil) then
			pl.mw_frame = vgui.Create("DFrame")
			pl.mw_frame:SetSize(w,h)
			pl.mw_frame:SetPos(ScrW()/2-w/2+150,ScrH()/2-h/3)
			pl.mw_frame:SetTitle("Melon Wars")
			pl.mw_frame:MakePopup()
			pl.mw_frame:ShowCloseButton()
			local button = vgui.Create("DButton", pl.mw_frame)
			button:SetSize(90,18)
			button:SetPos(w-93,3)
			button:SetText("Press R to close")
			function button:DoClick()
				pl.mw_frame:Remove()
				pl.mw_frame = nil
			end
			
			_CreatePanel()

			local h = 70
			self:MenuButton(pl, 30+h*0, h, "Units", 0)
			self:MenuButton(pl, 30+h*1, h, "Buildings", 1)
			self:MenuButton(pl, 30+h*2, h, "Base", 2)
			self:MenuButton(pl, 30+h*3, h, "Energy", 3)
			self:MenuButton(pl, 30+h*4, h, "Contrap.", 4)

			self:MenuButton(pl, 390, 25, "Help", 6)
			self:MenuButton(pl, 415, 25, "Team", 5)
			self:MenuButton(pl, 440, 25, "Admin", 7)
			self:MenuButton(pl, 470, 25, "Campai.", 8)

			//button:SetEnabled( pl:IsAdmin() )
		end
		//}
	end
end

function _MakeCheckbox (x, y, parent, textstr, command, labelstr, inverted)
	local checkbox = vgui.Create( "DButton", parent )// Create the checkbox
	checkbox:SetPos( x, y )// Set the position
	checkbox:SetSize(60,30)
	checkbox:SetText("")
	local checked = (GetConVarNumber( command ) == 1)
	if (inverted) then checked = !checked end
	checkbox.Paint = function(s, w, h)
		draw.RoundedBox( 8, 0, 0, w, h, Color(255,255,255) )
		draw.RoundedBox( 6, 2, 2, w-4, h-4, Color(0,0,0) )
		if (checked) then
			draw.RoundedBox( 4, 4, 4, w-8, h-8, Color(255,255,255) )
		end
	end
	function checkbox:DoClick()
		local commandstring = command.." "..tostring(1-GetConVarNumber( command ))
		LocalPlayer():ConCommand(commandstring) -- -1 es el Engine
		local checked = (GetConVarNumber( command ) != 1)
		if (inverted) then checked = !checked end
		checkbox.Paint = function(s, w, h)
			draw.RoundedBox( 8, 0, 0, w, h, Color(255,255,255) )
			draw.RoundedBox( 6, 2, 2, w-4, h-4, Color(0,0,0) )
			if (checked) then
				draw.RoundedBox( 4, 4, 4, w-8, h-8, Color(255,255,255) )
			end
		end
	end
	if (textstr != nil) then
		local label = vgui.Create("DLabel", parent)
		label:SetPos( x+70, y)
		label:SetSize(370,30)
		label:SetFontInternal( "Trebuchet24" )
		label:SetText(textstr)
	end
	if (labelstr != nil) then
		local label = vgui.Create("DLabel", parent)
		label:SetPos( x+250, y)
		label:SetSize(370,30)
		label:SetFontInternal( "Trebuchet18" )
		label:SetText(labelstr)
	end
	return checkbox
end

function _CreatePanel()
	if (CLIENT) then
		local pl = LocalPlayer()
		
		pl.panel = vgui.Create("DPanel", pl.mw_frame)
		pl.panel:SetSize(w-120, h-25)
		pl.panel:SetPos(120,25)
		pl.panel.Paint = function(s, w, h)
			draw.RoundedBox( 4, 0, 0, w, h, Color(30,30,30) )
		end
		if (pl.mw_menu == 0) then																	--units menu
			//{ units MENU
			local scroll = vgui.Create( "DScrollPanel", pl.panel ) //Create the Scroll panel
			scroll:SetSize( 175, h-30)
			scroll:SetPos( 0, 0 )
			local lines = vgui.Create("DPanel", scroll)
			lines:SetSize(w-120, h-30)
			lines:SetPos(0,0)
			lines.Paint = function(s, w, h)
				surface.SetDrawColor(Color(255,255,255))
				if (pl.mw_hover ~= 0) then
					local a = pl.mw_hover*45-25
					surface.DrawRect( 135, a, 20, 20)
				end
			end
			local ipos = 1
			for i=1, firstBuilding-1 do
				if (cvars.Bool("mw_admin_allow_manual_placing") or mw_units[i].welded_cost != -1) then
					if (mw_units[i].code == nil or LocalPlayer():GetInfo("mw_code") == mw_units[i].code) then
						_MakeButton(i, ipos, scroll)
						ipos = ipos+1
					end
				end
			end

			if (!cvars.Bool("mw_admin_allow_manual_placing")) then 
				LocalPlayer():ConCommand("mw_unit_option_welded 1")
				local label = vgui.Create("DLabel", pl.panel)
				label:SetPos(170, 15)
				label:SetSize(400,30)
				label:SetFontInternal( "Trebuchet24" )
				label:SetText("Mobile units only spawnable from barracks!")
				label:SetColor(Color(255,100,0,255))
				label = vgui.Create("DLabel", pl.panel)
				label:SetPos(170, 40)
				label:SetSize(400,30)
				label:SetFontInternal( "Trebuchet24" )
				label:SetText("These units will be spawned as turrets.")
				label:SetColor(Color(255,100,0,255))
			else
				--[[
				local checkbox = vgui.Create( "DCheckBox", pl.panel )// Create the checkbox
				checkbox:SetPos( 180, 15 )// Set the position
				checkbox:SetValue( cvars.Bool("mw_unit_option_welded"))
				checkbox:SetSize(60,30)
				checkbox:SetConVar( "mw_unit_option_welded" )
				checkbox.Paint = function(s, w, h)
					draw.RoundedBox( 8, 0, 0, w, h, Color(255,255,255) )
					draw.RoundedBox( 6, 2, 2, w-4, h-4, Color(0,0,0) )
					if (checkbox:GetChecked()) then
						draw.RoundedBox( 4, 4, 4, w-8, h-8, Color(255,255,255) )
					end
				end]]
				local checkbox = _MakeCheckbox( 180, 15, pl.panel, "Spawn as turret", "mw_unit_option_welded")
				function checkbox:OnCursorEntered()
					pl.mw_hover = 0
					pl.info_name:SetText("Spawn as turret")	
					pl.info_cost:SetText("")
					pl.info_turret_cost:SetText("")
					pl.info_power:SetText("")
					pl.info_time:SetText("")
					pl.info:SetText("If this is checked, you will be able to spawn units welded to where you point at, with a reduced cost. Not all units can be spawned as turret.")
				end
				--local label = vgui.Create("DLabel", pl.panel)
				--label:SetPos(250, 15)
				--label:SetSize(370,30)
				--label:SetFontInternal( "Trebuchet24" )
				--label:SetText("Spawn as turret")
			end

			DefaultInfo()
			//}
		elseif (pl.mw_menu == 1) then																--Buildings menu
			//{ BUILDINGS MENU
			local scroll = vgui.Create( "DScrollPanel", pl.panel ) //Create the Scroll panel
			scroll:SetSize( 175, h-25)
			scroll:SetPos( 0, 0 )
			local lines = vgui.Create("DPanel", scroll)
			lines:SetSize(w-120, 900)
			lines:SetPos(0,0)
			lines.Paint = function(s, w, h)
				local a = (pl.mw_hover-firstBuilding+1)*45-18
				surface.SetDrawColor(Color(255,255,255))
				surface.DrawRect( 135, a-5, 20, 20)
			end
			--[[local lines = vgui.Create("DPanel", scroll)
			lines:SetSize(w-120, h-30)
			lines:SetPos(0,0)
			lines.Paint = function(s, w, h)
				draw.RoundedBox( 4, 0, 0, w, h, Color(30,30,30) )
				surface.SetDrawColor(Color(255,255,255))
				if (pl.mw_hover ~= 0) then
					surface.DrawRect( 160, 120, w-250, 5 )
					local a = (pl.mw_hover-firstBuilding+1)*45-18
					if (a < 120) then
						surface.DrawRect( 160, a, 5, 120-(a))
					else
						surface.DrawRect( 160, 120, 5, a-115)
					end
					surface.DrawRect( 130, a, 30, 5)
				end
			end]]
			ipos = 1
			for i=firstBuilding, firstEnergy-1 do
				if (mw_units[i].code == nil or LocalPlayer():GetInfo("mw_code") == mw_units[i].code) then
					_MakeButton(i, ipos, scroll)
					ipos = ipos+1
				end
			end
			
			DefaultInfo()
			//}
		elseif (pl.mw_menu == 2) then																--Base menu	
			//{ BASE MENU

			local prop_info = vgui.Create("DLabel", pl.panel)
			prop_info:SetPos(360, 250)
			prop_info:SetSize(370,100)
			prop_info:SetFontInternal( "Trebuchet24" )
			prop_info:SetText("Select a prop")
			
			local prop_window = vgui.Create("DModelPanel", pl.panel)
			prop_window:SetPos(350, 10)
			prop_window:SetSize(200,200)
			prop_window:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		
			local scroll = vgui.Create( "DScrollPanel", pl.panel ) //Create the Scroll panel
			scroll:SetSize( 340, h-80 )
			scroll:SetPos( 10, 30 )

			local List	= vgui.Create( "DIconLayout", scroll )
			List:SetSize( 330, 200 )
			List:SetPos( 0, 80 )
			List:SetSpaceY( 5 ) //Sets the space in between the panels on the X Axis by 5
			List:SetSpaceX( 5 ) //Sets the space in between the panels on the Y Axis by 5
			
			//local a = table.getn(base_models)
			//for i = 1, a do //Make a loop to create a bunch of panels inside of the DIconLayout
			for k, v in pairs(mw_base_props) do
				local ListItem = List:Add( "SpawnIcon" ) //Add DPanel to the DIconLayout
				ListItem:SetSize( 75, 75 ) //Set the size of it
				ListItem:SetModel(v.model)
				function ListItem:DoClick()
					pl:ConCommand("mw_chosen_prop "..tostring(k))
					pl:ConCommand("mw_action 3")
					pl.mw_frame:Remove()
					pl.mw_frame = nil
				end
				function ListItem:OnCursorEntered()
					prop_info:SetText(v.name.."\nHealth: "..v.hp.."\nCost: "..v.cost)
					prop_window:SetModel(v.model)
					prop_window:SetCamPos(prop_window:GetEntity():GetPos()+Vector(150,0,50))
					function prop_window:LayoutEntity(Entity)
						Entity:SetAngles(v.angle+Angle(0,CurTime()*50,0))
					end
					--prop_window:SetLookAt(prop_window:GetEntity():OBBCenter())	
				end
				//You don't need to set the position, that is done automatically.
			end

			_MakeCheckbox( 380, h-100, pl.panel, "Offset", "mw_prop_offset")
			_MakeCheckbox( 380, h-150, pl.panel, "Angle Snap", "mw_prop_snap")
			//}
			local button = vgui.Create("DButton", pl.panel)
			button:SetSize(220,50)
			button:SetPos(20,20)
			button:SetFont("CloseCaption_Normal")
			button:SetText("Sell Tool")
			function button:DoClick()
				pl:ConCommand("mw_chosen_unit -1") -- -1 es el Engine
				pl:ConCommand("mw_action 5")
				pl.mw_frame:Remove()
				pl.mw_frame = nil
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
				draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
			end
		elseif (pl.mw_menu == 3) then																--Energy menu
			//{ BUILDINGS MENU
			local scroll = vgui.Create( "DScrollPanel", pl.panel ) //Create the Scroll panel
			scroll:SetSize( 175, h-25)
			scroll:SetPos( 0, 0 )
			local lines = vgui.Create("DPanel", scroll)
			lines:SetSize(w-120, 450)
			lines:SetPos(0,0)
			lines.Paint = function(s, w, h)
				local a = (pl.mw_hover-firstEnergy+1)*45-18
				surface.SetDrawColor(Color(255,255,255))
				surface.DrawRect( 135, a-5, 20, 20)
			end
			--[[local lines = vgui.Create("DPanel", scroll)
			lines:SetSize(w-120, h-30)
			lines:SetPos(0,0)
			lines.Paint = function(s, w, h)
				draw.RoundedBox( 4, 0, 0, w, h, Color(30,30,30) )
				surface.SetDrawColor(Color(255,255,255))
				if (pl.mw_hover ~= 0) then
					surface.DrawRect( 160, 120, w-250, 5 )
					local a = (pl.mw_hover-firstBuilding+1)*45-18
					if (a < 120) then
						surface.DrawRect( 160, a, 5, 120-(a))
					else
						surface.DrawRect( 160, 120, 5, a-115)
					end
					surface.DrawRect( 130, a, 30, 5)
				end
			end]]
			for i=firstEnergy, firstContraption-1 do
				_MakeButton(i, i-firstEnergy+1, scroll)
			end
			
			DefaultInfo()
		elseif (pl.mw_menu == 4) then																--Contraption menu	
			//{ SPECIAL MENU

			local tool_info = vgui.Create("DLabel", pl.panel)
			tool_info:SetPos(270, 30)
			tool_info:SetSize(300,340)
			tool_info:SetFontInternal( "Trebuchet24" )
			tool_info:SetText("Select a tool")
			
			local button = vgui.Create("DButton", pl.panel)
			button:SetSize(220,50)
			button:SetPos(20,20)
			button:SetFont("CloseCaption_Normal")
			button:SetText("Contraption Manager")
			function button:DoClick()
				pl.panel:Remove()
				pl.mw_menu = -1
				_CreatePanel()
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
				draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
			end

			local scroll = vgui.Create( "DScrollPanel", pl.panel ) //Create the Scroll panel
			scroll:SetSize( 175, h-105)
			scroll:SetPos( 0, 80 )
			local lines = vgui.Create("DPanel", scroll)
			lines:SetSize(w-120, 550)
			lines:SetPos(0,0)
			lines.Paint = function(s, w, h)
				local a = (pl.mw_hover-firstContraption+1)*45-18
				surface.SetDrawColor(Color(255,255,255))
				surface.DrawRect( 135, a-5, 20, 20)
			end

			for i=firstContraption, unitCount do
				_MakeButton(i, i-firstContraption+1, scroll)
			end
			
			DefaultInfo()
			//}
		elseif (pl.mw_menu == -1) then																--Contraption manager menu
			local scroll = vgui.Create( "DScrollPanel", pl.panel ) //Create the Scroll panel
			scroll:SetSize( 100, 50)
			scroll:SetPos( 20, 20 )


			local tool_info = vgui.Create("DLabel", pl.panel)
			tool_info:SetPos(20, 30)
			tool_info:SetSize(200,50)
			tool_info:SetFontInternal( "Trebuchet24" )
			tool_info:SetText("Save contraption: ")

			local tool_info = vgui.Create("DLabel", pl.panel)
			tool_info:SetPos(100, 85)
			tool_info:SetSize(500,30)
			tool_info:SetFontInternal( "Trebuchet18" )
			tool_info:SetText("Type the name, press enter and then click on your contraption")

			local TextEntry = vgui.Create( "DTextEntry", pl.panel ) -- create the form as a child of frame
			TextEntry:SetPos( 200, 30 )
			TextEntry:SetSize( 300, 50 )
			TextEntry:SetText( "name" )
			//TextEntry:SetFont( "Trebuchet24" )
			TextEntry:SetTextColor(Color(0,0,0))
			TextEntry.OnEnter = function( self )
				pl.contraption_name = self:GetValue()
				pl:ConCommand("mw_action 4")
				pl.mw_frame:Remove()
				pl.mw_frame = nil
			end

			local browser = vgui.Create( "DFileBrowser", pl.panel )
			browser:SetPos( 20, 250 )
			browser:SetSize(500, 200)

			browser:SetPath( "DATA" ) -- The access path i.e. GAME, LUA, DATA etc.
			browser:SetBaseFolder( "melonwars/contraptions" ) -- The root folder
			browser:SetName( "Contraptions" ) -- Name to display in tree
			browser:SetSearch( "contraptions" ) -- Search folders starting with "props_"
			browser:SetFileTypes( "*.txt" ) -- File type filter
			browser:SetOpen( true ) -- Opens the tree ( same as double clicking )
			browser:SetCurrentFolder( "melonwars/contraptions" ) -- Set the folder to use

			function browser:OnSelect( path, pnl ) -- Called when a file is clicked
				pl.selectedFile = path
			end

			local button = vgui.Create("DButton", pl.panel)
			button:SetSize(220,50)
			button:SetPos(20,150)
			button:SetFont("CloseCaption_Normal")
			button:SetText("Delete selected")
			function button:DoClick()
				button:SetText("Are you sure?")
				function button:DoClick()
					if (pl.selectedFile != nil) then
						file.Delete( pl.selectedFile )
						
						timer.Simple(0.1,function ()
							pl.panel:Remove()
							_CreatePanel()
						end)
						
					end
				end
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
				draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
			end

			
			local button = vgui.Create("DButton", pl.panel)
			button:SetSize(220,50)
			button:SetPos(300,150)
			button:SetFont("CloseCaption_Normal")
			button:SetText("Load selected")
			if (cvars.Number("mw_admin_credit_cost") == 0) then
				function button:DoClick()
					if (pl.selectedFile != nil) then
						pl:ConCommand("mw_action 6")
						pl.mw_frame:Remove()
						pl.mw_frame = nil
					end
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
					draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
				end
			else
				button:SetText("Sandbox Only")
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(50,50,50) )
					draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(70,70,70) )
				end
			end
		elseif (pl.mw_menu == 5) then																--Team menu
			//{ TEAM MENU
			local label = vgui.Create("DLabel", pl.panel)
			label:SetPos(20, 200)
			label:SetSize(200,40)
			label:SetFontInternal( "DermaLarge" )
			label:SetText("Select team:")
			
			local selection = vgui.Create("DPanel", pl.panel)
			if (cvars.Number("mw_team") != 0) then
				selection:SetPos(135+cvars.Number("mw_team")*45, 195)
			else
				selection:SetPos(135+45, 260)
			end
			selection:SetSize(50,50)
			selection.Paint = function(s, w, h)
				draw.RoundedBox( 10, 0, 0, w, h, Color(255,255,255,255) )
			end
				
			for i=1, 8 do
				local button = vgui.Create("DButton", pl.panel)
				button:SetSize(40,40)
				button:SetPos(140+i*45,200)
				button:SetText("")
				function button:DoClick()
					LocalPlayer():ConCommand("mw_team "..tostring(i))
					selection:SetPos(135+i*45, 195)
					
					net.Start("MW_UpdateClientInfo")
						net.WriteInt(i, 8)
					net.SendToServer()
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
					draw.RoundedBox( 4, 2, 2, w-4, h-4, mw_team_colors[i] )
				end
			end

			------------------- Factions
			local label = vgui.Create("DLabel", pl.panel)
			label:SetPos(20, 325)
			label:SetSize(200,40)
			label:SetFontInternal( "DermaLarge" )
			label:SetText("Faction:")

			local factionSelection = vgui.Create("DPanel", pl.panel)
			factionSelection:SetSize(50,50)
			factionSelection.Paint = function(s, w, h)
				draw.RoundedBox( 10, 0, 0, w, h, Color(255,255,255,255) )
			end

			local code = cvars.String("mw_code")

			factionSelection:SetPos(180, 320)
			local button = vgui.Create("DButton", pl.panel)
			button:SetSize(40,40)
			button:SetPos(185,325)
			button:SetText("-")
			function button:DoClick()
				LocalPlayer():ConCommand("mw_code none")
				factionSelection:SetPos(180, 320)
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(90,90,90) )
				draw.RoundedBox( 3, 10, 10, w-20, h-20, Color(250,250,250) )
			end

			if (code == "full") then
				factionSelection:SetPos(180+45, 320)
			end
			local button = vgui.Create("DButton", pl.panel)
			button:SetSize(40,40)
			button:SetPos(185+45,325)
			button:SetText("F")
			function button:DoClick()
				LocalPlayer():ConCommand("mw_code full")
				factionSelection:SetPos(180+45, 320)
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(255,240,60) )
				draw.RoundedBox( 3, 10, 10, w-20, h-20, Color(250,250,250) )
			end

			if (code == "void") then
				factionSelection:SetPos(180+90, 320)
			end
			local button = vgui.Create("DButton", pl.panel)
			button:SetSize(40,40)
			button:SetPos(185+90,325)
			button:SetText("V")
			function button:DoClick()
				LocalPlayer():ConCommand("mw_code void")
				factionSelection:SetPos(180+90, 320)
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(210,30,240) )
				draw.RoundedBox( 3, 10, 10, w-20, h-20, Color(250,250,250) )
			end

			if (code == "prot") then
				factionSelection:SetPos(180+135, 320)
			end
			local button = vgui.Create("DButton", pl.panel)
			button:SetSize(40,40)
			button:SetPos(185+135,325)
			button:SetText("P")
			function button:DoClick()
				LocalPlayer():ConCommand("mw_code prot")
				factionSelection:SetPos(180+135, 320)
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(20,170,230) )
				draw.RoundedBox( 3, 10, 10, w-20, h-20, Color(250,250,250) )
			end
			------------------------------------------

			if (pl:IsAdmin()) then
				local label = vgui.Create("DLabel", pl.panel)
				label:SetPos(20, 265)
				label:SetSize(200,40)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("Gray team:")
				
				local button = vgui.Create("DButton", pl.panel)
				button:SetSize(40,40)
				button:SetPos(140+45,265)
				button:SetText("")
				function button:DoClick()
					LocalPlayer():ConCommand("mw_team "..tostring(0))
					selection:SetPos(135+45, 260)
					
					net.Start("MW_UpdateClientInfo")
						net.WriteInt(0, 8)
					net.SendToServer()
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
					draw.RoundedBox( 4, 2, 2, w-4, h-4, Color(80,80,80,255) )
				end
			end
			//}
		elseif (pl.mw_menu == 6) then																--Help menu
			//{ HELP MENU
			local h = 40
		
			--local scroll = vgui.Create( "DScrollPanel", pl.panel )
			--scroll:SetSize( 440, 450 )
			--scroll:SetPos( 120, 10 )
			
			local info = vgui.Create( "RichText", pl.panel )
			info:SetPos( 120, 20 )
			info:SetSize( 450,450 )
			info:SetWrap( true )
			info:SetContentAlignment( 7 )
			timer.Simple( 0.001, function() info:SetFontInternal("Trebuchet24") end )
			info:SetText(
[[
Thanks for downloading and using the MelonWars:RTS addon. I hope you enjoy it.

Choose a category on the left to see info about a certain topic!
]])

			_MakeHelpButton("About", 0, info,
[[
What is this mod?

This is a remake of a 2006 addon called WarMelons:RTS by Lap and MegaJohnny. Its a strategy game that is played in sandbox, so that you can build contraptions and your own maps, with the familiar controls of standard Garry's Mod. 

The original addon was discontinued and broke when Gmod 13 came out, and i never heard of the developer again. I missed the addon so much that i looked for it everywhere. After more than a year without success, i decided to learn lua and make my own version. 

This addon isn't quite the same as the original, but i hope it will fill the void that WarMelons left. 



Credits:

The creator of this addon:
Marum

The creators of the original:
Lap and MegaJohnny
]],--[[i had to do this closing and opening of strings because some strange limit that trimed the text]][[
Testers and supporters:
X marks it
(Xen)SunnY
BOOM! The_Rusty_Geek
Dagren
Fush
Broh
Jwanito
Mr. Thompson
Arheisel
Hipnox

Suggestions:
Squid-Inked (Tesla Tower)
Durendal5150 (Radar)

Thanks to:
Members of the MelonWars:RTS discord, and you, for subscribing!


Shoutout to Ludsoe, who is also making a WarMelons remake
]])
			info:SetFontInternal("Trebuchet24")

			_MakeHelpButton("Help", 1, info, 
[[
Introduction:

This addon is a tool that allows you and your friends to play a Real Time Strategy game, much like StarCraft, or Age of Empires, but much simpler.


Getting Started:

If you are seeing this, you probably know how to equip this tool, but just in case you loose it, i'll explain how to equip it.

Hold Q (or your spawn menu key), and go to the Tools tab, on the upper right.

Under the category 'MelonWars: RTS', there's the Player Tool. This is pretty much all you need to play.

Select the Player Tool. With this tool equiped, you can now press your Reload key (R by default) to open up the Melon Wars menu. You are going to be using this menu a lot.
Feel free to navigate this menu on your own. For more help on how the menu works and what to do, please choose the 'Menu' category, to the left.
]])

			_MakeHelpButton("Menu", 2, info,
[[
The Melon Wars Menu:

This menu can be opened and closed with the Reload key while you have the Player Tool equiped, and it has everything you need to play MelonWars.

You have diferent submenues on the left:
units, Buildings, Base, Energy, Contrap., Team, Help and Admin.

From the units category you can spawn different kinds of melons to fight for your team. Inside, you can see info about each unit. Click on a unit to start spawning. The crosshair will change while you are spawning units.
]],--[[i had to do this closing and opening of strings because some strange limit that trimed the text]][[

The buildings menu works similarly to the units menu, but has different kinds of utility houses and machines to help you improve your army.

From the Base category you can select props to spawn as defense and walls. You can see the props health and cost on the right, and toggle Angle snap and Offset. The Angle snap option allows you to snap props to 15 degree intervals. The Offset, if disabled, spawns the prop at its origin, rather than a custom point.

The Energy menu contains builgins that generate, store or transport Energy.

The Contrap. menu is where you spawn contraption parts from, aswell as manage your saved contraptions. To know what is a contraption go to the Contrap. help tab.

In the Team menu you can choose which team you wan't to be on.

The Help menu is this menu right here!

And finally, the Admin menu is where the server owner can set all of the options for the gamemode.
]])		
	
			_MakeHelpButton("Spawning", 3, info,
[[
How do i spawn units?

Once you selected a unit from the units menu, or a building from the Buildings menu, your toolgun will be set to Spawn the selected unit. While selecting, your crosshair changes, and the selected unit is displayed below it.

While the toolgun is set to spawn, click on the ground to spawn the selected unit. units have a Water cost and a Power cost. Water is the game's main resource, and it will be depleted when spawning units, unless the admin option "Free Water" is set to true (which it is by default). Power usage increases the more units you have, and you can't spawn units if your power has reached its max.

From the units menu, you can also select an option to spawn units as Turrets, which reduces their cost, but they spawn welded to what you are looking at. Some units can't be spawned as turrets, such as Nukes and Jetpacks.
]])		

			_MakeHelpButton("Units", 4, info,
[[
What does each unit do?

Marines:
The Marines are the generic soldier. They have accurate rifles, but not very long range. Marines are usually used as cannon fodder to push against slow firing units, but don't underestimate the strength of Marines in big numbers.

Medic:
The Medic doesn't like to fight, but he likes seeing others fight. It cannot deal damage in any way. Its only goal is to keep all of its nearby friends healthy and ready for the next battle. Having multiple medics in a squad can drastically increase the squad's durability, and they can keep important units alive. They hurt themselves while healing, and can't heal each other.
]],[[

Bomb:
The Bomb is willing to die for its team. He will explode if he gets killed or if there are enemy units in range. A well placed bomb can take down an entire squad in no time, but they are fragile, so protect them until they get to the target. A Bomb spawned as turret will become a Mine, and bury into the ground. Be careful about having bombs in your midst, as an enemy sniper can make it explode and take a chunk of your army with it.

Jetpack:
The Jetpack is a promoted marine that takes to the skies with a rocket pack. He flies a few meters of the ground at all times, and he specializes in going over walls, transiting harsh terrain, flanking from outside the map, and flying over squads to take down valuable defended targets.

Gunner:
The Gunner is a tough and slow unit that carries a minigun. Their gun will spin faster as the battle goes on, so it will deal a lot more damage if it manages to survive 18 seconds of continuous firing.
]],[[

Missiles:
The Missiles is the brother of the Gunner, but he was given a bazooka instead of a machinegun. It fires homing missiles that deal low area damage. Its useful to take down crowds of weak enemies, taking down a squads medics, and shooting down flocks of Jetpacks.

Sniper:
The Sniper is one of the most damaging units in the game. It shoots very slowly, but it makes every shot count. They are useful for taking down valuable targets, like a bomb in the middle of the enemy army, or quickly take down a mortar. Its taller than most units to be able to shoot over its allies heads, but its gun is so unweildy he cannot shoot while running, making him easily killable on its own. Be sure to escort and protect him, as his shots can be heared from anywhere on the map, and he is sure to become a target.

Mortar:
The Mortar is a powerful armoured unit that can quickly take down enemy squads. It shoots mortal shells in an arc, which might not be ideal if the enemy is swift to move out of the way, but if that bomb hits a crowd, it will hurt a lot. The mortar is the only unit that can fire over walls, making it a good siege unit.

Nuke:
The Nuke is the ultimate breaching weapon. Its slow, but it carries a powerful blast. When it spawns, it informs every player of the imminent danger. It takes it 1.5 seconds to explode after it gets to the enemy wall, but it doesn't explode as big if it gets killed before it detonates, so take good care of it until it does. It will only automatically target enemy walls too, to avoid enemy kamikazes from triggering it.
]])		

			_MakeHelpButton("Buildings", 5, info,
[[
What does each building do?

Barracks:
The Barracks are a building that produces Marines at one third of the rate they can be spawned with the toolgun, but they spawn ready for battle and half the price. It will produce up to 10 Marines at any given time. The Barracks can be turned on or off by holding the Player Tool, looking at it and pressing the E key.
Each unit has its own barracks!

Turret:
The turret is your go to static defense. It has a good damage output, and the longest range in the game. It can't move, even if its spawned onto a contraption.
]],[[

Shredder:
The shredder is used to recycle melons, and get 90% of their value back. Its good to get rid of your army if you want to replace your low tier units with higher tier ones.

Elevator Pad:
The elevator pad is used as an elevator. Every unit on top of it will be levitated upwards, up to a certain height. As you cant spawn mobile units onto base props, if you want to, say, make a bomb ambush tower to drop bombs onto your attackers, those bombs can't be spawned directly on the tower. Just use a Pad to get them up there.
]],[[

Gate:
The gate is useful for making entrances and exits for your base. You can open and close it by looking at it and pressing E with the Player Tool equiped.

Large Gate:
The large gate requires energy to open and close, but can be operated the same way as the small gate. Its wider and taller, allowing for bigger armies or contraptions to go through.
]],[[

Contraption Assembler:
This workshop can build any contraption that you've previously saved with the contraption manager. Use it to produce Tanks, Ships or any vehicle you can imagine and build!

Tesla Tower:
This building requires energy to function, but is a powerful AOE static defense, that will zap the 5 closest enemies in a big range. It can get overwelmed by big squads, and it will consume a LOT of energy while firing.

Over-Clocker:
Spawn this bad boy right next to a barracks of any kind, and watch it increase its production rate! (and consume all of your energy). You cant turn it on and off with E.
]],[[

Radar:
The radar constantly consumes energy, equivalent to one Solar Panel, and cannot be turned off. If the radar detects an enemy unit, an exclamation mark will popup on the player's hud, showing the place of the detection.

Medical Bay:
Uses a lot of energy, but has the healing capabilities of 10 medics in a way bigger radius. Its meant to keep all the units in your base at full health. Be careful tho, as having to heal a lot of units at once can really drain your energy supply.
]])
			_MakeHelpButton("Energy", 6, info,
[[
What is Energy for?

Energy is used to power certain buildings that need it to operate. Buildings that interact with Energy appear with Yellow buttons on the spawn menu.
Buildings use a lot more power than what a player usually generates, so its a good idea to store it in Batteries, so you have enough when you need it.
]],[[

How do i connect buildings?

To connect energy buildings, use the Relay, located in the Energy submenu. For buildings to work, you will need to connect some sort of battery to the network.
]],[[
]])
			_MakeHelpButton("Contrap.", 7, info,
[[
What is a contraption?

A contraption is a machine built by the player that can be used in melon combat as a vehicle. It can be used for ramming, as a tank, as transport, or anything you can imagine.

How do i build them?

Build a contraption just like you would in sandbox. Beware that parts like thrusters, hoverballs and wheels will get removed when you 'Legalize' the contraption.

What is legalizing?

In order to make your contraption legal inside the melonwars battle, you have to Save it using the Contraption Manager, under the Contrap. menu, and spawn it using a Contraption Assembler.
]],[[

How do i make my contraption move?

Under the "Contrap." submenu, you have Thrusters, Wheels, Propellers and Hover Pads. The Thruster is a powerful melon that cannot shoot, but is very strong and can move even if attached to a contraption. The Wheel can be used to help your contraption roll across the ground. The Propeller and hover-Pad can be used to make your contraption hover above ground.]])

			_MakeHelpButton("Setup", 8, info,
[[
How do i set up a game?

In order to set up a game, you should build an arena out of props or go to a melonwars map. The admin should ask the players what colors they want to be, and spawn a Base (or Grand War Base) from the admin menu for each player at diferent locations.

Be sure to ask every player to set their team in the Teams tab in this menu.

Spawn a few outposts and capture points around the arena as objectives, and once everything is set up, press the Start Match button.
]],[[

The admin can also set alliances from the Admin tab.

Once the match starts, its a battle to destroy the enemies bases. Last team standing wins!

Remember, this is as much a gamemode as it is a toy, so there is no actual "End" to the match, other than whatever you make it. You can play until the last base is destroyed, until only one player has units or any other condition you can imagine. Just be sure to be clear about it with all players before starting.
]])

		--[[
		local button = vgui.Create("DButton", LocalPlayer().panel)
		button:SetSize(100,40)
		button:SetPos(10,420)
		button:SetText("News")
		button:SetFontInternal("CloseCaption_Normal")
		function button:DoClick()
			MW_OpenPatchNotes()
		end]]
			//}
		elseif (pl.mw_menu == 7) then																--Admin menu
			//{ ADMIN MENU
			if (pl:IsAdmin() or cvars.Number("mw_admin_open_permits") == 1) then
				local y = 20
				local scroll = vgui.Create("DScrollPanel", pl.panel)
				local px, py = pl.panel:GetSize()
				scroll:SetPos(0,0)
				scroll:SetSize(px, py)

				local button = vgui.Create("DButton", scroll)
				button:SetSize(200,40)
				button:SetPos(20,y)
				button:SetFont("CloseCaption_Normal")
				button:SetText("Start Match")
				function button:DoClick()
					/*LocalPlayer():ConCommand("mw_admin_playing 1")
					LocalPlayer():ConCommand("mw_admin_move_any_team 0")
					LocalPlayer():ConCommand("mw_admin_credit_cost 1")
					LocalPlayer():ConCommand("mw_admin_allow_free_placing 0")
					LocalPlayer():ConCommand("mw_admin_spawn_time 1")
					LocalPlayer():ConCommand("mw_admin_immortality 0")
					LocalPlayer():ConCommand("mw_reset_credits")*/
					net.Start("StartGame")
					net.SendToServer()
					pl.mw_frame:Remove()
					pl.mw_frame = nil
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
					draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
				end
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(270, y)
				label:SetSize(370,40)
				label:SetFontInternal( "Trebuchet18" )
				label:SetText("[Set preferences for a match of MelonWars]")
				y = y+50
				local button = vgui.Create("DButton", scroll)
				button:SetSize(200,40)
				button:SetPos(20,y)
				button:SetFont("CloseCaption_Normal")
				button:SetText("Sandbox mode")
				function button:DoClick()
					LocalPlayer():ConCommand("mw_admin_playing 1")
					LocalPlayer():ConCommand("mw_admin_move_any_team 1")
					LocalPlayer():ConCommand("mw_admin_credit_cost 0")
					LocalPlayer():ConCommand("mw_admin_allow_free_placing 1")
					LocalPlayer():ConCommand("mw_admin_spawn_time 0")
					LocalPlayer():ConCommand("mw_admin_allow_manual_placing 1")
					net.Start("SandboxMode")
					net.SendToServer()
					pl.mw_frame:Remove()
					pl.mw_frame = nil
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
					draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
				end
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(270, y)
				label:SetSize(370,40)
				label:SetFontInternal( "Trebuchet18" )
				label:SetText("[Set preferences for messing around]")
				y = y+80


				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y)
				label:SetSize(300,40)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("Game control Options")

				y = y+40
				_MakeCheckbox( 20, y, scroll, "PAUSE", "mw_admin_playing", "[Stops units, income and controls]", true)

				y = y+40
				_MakeCheckbox( 20, y, scroll, "Player Colors", "mw_admin_player_colors", "[Show a colored circle over players]")
				
				y = y+80
				
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(15, y)
				label:SetSize(200,60)
				label:SetFontInternal( "DermaLarge" )
				label:SetText([[Spawn normal
					base]])
				for i=1, 8 do
					local button = vgui.Create("DButton", scroll)
					button:SetSize(40,40)
					button:SetPos(145+i*45,y)
					button:SetText("")
					function button:DoClick()
						LocalPlayer():ConCommand("mw_team "..tostring(i))
						LocalPlayer():ConCommand("mw_action 2")
						pl.mw_frame:Remove()
						pl.mw_frame = nil
						
						net.Start("MW_UpdateClientInfo")
							net.WriteInt(i, 8)
						net.SendToServer()
					end
					button.Paint = function(s, w, h)
						draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
						draw.RoundedBox( 4, 2, 2, w-4, h-4, mw_team_colors[i] )
					end
				end

				y = y+80

				local label = vgui.Create("DLabel", scroll)
				label:SetPos(15, y)
				label:SetSize(200,60)
				label:SetFontInternal( "DermaLarge" )
				label:SetText([[Spawn grand
					war base]])
				for i=1, 8 do
					local button = vgui.Create("DButton", scroll)
					button:SetSize(40,40)
					button:SetPos(145+i*45,y)
					button:SetText("")
					function button:DoClick()
						LocalPlayer():ConCommand("mw_team "..tostring(i))
						LocalPlayer():ConCommand("mw_action 7")
						pl.mw_frame:Remove()
						pl.mw_frame = nil
						
						net.Start("MW_UpdateClientInfo")
							net.WriteInt(i, 8)
						net.SendToServer()
					end
					button.Paint = function(s, w, h)
						draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
						draw.RoundedBox( 4, 2, 2, w-4, h-4, mw_team_colors[i] )
					end
				end

				y = y+80

				local label = vgui.Create("DLabel", scroll)
				label:SetPos(15, y)
				label:SetSize(200,60)
				label:SetFontInternal( "DermaLarge" )
				label:SetText([[Spawn
					Ornament]])
				for i=1, 8 do
					local button = vgui.Create("DButton", scroll)
					button:SetSize(40,40)
					button:SetPos(145+i*45,y)
					button:SetText("")
					function button:DoClick()
						LocalPlayer():ConCommand("mw_team "..tostring(i))
						LocalPlayer():ConCommand("mw_action 25")
						pl.mw_frame:Remove()
						pl.mw_frame = nil
						
						net.Start("MW_UpdateClientInfo")
							net.WriteInt(i, 8)
						net.SendToServer()
					end
					button.Paint = function(s, w, h)
						draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
						draw.RoundedBox( 4, 2, 2, w-4, h-4, mw_team_colors[i] )
					end
				end

				y = y+80

				local label = vgui.Create("DLabel", scroll)
				label:SetPos(15, y)
				label:SetSize(300,60)
				label:SetFontInternal( "Trebuchet24" )
				label:SetText([[Spawn Cap Point]])
				local button = vgui.Create("DButton", scroll)
				button:SetSize(40,40)
				button:SetPos(190,y)
				button:SetText("")
				function button:DoClick()
					LocalPlayer():ConCommand("mw_action 8")
					pl.mw_frame:Remove()
					pl.mw_frame = nil
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
					draw.RoundedBox( 4, 2, 2, w-4, h-4, Color(255, 255, 255, 255) )
				end

				y = y+60

				local label = vgui.Create("DLabel", scroll)
				label:SetPos(15, y)
				label:SetSize(300,60)
				label:SetFontInternal( "Trebuchet24" )
				label:SetText([[Spawn Outpost]])
				local button = vgui.Create("DButton", scroll)
				button:SetSize(40,40)
				button:SetPos(190,y)
				button:SetText("")
				function button:DoClick()
					LocalPlayer():ConCommand("mw_action 9")
					pl.mw_frame:Remove()
					pl.mw_frame = nil
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
					draw.RoundedBox( 4, 2, 2, w-4, h-4, Color(255, 255, 255, 255) )
				end

				y = y+60

				local label = vgui.Create("DLabel", scroll)
				label:SetPos(15, y)
				label:SetSize(300,60)
				label:SetFontInternal( "Trebuchet24" )
				label:SetText([[Spawn Water tank]])
				local button = vgui.Create("DButton", scroll)
				button:SetSize(40,40)
				button:SetPos(190,y)
				button:SetText("")
				function button:DoClick()
					LocalPlayer():ConCommand("mw_action 10")
					pl.mw_frame:Remove()
					pl.mw_frame = nil
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(100,100,100,255) )
					draw.RoundedBox( 4, 2, 2, w-4, h-4, Color(255, 255, 255, 255) )
				end

				y = y+80

				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y)
				label:SetSize(400,40)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("Alternative Gameplay Options")

				y = y+40
				
				_MakeCheckbox( 20, y, scroll, "No manual placing", "mw_admin_allow_manual_placing", "[Prevents spawning of mobile units]", true)

				y = y+60

				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y)
				label:SetSize(300,40)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("Cheats")

				y = y+40
				_MakeCheckbox( 20, y, scroll, "Instant Spawn", "mw_admin_spawn_time", "[Makes units spawn instantly]", true)
				y = y+40
				_MakeCheckbox( 20, y, scroll, "Infinite Water", "mw_admin_credit_cost", "[Allows you to spawn units without cost]", true)
				y = y+40
				_MakeCheckbox( 20, y, scroll, "Build anywhere", "mw_admin_allow_free_placing", "[Allows you to spawn units anywhere]")
				y = y+40
				_MakeCheckbox( 20, y, scroll, "Control any team", "mw_admin_move_any_team", "[Allows you to control units regardless of team]")
				y = y+40
				_MakeCheckbox( 20, y, scroll, "Immortal Units", "mw_admin_immortality", "[Units cant die. Useful for photography]")

				y = y+60
				local button = vgui.Create("DButton", scroll)
				button:SetSize(200,40)
				button:SetPos(20,y)
				button:SetFont("CloseCaption_Normal")
				button:SetText("Reset Credits")
				function button:DoClick()
					LocalPlayer():ConCommand("mw_reset_credits")
					--pl.mw_frame:Remove()
					--pl.mw_frame = nil
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
					draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
				end
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(270, y)
				label:SetSize(370,40)
				label:SetFontInternal( "Trebuchet18" )
				label:SetText("[Set all credits back to the default]")
				y = y+45
				local button = vgui.Create("DButton", scroll)
				button:SetSize(200,40)
				button:SetPos(20,y)
				button:SetFont("CloseCaption_Normal")
				button:SetText("Reset Power")
				function button:DoClick()
					LocalPlayer():ConCommand("mw_reset_power")
					--pl.mw_frame:Remove()
					--pl.mw_frame = nil
				end
				button.Paint = function(s, w, h)
					draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
					draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
				end
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(270, y)
				label:SetSize(370,40)
				label:SetFontInternal( "Trebuchet18" )
				label:SetText("[Set all Power back to the 0]")
				y = y+70
				---------------------------------------------------------// Power
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y)
				label:SetSize(200,40)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("Power: "..tostring(cvars.Number("mw_admin_max_units")))
				local default = vgui.Create("DPanel", scroll)
				default:SetSize(360,60)
				default:SetPos(200,y-10)
				default.Paint = function(s, w, h)
						draw.RoundedBox( 0, 108, 0, 12, h, Color(10,150,10) )
						draw.RoundedBox( 0, 0, 0, 12*6, h, Color(10,40,80) )
						draw.RoundedBox( 0, 12*15, 0, 12*15, h, Color(80,10,10) )
					end
				local slider = vgui.Create("DPanel", scroll)
				slider:SetSize(cvars.Number("mw_admin_max_units")*1.2,40)
				slider:SetPos(200,y)
				for i=1, 30 do
					local button = vgui.Create("DButton", scroll)
					button:SetSize(15,40)
					button:SetPos(185+i*12,y)
					button:SetText("")
					function button:DoClick()
						LocalPlayer():ConCommand("mw_admin_max_units "..tostring(i*10))
						slider:SetSize(i*12, 40)
						label:SetText("Power: "..tostring(i*10))
						--pl.mw_frame:Remove()
						--pl.mw_frame = nil
					end
					button.Paint = function(s, w, h)
						draw.RoundedBox( 0, w-1, 0, 1, h, Color(100,100,100) )
					end
				end
				----------------------------------------------------------- Starting Credits
				y = y+70
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y-20)
				label:SetSize(200,80)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("Starting Water:\n"..tostring(cvars.Number("mw_admin_starting_credits")))
				local default = vgui.Create("DPanel", scroll)
				default:SetSize(360,60)
				default:SetPos(200,y-10)
				default.Paint = function(s, w, h)
						draw.RoundedBox( 0, 108, 0, 12, h, Color(10,150,10) )
						draw.RoundedBox( 0, 0, 0, 12*6, h, Color(10,40,80) )
						draw.RoundedBox( 0, 12*15, 0, 12*15, h, Color(80,10,10) )
					end
				local slider = vgui.Create("DPanel", scroll)
				slider:SetSize(cvars.Number("mw_admin_starting_credits")*12/200,40)
				slider:SetPos(200,y)
				for i=1, 30 do
					local button = vgui.Create("DButton", scroll)
					button:SetSize(15,40)
					button:SetPos(185+i*12,y)
					button:SetText("")
					function button:DoClick()
						LocalPlayer():ConCommand("mw_admin_starting_credits "..tostring(i*200))
						slider:SetSize(i*12, 40)
						label:SetText("Starting Water:\n"..tostring(i*200))
						--pl.mw_frame:Remove()
						--pl.mw_frame = nil
					end
					button.Paint = function(s, w, h)
						draw.RoundedBox( 0, w-1, 0, 1, h, Color(100,100,100) )
					end
				end

				y = y+70
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y-20)
				label:SetSize(200,80)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("Water Income:\n"..tostring(cvars.Number("mw_admin_base_income")))
				local default = vgui.Create("DPanel", scroll)
				default:SetSize(360,60)
				default:SetPos(200,y-10)
				default.Paint = function(s, w, h)
						draw.RoundedBox( 0, 48, 0, 12, h, Color(10,150,10) )
						draw.RoundedBox( 0, 0, 0, 12*2, h, Color(10,40,80) )
						draw.RoundedBox( 0, 12*8, 0, 12*22, h, Color(80,10,10) )
					end
				local slider = vgui.Create("DPanel", scroll)
				slider:SetSize(cvars.Number("mw_admin_base_income")*12/5,40)
				slider:SetPos(200,y)
				for i=1, 30 do
					local button = vgui.Create("DButton", scroll)
					button:SetSize(15,40)
					button:SetPos(185+i*12,y)
					button:SetText("")
					function button:DoClick()
						LocalPlayer():ConCommand("mw_admin_base_income "..tostring(i*5))
						slider:SetSize(i*12, 40)
						label:SetText("Water Income:\n"..tostring(i*5))
						--pl.mw_frame:Remove()
						--pl.mw_frame = nil
					end
					button.Paint = function(s, w, h)
						draw.RoundedBox( 0, w-1, 0, 1, h, Color(100,100,100) )
					end
				end

				y = y+120
				-------------------------------------------------------- TEAMS
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y-45)
				label:SetSize(370,40)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("Alliances")
				local grid = vgui.Create( "DGrid", scroll )
				grid:SetPos( 160, y )
				grid:SetCols( 8 )
				grid:SetColWide( 30 )
				for i=1, 8 do
					for j=1, 8 do
						local checkbox = vgui.Create( "DButton" )// Create the checkbox
						checkbox:SetPos( 20, y )// Set the position
						--checkbox:SetValue( teamgrid[i][j] )
						checkbox:SetSize(30,30)
						checkbox:SetText("")

						if (9-i != j) then
							function checkbox:DoClick()
								teamgrid[9-i][j] = !teamgrid[9-i][j]
								teamgrid[j][9-i] = teamgrid[9-i][j]
								net.Start("UpdateServerTeams")
									net.WriteTable(teamgrid)
								net.SendToServer()
							end
							if (i+j < 9) then
								checkbox.Paint = function(s, w, h)
									draw.RoundedBox( 4, 0, 0, w, h, Color(150,150,150) )
									draw.RoundedBox( 2, 2, 2, w-4, h-4, Color(0,0,0) )
									if (teamgrid[9-i][j]) then
										draw.RoundedBox( 0, 4, 4, w/2-4, h-8, mw_team_colors[9-i] )
										draw.RoundedBox( 0, 4+w/2-4, 4, w/2-4, h-8, mw_team_colors[j] )
									end
								end
							else
								checkbox.Paint = function(s, w, h)
									draw.RoundedBox( 8, 0, 0, w, h, Color(30,30,30) )
									draw.RoundedBox( 6, 2, 2, w-4, h-4, Color(20,20,20) )
									if (teamgrid[9-i][j]) then
										draw.RoundedBox( 4, 4, 4, w-8, h-8, Color(30,30,30) )
									end
								end
							end
						else
							checkbox.Paint = function(s, w, h)
							end
						end
						grid:AddItem(checkbox)
					end
				end
				-- Equipos horizontal
				grid = vgui.Create( "DGrid", scroll )
				grid:SetPos( 160, y-35 )
				grid:SetCols( 8 )
				grid:SetColWide( 30 )
				for i=1, 8 do
					local DPanel = vgui.Create( "DPanel" )
					DPanel:SetSize( 30, 30 ) -- Set the size of the panel
					DPanel.Paint = function(s, w, h)
						draw.RoundedBox( 8, 0, 0, w, h, Color(150,150,150) )
						draw.RoundedBox( 6, 2, 2, w-4, h-4, mw_team_colors[i] )
					end
					grid:AddItem(DPanel)
				end
				-- Equipos vertical
				grid = vgui.Create( "DGrid", scroll )
				grid:SetPos( 160-35, y )
				grid:SetCols( 1 )
				grid:SetColWide( 30 )
				for i=8, 1, -1 do
					local DPanel = vgui.Create( "DPanel" )
					DPanel:SetSize( 30, 30 ) -- Set the size of the panel
					DPanel.Paint = function(s, w, h)
						draw.RoundedBox( 8, 0, 0, w, h, Color(150,150,150) )
						draw.RoundedBox( 6, 2, 2, w-4, h-4, mw_team_colors[i] )
					end
					grid:AddItem(DPanel)
				end

				
			else
				local label = vgui.Create("DLabel", pl.panel)
				label:SetPos(120, 210)
				label:SetSize(370,30)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("This menu is for admins only")
			end
			//}
		elseif (pl.mw_menu == 8) then																--Campaign menu
			if (pl:IsAdmin()) then
				local y = 50
				local scroll = vgui.Create("DScrollPanel", pl.panel)
				local px, py = pl.panel:GetSize()
				scroll:SetPos(0,0)
				scroll:SetSize(px, py)
				-------------------------------------------------------- Campaign
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y-45)
				label:SetSize(370,40)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("Scenarios")

				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y-5)
				label:SetSize(370,40)
				label:SetFontInternal( "Trebuchet18" )
				label:SetText("File Name")

				local TextEntry = vgui.Create( "DTextEntry", scroll ) -- create the form as a child of frame
				TextEntry:SetPos( 100, y )
				TextEntry:SetSize( 200, 25 )
				TextEntry:SetText( os.time() )
				TextEntry.OnEnter = function( self )
					RunConsoleCommand("mw_save_name", "melonwars/campaign/"..self:GetValue())
					RunConsoleCommand("mw_save")
					chat.AddText( "Saved "..self:GetValue()..".txt" )
					pl.mw_frame:Remove()
					pl.mw_frame = nil
				end

				y = y+40

				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y-5)
				label:SetSize(370,40)
				label:SetFontInternal( "Trebuchet18" )
				label:SetText("Type a name and press Enter to save.")

				y = y+40

				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y-5)
				label:SetSize(370,40)
				label:SetFontInternal( "Trebuchet18" )
				label:SetText("The file will be saved in the garrysmod/data/melonwars/campaign folder.")

				y = y+15
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y-5)
				label:SetSize(500,40)
				label:SetFontInternal( "Trebuchet18" )
				label:SetText("If you want to manage subfolders and move files, use your desktop's file explorer.")

				y = y+40
				local label = vgui.Create("DLabel", scroll)
				label:SetPos(20, y-5)
				label:SetSize(500,40)
				label:SetFontInternal( "Trebuchet18" )
				label:SetText("To load a file, double click on it in the browser bellow")

				y = y+40
				local browser = vgui.Create( "DFileBrowser", scroll )
				browser:SetPos( 0, y )
				browser:SetSize(px,200)
				browser:SetPath( "DATA" ) -- The access path i.e. GAME, LUA, DATA etc.
				browser:SetBaseFolder( "melonwars/campaign" ) -- The root folder
				browser:SetOpen( true ) -- Open the tree to show sub-folders
				browser:SetCurrentFolder( "persist" ) -- Show files from persist

				function browser:OnDoubleClick( path, pnl ) -- Called when a file is clicked
					RunConsoleCommand( "mw_save_name", path )
					RunConsoleCommand( "mw_load" )
				end
			else
				local label = vgui.Create("DLabel", pl.panel)
				label:SetPos(120, 210)
				label:SetSize(370,30)
				label:SetFontInternal( "DermaLarge" )
				label:SetText("This menu is for admins only")
			end
		end
	end
end

//{ BUTTON FUNCTIONS
function _MakeHelpButton(name, number, info, text1, text2, text3, text4, text5)								--------------Make HELP Button
	local button = vgui.Create("DButton", LocalPlayer().panel)
	button:SetSize(100,40)
	button:SetPos(10,10+number*(40+5))
	button:SetText(name)
	button:SetFontInternal("CloseCaption_Normal")
	function button:DoClick()
		info:SetFontInternal("Trebuchet24")
		info:SetText(text1)
		if (text2 ~= nil) then info:AppendText(text2) end
		if (text3 ~= nil) then info:AppendText(text3) end
		if (text4 ~= nil) then info:AppendText(text4) end
		if (text5 ~= nil) then info:AppendText(text5) end
		timer.Simple( 0.001, function() info:GotoTextStart() end )

		if (name == "About") then
			if (LocalPlayer():GetInfo("mw_code") == "about" or LocalPlayer():GetInfo("mw_code") == "ABOUT") then
				chat.AddText( "Well done" )
				LocalPlayer():ConCommand("mw_action 945")
			end
		end
	end
end

function _MakeButton(number, posnumber, parent)											--------------Make Button
	if (CLIENT) then
		local pl = LocalPlayer()
		--Unit button
		local button = vgui.Create("DButton", parent)
		button:SetSize(120,40)
		button:SetPos(10,10+(posnumber-1)*45)
		button:SetFont("CloseCaption_Normal")
		button:SetText(mw_units[number].name)
		function button:DoClick()
			LocalPlayer():ConCommand("mw_chosen_unit "..tostring(number))
			LocalPlayer():ConCommand("mw_action 1")
			pl.mw_frame:Remove()
			pl.mw_frame = nil
		end
		local color = mw_units[number].button_color
		button.Paint = function(s, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color(color.r-40,color.g-40,color.b-40) )
			draw.RoundedBox( 3, 5, 5, w-10, h-10, color )
		end
		function button:OnCursorEntered()
			pl.mw_hover = number
			pl.info:SetText(mw_units[number].description)	
			if (cvars.Number("mw_admin_credit_cost") == 1) then
				pl.info_cost:SetText("Cost: "..mw_units[number].cost)
				if (mw_units[number].welded_cost == -1) then
					pl.info_turret_cost:SetText("")
				else
					pl.info_turret_cost:SetText("Turret cost: "..mw_units[number].welded_cost)
				end
			else
				pl.info_cost:SetText("")
				pl.info_turret_cost:SetText("")
			end
			pl.info_power:SetText("Power: "..mw_units[number].population)	
			if (cvars.Number("mw_admin_spawn_time") == 1) then
				pl.info_time:SetText("Spawn time: "..mw_units[number].spawn_time.."s")
			else
				pl.info_time:SetText("")
			end
			pl.info_name:SetText(mw_units[number].name)
		end
	end
end
//}

function DefaultInfo ()
	if (CLIENT) then
		local pl = LocalPlayer()
		
		pl.info = vgui.Create("DLabel", pl.panel)
		pl.info:SetPos(190, 190)
		pl.info:SetSize(370,200)
		pl.info:SetWrap(true)
		pl.info:SetFontInternal( "Trebuchet24" )
		pl.info:SetText("Hover over a button to see more info about the units")
		pl.mw_hover = 0
		
		pl.info_name = vgui.Create("DLabel", pl.panel)
		pl.info_name:SetPos(190, 50)
		pl.info_name:SetSize(370,100)
		pl.info_name:SetWrap(true)
		pl.info_name:SetFontInternal( "DermaLarge" )
		pl.info_name:SetText("-")	
		
		pl.info_cost = vgui.Create("DLabel", pl.panel)
		pl.info_cost:SetPos(190, 110)
		pl.info_cost:SetSize(370,100)
		pl.info_cost:SetWrap(true)
		pl.info_cost:SetFontInternal( "DermaLarge" )
		pl.info_cost:SetText("Cost: ")	
		
		pl.info_turret_cost = vgui.Create("DLabel", pl.panel)
		pl.info_turret_cost:SetPos(190, 140)
		pl.info_turret_cost:SetSize(370,100)
		pl.info_turret_cost:SetWrap(true)
		pl.info_turret_cost:SetFontInternal( "Trebuchet24" )
		pl.info_turret_cost:SetText("")	
		
		pl.info_power = vgui.Create("DLabel", pl.panel)
		pl.info_power:SetPos(400, 110)
		pl.info_power:SetSize(370,100)
		pl.info_power:SetWrap(true)
		pl.info_power:SetFontInternal( "DermaLarge" )
		pl.info_power:SetText("Power")	

		pl.info_time = vgui.Create("DLabel", pl.panel)
		pl.info_time:SetPos(400, 140)
		pl.info_time:SetSize(370,100)
		pl.info_time:SetWrap(true)
		pl.info_time:SetFontInternal( "Trebuchet24" )
		pl.info_time:SetText("")	
	end
end

function TOOL:DrawToolScreen( width, height )
	
	-- Draw black background
	surface.SetDrawColor( Color( 20, 20, 20 ) )
	surface.DrawRect( 0, 0, width, height )

	if (cvars.Bool("mw_admin_cutscene")) then 
		draw.SimpleText( "Toolgun Disabled", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	else
		-- Draw white text in middle
		local action = LocalPlayer():GetInfoNum("mw_action", 0)
		if (action == 0) then
			draw.SimpleText( "Selecting units", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif (action == 1) then
			draw.SimpleText( "Spawning units", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif (action == 2) then
			draw.SimpleText( "Spawning Base", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif (action == 3) then
			draw.SimpleText( "Spawning Prop", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif (action == 4) then
			draw.SimpleText( "Contraptions", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		elseif (action == 945) then
			draw.SimpleText( "Click on a unit", "DermaLarge", width / 2, height / 2, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	

	// New Year
	// RECORDAR DESCOMENTAR EL CODIGO ANTERIOR
	/*surface.SetDrawColor( HSVToColor( (CurTime()*50)%360, 1, 0.2 ) );
	surface.DrawRect( 0, 0, width, height );
	local txt = "Happy Holidays!"
	local len = string.len(txt);
	local letterWidth = 15;
	local amplitude = 20;
	local frequency = 0.4;
	local speed = 5;

	local colorFrequency = 10;
	local colorSpeed = 180;
	for i = 1, len do
		local color = HSVToColor( (CurTime()*colorSpeed+i*colorFrequency)%360, 1, 1 )
		draw.SimpleText( string.sub(txt, i, i), "DermaLarge", width / 2 + (-len/2 + i)*letterWidth, height / 2+math.sin(i*frequency+CurTime()*speed)*amplitude, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end*/
end

function TOOL:Initialize()
	self:GetOwner().cutsceneOpacity = 0
	self:GetOwner().chatTimer = 0

	MW_OpenPatchNotes()
end

function MW_OpenPatchNotes()
	--[[
	local lastExistingPatchNote = 0
	local files, directories = file.Find( "patchnotes/*", "LUA" )
	PrintTable(directories)
	--for k, v in SortedPairsByValue( files, true ) do
	--	--local str = file.Read( GetConVarString( "melonwars_last_read_patch_note.lua", "LUA"))
	--end

	local lastReadPatchNote = 0
	if (file.Exists("melonwars_last_read_patch_note.lua", "DATA")) then
		local str = file.Read( "melonwars_last_read_patch_note.lua", "DATA")
		lastReadPatchNote = util.StringToType(str, "int")
	end

	if (lastReadPatchNote == 0) then
		file.Write( "melonwars_last_read_patch_note.lua", tostring(lastReadPatchNote) )
	end

	local frame = vgui.Create("DFrame")
	local w = 700
	local h = 500
	frame:SetSize(w,h)
	frame:SetPos(ScrW()/2-w/2,ScrH()/2-h/2)
	frame:SetTitle("Patch Notes")
	frame:MakePopup()
	]]
end

function TOOL:Deploy ()
	self.pressed = false
	self.rPressed = false
	self.disableKeyboard = false
	self.ctrlPressed = false
	self.canPlace = true
	--self:GetOwner():ConCommand("r_drawviewmodel 0")
	--self:GetOwner():ConCommand("cl_drawhud 0")
	self:GetOwner().cutsceneOpacity = 0
	self:GetOwner().chatTimer = 0
	local _team = self:GetOwner():GetInfoNum("mw_team", 0)
	if (SERVER) then
		if (_team != 0) then
			net.Start("MW_TeamCredits")
				net.WriteInt(mw_teamCredits[_team] ,32)
			net.Send(self:GetOwner())
			
			net.Start("MW_TeamUnits")
				net.WriteInt(mw_teamUnits[_team] ,16)
			net.Send(self:GetOwner())
		end
		self:GetOwner():PrintMessage( HUD_PRINTCENTER, "Press R to open the menu" )
	end
end

function TOOL:Holster ()
	--self:GetOwner():ConCommand("r_drawviewmodel 1")
	--self:GetOwner():ConCommand("cl_drawhud 1")
	--if (CLIENT) then
	--	if (tostring(pl.mw_frame) ~= "[NULL Panel]") then
	--		pl.mw_frame:Remove()
	--	end
	--end
	if ( IsValid(self.GhostEntity)) then
		self.GhostEntity:Remove()
	end
	if ( IsValid(self.GhostSphere)) then
		self.GhostSphere:Remove()
	end
end

function TOOL:RightClick( tr )
	if (IsValid(self:GetOwner().controllingUnit)) then
		self:GetOwner().controllingUnit = nil
	end 
	if (CLIENT) then
		if (LocalPlayer().mw_cooldown < CurTime()-0.05) then
			if (cvars.Number("mw_chosen_unit") == 0) then
				//self.Owner:ConCommand( "mw_order" ) //ordenar
				if (istable(LocalPlayer().foundMelons)) then
					net.Start("MW_Order")
						net.WriteVector(LocalPlayer():GetEyeTrace().HitPos)
						net.WriteBool(LocalPlayer():KeyDown(IN_SPEED))
						net.WriteBool(LocalPlayer():KeyDown(IN_WALK))
						for k, v in pairs(LocalPlayer().foundMelons) do
							if (not v:IsWorld() and v:IsValid() and v != nil) then
								net.WriteEntity(v)
							end
						end
					net.SendToServer()
				end
			else
				self.Owner:ConCommand( "mw_chosen_unit 0" ) //dejar de spawnear
			end
			LocalPlayer():ConCommand("mw_action 0")
			LocalPlayer().mw_cooldown = CurTime()
		end
	end
end

function TOOL:LeftClick( tr )
	
	if (IsValid(self:GetOwner().controllingUnit)) then
		if (CLIENT) then
			if (IsFirstTimePredicted()) then
				local cUnit = LocalPlayer().controllingUnit
				net.Start("MWControlShoot")
					net.WriteEntity(cUnit)
					net.WriteVector(LocalPlayer().controlTrace.HitPos)
				net.SendToServer()
			end
		end
	else
		local trace = self:GetOwner():GetEyeTrace( {
		mask = MASK_WATER+MASK_SOLID
		} )
		if (CLIENT and not GetConVar( "mw_admin_cutscene" ):GetBool()) then
			local pl = LocalPlayer()
			if (pl.mw_cooldown < CurTime()-0.1) then
				/*if (!LocalPlayer().mw_selecting) then
					LocalPlayer().mw_selectionStartingPoint = LocalPlayer():GetEyeTrace().HitPos
					LocalPlayer().mw_selectionEndingPoint = LocalPlayer().mw_selectionStartingPoint
					LocalPlayer().mw_selecting = true
				end*/

				pl.mw_cooldown = CurTime()
				mw_melonTeam = pl:GetInfoNum("mw_team", 0)
				
				local action = pl:GetInfoNum("mw_action", 0)
				if (action == 0) then
					/*if (pl.mw_selectTimer > CurTime()-0.3 and pl.mw_selectTimer < CurTime()-0.05) then
						if (trace.Entity.Base == "ent_melon_base") then
							MW_TypeSelection()
						end
					else*/
						//pl:ConCommand( "+mw_select" )
						MW_BeginSelection()
						/*self.pressed = true
						pl.LocalPlayer().mw_selecting = true*/
						pl.mw_selectTimer = CurTime()
					//end
					pl.mw_spawnTimer = CurTime()
				elseif (action == 1) then
					if (pl.mw_spawnTimer < CurTime()-0.1) then
						if (cvars.Bool("mw_admin_playing")) then 
							attach = pl:GetInfoNum("mw_unit_option_welded", 0)
							unit_index = pl:GetInfoNum("mw_chosen_unit", 0)
							if (cvars.Bool("mw_admin_allow_free_placing") or mw_units[unit_index].buildAnywere or MW_isInRange(trace.HitPos, mw_melonTeam) or mw_melonTeam == 0) then
								if (cvars.Bool("mw_admin_allow_free_placing") or MW_noEnemyNear(trace.HitPos, mw_melonTeam)) then 
									if (mw_units[unit_index].population == 0 or pl.mw_units+mw_units[unit_index].population <= cvars.Number("mw_admin_max_units")) then
										if (LocalPlayer().canPlace) then
											local cost = 0
											local class = ""
											
											if (unit_index > 0) then
												class = mw_units[unit_index].class
												
												cost = 1337
												
												if (attach == 1) then 
													cost = mw_units[unit_index].welded_cost
												else 
													cost = mw_units[unit_index].cost
												end		

												if (cost == -1) then
													cost = mw_units[unit_index].cost
													attach = false
												end

												if (mw_units[unit_index].contraptionPart) then
													attach = true
												end

												if (unit_index >= firstBuilding && unit_index < firstContraption) then
													attach = true
												end
											end
											
											--if (unit_index >= firstBuilding) then attach = true end
											if (pl.mw_credits >= cost or not cvars.Bool("mw_admin_credit_cost") or mw_melonTeam == 0) then
												if (attach == false or (mw_units[unit_index].spawnable_on_floor or not trace.Entity:IsWorld()) and ((trace.Entity:GetClass() != "ent_melon_outpost_point" and trace.Entity:GetClass() != "ent_melon_cap_point"  and trace.Entity:GetClass() != "ent_melon_water_tank") and (trace.Entity:GetNWInt("mw_melonTeam", 0) == mw_melonTeam or trace.Entity:GetNWInt("mw_melonTeam", 0) == 0))) then
													if (unit_index >= 0) then
														if (cvars.Number("mw_admin_spawn_time") == 1) then
															if (pl.mw_spawntime < CurTime()) then
																pl.mw_spawntime = CurTime() + mw_units[unit_index].spawn_time
															else
																pl.mw_spawntime = pl.mw_spawntime + mw_units[unit_index].spawn_time
															end
														end
													else
														pl.mw_spawntime = 0
													end

													local spawnAngle
													if (mw_units[unit_index].normalAngle) then
														spawnAngle = trace.HitNormal:Angle()+mw_units[unit_index].angle
													else
														if (mw_units[unit_index].changeAngles) then
															spawnAngle = pl.propAngle + mw_units[unit_index].angle
														else
															spawnAngle = mw_units[unit_index].angle
														end
													end

													local spawnPosition = trace.HitPos+Vector(0,0,1)+trace.HitNormal*5+mw_units[unit_index].offset
													net.Start("MW_SpawnUnit")
														net.WriteString(class)
														net.WriteInt(unit_index, 16)
														net.WriteTable(trace)
														net.WriteInt(cost, 16)
														net.WriteInt(pl.mw_spawntime*cvars.Number("mw_admin_spawn_time"), 16)
														net.WriteInt(mw_melonTeam, 8)
														net.WriteBool(attach)
														net.WriteAngle(spawnAngle)
														net.WriteVector(spawnPosition)
													net.SendToServer()

													local effectdata = EffectData()
													effectdata:SetEntity( newMarine )
													util.Effect( "propspawn", effectdata )
													
													if (cvars.Bool("mw_admin_credit_cost") or mw_melonTeam == 0) then
														self:IndicateIncome(-cost)
														pl.mw_credits = pl.mw_credits-cost
													end
													
													net.Start("MW_UpdateServerInfo")
														net.WriteInt(mw_melonTeam ,8)
														net.WriteInt(pl.mw_credits ,32)
													net.SendToServer()
												else
													pl:PrintMessage( HUD_PRINTTALK, "///// Cant attach units onto non legalized props" )
												end
											else
												pl:PrintMessage( HUD_PRINTTALK, "///// Not enough resources" )
											end
										else
											pl:PrintMessage( HUD_PRINTTALK, "///// What you're trying to spawn overlaps with something else" )
										end
									else
										pl:PrintMessage( HUD_PRINTTALK, "///// Power max reached" )
									end
								else
									pl:PrintMessage( HUD_PRINTTALK, "///// Enemy too close" )
								end
							else 
								pl:PrintMessage( HUD_PRINTTALK, "///// To far from an outpost" )
							end
						else
							pl:PrintMessage( HUD_PRINTTALK, "///// The admin has paused the game" )
						end
						pl.mw_spawnTimer = CurTime()
					end
				elseif (action == 2) then
					net.Start("SpawnBase")
						net.WriteTable(trace)
						net.WriteInt(mw_melonTeam, 8)
					net.SendToServer()
					self:GetOwner():ConCommand("mw_action 0")
				elseif (action == 3) then
					if (pl.mw_spawnTimer < CurTime()-0.1) then
						local prop_index = pl:GetInfoNum("mw_chosen_prop", 0)
						local cost = mw_base_props[prop_index].cost
						if (cvars.Bool("mw_admin_playing")) then 
							attach = pl:GetInfoNum("mw_unit_option_welded", 0)
							if (cvars.Bool("mw_admin_allow_free_placing") or MW_isInRange(trace.HitPos, mw_melonTeam)) then
								if (cvars.Bool("mw_admin_allow_free_placing") or MW_noEnemyNear(trace.HitPos, mw_melonTeam)) then 
									if (pl.mw_credits >= cost or not cvars.Bool("mw_admin_credit_cost")) then
										if (cvars.Number("mw_admin_spawn_time") == 1) then
											if (pl.mw_spawntime < CurTime()) then
												pl.mw_spawntime = CurTime() + mw_base_props[prop_index].spawn_time
											else
												pl.mw_spawntime = pl.mw_spawntime + mw_base_props[prop_index].spawn_time
											end
										end
										net.Start("MW_SpawnProp")
											net.WriteInt(prop_index, 16)
											net.WriteTable(trace)
											net.WriteInt(cost, 16)
											net.WriteInt(mw_melonTeam, 8)
											net.WriteInt(pl.mw_spawntime*cvars.Number("mw_admin_spawn_time"), 16)
											net.WriteAngle(pl.propAngle)
										net.SendToServer()
										if (cvars.Bool("mw_admin_credit_cost")) then
											self:IndicateIncome(-cost)
											pl.mw_credits = pl.mw_credits-cost
										end
										
										--pl.mw_units = pl.mw_units+unit_population[unit_index]
										net.Start("MW_UpdateServerInfo")
											net.WriteInt(mw_melonTeam ,8)
											net.WriteInt(pl.mw_credits ,32)
											--net.WriteInt(pl.mw_units ,16)
										net.SendToServer()
									end
								end
							end
						end
					end
				elseif (action == 4) then  --Contraption Save
					if (CLIENT) then
						--ContraptionSave(pl.contraption_name, pl:GetEyeTrace().Entity)
						net.Start("ContraptionSave")
							net.WriteString(pl.contraption_name)
							net.WriteEntity(pl:GetEyeTrace().Entity)
						net.SendToServer()
					end
					self:GetOwner():ConCommand("mw_action 0")
				elseif (action == 5) then  --Sell Tool
				elseif (action == 6) then  --Contraption Load
					/*net.Start("ContraptionLoad")
						net.WriteString(file.Read(pl.selectedFile))
						net.WriteEntity(pl)
					net.SendToServer()*/

					local text = file.Read(pl.selectedFile)
					local compressed_text = util.Compress( text )
					if ( !compressed_text ) then compressed_text = text end
					local len = string.len( compressed_text )
					local send_size = 60000
					local parts = math.ceil( len / send_size )
					local start = 0
					net.Start( "BeginContraptionLoad" )
						net.WriteEntity(pl)
					net.SendToServer()
					for i = 1, parts do
						local endbyte = math.min( start + send_size, len )
						local size = endbyte - start
						local data = compressed_text:sub( start + 1, endbyte + 1 )
						net.Start( "ContraptionLoad" )
							net.WriteBool( i == parts )
							net.WriteUInt( size, 16 )
							net.WriteData( data, size )
						net.SendToServer()
						start = endbyte
					end
				elseif (action == 7) then
					net.Start("SpawnBaseGrandWar")
						net.WriteTable(trace)
						net.WriteInt(mw_melonTeam, 8)
					net.SendToServer()
					self:GetOwner():ConCommand("mw_action 0")
				elseif (action == 8) then
					net.Start("SpawnCapturePoint")
						net.WriteTable(trace)
					net.SendToServer()
					self:GetOwner():ConCommand("mw_action 0")
				elseif (action == 9) then
					net.Start("SpawnOutpost")
						net.WriteTable(trace)
					net.SendToServer()
					self:GetOwner():ConCommand("mw_action 0")
				elseif (action == 10) then
					net.Start("SpawnWaterTank")
						net.WriteTable(trace)
					net.SendToServer()
					self:GetOwner():ConCommand("mw_action 0")
				elseif (action == 25) then
					net.Start("SpawnBaseUnit")
						net.WriteTable(trace)
						net.WriteInt(mw_melonTeam, 8)
					net.SendToServer()
					self:GetOwner():ConCommand("mw_action 0")
				elseif (action == 945) then
					if (LocalPlayer():GetInfo("mw_code") == "about" or LocalPlayer():GetInfo("mw_code") == "ABOUT") then
						local targetUnit = self:GetOwner():GetEyeTrace().Entity
						if (targetUnit != nil) then
							if (targetUnit.Base == "ent_melon_base") then
								net.Start("MWControlUnit")
									net.WriteEntity(targetUnit)
								net.SendToServer()
							end
						end
					else
						net.Start("MWBrute")
						net.SendToServer()
					end
				end
			end
		end
	end
end

function TOOL.BuildCPanel( CPanel )
 
 	if (CLIENT) then 
	
		--CPanel:AddControl("Label", { Text = "Options" , Description = "These options only affect mw_units" })
	
		--CPanel:AddControl("CheckBox", {
		--	Label = "Rocketeer",
		--	Command = "mw_unit_option_rocketeer",
		--	Description = "Makes the unit mw_hover a few meters above ground while moving. Multiplies price by 3."
		--})
		
		CPanel:AddControl("Label", { Text = "Reload to open the menu" })
	end
end

--list.Set( "MelonUnits", "1", { model = "models/props_junk/watermelon01.mdl"} )
--list.Set( "MelonUnits", "2", { model = "models/Combine_Helicopter/helicopter_bomb01.mdl"} )

function TOOL:Think()
	//if (not IsValid(self:GetOwner().controllingUnit)) then

		if (CLIENT) then
			local ply = LocalPlayer()
			local trace = ply:GetEyeTrace()
			local vector = trace.HitPos-ply:GetPos()

			if (ply.mw_selecting) then
				LocalPlayer().mw_selectionEndingPoint = (LocalPlayer().mw_selectionEndingPoint*9+trace.HitPos)/10
				if (!input.IsMouseDown(MOUSE_LEFT)) then
					//surface.PlaySound( "garrysmod/ui_hover.wav")
					self:DoSelection(LocalPlayer().mw_selectionStartingPoint, trace.HitPos)
					MW_FinishSelection()
					ply.mw_selecting = false
				end
			end

			if (ply.chatTimer == nil) then
				ply.chatTimer = 0
			end
			if (ply.cutsceneOpacity == nil) then
				ply.cutsceneOpacity = 0
			end
			if (self.canPlace == nil) then
				self.canPlace = false
			end
			if (ply.chatTimer > 0) then
				if (ply.cutsceneOpacity < 230) then
					ply.cutsceneOpacity = ply.cutsceneOpacity+2
				end
				ply.chatTimer = ply.chatTimer-1
			else
				if (ply.cutsceneOpacity > 0) then
					ply.cutsceneOpacity = ply.cutsceneOpacity-0.5
					if (ply.cutsceneOpacity < 0) then
						ply.cutsceneOpacity = 0
					end
				end
			end

			if (ply.mw_action == 1) then
				ply.propAngle = Vector(vector.x, vector.y, 0):Angle()
				if (ply:GetInfoNum("mw_chosen_unit", 0) != 0) then
					if (mw_units[ply:GetInfoNum("mw_chosen_unit", 0)].angleSnap) then
						ply.propAngle = Angle(ply.propAngle.p, 180+math.Round(ply.propAngle.y/90)*90, ply.propAngle.r)
					end
				end
			elseif (cvars.Number("mw_prop_snap") == 1) then
				ply.propAngle = Vector(vector.x, vector.y, 0):Angle()
				ply.propAngle = Angle(ply.propAngle.p, math.Round(ply.propAngle.y/45)*45, ply.propAngle.r)
			else
				ply.propAngle = Vector(vector.x, vector.y, 0):Angle()
			end

			local newTeam = cvars.Number("mw_team")
			local newColor = Color(200,200,200,255)

			if (!ply.disableKeyboard) then
				if (input.IsKeyDown( KEY_R )) then
					if (self.rPressed == nil) then
						self.rPressed = false
					end
					if (!self.rPressed) then
						self.rPressed = true
						if (ply.mw_frame ~= nil) then
							ply.mw_frame:Remove()
							ply.mw_frame = nil
						end
					end
				else
					self.rPressed = false
				end

				if (ply.mw_action == 0) then
					if (input.IsKeyDown( KEY_E )) then
						if (self.ePressed == nil) then
							self.ePressed = false
						end
						if (!self.ePressed) then
							self.ePressed = true
							local tr = LocalPlayer():GetEyeTrace()
							local correctTeam = (tr.Entity:GetNWInt("mw_melonTeam", 0) == newTeam or tr.Entity:GetNWInt("capTeam", 0) == newTeam or cvars.Bool("mw_admin_move_any_team", false))
							
							if (string.StartWith( tr.Entity:GetClass(), "ent_melon_barracks" ) or tr.Entity:GetClass() == "ent_melon_overclocker" ) then
								if (correctTeam) then
									net.Start("ToggleBarracks")
									 	net.WriteEntity(tr.Entity)
									net.SendToServer()
								end
							elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_gate" ) or string.StartWith( tr.Entity:GetClass(), "ent_melon_energy_switch" )) then
								if (correctTeam) then
									net.Start("MW_Activate")
										net.WriteEntity(tr.Entity)
									net.SendToServer()
								end
							elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_singleplayer" )) then
								net.Start("ActivateWaypoints")
								net.SendToServer()
							elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_propeller" ) or string.StartWith( tr.Entity:GetClass(), "ent_melon_hover" )) then
								if (correctTeam) then
									net.Start("PropellerReady")
									 	net.WriteEntity(tr.Entity)
									net.SendToServer()
								end
							elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_unit_transport" )) then
								if (correctTeam) then
									net.Start("MW_Activate")
									 	net.WriteEntity(tr.Entity)
									net.SendToServer()
								end
							elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_water_tank" )) then
								if (correctTeam) then
									net.Start("UseWaterTank")
									 	net.WriteEntity(tr.Entity)
									net.SendToServer()
								end
							elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_energy_steam_plant" )) then
								if (correctTeam) then
									net.Start("MW_Activate")
									 	net.WriteEntity(tr.Entity)
									net.SendToServer()
								end
							elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_energy_nuclear_plant" )) then
								if (correctTeam) then
									net.Start("MW_Activate")
									 	net.WriteEntity(tr.Entity)
									net.SendToServer()
								end
							elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_contraption_assembler" )) then
								if (correctTeam) then
									ply.selectedAssembler = tr.Entity
									self:MakeContraptionMenu()
								end
							elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_energy_water_pump" )) then
								if (correctTeam) then
									net.Start("MW_Activate")
									 	net.WriteEntity(tr.Entity)
									net.SendToServer()
								end
							elseif (string.StartWith( tr.Entity:GetClass(), "ent_melon_longboy" )) then
								if (correctTeam) then
									net.Start("MW_Activate")
									 	net.WriteEntity(tr.Entity)
									net.SendToServer()
								end
							end
						end
					else
						self.ePressed = false
					end
				end
			end
			
			if (newTeam != 0) then
				newColor = mw_team_colors[newTeam]
			else
				newColor = Color(100,100,100,255)
			end
			ply.mw_hudColor = newColor

			if (LocalPlayer().mw_action == 5) then
				if (!input.IsMouseDown( MOUSE_LEFT )) then
					LocalPlayer().mw_sell = 0
				else
					LocalPlayer().mw_sell = LocalPlayer().mw_sell+1/100
					if (LocalPlayer().mw_sell > 1) then
						if (trace.Entity:GetNWInt("mw_melonTeam") == newTeam) then
							net.Start("SellEntity")
								net.WriteEntity(trace.Entity)
								net.WriteInt(cvars.Number("mw_team"), 8)
							net.SendToServer()
						end
						LocalPlayer().mw_sell = 0
					end
				end
			end
			
			if (input.IsKeyDown( KEY_LCONTROL )) then
				if (self.ctrlPressed == nil) then
					self.ctrlPressed = false
				end
				if (!self.ctrlPressed) then
					self.ctrlPressed = true
					//self.Owner:ConCommand( "mw_stop" ) //parar
					if (istable(LocalPlayer().foundMelons)) then
					local count = table.Count(LocalPlayer().foundMelons)
					if (count > 0) then
						net.Start("MW_Stop")
							for k, v in pairs(LocalPlayer().foundMelons) do
								net.WriteEntity(v)
							end
						net.SendToServer()
						end
					end
				end
			else
				self.ctrlPressed = false
			end
			
			if (LocalPlayer().mw_spawnTimer == nil) then
				LocalPlayer().mw_spawnTimer = CurTime()
			end
			if (LocalPlayer().mw_selectTimer == nil) then
				LocalPlayer().mw_selectTimer = CurTime()
			end
			if (LocalPlayer().mw_cooldown == nil) then
				LocalPlayer().mw_cooldown = CurTime()
			end
			
			if (LocalPlayer().mw_units == nil) then
				LocalPlayer().mw_units = 0
			end
			if (LocalPlayer().mw_credits == nil) then
				LocalPlayer().mw_credits = 0
			end
			if (LocalPlayer().mw_sell == nil) then
				LocalPlayer().mw_sell = 0
			end
			if (LocalPlayer().mw_spawntime == nil) then
				LocalPlayer().mw_spawntime = CurTime()
			end
			
			if (LocalPlayer().mw_action == 1) then
				local newColor = mw_team_colors[ply:GetInfoNum("mw_team", 0)]
				local unit_index = ply:GetInfoNum("mw_chosen_unit", 0)
				if (unit_index > 0 and mw_units[unit_index].offset != nil) then
					local offset = mw_units[unit_index].offset
					local xoffset = Vector(offset.x*(math.cos(ply.propAngle.y/180*math.pi)), offset.x*(math.sin(ply.propAngle.y/180*math.pi)),0)
					local yoffset = Vector(offset.y*(-math.sin(ply.propAngle.y/180*math.pi)), offset.y*(math.cos(ply.propAngle.y/180*math.pi)),0)
					offset = xoffset+yoffset+Vector(0,0,offset.z)
					local ang = ply.propAngle+mw_units[unit_index].angle
					if (mw_units[unit_index].normalAngle) then
						ang = trace.HitNormal:Angle()+mw_units[unit_index].angle
					end
					MW_UpdateGhostEntity (mw_units[unit_index].model, trace.HitPos, trace.HitNormal * 5+offset, ang, newColor, mw_units[unit_index].energyRange, trace.HitPos)
				end
			elseif (LocalPlayer().mw_action == 3) then
				local newColor = mw_team_colors[ply:GetInfoNum("mw_team", 0)]
				//local modeltable = list.Get( "WallModels" )
				local prop_index = ply:GetInfoNum("mw_chosen_prop", 0)
				local offset
				if (cvars.Bool("mw_prop_offset") == true) then
					offset = mw_base_props[prop_index].offset
					--offset:Rotate( ply.propAngle )
					local xoffset = Vector(offset.x*(math.cos(ply.propAngle.y/180*math.pi)), offset.x*(math.sin(ply.propAngle.y/180*math.pi)),0)
					local yoffset = Vector(offset.y*(-math.sin(ply.propAngle.y/180*math.pi)), offset.y*(math.cos(ply.propAngle.y/180*math.pi)),0)
					offset = xoffset+yoffset+Vector(0,0,offset.z)
				else
					offset = Vector(0,0,mw_base_props[prop_index].offset.z)
				end
				MW_UpdateGhostEntity (mw_base_props[prop_index].model, LocalPlayer():GetEyeTrace().HitPos, Vector(0,0,1)+offset, ply.propAngle + mw_base_props[prop_index].angle, newColor, 0, trace.HitPos)
			else
				if ( IsValid(LocalPlayer().GhostEntity)) then
					LocalPlayer().GhostEntity:Remove()
				end
				if ( IsValid(LocalPlayer().GhostSphere)) then
					LocalPlayer().GhostSphere:Remove()
				end
			end
		end
	//end
end

function TOOL:DoSelection(startingPos, endingPos)
	local center = (startingPos+endingPos)/2;
	local radius = (startingPos-endingPos):Length()/2

	local foundEntities = {}
	local allFoundEntities = {}
	local typeSelect = nil

	if (LocalPlayer().foundMelons != nil) then
		if (not LocalPlayer():KeyDown(IN_SPEED)) then
			table.Empty(LocalPlayer().foundMelons)
		end
	end

	if (LocalPlayer().lastSelectionTime == nil) then
		LocalPlayer().lastSelectionTime = CurTime()
	end

	local _team = LocalPlayer():GetInfoNum("mw_team", -2)

	if (LocalPlayer().mw_selectionID == nil) then
		LocalPlayer().mw_selectionID = 0
	end

	LocalPlayer().mw_selectionID = (LocalPlayer().mw_selectionID+1)%255

	if (LocalPlayer().lastSelectionTime+0.3 > CurTime()) then
		local clickedUnit = LocalPlayer():GetEyeTrace().Entity
		if (IsValid(clickedUnit)) then
			if (string.StartWith(clickedUnit:GetClass(),"ent_melon_")) then
				allFoundEntities = ents.FindInSphere( center, 300 )
				net.Start("MW_RequestSelection")
					net.WriteInt(LocalPlayer().mw_selectionID, 8)
					net.WriteString(clickedUnit:GetClass())
					net.WriteVector(center)
					net.WriteFloat(300)
				net.SendToServer()
				typeSelect = clickedUnit:GetClass()
			end
		end
	else

		if (radius > 10) then 
			allFoundEntities = ents.FindInSphere( center, radius )
			net.Start("MW_RequestSelection")
				net.WriteInt(LocalPlayer().mw_selectionID, 8)
				net.WriteString("nil")
				net.WriteVector(center)
				net.WriteFloat(radius)
			net.SendToServer()
		else
			allFoundEntities = ents.FindInSphere( center, 10 )
			net.Start("MW_RequestSelection")
				net.WriteInt(LocalPlayer().mw_selectionID, 8)
				net.WriteString("nil")
				net.WriteVector(center)
				net.WriteFloat(10)
			net.SendToServer()
		end
	end

	LocalPlayer().lastSelectionTime = CurTime()

	for k, v in ipairs(allFoundEntities) do
		if (cvars.Bool("mw_admin_move_any_team", false) or v:GetNWInt("mw_melonTeam", -1) == LocalPlayer():GetInfoNum("mw_team", -2)) then
			if (v:GetClass() != "ent_melon_zone") then
				if (typeSelect == nil or typeSelect == v:GetClass()) then
					table.insert( foundEntities, v )
				end
			end
		end
	end

	if (istable(foundEntities)) then
		LocalPlayer().foundMelons = table.Copy(foundEntities)
	end
end

local plainMaterial = Material( "color" )

function TOOL:IndicateIncome(amount)
	local indicator = incomeIndicators[currentIncomeIndicator]
	currentIncomeIndicator = (currentIncomeIndicator+1)%(#incomeIndicators)+1
	indicator.time = CurTime()
	indicator.value = amount
end

function TOOL:MakeContraptionMenu()
	if (LocalPlayer().cmenuframe != nil) then
		if (LocalPlayer().selectedAssembler.file != nil) then
			StartBuildingContraption(LocalPlayer().selectedAssembler, LocalPlayer().selectedAssembler.file, LocalPlayer().contrapCost, LocalPlayer().contrapPower)
		end
	end
	if (LocalPlayer().cmenuframe == nil) then
		if (LocalPlayer().selectedAssembler:GetNWBool("active", true) == false) then
			LocalPlayer().cmenuframe = vgui.Create("DFrame")
			local w = 400
			local h = 400
			local freeze = net.ReadBool()
			LocalPlayer().cmenuframe:SetSize(w,h)
			LocalPlayer().cmenuframe:SetPos(ScrW()/2-w/2,ScrH()/2-h/2)
			LocalPlayer().cmenuframe:SetTitle("Contraption Legalizer")
			LocalPlayer().cmenuframe:MakePopup()
			
			LocalPlayer().cmenuframe.OnClose = function()
				LocalPlayer().cmenuframe = nil
			end

			local contraptionE = vgui.Create("DLabel", LocalPlayer().cmenuframe)
			contraptionE:SetPos( 30, 90)
			contraptionE:SetSize(300,30)
			contraptionE:SetFontInternal( "Trebuchet18" )
			contraptionE:SetText("Press E again to spawn last spawned contraption")

			local contraptionName = vgui.Create("DLabel", LocalPlayer().cmenuframe)
			contraptionName:SetPos( 30, 110)
			contraptionName:SetSize(300,30)
			contraptionName:SetFontInternal( "Trebuchet24" )
			contraptionName:SetText("Contraption: ")

			local contraptionCost = vgui.Create("DLabel", LocalPlayer().cmenuframe)
			contraptionCost:SetPos( 30, 150)
			contraptionCost:SetSize(300,30)
			contraptionCost:SetFontInternal( "Trebuchet24" )
			contraptionCost:SetText("Cost:")

			local contraptionPower = vgui.Create("DLabel", LocalPlayer().cmenuframe)
			contraptionPower:SetPos( 200, 150)
			contraptionPower:SetSize(300,30)
			contraptionPower:SetFontInternal( "Trebuchet24" )
			contraptionPower:SetText("Power:")

			if (LocalPlayer().selectedAssembler != nil and LocalPlayer().selectedAssembler.file != nil) then
				LocalPlayer().contrapCost, LocalPlayer().contrapPower = SelectContraption(LocalPlayer(), LocalPlayer().selectedAssembler.file, contraptionName, contraptionCost, contraptionPower)
			end

			local button = vgui.Create("DButton", LocalPlayer().cmenuframe)
			button:SetSize(180,40)
			button:SetPos(110, 50)
			button:SetFont("CloseCaption_Normal")
			button:SetText("Produce")
			function button:DoClick()
				if (IsEntity(LocalPlayer().selectedAssembler)) then
					StartBuildingContraption(LocalPlayer().selectedAssembler, LocalPlayer().selectedFile, LocalPlayer().contrapCost, LocalPlayer().contrapPower)
				else
					print("Somehow, the contraption assembler you have selected doesn't seem to be an Entity")
					print(LocalPlayer().selectedAssembler)
					debug.Trace()
				end
			end
			button.Paint = function(s, w, h)
				draw.RoundedBox( 6, 0, 0, w, h, Color(210,210,210) )
				draw.RoundedBox( 3, 5, 5, w-10, h-10, Color(250,250,250) )
			end

			local browser = vgui.Create( "DFileBrowser", LocalPlayer().cmenuframe )
			browser:SetPos( 25, 200 )
			browser:SetSize(350, 175)

			browser:SetPath( "DATA" ) -- The access path i.e. GAME, LUA, DATA etc.
			browser:SetBaseFolder( "melonwars/contraptions" ) -- The root folder
			browser:SetName( "Contraptions" ) -- Name to display in tree
			browser:SetSearch( "contraptions" ) -- Search folders starting with "props_"
			browser:SetFileTypes( "*.txt" ) -- File type filter
			browser:SetOpen( true ) -- Opens the tree ( same as double clicking )
			browser:SetCurrentFolder( "melonwars/contraptions" ) -- Set the folder to use

			function browser:OnSelect( path, pnl )
				LocalPlayer().contrapCost, LocalPlayer().contrapPower = SelectContraption(LocalPlayer(), path, contraptionName, contraptionCost, contraptionPower)
			end
		end
	end
end

function StartBuildingContraption(assembler, _file, cost, power)
	if (not assembler:GetNWBool("active", false)) then
		if (LocalPlayer().mw_units < cvars.Number("mw_admin_max_units")) then
			if (LocalPlayer().mw_credits >= LocalPlayer().contrapCost or not cvars.Bool("mw_admin_credit_cost")) then
				if (LocalPlayer().contrapPower == 0 or LocalPlayer().mw_units+LocalPlayer().contrapPower <= cvars.Number("mw_admin_max_units")) then
					assembler.nextSlowThink = CurTime()+assembler:GetNWFloat("slowThinkTimer", 0)
					assembler:SetNWFloat("nextSlowThink", CurTime()+assembler:GetNWFloat("slowThinkTimer", 0))
					assembler.unitspawned = false
					assembler:SetNWBool("active", true)
					assembler.player = LocalPlayer()
					assembler.file = _file
					assembler.contrapCost = cost
					assembler.contrapPower = power
					net.Start("RequestContraptionLoadToAssembler")
						net.WriteEntity(assembler)
						net.WriteUInt(LocalPlayer().contrapPower, 16)
						net.WriteString(_file)
						net.WriteFloat(assembler:GetNWFloat("slowThinkTimer", 0))
						--net.WriteVector(LocalPlayer().selectedAssembler:GetPos())
					net.SendToServer()
					if (cvars.Bool("mw_admin_credit_cost")) then
						local newCredits = LocalPlayer().mw_credits-LocalPlayer().contrapCost 
						net.Start("MW_UpdateServerInfo")
							net.WriteInt(cvars.Number("mw_team"), 8)
							net.WriteInt(newCredits, 32)
						net.SendToServer()
						net.Start("MW_UpdateClientInfo")
							net.WriteInt(cvars.Number("mw_team"), 8)
						net.SendToServer()
					end
					LocalPlayer().cmenuframe:Remove()
					LocalPlayer().cmenuframe = nil
				end
			end
		end
	end
end

function SelectContraption(pl, path, contraptionName, contraptionCost, contraptionPower)
	local cost = 0
	local power = 0
	local result = ""
	local fulltable = util.JSONToTable(file.Read( path ))
	local duptable = fulltable.Entities
	local sizePenalty = 0

	if (cvars.Bool("mw_admin_contraptions_beta")) then
		result, cost, power = MW_CalculateContraptionValues(fulltable)
	else
		for _, ent in pairs( duptable ) do
			if (ent.realvalue != nil) then
				cost = cost+ent.realvalue*0.5
			end
			if (ent.population != nil) then
				power = power+ent.population
			end
			if (ent.Pos != nil) then
				sizePenalty = sizePenalty+(ent.Pos):LengthSqr()/1000
			end
		end
	end
	pl.selectedFile = path
	cost = math.Round(cost+sizePenalty)
	pl.selectedAssembler:SetNWFloat("slowThinkTimer", cost/25)
	contraptionName:SetText("Contraption: "..string.sub(path, string.len( "melonwars/contraptions/" )+1, string.len( path )-4))
	contraptionCost:SetText("Cost: "..cost)
	contraptionPower:SetText("Power: "..power)
	return cost, power, "success"
end

function TOOL:DrawHUD()

	--if (SERVER) then
	if (game.SinglePlayer()) then
		local w = 550
		local h = 320
		local x = ScrW()/2-w/2
		local y = ScrH()/2-h/2

		draw.RoundedBox( 15, x, y, w, h, Color(255, 80+80*math.sin(CurTime()*3), 0, 255) )
		draw.RoundedBox( 10, x+10, y+10, w-20, h-20, Color(0,0,0,150) )
		draw.DrawText(
[[I'm sorry, but this tool does not work in
singleplayer. Please, start a 2 player game
if you want to use this addon on your own.

You'll have more fun if you play with
someone. Join the MelonWars:RTS steam
group to find MelonWars players!]],
 "DermaLarge", x+w/2, y+30, Color(255,255,255,255), TEXT_ALIGN_CENTER )
 draw.DrawText("http://steamcommunity.com/groups/melonwarsrts", "Trebuchet24", x+w/2, y+270, Color(255,255,255,255), TEXT_ALIGN_CENTER )

	else
		local pl = LocalPlayer()
		/*if (LocalPlayer().mw_selecting) then
			MWDrawSelectionCircle(LocalPlayer().mw_selectionStartingPoint, LocalPlayer().mw_selectionEndingPoint);
		end */

		local w = 300
		local h = 280
		local x = ScrW()-w
		local y = ScrH()

		local mx = gui.MouseX()
		if (mx == 0) then mx = ScrW()/2 end
		local my = gui.MouseY()
		if (my == 0) then my = ScrH()/2 end

		local cbx, cby = chat.GetChatBoxPos()
		local cbw, cbh = chat.GetChatBoxSize()

		if (pl.cutsceneOpacity > 0) then
			draw.RoundedBox( 5, cbx, cby+30, cbw-30, cbh-80, Color(0,0,0,pl.cutsceneOpacity) )
		end

		if (GetConVar( "mw_admin_cutscene" ):GetBool()) then
			surface.SetFont("DermaLarge")
			surface.SetTextColor( 255, 255, 255, 150 )
			surface.SetTextPos( mx-103, my-17 )
			surface.DrawText( "Toolgun Disabled" )
		elseif (not cvars.Bool("mw_admin_playing")) then
			surface.SetFont("DermaLarge")
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( mx-50, my-17 )
			surface.DrawText( "PAUSED" )
			draw.DrawText( "R: Open menu", "DermaLarge", x+w-10, y-140, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
		else
			local pos = 1
			local teamColor = cvars.Number("mw_team")
			local size = 50
			for i=1, 8 do
				if (teamgrid[i][teamColor] == true) then
					draw.RoundedBox( 0, x-pos*size, y-size, size, size, Color(20,20,20,255) )
					draw.RoundedBox( 5, x+4-pos*size, y+4-size, size-8, size-8, mw_team_colors[i] )
					pos = pos + 1
				end
			end
			if (pos > 1) then
				draw.RoundedBox( 0, x-80, y-size-35, 80, 35, Color(20,20,20,255) )
				draw.DrawText( "Allies:", "DermaLarge", x-40, y-size-32, Color(255,255,255,255), TEXT_ALIGN_CENTER )
			end
		
			pl.mw_action = cvars.Number("mw_action")
		
			local unit_id = cvars.Number("mw_chosen_unit")
			
			if (math.floor(LocalPlayer().mw_spawntime-CurTime()) > 0) then
				draw.DrawText( "Spawning Queue: "..math.floor(LocalPlayer().mw_spawntime-CurTime()), "DermaLarge", ScrW()/2, ScrH()-80, Color(255,255,255,255), TEXT_ALIGN_CENTER )
			end

			local cheats = false
			local cheatsOffset = 500
			local freeunits = !cvars.Bool("mw_admin_credit_cost")
			if (freeunits) then
				cheats = true
				draw.DrawText( "> Infinite Water", "DermaLarge", 10, ScrH()-cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
				cheatsOffset = cheatsOffset + 40
			end

			local freeplacing = cvars.Bool("mw_admin_allow_free_placing")
			if (freeplacing) then
				cheats = true
				draw.DrawText( "> Build anywhere", "DermaLarge", 10, ScrH()-cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
				cheatsOffset = cheatsOffset + 40
			end

			local controlany = cvars.Bool("mw_admin_move_any_team")
			if (controlany) then
				cheats = true
				draw.DrawText( "> Control any team", "DermaLarge", 10, ScrH()-cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
				cheatsOffset = cheatsOffset + 40
			end

			local instantspawn = !cvars.Bool("mw_admin_spawn_time")
			if (instantspawn) then
				cheats = true
				draw.DrawText( "> Instant spawn", "DermaLarge", 10, ScrH()-cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
				cheatsOffset = cheatsOffset + 40
			end

			local immortality = cvars.Bool("mw_admin_immortality")
			if (immortality) then
				cheats = true
				draw.DrawText( "> Immortal units", "DermaLarge", 10, ScrH()-cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
				cheatsOffset = cheatsOffset + 40
			end

			if (cheats) then
				cheatsOffset = cheatsOffset + 20
				draw.DrawText(
[[Go to the admin menu to set these
options, or press the start game button
to start a game and turn off cheats]]
					, "Trebuchet18", 10, ScrH()-cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
				cheatsOffset = cheatsOffset + 30
				draw.DrawText( "Current Cheats:", "DermaLarge", 10, ScrH()-cheatsOffset, Color(255,255,255,100), TEXT_ALIGN_LEFT)
			end

			if (pl.mw_action == 2) then --spawning main building
				local w = 300
				local h = 280
				local x = ScrW()-w
				local y = ScrH()
			
				draw.DrawText( "R: Open menu", "DermaLarge", x+w-10, y-140, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "LMB: Spawn Main Building", "DermaLarge", x+w-10, y-100, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "RMB: Cancel", "DermaLarge", x+w-10, y-60, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
			elseif (pl.mw_action == 1) then --spawning
				local teamColor = Color(100,100,100,255)
				if (cvars.Number("mw_team") != 0) then
					teamColor = mw_team_colors[cvars.Number("mw_team")]
				end
				if (unit_id > 0) then
					
					local w = 300
					local h = 280
					local x = ScrW()-w
					local y = ScrH()-h

					draw.RoundedBox( 15, x, y, w, h, teamColor )
					draw.RoundedBox( 10, x+10, y+10, w-20, h-20, Color(0,0,0,230) )
					draw.DrawText( mw_units[unit_id].name, "DermaLarge", x+w/2, y+30, Color(255,255,255,255), TEXT_ALIGN_CENTER )
					for i=1, mw_units[unit_id].population do
						draw.RoundedBox( 1, x+w/2-(mw_units[unit_id].population+1)/2*15+i*15-7, y+65, 10, 10, Color(255,255,255,255) )
					end
					if (freeunits) then
						draw.DrawText( "- Infinite Water -", "Trebuchet18", x+w/2, y+120, Color(255,255,255,255), TEXT_ALIGN_CENTER )
						draw.DrawText( "To enable water cost go to the admin menu", "Trebuchet18", x+w/2, y+140, Color(255,255,255,255), TEXT_ALIGN_CENTER )
					else
						draw.DrawText( "Cost: "..mw_units[unit_id].cost, "DermaLarge", x+30, y+90, Color(255,255,255,255), TEXT_ALIGN_LEFT )
						if (mw_units[unit_id].welded_cost ~= -1) then
							draw.DrawText( "Welded Cost (RMB): "..mw_units[unit_id].welded_cost, "Trebuchet18", x+30, y+130, Color(255,255,255,255), TEXT_ALIGN_LEFT )
						end
						draw.DrawText( "Water: "..tostring(self:GetOwner().mw_credits), "DermaLarge", x+30, y+160, Color(255,255,255,255), TEXT_ALIGN_LEFT )
					
					end
					draw.DrawText( "Power: "..tostring(self:GetOwner().mw_units).." / "..tostring(cvars.Number("mw_admin_max_units")), "DermaLarge", x+30, y+200, Color(255,255,255,255), TEXT_ALIGN_LEFT )
					
					draw.DrawText( "R: Open menu", "DermaLarge", x+w-10, y-120, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
					draw.DrawText( "LMB: Spawn", "DermaLarge", x+w-10, y-80, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
					draw.DrawText( "RMB: Cancel", "DermaLarge", x+w-10, y-40, Color(255,255,255,255), TEXT_ALIGN_RIGHT )

					--if (math.floor(LocalPlayer().mw_spawntime-CurTime()) > 0) then
					--	draw.DrawText( "Spawning Queue: "..math.floor(LocalPlayer().mw_spawntime-CurTime()), "DermaLarge", ScrW()/2, ScrH()-80, Color(255,255,255,255), TEXT_ALIGN_CENTER )
					--end

					if (cvars.Bool("mw_unit_option_welded") and mw_units[unit_id].welded_cost != -1) then
						draw.RoundedBox( 10, mx-100, my+40, 200, 45, Color(0,0,0,100) )
						draw.DrawText( "Spawning "..mw_units[unit_id].name, "Trebuchet24", mx, my+40, Color(255,255,0,255), TEXT_ALIGN_CENTER )
						draw.DrawText( "as turret", "Trebuchet24", mx, my+60, Color(255,255,0,255), TEXT_ALIGN_CENTER )
						
						draw.RoundedBox( 2, mx-21, my-3, 17, 5, Color(50,50,50))
						draw.RoundedBox( 2, mx+4, my-3, 17, 5, Color(50,50,50))
						draw.RoundedBox( 2, mx-4, my-31-math.sin(CurTime()*3)*10, 7, 12, Color(50,50,50))
						draw.RoundedBox( 1, mx-20, my-2, 15, 3, teamColor)
						draw.RoundedBox( 1, mx+5, my-2, 15, 3, teamColor)
						draw.RoundedBox( 1, mx-3, my-30-math.sin(CurTime()*3)*10, 5, 10, teamColor)
					else
						draw.RoundedBox( 10, mx-160, my+40, 320, 25, Color(0,0,0,100) )
						draw.DrawText( "Spawning "..mw_units[unit_id].name, "Trebuchet24", mx, my+40, Color(255,255,255,200), TEXT_ALIGN_CENTER )
						local a = math.sin(CurTime()*3)*5
						
						draw.RoundedBox( 2, mx-4, my-23-a, 7, 12, Color(50,50,50))
						draw.RoundedBox( 2, mx-4, my+12+a, 7, 12, Color(50,50,50))
						draw.RoundedBox( 2, mx-24-a, my-3, 12, 7, Color(50,50,50))
						draw.RoundedBox( 2, mx+11+a, my-3, 12, 7, Color(50,50,50))
						
						draw.RoundedBox( 1, mx-3, my-22-a, 5, 10, teamColor)
						draw.RoundedBox( 1, mx-3, my+13+a, 5, 10, teamColor)
						draw.RoundedBox( 1, mx-23-a, my-2, 10, 5, teamColor)
						draw.RoundedBox( 1, mx+12+a, my-2, 10, 5, teamColor)
					end
				else
					local name = ""
					draw.RoundedBox( 10, mx-115, my+40, 230, 45, Color(0,0,0,100) )
					draw.DrawText( "Spawning "..name, "Trebuchet24", mx, my+40, Color(255,255,0,255), TEXT_ALIGN_CENTER )
					
					draw.RoundedBox( 2, mx-21, my-3, 17, 5, Color(50,50,50))
					draw.RoundedBox( 2, mx+4, my-3, 17, 5, Color(50,50,50))
					draw.RoundedBox( 2, mx-4, my-31-math.sin(CurTime()*3)*10, 7, 12, Color(50,50,50))
					draw.RoundedBox( 1, mx-20, my-2, 15, 3, teamColor)
					draw.RoundedBox( 1, mx+5, my-2, 15, 3, teamColor)
					draw.RoundedBox( 1, mx-3, my-30-math.sin(CurTime()*3)*10, 5, 10, teamColor)
				end
			elseif(pl.mw_action == 0) then -- LocalPlayer().mw_selecting
				local teamColor = self:GetOwner().mw_hudColor
				
				local w = 300
				local h = 150
				local x = ScrW()-w
				local y = ScrH()-h
				
				draw.DrawText( "R: Open menu", "DermaLarge", x+w-10, y-235, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "LMB (Hold and drag): Select", "DermaLarge", x+w-10, y-195, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "LMB double click: Select unit type", "CloseCaption_Normal", x+w-10, y-165, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "Hold Shift to add to selection", "CloseCaption_Normal", x+w-10, y-145, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "RMB: Move selected", "DermaLarge", x+w-10, y-115, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "Alt + RMB: force target or follow ally", "CloseCaption_Normal", x+w-10, y-85, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "Shift + RMB: Add waypoint", "CloseCaption_Normal", x+w-10, y-65, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "Left Ctrl: Stop selected units", "CloseCaption_Normal", x+w-10, y-45, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				--draw.DrawText( "Left Ctrl + RMB: Disperse", "CloseCaption_Normal", x+w-10, y-25, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				
				draw.RoundedBox( 15, x, y, w, h, teamColor )
				draw.RoundedBox( 10, x+10, y+10, w-20, h-20, Color(0,0,0,230) )
				if (freeunits) then
					draw.DrawText( "- Infinite Water -", "Trebuchet18", x+w/2, y+20, Color(255,255,255,255), TEXT_ALIGN_CENTER )
					draw.DrawText( "To enable water cost go to the admin menu", "Trebuchet18", x+w/2, y+40, Color(255,255,255,255), TEXT_ALIGN_CENTER )
				else
					draw.DrawText( "Water: "..tostring(self:GetOwner().mw_credits), "DermaLarge", x+30, y+30, Color(255,255,255,255), TEXT_ALIGN_LEFT )
				end
				draw.DrawText( "Power: "..tostring(self:GetOwner().mw_units).." / "..tostring(cvars.Number("mw_admin_max_units")), "DermaLarge", x+30, y+70, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			elseif(pl.mw_action == 3) then
			
				local prop_id = self:GetOwner():GetInfoNum("mw_chosen_prop", 1)
		
				local teamColor = self:GetOwner().mw_hudColor
				local w = 300
				local h = 250
				local x = ScrW()-w
				local y = ScrH()-h
				
				draw.RoundedBox( 15, x, y, w, h, teamColor )
				draw.RoundedBox( 10, x+10, y+10, w-20, h-20, Color(0,0,0,230) )
				draw.DrawText( "Base Builder", "DermaLarge", x+w/2, y+30, Color(255,255,255,255), TEXT_ALIGN_CENTER )
				draw.DrawText( mw_base_props[prop_id].name, "DermaLarge", x+w-20, y+70, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "HP: "..mw_base_props[prop_id].hp, "DermaLarge", x+30, y+100, Color(255,255,255,255), TEXT_ALIGN_LEFT )
				draw.DrawText( "Cost: "..mw_base_props[prop_id].cost, "DermaLarge", x+30, y+130, Color(255,255,255,255), TEXT_ALIGN_LEFT )
				draw.DrawText( "Water: "..tostring(self:GetOwner().mw_credits), "DermaLarge", x+30, y+180, Color(255,255,255,255), TEXT_ALIGN_LEFT )
				
			elseif(pl.mw_action == 4) then
				local teamColor = mw_team_colors[cvars.Number("mw_team")]--self:GetOwner().mw_hudColor
				local w = 300
				local h = 150
				local x = ScrW()-w
				local y = ScrH()-h
				
				draw.RoundedBox( 10, mx-125, my+40, 250, 25, Color(0,0,0,100) )
				draw.DrawText( "Click on your contraption", "Trebuchet24", mx, my+40, Color(255,255,255,200), TEXT_ALIGN_CENTER )
						

				draw.DrawText( "R: Open menu", "DermaLarge", x+w-10, y-140, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "LMB: Save Contraption", "DermaLarge", x+w-10, y-100, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "RMB: Cancel", "DermaLarge", x+w-10, y-60, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				
				draw.RoundedBox( 15, x, y, w, h, teamColor )
				draw.RoundedBox( 10, x+10, y+10, w-20, h-20, Color(0,0,0,230) )
				draw.DrawText( "Water: "..tostring(self:GetOwner().mw_credits), "DermaLarge", x+30, y+30, Color(255,255,255,255), TEXT_ALIGN_LEFT )
				draw.DrawText( "Power: "..tostring(self:GetOwner().mw_units).." / "..tostring(cvars.Number("mw_admin_max_units")), "DermaLarge", x+30, y+70, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			elseif(pl.mw_action == 5) then
				local teamColor = mw_team_colors[cvars.Number("mw_team")]--self:GetOwner().mw_hudColor
				local w = 160
				local h = 30
				local x = ScrW()
				local y = ScrH()
				
				draw.DrawText( "R: Open menu", "DermaLarge", x-10, y-280, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "Hold LMB: Sell target", "DermaLarge", x-10, y-240, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "RMB: Cancel", "DermaLarge", x-10, y-200, Color(255,255,255,255), TEXT_ALIGN_RIGHT )

				draw.RoundedBox( 3, ScrW()/2-w/2, ScrH()/2+20, w, h, Color(0,0,0, 200) )
				draw.RoundedBox( 0, ScrW()/2-w/2+3, ScrH()/2+20+3, pl.mw_sell*(w-6), h-6, Color(0,230,0, 200) )
				draw.DrawText( "Hold click to sell", "Trebuchet18", ScrW()/2, ScrH()/2+25, Color(255,255,255,255), TEXT_ALIGN_CENTER )
			
				draw.RoundedBox( 15, x-300, y-150, 300, 150, teamColor )
				draw.RoundedBox( 10, x-300+10, y-140, 300-20, 130, Color(0,0,0,230) )
				draw.DrawText( "Water: "..tostring(self:GetOwner().mw_credits), "DermaLarge", x-270, y-100, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			elseif(pl.mw_action == 6) then
				local teamColor = mw_team_colors[cvars.Number("mw_team")]--self:GetOwner().mw_hudColor
				local w = 300
				local h = 150
				local x = ScrW()-w
				local y = ScrH()-h
				
				draw.RoundedBox( 10, mx-130, my+40, 260, 25, Color(0,0,0,100) )
				draw.DrawText( "Click to spawn contraption", "Trebuchet24", mx, my+40, Color(255,255,255,200), TEXT_ALIGN_CENTER )

				draw.DrawText( "R: Open menu", "DermaLarge", x+w-10, y-140, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "LMB: Load Contraption", "DermaLarge", x+w-10, y-100, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				draw.DrawText( "RMB: Cancel", "DermaLarge", x+w-10, y-60, Color(255,255,255,255), TEXT_ALIGN_RIGHT )
				
				draw.RoundedBox( 15, x, y, w, h, teamColor )
				draw.RoundedBox( 10, x+10, y+10, w-20, h-20, Color(0,0,0,230) )
				draw.DrawText( "Water: "..tostring(self:GetOwner().mw_credits), "DermaLarge", x+30, y+30, Color(255,255,255,255), TEXT_ALIGN_LEFT )
				draw.DrawText( "Power: "..tostring(self:GetOwner().mw_units).." / "..tostring(cvars.Number("mw_admin_max_units")), "DermaLarge", x+30, y+70, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			end

			if (cvars.Bool("mw_income_indicator")) then
				for k, v in pairs(incomeIndicators) do
					local time = CurTime()-v.time
					local text = tostring(v.value)
					local indColor = Color(255,0,0,200-time*100)
					if (v.value > 0) then
						text = "+"..text
						indColor = Color(0,255,0,200-time*100)
					end
					draw.DrawText( text, "DermaLarge", ScrW()-w-time*40, ScrH()-150+k*10, indColor, TEXT_ALIGN_RIGHT )
				end
			end
			
			surface.SetDrawColor(self:GetOwner().mw_hudColor)
			
			if (pl.mw_action != 16) then
				for i=0, 3 do
					surface.DrawOutlinedRect( mx-5-i, my-4-i, 9+i*2, 9+i*2 )
				end
				surface.SetDrawColor(Color(0,0,0,255))
				surface.DrawOutlinedRect( mx-5+1, my-4+1, 9-1*2, 9-1*2 )
				surface.DrawOutlinedRect( mx-5-4, my-4-4, 9+4*2, 9+4*2 )
			end
		end
		/*
		if (cvars.Bool("mw_admin_player_colors")) then
			for k, v in pairs(player:GetAll()) do
				//if (v != self:GetOwner()) then
					local weapon = LocalPlayer():GetActiveWeapon()
					if (IsValid(weapon)) then
						if ( weapon:GetClass() == "gmod_tool" ) then // TODO: Here i should deactivate the spawnmenu once the game started
							//if (IsValid(v:GetTool())) then
							//	if (v:GetTool().Mode == "melon_universal_tool") then
									local pos = v:GetPos()+Vector(0,0,85)
									local distance = EyePos():Distance(pos)
									local screenPos = pos:ToScreen()
									local size = 10000/distance
									local teamColor = mw_team_colors[v:GetInfoNum( "mw_team", -1 )]
									size = math.max(size, 15)
									draw.RoundedBox( size/2, screenPos.x-size/2, screenPos.y-size/2, size, size, Color(0,0,0,255) )
									size = size-4
									draw.RoundedBox( size/2, screenPos.x-size/2, screenPos.y-size/2, size, size, Color(255,255,255,255) )
									size = size-2
									draw.RoundedBox( size/2, screenPos.x-size/2, screenPos.y-size/2, size, size, teamColor )
							//	end
							//end
						end
					end
				//end
			end
		end*/
	end
end

function MW_isInRange( vector, teamIndex )
	local foundEnts = ents.FindByClass( "ent_melon_main_building" )
	local canBuild = false
	for k, v in pairs( foundEnts ) do
		if (vector:Distance(v:GetPos()) < 800) then
			if (v:GetNWInt("mw_melonTeam", 0) == teamIndex) then
				canBuild = true
				return true
			end
		end
	end

	foundEnts = ents.FindByClass( "ent_melon_main_unit" )
	canBuild = false
	for k, v in pairs( foundEnts ) do
		if (vector:Distance(v:GetPos()) < 210) then
			if (v:GetNWInt("mw_melonTeam", 0) == teamIndex) then
				canBuild = true
				return true
			end
		end
	end

    foundEnts = ents.FindByClass( "ent_melon_main_building_grand_war" )
	canBuild = false
	for k, v in pairs( foundEnts ) do
		if (vector:Distance(v:GetPos()) < 1600) then
			if (v:GetNWInt("mw_melonTeam", 0) == teamIndex) then
				canBuild = true
				return true
			end
		end
	end

	local foundPoints = ents.FindByClass( "ent_melon_outpost_point" )
	
	if (not canBuild) then
		for k, v in pairs( foundPoints ) do
			if (vector:Distance(v:GetPos()) < 600) then
				//if (v:GetNWInt("capTeam", 0) == teamIndex) then
				if (teamgrid == nil or teamgrid[v:GetNWInt("capTeam", 0)] == nil or teamgrid[v:GetNWInt("capTeam", 0)][teamIndex] == nil) then
					canBuild = v:GetNWInt("capTeam", 0) == teamIndex
				elseif (v:GetNWInt("capTeam", 0) == teamIndex or teamgrid[v:GetNWInt("capTeam", 0)][teamIndex]) then
					canBuild = true
				end
			end
		end
	end
	return canBuild
end

function MW_noEnemyNear( vector, teamIndex )
	local foundEnts = ents.FindInSphere( vector , 300 )
	local canBuild = true
	for k, v in pairs( foundEnts ) do
		if (v.Base == "ent_melon_base") then
			if (v:GetNWInt("mw_melonTeam", 0) ~= teamIndex) then
				if (v:GetNWInt("mw_melonTeam", 0) ~= 0) then
					if (not teamgrid[v:GetNWInt("mw_melonTeam", 0)][teamIndex]) then
						canBuild = false
					end
				end
			end
		end
	end
	return canBuild
end

net.Receive( "UpdateClientTeams", function( len, pl )
	teamgrid = net.ReadTable()
end )

if (CLIENT) then
	language.Add( "tool.melon_universal_tool.name", "" )
	language.Add( "tool.melon_universal_tool.desc", "" )
	language.Add( "tool.melon_universal_tool.0", "" )
	--language.Add( "Unique_Name", "MelonWars" )
	language.Add( "undone.melon_universal_tool", "Marine has been undone." )
end