local StarterGui = game:GetService("StarterGui")
local notify_service = loadstring(game:HttpGet("https://raw.githubusercontent.com/n9vo/rblx-notify-lib/refs/heads/main/main.lua"))()

local function assertGlobal(name)
    if _G[name] == nil then
        local msg = "Missing global: _G." .. name
        notify_service:Notify("Error", msg, 5)
        error(msg)
    end
end

assertGlobal("AUTH_SERVER_ID")
assertGlobal("AUTH_SCRIPT_ID")
assertGlobal("AUTH_KEY")

local httpRequest =
    (syn and syn.request) or
    (SENTINEL_V2 and function(opt)
        return {
            StatusCode = 200,
            Body = request(opt.Url, opt.Method, opt.Body or "")
        }
    end) or
    request or
    function()
        return { Body = "{}" }
    end

local url = ("https://9auth.xyz/loader/%s/%s"):format(_G.AUTH_SERVER_ID, _G.AUTH_SCRIPT_ID)

local ok, err = pcall(function()
    local success, res = pcall(httpRequest, {
        Url = url,
        Method = "GET",
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if not success then
        notify_service:Notify("Error", "[9AUTH] Servers are currently down.", 5)
        error("[9AUTH] Servers are currently down.")
    end

    assert(loadstring(res.Body))()
end)

if not ok then
    notify_service:Notify("Error", "[9AUTH] Servers are currently down.", 5)
    warn("[9AUTH] Servers are currently down.")
end
