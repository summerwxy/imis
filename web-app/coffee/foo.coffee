# Assignment:

number = 42
opposite = true

# Conditions:
number = -42 if opposite

# Functions:
square = (x) -> x * x

# Arrays:
list = [1, 2, 3, 4, 5, 6]

# Objects
math = 
    root: Math.sqrt
    square: square
    cube: (x) -> x * square x

# Splats:
race = (winner, runners...) ->
    print winner, runners

# Existence:
alert "I knew if!" if elvis?

# Array comprehensions:
cubes = (math.cube num for num in list)


fill = (container, liquid = "coffee") ->
    "Filling the #{container} with #{liquid}"


song = ["do", "re", "mi", "fa", "so"]

singers = {Jagger: "Rock", Elvis: "Roll"}

bitlist = [
    1, 0, 1
    0, 0, 1
    1, 1, 0
]

kids = 
    brother:
        name: "Max"
        age: 11
    sister:
        name: "Ida"
        age: 9

$('.account').attr class: 'active'
log object.class
