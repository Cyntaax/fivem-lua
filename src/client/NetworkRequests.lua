Something = setmetatable({}, Something)

Something.__index = Something

Something.__call = function()
    return "Something"
end

function Something.new(aa)
    local _Something = {
        FDSA = aa,
    }
    return setmetatable(_Something, Something)
end

function Something:DoSomething(a,b,c)
    print("doing something with", a, b, c)
end

local ss = Something.new(11)


function ToNet(target)
    return function(parent, fun, ...)
        print("performing =>", type(fun), "with args", table.unpack({...}))
    end
end

function DoTheSomething()

end

ToNet()(ss, ss.DoSomething, "fdsa", "fdsa", "fdsa")

