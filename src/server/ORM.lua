table.count = function(tb)
    local ct = 0
    for k,v in pairs(tb) do
        ct = ct + 1
    end

    return ct
end

---@class ORM
ORM = {
    ColumnType = {
        VARCHAR = function(chars)
            chars = tonumber(chars) or 0
            return "VARCHAR (" .. chars .. ")"
        end,
        INT = function(int)
            int = tonumber(int) or 0
            return int == 0 and "INT" or "INT (" .. int .. ")"
        end,
        TEXT = function()
            return "TEXT"
        end
    }
}

---Defines a model
---@param name string The table name
---@param options table Options
function ORM.Model(name, options)
    options = options or {}
    return function(obj, parent)
        local self = {}
        self.__tablename = name
        self.__parent = parent
        self.__schema = {

        }

        if not options.noId then
            obj.id = 0
        end

        self.findOne =  function(cb, options)
            options = options or {}
            options.limit = 1
            options.where = options.where or {}
            local primaryKey
            local compositeKeys = {}
            for k,v in pairs(obj.__schema) do
                if v.primaryKey == true then
                    primaryKey = v.column_name
                elseif v.compositeKey == true then
                    table.insert(compositeKeys, k)
                end
            end

            if primaryKey then
                options.where[primaryKey] = obj[primaryKey]
            else
                options.where["id"] = obj.id
            end

            for k,v in pairs(compositeKeys) do
                options.where[v] = obj[v]
            end

            ORM.GenerateQuery(obj.__tablename, "select", options, obj)(function(vals)
                if vals[1] then
                    for k,v in pairs(vals[1]) do
                        if not options.readOnly then
                            local colCfg = obj.__schema[k] or false
                            local targetKey = k
                            if colCfg == false then
                                for b,z in pairs(obj.__schema) do
                                    print(b, z)
                                    if z.column_name == k then
                                        colCfg = z
                                        targetKey = b
                                    end
                                end
                            end
                            if not colCfg then colCfg = {} end
                            if colCfg.json == true then
                                obj[targetKey] = json.decode(v) or v
                            else
                                obj[targetKey] = v
                            end
                        end
                    end
                    cb(obj)
                else
                    cb(nil)
                end
            end)
        end

        self.findAll = function(cb, options)
            options = options or {}
            options.where = options.where or {}

            ORM.GenerateQuery(obj.__tablename, "select", options, obj)(function(vals)
                local tmp = {}
                for k,v in pairs(vals) do
                    local copy = {}
                    for b,z in pairs(obj) do
                        copy[b] = z
                    end

                    local targetKey
                    for b,z in pairs(v) do
                        for i,j in pairs(obj.__schema) do
                            if j.column_name == b then
                                targetKey = i
                            end
                        end
                        copy[targetKey] = z
                    end
                    if obj.__parent then
                        print("parent type thing", type(obj.__parent.Hello))
                        copy = setmetatable(copy, obj.__parent)
                    end
                    table.insert(tmp, copy)
                end
                cb(tmp)
            end)
        end

        self.save = function(cb, options)
            local primaryKey
            local compositeKeys = {}
            options = options or {}
            options.where = options.where or {}
            for k,v in pairs(obj.__schema) do
                if v.primaryKey == true then
                    primaryKey = v.column_name
                elseif v.compositeKey == true then
                    table.insert(compositeKeys, k)
                end
            end

            if primaryKey then
                options.where[primaryKey] = obj[primaryKey]
            end

            for k,v in pairs(compositeKeys) do
                options.where[v] = obj[v]
            end

            if obj.id ~= nil then
                options.where["id"] = obj.id
            end
            obj.findOne(function(cObj)
                if cObj then
                    ORM.GenerateQuery(obj.__tablename, "update", options, obj)(function(af)
                        if type(cb) == "function" then
                            cb(af)
                        end
                    end)
                else
                    options.readOnly = true
                    ORM.GenerateQuery(obj.__tablename, "insert", {}, obj)(function(cObj)
                        if type(cb) == "function" then
                            cb(cObj)
                        end
                    end)
                end
            end, { readOnly = true })
        end

        for k,v in pairs(self) do
            obj[k] = v
        end
    end
end

---Defines a column
---@param name string The name of the property on the table to map this to
---@param options table Options
function ORM.Column(name, options)
    return function(obj)
        options = options or {}
        options = options or {}
        obj.__schema[name] = {
            column_name = options.column_name or name,
            type = options.type or "string",
            primaryKey = options.primaryKey,
            compositeKey = options.compositeKey,
            json = options.json,
            default = options.default,
            autoIncrement = options.autoIncrement
        }

        if options.default then
            log("Setting " .. name .. " default value " .. tostring(options.default))
            obj[name] = options.default
        end

    end
end

---Generates a query string
---@param tb string The name of the table
---@param kind string The kind of query
---@param queryInfo table Information about this query
---@param data table The model being worked with
---@return fun(cb: fun)
function ORM.GenerateQuery(tb, kind, queryInfo, data)

    local copy = {}
    if not data.__schema then
        print('Invalid model')

        return
    end
    for k,v in pairs(data.__schema) do
        if type(data[k]) == "table" then
            copy[k] = json.encode(data[k])
        else
            copy[k] = data[k]
        end
    end
    if kind == "insert" then
        print("inserting!")
        local tmp = {}
        local fields = ""
        local valfields = ""
        for k,v in pairs(copy) do
            fields = fields .. k .. ","
            valfields = valfields .. "@" .. k .. ","
            tmp["@" .. k] = v
        end
        fields = fields:sub(1, -2)
        valfields = valfields:sub(1, -2)

        local tmpStr = "INSERT INTO " .. tb .. "(" .. fields .. ") VALUES(" .. valfields .. ")"
        log(tmpStr, "Green")
        return function(cb)
            if MySQL ~= nil then
                MySQL.Async.execute(tmpStr, tmp, function(rowsAffected)
                    cb()
                end)
            else
                exports.ghmattimysql:execute(tmpStr, tmp, function()
                    cb()
                end)
            end
        end
    elseif kind == "update" then
        local tmpVals = {}
        local tmpstr = "UPDATE " .. tb .. " SET "
        queryInfo.updates = queryInfo.updates or {}
        if #queryInfo.updates == 0 then
            for b,z in pairs(copy) do
                if b ~= "id" then
                    table.insert(queryInfo.updates, b)
                end
            end
        end
        for b,z in pairs(queryInfo.updates) do
            tmpstr = tmpstr .. z .. " = @" .. z .. ","
            tmpVals["@" .. z] = copy[z]
        end

        tmpstr = tmpstr:sub(1, -2)

        if queryInfo.where then
            if table.count(queryInfo.where) > 0 then
                tmpstr = tmpstr .. " WHERE "
                local wheres = 0
                for b, z in pairs(queryInfo.where) do
                    wheres = wheres + 1
                    tmpstr = tmpstr .. b .. " = @" .. b .. " "
                    tmpVals["@" .. b] = copy[b]
                    if wheres < table.count(queryInfo.where) then
                        tmpstr = tmpstr .. " AND "
                    end
                end
            end
        end
        log(tmpstr, "Green")
        log(tmpVals)
        return function(cb)
            if MySQL ~= nil then
                MySQL.Async.execute(tmpstr, tmpVals, function(affected)
                    cb(affected)
                end)
            else
                exports.ghmattimysql:execute(tmpstr, tmpVals, function(affected)
                    cb(affected)
                end)
            end
        end
    elseif kind == "select" then
        local tmpValMap = {}
        local toGet = queryInfo.gets or {}
        local getStr = "SELECT "
        if #toGet == 0 then
            getStr = getStr .. "*"
        else
            local getsDone = 0
            for k,v in pairs(queryInfo.gets) do
                if type(v) == "string" then
                    getStr = getStr .. v
                    if getsDone < #queryInfo.gets then
                        getStr = getStr .. ","
                    end
                end
            end
        end

        getStr = getStr .. " FROM `" .. tb .. "` "


        local wheres = 0
        if table.count(queryInfo.where) > 0 then
            getStr = getStr .. " WHERE "
            for b,z in pairs(queryInfo.where) do
                wheres = wheres + 1
                tmpValMap["@" .. b] = z
                getStr = getStr .. b .. " = @" .. b .. " "
                if wheres < table.count(queryInfo.where) then
                    getStr = getStr .. " AND "
                end
            end

        end
        if queryInfo.limit then
            getStr = getStr .. "LIMIT " .. queryInfo.limit
        end
        log(getStr, "Green")
        return function(cb)
            if MySQL ~= nil then
                MySQL.Async.fetchAll(getStr, tmpValMap, function(vals)
                    if type(vals) ~= "table" then cb({}) return end
                    if vals then
                        cb(vals)
                    else
                        cb({})
                    end
                end)
            else
                exports.ghmattimysql:execute(getStr, tmpValMap, function(vals)
                    cb(vals)
                end)
            end
        end
    elseif kind == "create" then
        local columns = data.__schema
        -- CREATE TABLE Persons (
        --   ID int NOT NULL,
        -- LastName varchar(255) NOT NULL,
        -- FirstName varchar(255),
        --Age int,
        local query = "CREATE TABLE " .. tb .. "("
        local total = table.count(columns)
        local done = 0
        for k,v in pairs(columns) do
            done = done + 1
            if not v.type then
                return function()
                    print("Error: No type specified for " .. k)
                end
            end
            local columnName = v.column_name or k
            local colStr = ""
            if v.type then
                colStr = columnName .. " " .. v.type
                print("done is", done, "totalIs", total)
                if v.autoIncrement == true then
                    colStr = colStr .. " AUTO_INCREMENT"
                end
                if v.primaryKey == true then
                    colStr = colStr .. " PRIMARY KEY"
                end
                if done < total then
                    colStr = colStr .. ","
                end
                query = query .. colStr
            end
            print("completed", k)
        end
        query = query .. ")"

        return function(cb)
            if MySQL ~= nil then
                MySQL.Async.execute(query, {}, function(affected)
                    cb(affected)
                end)
            else
                exports.ghmattimysql:execute(query, {}, function(affected)
                    cb(affected)
                end)
            end
        end
    elseif kind == "drop" then
        local table = tb
        local query = "DROP TABLE " .. table
        return function(cb)
            if MySQL ~= nil then
                MySQL.Async.execute(query, {}, function(affected)
                    cb(affected)
                end)
            else
                exports.ghmattimysql:execute(query, {}, function(affected)
                    cb(affected)
                end)
            end
        end
    end

end

function ORM.AutoMigrate(targets, cb)
    local migrateFuncs = {}
    for k,v in pairs(targets) do
        if v.__schema then
            local func = ORM.GenerateQuery(v.__tablename, "create", {}, v)
            table.insert(migrateFuncs, func)
        end
    end

    Async.series(migrateFuncs, function()
        cb()
    end)
end

DumpTable = function(table, nb)
    if nb == nil then
        nb = 0
    end

    if type(table) == 'table' then
        local s = ''
        for i = 1, nb + 1, 1 do
            s = s .. "    "
        end

        s = '{\n'
        for k,v in pairs(table) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            for i = 1, nb, 1 do
                s = s .. "    "
            end
            s = s .. '['..k..'] = ' .. DumpTable(v, nb + 1) .. ',\n'
        end

        for i = 1, nb, 1 do
            s = s .. "    "
        end

        return s .. '}'
    else
        return tostring(table)
    end
end

if GetConvar == nil then
    GetConvar = function(...)  end
end

Ver = setmetatable({}, Ver)

Ver.__cal = function()
    return "Ver"
end

Ver.__index = Ver

function Ver.new()
    local _Ver = {
        ID = 0,
        Plate = ""
    }

    ORM.Model("ver")(_Ver)

    ORM.Column("ID", {
        primaryKey = true,
        autoIncrement = true,
        type = ORM.ColumnType.INT(),
        column_name = "id"
    })(_Ver)

    ORM.Column("Plate", {
        type = ORM.ColumnType.TEXT(),
        column_name = "plate"
    })(_Ver)

    return setmetatable(_Ver, Ver)
end

Acc = setmetatable({}, Acc)

Acc.__call = function()
    return "Acc"
end

Acc.__index = Acc

function Acc.new()
    local _Acc = {
        ID = 0,
        Name = "",
        Balance = 0
    }

    ORM.Model("accounts")(_Acc)

    ORM.Column("ID", {
        primaryKey = true,
        autoIncrement = true,
        type = ORM.ColumnType.INT(),
        column_name = "id"
    })(_Acc)

    ORM.Column("Name", {
        type = ORM.ColumnType.TEXT(),
        column_name = "name"
    })(_Acc)

    ORM.Column("Balance", {
        type = ORM.ColumnType.INT(),
        column_name = "balance"
    })(_Acc)

    return setmetatable(_Acc, Acc)
end

TPlayer = setmetatable({}, TPlayer)

TPlayer.__call = function()
    return "TPlayer"
end

TPlayer.__index = TPlayer

function TPlayer.new()
    local _Player = {
        Name = "",
        ID = 0
    }

    ORM.Model("players")(_Player)
    ORM.Column("Name", {
        type = ORM.ColumnType.TEXT(),
        column_name = "name"
    })(_Player)

    ORM.Column("ID", {
        type = ORM.ColumnType.INT(),
        primaryKey = true,
        column_name = "id",
        autoIncrement = true
    })(_Player)

    return setmetatable(_Player, TPlayer)
end


local Colors = {
    Red = "^1",
    Green = "^2",
    Blue = "^3",
    White = "^0"
}

function log(value, color)
    color = color or "White"
    local logEnabled = GetConvar("orm_debug", "false")
    logEnabled = logEnabled == "true" and true or false
    if not logEnabled then return end
    if type(value) == "table" then value = DumpTable(value) end
    print(Colors[color] .. tostring(value) .. Colors.White)
end

function toPack(tb)
    local tmpObj = {}
    local tmpMt = getmetatable(tb)

    print(type(tmpMt))

    for k,v in pairs(tb) do
        print("Assigning", k, v)
        tmpObj[k] = v
    end

    for k,v in pairs(tmpMt) do
        if k ~= "__index" and k ~= "__call" and k ~= "new" then
            tmpObj[k] = v
        end
    end

    return tmpObj
end

