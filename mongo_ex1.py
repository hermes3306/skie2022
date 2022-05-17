from pymongo import MongoClient
#client = MongoClient(host="localhost", port=27017)
client = MongoClient("mongodb://localhost:27017")
db = client["rptutorials"]
tutorial = db.tutorial

tutorial2 = {
    "title": "Python's Requests Library (Guide)",
    "author": "Alex",
    "contributors": [
        "Aldren",
        "Brad",
        "Joanna"
    ],
    "url": "https://realpython.com/python-requests/"
}

tutorial3 = {
    "title": "Object-Oriented Programming (OOP) in Python 3",
    "author": "David",
    "contributors": [
        "Aldren",
        "Joanna",
        "Jacob"
    ],
    "url": "https://realpython.com/python3-object-oriented-programming/"
}

new_result = tutorial.insert_many([tutorial2, tutorial3])

print(f"Multiple tutorials: {new_result.inserted_ids}")
