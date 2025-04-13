local Lib = {}

function Lib:Check()
    local FunctionsToCheck = {
        mouse1click
    }

    local IncompatibleFunctions = {}

    for i, v in pairs(FunctionsToCheck) do
        local s,e = pcall(v)

        if not s then
            table.insert(IncompatibleFunctions, v)
        end
    end

    return "COMPATIBLE", IncompatibleFunctions
end

return Lib