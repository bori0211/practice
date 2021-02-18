# A List is a collection which is ordered and changeable. Allows duplicate members.

# create list
numbers = [1, 2, 3, 4, 5]
fruits = ["Apples", "Oranges", "Grapes"]


# Use a constructor
#numbers2 = list((1, 2, 3, 4, 5))

#print(numbers, numbers2)

print(fruits[1])

# Get length
print(len(fruits))

# Append to list
fruits.append("Mangos")
print(fruits)

# Remove from list
fruits.remove("Grapes")
print(fruits)

# Insert into position
fruits.insert(2, "Strawberries")
print(fruits)

