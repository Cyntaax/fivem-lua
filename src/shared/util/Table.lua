table.contains = function(table, value)
    for k,v in pairs(table) do
        if value == v then
            return true
        end
    end
    return false
end