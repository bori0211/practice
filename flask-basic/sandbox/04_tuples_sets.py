# A Tuple is a collection which is ordered and unchangeable. Allows duplicate members.


# Create tuple
fruits = ("Apples", "Oranges", "Grapes") 
#fruits2 = tuple(("Apples", "Oranges", "Grapes"))

#print(fruits, fruits2)

# Single value needs trailing comma
fruits2 = ("Apples",)


print(fruits2, type(fruits2))


# Can't change value (unchangeable)
#fruits[0] = "Pears"



# A Set is a collection which is unordered and unindexed. No duplicate members.

fruits_set = {"Apples", "Oranges", "Mango"}

# Check if in set
print("Apples" in fruits_set)

# Add to set
fruits_set.add("Grape")

print(fruits_set)
