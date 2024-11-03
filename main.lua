local db = require("jebongskiDB")

db.setup()
db.createDocument("Pokemon")
db.setDocument("Pokemon")
-- db.printCurrDocument()
local res = db.insertOne({name="Nick", age=21})
-- res = (db.deleteOne({name="Jebong"}))
print(res[1], res[2])
db.save()

-- db.printAllDocuments()
print(db.dump(db.findOne({name="Jebong"})))

