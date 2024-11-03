local version = 1

local utils = require("utils")
local DB = nil
local CurrDocument = nil

function save(path)
    local data = textutils.serialiseJSON(DB, {unicode_strings = true})

    local file
    if path == nil then
        local resolvedPath = shell.resolve("data/db_info.json") 
        file  = fs.open(resolvedPath, "w+")
    else
        file = fs.open(path .. "db_info.json", "w+")
    end

    file.write(data)
    file.close()

    return true
end

function open(path)
    local file
    local db
    if path == nil then
        local resolvedPath = shell.resolve("data/db_info.json") 
        if not fs.exists(resolvedPath) then
            shell.execute("mkdir", "data")
            
            local temp = fs.open(resolvedPath, "w")
            temp.write("{}")
            temp.close()
        end
        
        local resolvedPath = shell.resolve("data/db_info.json") 
        file = fs.open(resolvedPath, "r")
    else
        file = fs.open(path .. "db_info.json", "r")
    end

    db = textutils.unserialiseJSON(file.readAll())
    file.close()
    
    return db
end

function createDocument(document)
    if not documentExists(document) then
        DB[document] = {}
        return true
    else 
        return false
    end
    
end

function documentExists(document) 
    for k, v in pairs(DB) do
        if document == k then
            return true
        end
    end

    return false
end

function setDocument(document)
    if documentExists(document) then
        CurrDocument = document
        return true
    else
        return false
    end
end

function printCurrDocument()
    print(CurrDocument)
end

function printAllDocument() 
    for k, v in pairs(DB) do
        print(k)
    end

    print(dump(DB[CurrDocument]))
end


function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

function findOne(query)
    local document = DB[CurrDocument]
    local passed = 0
    for i = 1, utils.Len(document) do
        for k, v in pairs(query) do
            if document[i][k] == v then
                passed = passed + 1
            end
        end

        if passed == utils.Len(query) then
            return document[i]
        end

        passed = 0
    end
end

function insertOne(data)
    local id = utils.Uuid()
    data["_id"] = id
    table.insert(DB[CurrDocument], data)
    return {true, id}
end

function deleteOne(query)
    local document = DB[CurrDocument]
    local passed = 0
    for i = 1, utils.Len(document) do
        for k, v in pairs(query) do
            if document[i][k] == v then
                passed = passed + 1
            end
        end

        if passed == utils.Len(query) then
            table.remove(document, i)
            return {true, 1}
        end

        passed = 0
    end
end

function updateOne(filter, update)
    local document = DB[CurrDocument]
    local passed = 0
    for i = 1, utils.Len(document) do
        for k, v in pairs(query) do
            if document[i][k] == v then
                passed = passed + 1
            end
        end

        if passed == utils.Len(query) then
            for k, v in pairs(query) do
                document[i][k] = v
            end
            
            return {true, 1}
        end

        passed = 0
    end
end

function setup(path)
    CurrDocument = nil
    DB = open(path)
end

return {
    setup = setup,
    save = save,
    open = open,
    printCurrDocument = printCurrDocument,
    printAllDocuments = printAllDocument,
    dump=dump,
    setDocument = setDocument,
    createDocument = createDocument,
    findOne = findOne,
    insertOne = insertOne,
    deleteOne = deleteOne
}