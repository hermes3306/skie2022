from pymongo import MongoClient
import pprint
#client = MongoClient(host="localhost", port=27017)
client = MongoClient("mongodb://localhost:27017")
db = client["rptutorials"]
tutorial = db.tutorial


for doc in tutorial.find():
    pprint.pprint(doc)


jon_tutorial = tutorial.find_one({"author": "David"})

pprint.pprint(jon_tutorial)
