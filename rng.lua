require('rnghelper')
 
function get_sets()
    mote_include_version = 2
    include('Mote-Include.lua')
end
 
function job_setup()
    state.Buff.Barrage = buffactive.Barrage or false
    state.Buff.Flurry = ((1 and buffactive[265]) or (2 and buffactive[581]))
    state.Buff['Unlimited Shot'] = buffactive['Unlimited Shot'] or false
    state.Utsusemi = 2
    flurry_level = 1
    PlayerH = 0
end
 
function user_setup()

    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.OffenseMode:options('Normal', 'Acc')
	autofacetarget = true
    DefaultAmmo = {['Fail-Not'] = "Chrono Arrow", ['Annihilator'] = "Eradicating Bullet", ['Fomalhaut'] = "Chrono Bullet", ["Phaosphaelia"] = "Achiyalabopa arrow", ["Lionsquall"] = "Achiyalabopa bullet", ["Gastraphetes"] = "Quelling Bolt" }
    U_Shot_Ammo = {['Fail-Not'] = "Chrono Arrow", ['Annihilator'] = "Eradicating Bullet", ['Fomalhaut'] = "Chrono Bullet"}
    send_command('bind !numpad1 gs rh enable')
    send_command('bind !numpad2 gs rh disable')
    send_command('bind !numpad3 gs rh clear') 
     send_command('bind !numpad4 gs rh set "Last Stand"') 
     send_command('bind !numpad5 gs rh set "Wildfire"')
     send_command('bind ^numpad5 gs rh set "Hot shot"')
     send_command('bind !numpad6 gs rh set "Trueflight"') 
     send_command('bind !numpad7 gs rh set "Coronach"') 
     send_command('bind !numpad8 gs rh set')
     send_command('bind ^numpad1 send @all gs rh enable')
     send_command('bind ^numpad2 send @all gs rh disable')
     send_command('bind ^numpad3 send @all gs rh clear')
     send_command('bind ^numpad6 send jyouyaya gs rh set Leaden Salute; gs rh set Trueflight')
     send_command('bind !f3 rm shoot; input /ra <t>') 
     send_command('bind ^f3 rm ws')
     send_command('bind !f2 rm multishot; input /ja "Double Shot" <me>')
 
     
     select_default_macro_book() 
          
end
 
function init_gear_sets()


    sets.idle = {
    head="Genmei Kabuto",
    body="Mekosu. Harness",
    hands="Meg. Gloves +2",
    legs="Mummu Kecks +1",
    feet="Meg. Jam. +2",
    neck="Scout's Gorget +1",
    waist="Flume Belt +1",
    left_ear="Eabani Earring",
    right_ear="Infused Earring",
    left_ring="Paguroidea Ring",
    right_ring="Sheltered Ring",
    back="Solemnity Cape",
}
    
    
    ---Melee TP Sets---
    
    sets.engaged = {
      
    head={ name="Adhemar Bonnet", augments={'DEX+10','AGI+10','Accuracy+15',}},
    body="Mummu jacket +2",
    hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    feet={ name="Herculean Boots", augments={'Accuracy+19 Attack+19','"Triple Atk."+2','AGI+2','Accuracy+11','Attack+12',}},
    neck="Iskur Gorget",
    waist="Kentarch Belt +1",
    left_ear="Suppanomimi",
    right_ear="Eabani Earring",
    left_ring="Epona's Ring",
    right_ring="Rajas Ring",
    back={ name="Mecisto. Mantle", augments={'Cap. Point+43%','Accuracy+1','DEF+10',}},
}

	---High Accuracy Melee TP---
	
    sets.engaged.Acc={
    
    head={ name="Adhemar Bonnet", augments={'DEX+10','AGI+10','Accuracy+15',}},
    body="Mummu Jacket +2",
    hands={ name="Adhemar Wristbands", augments={'DEX+10','AGI+10','Accuracy+15',}},
    legs={ name="Carmine Cuisses +1", augments={'Accuracy+20','Attack+12','"Dual Wield"+6',}},
    feet={ name="Herculean Boots", augments={'Accuracy+19 Attack+19','"Triple Atk."+2','AGI+2','Accuracy+11','Attack+12',}},
    neck="Iskur Gorget",
    waist="Kentarch Belt +1",
    left_ear="Suppanomimi",
    right_ear="Eabani Earring",
    left_ring="Epona's Ring",
    right_ring="Rajas Ring",
    back={ name="Mecisto. Mantle", augments={'Cap. Point+43%','Accuracy+1','DEF+10',}},
}

	--- No Flurry Precast ---
	-- Snapshot (10 from merits) : 76 (70 Cap)
	-- Rapid Shot (35 from Levels/Merits) : 61
	-- Velocity Shot  : 27%
	
    sets.precast.RA = {
    
    head={ name="Taeon Chapeau", augments={'Accuracy+18','"Snapshot"+4','"Snapshot"+5',}}, -- 9 Snapshot
    body="Oshosi Vest", -- 12 Snapshot
    hands="Carmine Fin. Ga. +1", -- 8 Snapshot , 11 Rapid Shot
    legs={ name="Adhemar Kecks", augments={'AGI+10','"Rapid Shot"+10','Enmity-5',}}, -- 9 Snapshot, 10 Rapid Shot
    feet="Meg. Jam. +2", -- 10 Snapshot
    neck="Scout's Gorget +1", -- 3 Snapshot
    waist="Yemaya Belt", -- 5 Rapid Shot
    left_ear="Telos Earring",
    right_ear="Enervating Earring",
    left_ring="Rajas Ring",
    right_ring="Petrov Ring",
    back={ name="Belenus's Cape", augments={'"Snapshot"+10',}}, --10 Snapshot, 2% Velocity Shot
}

	--- Flurry I (+15 Snapshot) Precast ---
	-- Snapshot (10 from merits) : 74 (70 Cap)
	-- Rapid Shot (35 from Levels/Merits) : 61
	-- Velocity Shot: 34%
	sets.precast.RA.Flurry = {}
--	sets.precast.RA.Gastraphetes.Flurry = {}
   sets.precast.RA.Flurry[1] = {
    head={ name="Taeon Chapeau", augments={'Accuracy+18','"Snapshot"+4','"Snapshot"+5',}}, --9
    body="Amini Caban +1",  --7% Velocity Shot
    hands="Carmine Fin. Ga. +1", -- 8 Snapshot , 11 Rapid Shot
    legs={ name="Adhemar Kecks", augments={'AGI+10','"Rapid Shot"+10','Enmity-5',}},  -- 9 Snapshot, 10 Rapid Shot
    feet="Meg. Jam. +2",  -- 10 Snapshot
    neck="Scout's Gorget +1", -- 3 Snapshot
    waist="Yemaya Belt", -- 5 Rapid Shot
    left_ear="Telos Earring",
    right_ear="Enervating Earring",
    left_ring="Rajas Ring",
    right_ring="Petrov Ring",
    back={ name="Belenus's Cape", augments={'"Snapshot"+10',}}, --10 Snapshot, 2% Velocity Sho
}

	--- Flurry II (+30 Snapshot) Precast ---
	-- Snapshot (10 from merits) : 70 (70 Cap)
	-- Rapid Shot (35 from Levels/Merits) : 89
	-- Velocity Shot: 34%   
  
      sets.precast.RA.Flurry[2] = {
      
    head="Orion Beret +3", -- 18 Rapid Shot
    body="Amini Caban +1", -- 7% Velocity Shot
    hands="Carmine Fin. Ga. +1", -- 8 Snapshot , 11 Rapid Shot
    legs={ name="Adhemar Kecks", augments={'AGI+10','"Rapid Shot"+10','Enmity-5',}}, -- 9 Snapshot, 10 Rapid Shot
    feet={ name="Pursuer's Gaiters", augments={'Rng.Acc.+10','"Rapid Shot"+10','"Recycle"+15',}},  -- 10 Rapid Shot
    neck="Scout's Gorget +1", -- 3 Snapshot
    waist="Yemaya Belt", -- 5 Rapid Shot
    left_ear="Telos Earring",
    right_ear="Enervating Earring",
    left_ring="Rajas Ring",
    right_ring="Petrov Ring",
    back={ name="Belenus's Cape", augments={'"Snapshot"+10',}}, --10 Snapshot, 2% Velocity Sho
}

--- Gastra Preshot ---

	--- No Flurry Precast ---
	-- Snapshot (10 from merits) : 69 (70 Cap)
	-- Rapid Shot (35 from Levels/Merits) : 61
	-- Velocity Shot  : 34%

 sets.precast.RA.Gastraphetes = {
 
    head={ name="Taeon Chapeau", augments={'Accuracy+18','"Snapshot"+4','"Snapshot"+5',}}, --9
    body="Amini Caban +1",  --7% Velocity Shot
    hands="Carmine Fin. Ga. +1", -- 8 Snapshot , 11 Rapid Shot
    legs={ name="Adhemar Kecks", augments={'AGI+10','"Rapid Shot"+10','Enmity-5',}},  -- 9 Snapshot, 10 Rapid Shot
    feet="Meg. Jam. +2",  -- 10 Snapshot
    neck="Scout's Gorget +1", -- 3 Snapshot
    waist="Yemaya Belt", -- 5 Rapid Shot
    left_ear="Telos Earring",
    right_ear="Enervating Earring",
   left_ring="Rajas Ring",
    right_ring="Petrov Ring",
    back={ name="Belenus's Cape", augments={'"Snapshot"+10',}}, --10 Snapshot, 2% Velocity Sho
 
 
 }
 
 sets.precast.RA.Gastraphetes.Flurry = {}
 
 	--- Flurry I (+15 Snapshot) Precast ---
	-- Snapshot (10 from merits) : 75 (70 Cap)
	-- Rapid Shot (35 from Levels/Merits) : 79
	-- Velocity Shot: 34%
 
    sets.precast.RA.Gastraphetes.Flurry[1] = {
     head="Orion Beret +3", -- 18 Rapid Shot
    body="Amini Caban +1",  --7% Velocity Shot
    hands="Carmine Fin. Ga. +1", -- 8 Snapshot , 11 Rapid Shot
    legs={ name="Adhemar Kecks", augments={'AGI+10','"Rapid Shot"+10','Enmity-5',}},  -- 9 Snapshot, 10 Rapid Shot
    feet="Meg. Jam. +2",  -- 10 Snapshot
    neck="Scout's Gorget +1", -- 3 Snapshot
    waist="Yemaya Belt", -- 5 Rapid Shot
    left_ear="Telos Earring",
      right_ear="Enervating Earring",
    left_ring="Rajas Ring",
    right_ring="Petrov Ring",
    back={ name="Belenus's Cape", augments={'"Snapshot"+10',}}, --10 Snapshot, 2% Velocity Shot
}

	--- Flurry II (+30 Snapshot) Precast ---
	-- Snapshot (10 from merits) : 70 (70 Cap)
	-- Rapid Shot (35 from Levels/Merits) : 98
	-- Velocity Shot: 34%   
  
      sets.precast.RA.Gastraphetes.Flurry[2] = {
      
    head="Orion Beret +3", -- 18 Rapid Shot
    body="Amini Caban +1", -- 7% Velocity Shot
    hands="Carmine Fin. Ga. +1", -- 8 Snapshot , 11 Rapid Shot
   legs="Pursuer's Pants", -- 19 Raoud Shot
    feet={ name="Pursuer's Gaiters", augments={'Rng.Acc.+10','"Rapid Shot"+10','"Recycle"+15',}},  -- 10 Rapid Shot
    neck="Scout's Gorget +1", -- 3 Snapshot
    waist="Yemaya Belt", -- 5 Rapid Shot
    left_ear="Telos Earring",
    right_ear="Enervating Earring",
    left_ring="Rajas Ring",
    right_ring="Petrov Ring",
    back={ name="Belenus's Cape", augments={'"Snapshot"+10',}}, --10 Snapshot, 2% Velocity Sho--
}
   
	-- RA Midcast --
	-- +50 TP 89% of the time (Recycle)
	-- +62 STP 
   
    
    sets.midcast.RA = {
    head={ name="Arcadian Beret +2", augments={'Enhances "Recycle" effect',}},
    body="Oshosi Vest", -- 7 STP
    hands={ name="Adhemar Wristbands", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}}, -- 6 STP
    legs={ name="Adhemar Kecks", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}}, -- 7 STP
    feet="Meg. Jam. +2",
    neck="Iskur Gorget", -- 8 STP
    waist="Yemaya Belt", -- 5 STP 
    left_ear="Telos Earring", -- 5 STP
    right_ear="Enervating Earring", -- 4 STP
    left_ring="Rajas Ring", -- 5 STP
    right_ring="Petrov Ring", -- 5 STP
    back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10',}}, -- 10 STP
}

	-- Doubleshot Set --
	-- 49 STP	
	-- Doubleshot Rate: 80
	
	
sets.midcast.RA.DoubleShot = {
	head={ name="Arcadian Beret +2", augments={'Enhances "Recycle" effect',}},
	body="Arcadian Jerkin +3",
    hands="Oshosi Gloves",
    legs="Oshosi Trousers",
    feet="Oshosi Leggings",
    neck="Iskur Gorget", -- 8 STP
    waist="Yemaya Belt", -- 5 STP 
    left_ear="Telos Earring", -- 5 STP
    right_ear="Enervating Earring", -- 4 STP
    left_ring="Rajas Ring", -- 5 STP
    right_ring="Petrov Ring", -- 5 STP
    back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10',}}, -- 10 STP
    
    }
    
	-- High ACC RA set (Not used currently)       	

    sets.midcast.RA.Acc = set_combine(sets.midcast.RA, {   
    })

	-- General WS set, Setup for Last Stand --
	
    sets.precast.WS ={
 
    head="Orion Beret +3",
    body={ name="Herculean Vest", augments={'Rng.Acc.+16 Rng.Atk.+16','Weapon skill damage +4%','AGI+6',}},
    hands="Meg. Gloves +2",
    legs={ name="Adhemar Kecks", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}},
    feet={ name="Herculean Boots", augments={'Rng.Acc.+25 Rng.Atk.+25','Weapon skill damage +2%','AGI+7','Rng.Acc.+6',}},
    neck="Scout's Gorget +1",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Regal Ring",
    right_ring="Dingir Ring",
    back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},
}    

	--Jishnu's Radiance Set, Not Setup--
	    
    sets.precast.WS["Jishnu's Radiance"] ={ 
    head="Meghanada Visor +1",
    body="Mummu Jacket +2",
    hands="Meg. Gloves +1",
    legs={ name="Herculean Trousers", augments={'Accuracy+1','Weapon skill damage +4%','AGI+1','Rng.Acc.+15','Rng.Atk.+2',}},
    feet="Thereoid Greaves",
    neck="Light Gorget",
    waist="Light Belt",
    left_ear="Mache Earring",
    right_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +25',}},
    left_ring="Rajas Ring",
    right_ring="Begrudging Ring",
    back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10',}},
}
	
	-- WS accuracy toggle --
	
	
    sets.precast.WS.Acc = set_combine(sets.precast.WS)
    
    
    ---Wildfire Set---
    
    sets.precast.WS.Wildfire = {     

--    ammo="Orichalc. Bullet",
    head={ name="Herculean Helm", augments={'Potency of "Cure" effect received+7%','"Mag.Atk.Bns."+30','Mag. Acc.+17 "Mag.Atk.Bns."+17',}},
    body={ name="Herculean Vest", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +2%','STR+5','"Mag.Atk.Bns."+12',}},
    hands={ name="Herculean Gloves", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +3%','STR+1','Mag. Acc.+8','"Mag.Atk.Bns."+12',}},
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','INT+8','Mag. Acc.+12','"Mag.Atk.Bns."+9',}},
    feet={ name="Herculean Boots", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Crit. hit damage +1%','MND+8','Mag. Acc.+13','"Mag.Atk.Bns."+14',}},
    neck="Scout's Gorget +1",
    waist="Eschan Stone",
    left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
    right_ear="Friomisi Earring",
    left_ring="Weather. Ring",
    right_ring="Dingir Ring",
    back={ name="Belenus's Cape", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
}


	--Hotshot Set--

    sets.precast.WS.Hotshot ={     

--    ammo="Orichalc. Bullet",
    head="Orion Beret +3",
    body={ name="Herculean Vest", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +2%','STR+5','"Mag.Atk.Bns."+12',}},
    hands={ name="Herculean Gloves", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +3%','STR+1','Mag. Acc.+8','"Mag.Atk.Bns."+12',}},
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','INT+8','Mag. Acc.+12','"Mag.Atk.Bns."+9',}},
    feet={ name="Herculean Boots", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Crit. hit damage +1%','MND+8','Mag. Acc.+13','"Mag.Atk.Bns."+14',}},
    neck="Scout's Gorget +1",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
    right_ear="Friomisi Earring",
    left_ring="Regal Ring",
    right_ring="Dingir Ring",
    back={ name="Belenus's Cape", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
}

	---Trueflight Set---

	
    sets.precast.WS.Trueflight = {     

--    ammo="Orichalc. Bullet",
    head={ name="Herculean Helm", augments={'Potency of "Cure" effect received+7%','"Mag.Atk.Bns."+30','Mag. Acc.+17 "Mag.Atk.Bns."+17',}},
    body={ name="Herculean Vest", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +2%','STR+5','"Mag.Atk.Bns."+12',}},
    hands={ name="Herculean Gloves", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +3%','STR+1','Mag. Acc.+8','"Mag.Atk.Bns."+12',}},
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','INT+8','Mag. Acc.+12','"Mag.Atk.Bns."+9',}},
    feet={ name="Herculean Boots", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Crit. hit damage +1%','MND+8','Mag. Acc.+13','"Mag.Atk.Bns."+14',}},
    neck="Scout's Gorget +1",
    waist="Eschan Stone",
    left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
    right_ear="Friomisi Earring",
    left_ring="Weather. Ring",
    right_ring="Dingir Ring",
    back={ name="Belenus's Cape", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
}
-- Mab + 202 + 35/ 34 Weapons
-- WSD + 17%
-- 250 TP Bonus
-- Light Elemental + 10
-- Macc + 151 + 25 
-- Light Elemental + 10


	---Coronach Set---

 sets.precast.WS.Coronach ={
 
    head="Orion Beret +3",
    body={ name="Herculean Vest", augments={'Rng.Acc.+16 Rng.Atk.+16','Weapon skill damage +4%','AGI+6',}},
    hands="Meg. Gloves +2",
    legs={ name="Adhemar Kecks", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}},
    feet={ name="Herculean Boots", augments={'Rng.Acc.+25 Rng.Atk.+25','Weapon skill damage +2%','AGI+7','Rng.Acc.+6',}},
    neck="Scout's Gorget +1",
    waist="Fotia Belt",
    left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +250',}},
    right_ear="Ishvara Earring",
    left_ring="Regal Ring",
    right_ring="Dingir Ring",
    back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},
}
 
 	--- Barrage Set: Barrage +2 ---

    sets.buff.Barrage = {
    
    
    head="Orion Beret +3",
    body="Mummu Jacket +2",
    hands="Orion Bracers +2",
    legs={ name="Adhemar Kecks", augments={'AGI+10','Rng.Acc.+15','Rng.Atk.+15',}},
    feet="Meg. Jam. +2",
    neck="Iskur Gorget",
    waist="Kwahu Kachina Belt",
    left_ear="Telos Earring",
    right_ear="Enervating Earring",
    left_ring="Regal Ring",
    right_ring="Rajas Ring",
    back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10',}},
}
  
  --Unused Accuracy Sets. Commented out for now---
--    sets.precast.WS.Wildfire.Acc = set_combine(sets.precast.WS.Wildfire)
--    sets.precast.WS.Trueflight.Acc = set_combine(sets.precast.WS.Trueflight)
--    sets.precast.WS['Last Stand'] = {
 
--    head="Orion Beret +3",
--    body={ name="Herculean Vest", augments={'Rng.Atk.+15','Weapon skill damage +3%','DEX+9','Rng.Acc.+4',}},
--    hands="Meg. Gloves +2",
--    legs={ name="Herculean Trousers", augments={'Accuracy+1','Weapon skill damage +4%','AGI+1','Rng.Acc.+15','Rng.Atk.+2',}},
--    feet={ name="Herculean Boots", augments={'Weapon skill damage +3%','AGI+8','Rng.Acc.+10','Rng.Atk.+14',}},
--    neck="Fotia Gorget",
--    waist="Light Belt",
--    left_ear={ name="Moonshade Earring", augments={'"Mag.Atk.Bns."+4','TP Bonus +25',}},
--    right_ear="Ishvara Earring",
--    left_ring="Warp Ring",
--    right_ring="Petrov Ring",
--    back={ name="Belenus's Cape", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%',}},
--}
--    sets.precast.WS['Last Stand'].Acc = set_combine(sets.precast.WS.LastStand)
    sets.precast.FC = {
        head={ name="Carmine Mask +1", augments={'Accuracy+20','Mag. Acc.+12','"Fast Cast"+4',}},
        body={ name="Taeon Tabard", augments={'Accuracy+15','"Fast Cast"+5','DEX+4',}},
        hands={ name="Leyline Gloves", augments={'Accuracy+15','Mag. Acc.+15','"Mag.Atk.Bns."+15','"Fast Cast"+3',}},
        legs={ name="Herculean Trousers", augments={'Mag. Acc.+10','"Fast Cast"+5','MND+3','"Mag.Atk.Bns."+6',}},
        feet={ name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}},
        neck="Orunmila's Torque",
        waist="Goading Belt",
        left_ear="Etiolation Earring",
        right_ear="Loquac. Earring",
        left_ring="Weather. Ring",
        right_ring="Rahab Ring",
        back={ name="Belenus's Cape", augments={'"Fast Cast"+10',}},
    }
    sets.Kiting = { legs="Carmine Cuisses +1"}
    sets.precast.JA.Scavenge = { feet="Orion Socks"}
    sets.precast.JA.Shadowbind = { hands="Orion Bracers +2"}
    sets.precast.JA.Sharpshot = { legs="Orion Braccae +1"}
    sets.precast.JA['Bounty Shot'] = {
     --   head={ name="Herculean Helm", augments={'Haste+1','Crit.hit rate+4','"Treasure Hunter"+2','Mag. Acc.+1 "Mag.Atk.Bns."+1',}},
     --   hands={ name="Herculean Gloves", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','Accuracy+2 Attack+2','"Treasure Hunter"+2',}},
    }
end
 
local utsusemi = {
    ["Utsusemi: Ichi"] = 1,
    ["Utsusemi: Ni"] = 2,
    ["Utsusemi: San"] = 3,
}
 
function job_precast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' then
        state.CombatWeapon:set(player.equipment.range)
    end
    if spell.action_type == 'Ranged Attack' or (spell.type == 'WeaponSkill' and (spell.skill == 'Marksmanship' or spell.skill == 'Archery')) then
        check_ammo(spell, action, spellMap, eventArgs)
    end
end

function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' and state.Buff.Flurry then
        equip(get_precast_set(spell, spellMap).Flurry[flurry_level])
    end
    if ((spell.name == 'Trueflight') or (spell.name == 'Wildfire')) and ((spell.element == world.weather_element) or (spell.element == world.day_element)) then
        equip({ waist="Hachirin-no-Obi"})
    end
end
 
function job_midcast(spell, action, spellMap, eventArgs)
 if spell.action_type == 'Ranged Attack' then
        if buffactive['Double Shot'] then
            equip(sets.midcast.RA.DoubleShot)
        end
    elseif spellMap == 'Utsusemi' then
        if state.Utsusemi > utsusemi[spell.name] then
            if buffactive['Copy Image'] then
                windower.ffxi.cancel_buff(66)
            elseif buffactive['Copy Image (2)'] then
                windower.ffxi.cancel_buff(444)
            elseif buffactive['Copy Image (3)'] then
                windower.ffxi.cancel_buff(445)
            elseif buffactive['Copy Image (4+)'] then
                windower.ffxi.cancel_buff(446)
            end
        end
    end
end




 
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' then
        if buffactive['Double Shot'] then
            equip(sets.midcast.RA.DoubleShot)
        end
        if state.Buff.Barrage then
            equip(sets.buff.Barrage)
        end
    end
 end
 

 
function job_aftercast(spell, action, spellMap, eventArgs)
    if (not spell.interrupted) and spellMap == 'Utsusemi' then
        state.Utsusemi = utsusemi[spell.name]
    end
end

function job_buff_change(buff, gain, eventArgs)
	if buff == 'Flurry' and gain then
		state.Buff.Flurry = ((1 and buffactive[265]) or (2 and buffactive[581]))
	end
end
 
function check_ammo(spell, action, spellMap, eventArgs)
    if state.Buff['Unlimited Shot'] then
        if player.equipment.ammo ~= U_Shot_Ammo[player.equipment.range] then
            if player.inventory[U_Shot_Ammo[player.equipment.range]] or player.wardrobe[U_Shot_Ammo[player.equipment.range]] then
                add_to_chat(122,"Unlimited Shot active. Using custom ammo.")
                equip({ammo=U_Shot_Ammo[player.equipment.range]})
            elseif player.inventory[DefaultAmmo[player.equipment.range]] or player.wardrobe[DefaultAmmo[player.equipment.range]] then
                add_to_chat(122,"Unlimited Shot active but no custom ammo available. Using default ammo.")
                equip({ammo=DefaultAmmo[player.equipment.range]})
            else
                add_to_chat(122,"Unlimited Shot active but unable to find any custom or default ammo.")
            end
        end
    else
        if player.equipment.ammo == U_Shot_Ammo[player.equipment.range] and player.equipment.ammo ~= DefaultAmmo[player.equipment.range] then
            if DefaultAmmo[player.equipment.range] then
                if player.inventory[DefaultAmmo[player.equipment.range]] then
                    add_to_chat(122,"Unlimited Shot not active. Using Default Ammo")
                    equip({ammo=DefaultAmmo[player.equipment.range]})
                else
                    add_to_chat(122,"Default ammo unavailable.  Removing Unlimited Shot ammo.")
                    equip({ammo=empty})
                end
            else
                add_to_chat(122,"Unable to determine default ammo for current weapon.  Removing Unlimited Shot ammo.")
                equip({ammo=empty})
            end
        elseif player.equipment.ammo == 'empty' then
            if DefaultAmmo[player.equipment.range] then
                if player.inventory[DefaultAmmo[player.equipment.range]] then
                    add_to_chat(122,"Using Default Ammo")
                    equip({ammo=DefaultAmmo[player.equipment.range]})
                else
                    add_to_chat(122,"Default ammo unavailable.  Leaving empty.")
                end
            else
                add_to_chat(122,"Unable to determine default ammo for current weapon.  Leaving empty.")
            end
        elseif player.inventory[player.equipment.ammo].count < 15 then
            add_to_chat(122,"Ammo '"..player.inventory[player.equipment.ammo].shortname.."' running low ("..player.inventory[player.equipment.ammo].count..")")
        end
    end
end

function select_default_macro_book()
    set_macro_page(1, 7)
end

windower.raw_register_event('action',
    function(act)
        --check if you are a target of spell
        local actionTargets = act.targets
        playerId = windower.ffxi.get_player().id
        isTarget = false
        for _, target in ipairs(actionTargets) do
            if playerId == target.id then
                isTarget = true
            end
        end
        if isTarget == true then
            if act.category == 4 then
                local param = act.param
                if param == 845 and flurry ~= 2 then
                    add_to_chat(122, 'Flurry Status: Flurry I')
                    flurry_level = 1
                elseif param == 846 then
                    add_to_chat(122, 'Flurry Status: Flurry II')
                    flurry_level = 2
                end
            end
        end
    end)

ft_player = nil
	
function facetarget()
	if not autofacetarget then return end
	local t = ft_target()
	local destX = t.x
	local destY = t.y
	local direction = math.abs(PlayerH - math.deg(HeadingTo(destX,destY)))
	if direction > 5 then
		windower.ffxi.turn(HeadingTo(destX,destY))
	end
end

function ft_target()
	local rh = rh_status()
	if rh.enabled and rh.target then
		return windower.ffxi.get_mob_by_id(rh.target)
	else
		return windower.ffxi.get_mob_by_target('t')
	end
end

function HeadingTo(X,Y)
	
	local X = X - windower.ffxi.get_mob_by_id(ft_player.id).x
	local Y = Y - windower.ffxi.get_mob_by_id(ft_player.id).y
	local H = math.atan2(X,Y)
	return H - 1.5708
end

windower.raw_register_event('prerender', 
	function()
		ft_player = windower.ffxi.get_player()
		if not moving and ft_player.status <= 1 then
			local t = ft_target()
			if t and bit.band(t.id,0xFF000000) ~= 0 then -- highest byte of target.id indicates whether it's a play or not
				facetarget()
			end
		end
	end)
	
windower.raw_register_event('outgoing chunk', function(id, data)
    if id == 0x015 then
        local action_message = packets.parse('outgoing', data)
		PlayerH = action_message["Rotation"]
	end
end)