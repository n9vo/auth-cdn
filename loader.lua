local StarterGui = game:GetService("StarterGui")

local function notify(msg)
    StarterGui:SetCore("SendNotification", {
        Title = "9AUTH",
        Text = msg,
        Duration = 5
    })
end

local function assertGlobal(name)
    if _G[name] == nil then
        local msg = "Missing global: _G." .. name
        notify(msg)
        error(msg)
    end
end

assertGlobal("AUTH_SERVER_ID")
assertGlobal("AUTH_SCRIPT_ID")
assertGlobal("key")

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
        notify("Failed to download loader")
        error("[9auth] Failed to download loader")
    end

    assert(loadstring(res.Body))()
end)

if not ok then
    notify("Failed to run loader")
    warn("[9auth] Failed to run loader")
end
