# A for loop is used for iterating over a sequence (that is either a list, a tuple, a dictionary, a set, or a string).

people = ["Jone", "Paul", "Sara", "Susan"]

# Simple for loop
for person in people:
	if person == "Sara":
		break
	print(f"Current Person: {person}")

# range
for i in range(len(people)):
	if i == 2:
		continue
	print(f"Range Person: {people[i]}")
	


# While loops execute a set of statements as long as a condition is true.

count = 0
while count <= 10:
	print(f"Count: {count}")
	count += 1