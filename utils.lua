math.randomseed(os.time())
local random = math.random

function Len(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function Uuid()
    local template ='jbnsk1:XD=xxxx-xxxxx-xxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

return {
    Len = Len,
    Uuid = Uuid
}