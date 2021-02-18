# If/ Else conditions are used to decide to do something based on something being true or false

x = 10
y = 5



# Comparison Operators (==, !=, >, <, >=, <=) - Used to compare values

if x > y:
	print(f"{x} is greater than {y}")
elif x == y:
	print(f"{x} is equal to {y}")
else:
	print(f"{y} is greater than {x}")



# Logical operators (and, or, not) - Used to combine conditional statements

if x > 2 and x <= 10:
	print("2보다 크고 10보다 작거나 같음")

if not(x == y):
	print("x는 y과 같지 않음")


# Membership Operators (in, not in) - Membership operators are used to test if a sequence is presented in an object

numbers = [1,2,3,4,5]

if x in numbers:
	print(x in numbers) # True
else:
	print(x in numbers) # False



# Identity Operators (is, is not) - Compare the objects, not if they are equal, but if they are actually the same object, with the same memory location:

if x is y:
	print(x is y)
else:
	print(x is y)