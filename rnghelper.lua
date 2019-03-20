require('queues')
res = require('resources')
packets = require('packets')
config = require('config2')

local self = windower.ffxi.get_player().id
local target = nil
local completion = false
local mode = nil
local weaponskill = nil
local cooldowns = {}
local timeouts = {}
local settings = config.load('libs/rnghelper_settings.xml')
local cooldown = 0
local queue = Q{}
local pending = nil
local enabled = true
local midshot = false
local timeout = 0
local useAM = false

local action_events = {
    [2] = 'mid /ra',
    [3] = 'mid /ws',
    [4] = 'mid /ma',
    [5] = 'mid /item',
    [6] = 'pre /ja',
    [7] = 'pre /ws',
    [8] = 'pre /ma',
    [9] = 'pre /item',
    [12] = 'pre /ra',
    [14] = 'pre /ja',
    [15] = 'pre /ja',
}

--[[local events_by_prefix = {
	['/range'] = 2,
	['/weaponskill'] = 3,
	['/magic'] = 4,
	['/item'] = 5,
	['/jobability'] = 6
}]]

local terminal_action_events = {
    [2] = 'mid /ra',
    [3] = 'mid /ws',
    [4] = 'mid /ma',
    [5] = 'mid /item',
    [6] = 'pre /ja',
}

local action_interrupted = {
    [78] = 78,
    [84] = 84,
}

local action_message_interrupted = {
    [16] = 16,
    [62] = 62,
}

local action_message_unable = {
    [12] = 12,
    [17] = 17,
    [18] = 18,
    [34] = 34,
    [35] = 35,
    [40] = 40,
    [47] = 47,
    [48] = 48,
    [49] = 49,
    [55] = 55,
    [56] = 56,
    [71] = 71,
    [72] = 72,
    [76] = 76,
    [78] = 78,
    [84] = 84,
    [87] = 87,
    [88] = 88,
    [89] = 89,
    [90] = 90,
    [91] = 91,
    [92] = 92,
    [94] = 94,
    [95] = 95,
    [96] = 96,
    [104] = 104,
    [106] = 106,
    [111] = 111,
    [128] = 128,
    [154] = 154,
    [155] = 155,
    [190] = 190,
    [191] = 191,
    [192] = 192,
    [193] = 193,
    [198] = 198,
    [199] = 199,
    [215] = 215,
    [216] = 216,
    [217] = 217,
    [218] = 218,
    [219] = 219,
    [220] = 220,
    [233] = 233,
    [246] = 246,
    [247] = 247,
    [307] = 307,
    [308] = 308,
    [313] = 313,
    [315] = 315,
    [316] = 316,
    [325] = 325,
    [328] = 328,
    [337] = 337,
    [338] = 338,
    [346] = 346,
    [347] = 347,
    [348] = 348,
    [349] = 349,
    [356] = 356,
    [410] = 410,
    [411] = 411,
    [428] = 428,
    [443] = 443,
    [444] = 444,
    [445] = 445,
    [446] = 446,
    [514] = 514,
    [516] = 516,
    [517] = 517,
    [518] = 518,
    [523] = 523,
    [524] = 524,
    [525] = 525,
    [547] = 547,
    [561] = 561,
    [568] = 568,
    [569] = 569,
    [574] = 574,
    [575] = 575,
    [579] = 579,
    [580] = 580,
    [581] = 581,
    [649] = 649,
    [660] = 660,
    [661] = 661,
    [662] = 662,
    [665] = 665,
    [666] = 666,
    [700] = 700,
    [701] = 701,
    [717] = 717,
}

local aftermath_weaponskills = {
	['Gastraphetes'] = {ws='Trueflight', tp=3000, buff=272},
	['Death Penalty'] = {ws='Leaden Salute', tp=3000, buff=272},
	['Armageddon'] = {ws='Wildfire', tp=3000, buff=272},
	['Gandiva'] = {ws='Jishnu\'s Radiance', tp=3000, buff=272},
	['Annihilator'] = {ws='Coronach', tp=1000, buff=273},
	['Yoichinoyumi'] = {ws='Namas Arrow', tp=1000, buff=273}
}

local function load_profile(name, set_to_default)
    local profile = settings.profiles[name]
    for k, v in pairs(profile.cooldowns) do
        cooldowns["\/%s":format(k)] = v
		timeouts["\/%s":format(k)] = v + 1
    end
    weaponskill = profile.weaponskill
    mode = profile.mode
    if set_to_default then
        settings.default = name
        settings:save('all')
    end
end

local function save_profile(name)
    local profile = {}
    profile.cooldowns = {}
    for k, v in pairs(cooldowns) do
        profile.cooldowns[k:sub(2)] = v
    end
    profile.weaponskill = weaponskill
    profile.mode = mode
    settings.profiles[name] = profile
    settings.default = name
    settings:save('all')
end

local function able_to_use_action()
    if pending.action_type == 'Ability' then
        return windower.ffxi.get_ability_recasts()[res.job_abilities[pending.id].recast_id] == 0
    elseif pending.action_type == 'Magic' then
        return windower.ffxi.get_spell_recasts()[res.spells[pending.id].recast_id] == 0
    end
    return true
end

local function able_to_use_weaponskill()
    return windower.ffxi.get_player().vitals.tp >= 1000
end

local function execute_pending_action()
    cooldown = cooldowns[pending.prefix]
	timeout = os.clock() + timeouts[pending.prefix]
	midshot = true
    if pending.prefix == '/range' then
        windower.chat.input("%s %d":format(pending.prefix, pending.target))
    else
        windower.chat.input("%s \"%s\" %d":format(pending.prefix, pending.english, pending.target))
    end
end

local function process_pending_action()			-- Called only by processqueue
    if pending.prefix == '/weaponskill' then
        if not able_to_use_weaponskill() then	-- if we queue a WS, but don't have TP, it does an RA
            queue:insert(1, pending)		  	-- then tries to WS again.  Will repeat until we have TP
            pending = {
                ['prefix'] = '/range',
                ['english'] = 'Ranged',
                ['target'] = pending.target,
            }
        end
        execute_pending_action()
    elseif not able_to_use_action() then
        windower.add_to_chat(200, "Rnghelper : Aborting %s - Ability not ready.":format(pending.english))
        completion = true   
        process_queue() -- sets pending to nil,  then sets pending to the next item in queue
    else				-- if the queue is empty, will try to WS or RA the target.  This function is run again on the new action, until an action is executed, and the recursion is broken
        execute_pending_action()
    end
end

function process_queue()
    if completion then
        pending = nil
        completion = false
    end
    if pending then
    elseif not queue:empty() then
        pending = queue:pop()
    elseif target then
		w = aftermath_weaponskills[player.equipment.range]
        if weaponskill and able_to_use_weaponskill() and (not useAM or not w or isBuffActive(w.buff)) then
            pending = {
                ['prefix'] = '/weaponskill',
                ['english'] = weaponskill,
                ['target'] = target,
                ['action_type'] = 'Ability',
            }
		elseif useAM and w and windower.ffxi.get_player().vitals.tp >= w.tp then
			pending = {
				['prefix'] = '/weaponskill',
                ['english'] = w.ws,
                ['target'] = target,
                ['action_type'] = 'Ability',
			}
        else
            pending = {
                ['prefix'] = '/range',
                ['english'] = 'Ranged',
                ['target'] = target,
                ['action_type'] = 'Ranged Attack',
            }
        end
    end
    if pending then
        process_pending_action()
    end
end

function isBuffActive(id)
	local self = windower.ffxi.get_player()
	for k,v in pairs( self.buffs ) do
		if (v == id) then -- check for buff
			return true
		end	
	end
	return false
end

local function handle_interrupt() -- called when spell completes or is interrupted
    completion = true
	timeout = nil
	midshot = false
    windower.send_command('@wait %f;gs rh process':format(cooldown))
end

local function add_spell_to_queue(spell)
    queue:push({
        ['prefix'] = spell.prefix,
        ['english'] = spell.english,
        ['target'] = spell.target.id,
        ['id'] = spell.id,
        ['action_type'] = spell.action_type,
    })
end

function filter_precast(spell, spellMap, eventArgs)
    if (pending and
        pending.prefix == spell.prefix and
        pending.english == spell.english and
        pending.target == spell.target.id) or (not enabled) then
    else
        eventArgs.cancel = true
        cancel_spell()
        if pending then
            if spell.english == 'Ranged' then
                target = spell.target.id
                completion = true
                process_queue()
            else
                add_spell_to_queue(spell)
            end
        else
            add_spell_to_queue(spell)
            process_queue()
        end
    end
end

local function monitor_target(id, data, modified, injected, blocked)
    if (id == 0xe) and target then
        local p = packets.parse('incoming', data)
        if (p.NPC == target) and ((p.Mask % 8) > 3) then
            if not (p['HP %'] > 0) then
                target = nil
                pending = nil
                completion = false
                queue:clear()
				timeout = nil
            end
        end
    end
end

local function handle_incoming_action_packet(id, data, modified, injected, blocked)
    if id == 0x28 and enabled then
        local p = packets.parse('incoming', data)
        if (p.Actor == self) and action_events[p.Category] then
            if action_interrupted[p['Target 1 Action 1 Message']] then
                handle_interrupt()
            elseif p.Param == 28787 then
            elseif terminal_action_events[p.Category] then
                handle_interrupt()
            end
        end
    end
end

local function handle_incoming_action_message_packet(id, data, modified, injected, blocked)
    if id == 0x29 and enabled then
        local p = packets.parse('incoming', data)
        if (p.Actor == self) then
            if action_message_interrupted[p.Message] then
                handle_interrupt()
            elseif action_message_unable[p.Message] then
                windower.send_command('@wait 0;gs rh process')
            end
        end
    end
end

local function handle_outgoing_action_packet(id, data, modified, injected, blocked)
    if id == 0x1a and enabled then
        local p = packets.parse('outgoing', data)
        if p.Category == 16 then
            target = p.Target
            cooldown = cooldowns['/range']
			timeout = os.clock() + timeouts['/range']
        end
    end
end

local ws_shortcuts = {
	['lead']='Leaden Salute',
	['true']='Trueflight',
	['wild']='Wildfire',
	['last']='Last Stand',
	['hot'] ='Hot Shot',
	['jis'] ="Jishnu's Radiance",
}

local function resolve_shortcuts(str)
	for k,v in pairs(ws_shortcuts) do
		if str:startswith(k) then
			return v
		end
	end
end

register_unhandled_command(function (...)
    local args = T{...}
    if args[1] and args[1]:lower() == 'rh' then
		args:remove(1) -- remove 'rh'
		cmd = args[1]:lower()
		args:remove(1) -- remove cmd
		if cmd then
			if cmd == 'process' then
				process_queue()
			elseif cmd == 'set' then
				if args[1] then
					for i,v in pairs(args) do args[i]=windower.convert_auto_trans(args[i]) end
					weaponskill = resolve_shortcuts(args[1]:lower()) or table.concat(args," "):titlecase()
					windower.add_to_chat(200, "Rnghelper : Setting weaponskill to %s":format(weaponskill))
				else
					windower.add_to_chat(200, "Rnghelper : Clearing weaponskill.")
					weaponskill = nil
				end
			elseif cmd == 'print' then
				if pending then
					windower.add_to_chat(200, pending.prefix .. pending.english .. pending.target)
				end
				for k, v in pairs(queue.data) do
					windower.add_to_chat(200, k .. v.prefix .. v.english .. v.target)
				end
			elseif cmd == 'save' then
				save_profile(args[1])
			elseif cmd == 'load' then
				load_profile(args[1], true)
			elseif cmd == 'clear' then
				windower.add_to_chat(200, "Rnghelper : Clearing queue")
				target = nil
				pending = nil
				completion = false
				timeout = nil
				queue:clear()
			elseif T{'enable','on','start'}:contains(cmd) then
				if enabled then
					windower.add_to_chat(200, "Rnghelper : Already enabled")
				else
					windower.add_to_chat(200, "Rnghelper : Enabling")
					enabled = true
				end
			elseif T{'disable','off','stop'}:contains(cmd) then
				if not enabled then
					windower.add_to_chat(200, "Rnghelper : Already disabled")
				else
					windower.add_to_chat(200, "Rnghelper : Disabling")
					enabled = false
					timeout = nil
				end
			elseif cmd:startswith('am') then
				if args[1] then
					if T{'enable','on','true'}:contains(args[1]:lower()) then
						windower.add_to_chat(200, "Rnghelper : Use Aftermath Enabled")
						useAM = true
					elseif T{'disable','off','false'}:contains(args[1]:lower()) then
						windower.add_to_chat(200, "Rnghelper : Use Aftermath Disabled")
						useAM = false
					end
				end
			end
		end
		return true
    end
    return false
end)

function rh_status()
	return {enabled=enabled, target=target}
end

function string.titlecase(str)
	return str:gsub("(%a)([%w_']*)", function(f, r) return f:upper()..r:lower() end)
end

local function check_timeout()
	if timeout and midshot and os.clock() > timeout and pending then
		local t = windower.ffxi.get_mob_by_id(pending.target)
		if t and bit.band(t.id,0xFF000000) then
			handle_interrupt()
		else
			windower.add_to_chat(200, "Lockup detected, autoclearing queue")
			target = nil
			pending = nil
			completion = false
			timeout = nil
			queue:clear()
		end
	end
end

load_profile(settings.default)
windower.raw_register_event('prerender', check_timeout)
windower.raw_register_event('incoming chunk', handle_incoming_action_packet)
windower.raw_register_event('incoming chunk', handle_incoming_action_message_packet)
windower.raw_register_event('outgoing chunk', handle_outgoing_action_packet)
windower.raw_register_event('incoming chunk', monitor_target)