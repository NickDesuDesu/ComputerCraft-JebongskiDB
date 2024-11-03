name = "Jebong"

function changeName(change)
    name = change
end

function printName()
    print(name)
end

return {
    name = name,
    printName = printName,
    changeName = changeName
}