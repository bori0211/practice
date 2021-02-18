# A Dictionary is a collection which is unordered, changeable and indexed. No duplicate members.
# Read more about dictionaries at https://docs.python.org/3/tutorial/datastructures.html#dictionaries

# Create Dict
person = {
	"first_name": "John",
	"last_name": "Doe",
	"age": 30
}

#print(person, type(person))

# use constructor
#person2 = dict(first_name="Sara", last_name="Williams")

#print(person2, type(person2))



print(person["first_name"])
print(person.get("last_name"))

# Add key/value
person["phone"] = "555-5555"

print(person)

# Get dict keys
print(person.keys())
print(person.items())


# Copy dict
person2 = person.copy()
person2["city"] = "Boston"

print(person2)

# Remove item
del(person["age"])
person.pop("phone")

print(person)

# Clear
person.clear()

print(person)



# List of dict
people = [
	{"name": "Marth", "age": 30},
	{"name": "Kevin", "age": 25}
]

print(people)
