--[[timer = {}

timer.timers = {}

function timer.Add(name, delay, reps, callback) -- -1 reps for perma timer
	timer.timers[name] = {
		delay = delay,
		time = CurTime() + delay,
		callback = callback,
		reps = reps,
	}
end

function timer.Remove(name)
	timer.timers[name] = nil
end

function timer.Simple(delay, callback)
	timer.Add(CurTime()..math.random(), delay, 1, callback)
end

hook.Add("Paint", "TimerHook", function()
	for k, v in pairs(timer.timers) do
		if v.time <= CurTime() then
			v.callback()
			if v.reps > 0 then
				v.reps = v.reps - 1
				if v.reps == 0 then
					timer.timers[k] = nil
				end
			end
			v.time = CurTime() + v.delay
		end
	end
end)]]