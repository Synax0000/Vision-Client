local Lib = {}

function Lib:Init()
    local Data = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Libraries/Data.luau"))()
    local Config = game:GetService("HttpService"):JSONEDeodeo(Data:LoadConfig())
end

return Lib