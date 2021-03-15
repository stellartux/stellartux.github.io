### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 60c13530-6625-11eb-0b68-43bb98153c01
md"""
# Types

Types are a fundamental feature of computer programming that are found in some form in every programming language. They are a way for a programming language to describe the meaning of data stored in memory, describe the rules of how that data can be manipulated, enforce those rules and give the programmer tools to create their own systems of rules for the manipulation of data. 

The terminology varies quite a lot between the worlds of mathematics and computer science, and even between different programming languages. The description below takes a largely Julia oriented explanation of types, as the terminology used in discussing Julia's type system is very close to the generic CS definition of the concepts, so makes a good foundation for knowledge of types. Despite the variation in terminology and in the features offered by different languages' type systems, a lot of the concepts transfer to any language.

## Concrete Types

A concrete type can be thought of as a way of interpreting a sequence of bits. For example, the bitstring `10111000` is `184` when viewed as an unsigned integer (`UInt8` in Julia), or `-74` when viewed as a signed integer (`Int8`). The pattern of ones and zeros in memory does not change, only the rules for deciding the meaning of the data changes.
"""

# ╔═╡ 4e34af60-6629-11eb-3df9-537ac7a37f07
bitstring(UInt8(184))

# ╔═╡ 40ef14a0-6627-11eb-27ca-8984ae94c309
bitstring(Int8(-72))

# ╔═╡ 878872c0-662d-11eb-1ee3-dfdc633d89d6
parse(Int, bitstring(Int8(-72)), base=2)

# ╔═╡ f5ad1f90-662c-11eb-1fb3-c96ee1d6be18
md"""
Data can change from being one type to another in several different ways. The most common way is by explicit type conversion, i.e. creating a new instantiation of a type by passing its constructor. 

The Char `'A'` can be converted to an Int by passing it to the Int constructor.
"""

# ╔═╡ fe89a5c0-662c-11eb-21a9-1590e2af58cc
Int8('A')

# ╔═╡ 6868aae0-6632-11eb-22b3-ad8f1aa5654a
md"""
Likewise, Ints can be converted back to Chars with the Char constructor.
"""

# ╔═╡ cfd58da0-662e-11eb-0bb3-832ee64a0194
Char(65)

# ╔═╡ 0ab3be60-662f-11eb-3b12-ad38972ef557
md"""
In strongly typed languages, this is the only way to convert data from one type to another. In weakly typed languages, such as C, types can be changed by *casting* them from one type to another. This is where the bits in memory are treated as a different type by disregarding its previous type and treating that bitstring as if it is its new type.

```c
int i = (int)true; // i is now 1
i = (int)false; // i is now 0
```

This can backfire in situations where there are unexpected differences in the underlying hardware. For example, different systems can use different [endianness](https://en.wikipedia.org/wiki/Endianness). In general, the order of bits in a byte goes from most significant bit (MSB) to least significant bit (LSB). However, in types larger than a single byte, the order of bytes can differ from system to system and even between types.
"""

# ╔═╡ 6603f930-662d-11eb-304d-771cf3e9011f
bitstring(Char(65))

# ╔═╡ 68e40eb0-662d-11eb-2152-33ab3770c8b1
bitstring(Int32(65))

# ╔═╡ ec4d6a30-662d-11eb-11e8-711d50e4f58d
begin
	eachbyte(val) = join.([Iterators.partition(bitstring(val), 8)...])
	md"""
	The bitstring of the `Int32` is represented most significant byte first, or big-endian, and the `Char` is represented least significant byte first, or little-endian.
	"""
end

# ╔═╡ e38ae590-6636-11eb-35e0-8dd86e537f4f
Char(Int32(65)) == 'A'

# ╔═╡ 0b9de562-6631-11eb-077a-eb21ad4de957
eachbyte(Int32(65))	

# ╔═╡ 6d3603b0-662d-11eb-02a1-d5dffdd90d1e
eachbyte('A')

# ╔═╡ dc468b90-6636-11eb-2c2d-efac00304e64
md"""
Even though they both represent the number 65, the underlying bit pattern in memory is different. A C style casting of the `Char` `'A'` to an `Int32` results in a number that is very much not `65`.
"""

# ╔═╡ 709b27b0-662d-11eb-2618-fdc4bfff6279
parse(Int32, bitstring('A'), base=2)

# ╔═╡ f90c2c40-6630-11eb-06d0-b3877f1e7653
md"""
Other languages, such as JavaScript, allow a loose comparison of values across types. There are two different types of comparison, `==` and `===` (which don't have names, but I call twoquals and threequals, so feel free to use those), which differ on whether the type information is used when determining equality.

```js
> "0" == 0
true

> "0" === 0
false

> false == 0
true

> false === 0
false
```

This is due to another form of type conversion, called implicit type conversion or duck typing. This is when the type of an object is helpfully changed to whatever the interpreter thinks your code probably means based on the types passed to it.

In JavaScript, this is most famously known from the confusion caused by implicit conversion between Numbers and Strings. In particular, the `+` operator means addition for Numbers and concatenation for Strings. However, due to the loose conversions between types, if a string can also represent a number, and the operator can only be used on numbers, such as `-`, `*` or `/`, both strings will be implicitly converted to numbers.

```js
> 1 + 1
2

> "1" + 1
"11"

> "1" - "1"
0

> "1" + "1" - "1"
10
```

This is either perfectly sensible or jaw-clenchingly infuriating, depending on how you feel about this sort of thing. I don't mind JavaScript's semantics, but I can see why other people hate it. Let's compare with Julia.
"""

# ╔═╡ ed740ee0-6638-11eb-2990-a38eccca8f31
md"""
Julia lets you increment the value of a `Char`, but adding an `Int` to a `String` is not allowed. Or rather, not implemented by default. Due to the magic of operator overloading and sadomasochism, it's possible to add JavaScript's `+` semantics to Julia.
"""

# ╔═╡ 82b00a80-663f-11eb-3f2d-891a54c4e511
begin
	import Base: +, -
	+(a::String, b::String) = a * b
	-(a::String, b::String) = parse(Int, a) - parse(Int, b)
	"1" + "1" - "1"
end

# ╔═╡ d9e5f460-6638-11eb-3aef-e517d47f7251
'1' + 1

# ╔═╡ db84fe60-6638-11eb-2828-bbb42b4b733a
"1" + 1

# ╔═╡ 8c46a0a0-6639-11eb-1af7-b583bfcbdc20
let	+(a::String, b::Int64) = a * string(b)
	"1" + 1
end

# ╔═╡ 901bd8a0-6646-11eb-1011-49da944c1584
md"""
Mmmmmm, *web scale* and *full stack*. 👌😎🔥🔥🔥🔥🔥🔥

While ridiculous and nauseating to many, this example helps demonstrate why anyone cares about types in the first place. Annotating the types of function parameters on the function definition tells the compiler which types that function definition (or *method*) should handle. In the example above, we defined a new method on the `+` function, so that `+` can now handle being passed `String` arguments. 

Calling a different method on a function based on the types of the arguments is called *multiple dispatch*, and is very handy. It lets us add our super neato JS style string addition and subtraction without overwriting the boring normal way of adding and subtracting of numbers. The `+` functions can live happily side by side.
"""

# ╔═╡ 4231c040-6647-11eb-35d9-2901001b9f20
1 + 1        # your grampa's addition

# ╔═╡ 2bb893c0-6647-11eb-174c-d948da03a90a
"1" + "1"    # cool refreshing NEW Addition™  

# ╔═╡ ccbb2d40-6639-11eb-3ac3-d1e78b34f12e
md"""
## Abstract Types

As mentioned before, the types we've been referring to have all been *concrete* types, that is, types which have a particular representation in memory. Due the practical limitation of only having a finite amount of memory available on any given computer, it's necessary to only use a certain number of bits to represent any given value. This means that any concrete type has a limited range of values it can represent.

`Int8` can only represent values in the range `-128:127`, because it only has eight bits available, so the maximum number of values it can represent is `2^8`. `Int64` can represent a considerably larger range of values.
"""

# ╔═╡ 662f9f40-663c-11eb-27dd-5f3a6253d396
typemin(Int8):typemax(Int8)

# ╔═╡ 608a9d5e-663c-11eb-39e0-f70eabad7b59
typemin(Int64):typemax(Int64)

# ╔═╡ fd3a0100-663c-11eb-2b00-2741aa087dc9
md"""
Even though these are technically different types, they represent the same concept, so it's useful to be able to refer to operations on the common value that these types represent, like with the `+` operator in the example above. 

Now what if some people don't like our awesome new `+`? Well, we could make our own `addclassic` function that doesn't have the string methods, just like the `+` used to. This could be done using our old pal multiple dispatch again, something like:

```julia
addclassic(a::Int8, b::Int8) = a + b
addclassic(a::Int16, b::Int16) = a + b
addclassic(a::Int32, b::Int32) = a + b
addclassic(a::Int64, b::Int64) = a + b
```

This would work fine, but it would get tedious having to do this for every function that we wanted to work across multiple types, and this doesn't even cover what happens if we wanted to add an `Int64` to an `Int32`, or an `Int8` to an `Int16`, or any of the other combinations. Luckily there's an easier way.

> “If it walks like a duck, quacks like a duck, and subtypes `AbstractDuck`, it's a duck.” 
> 	— *Dijkstra, probably.*

Abstract types are a way of arranging types in a hierarchy, so that methods can be written for a type further up the hierarchy (called a *supertype*), and that function can be called by any of the types that are below it in the hierarchy (*subtypes*).
"""

# ╔═╡ 2e3b8990-6651-11eb-2ffa-b1600faf3e74
supertype.((Int8, Int16, Int32, Int64))

# ╔═╡ 2fbfea2e-6652-11eb-0aa2-0b07461c90b0
md"""
When each of those types was defined, it was assigned the supertype `Signed`, which is the supertype which represents all signed integer types.

```julia
type Int8 <: Signed end
```

Since each of the types we wrote `add` methods for share a supertype, so we could instead write the following code and have the same functionality.

```julia
add(a::Signed, b::Signed) = a + b
```

`Signed` itself also has further supertypes, so let's have a look at those.
"""

# ╔═╡ 9e84d930-6652-11eb-2a7a-d543e31df803
supertype(Signed)

# ╔═╡ 0d1571c0-6653-11eb-1b4c-ebe1e40a2c09
supertype(Integer)

# ╔═╡ 0fe581ae-6653-11eb-0fae-dba6c6847d8b
supertype(Real)

# ╔═╡ 132e9230-6653-11eb-2ae6-ff6393016405
supertype(Number)

# ╔═╡ 15c0aec0-6653-11eb-139a-c7c7bc9d4496
supertype(Any)

# ╔═╡ 19443030-6653-11eb-2ab4-593b361d76f3
md"""
As you can see, the type hierarchy goes quite high, all the way up to `Any`, the supertype of all supertypes that's even its own supertype. All the types form a big tree with `Any` sitting at the top (in the mathematical sense of a tree, it's not my fault mathematicians don't know which way up trees go). `Any` is the default type, and variables and parameters which don't have a type annotation default to `Any`.

Our `add` function could target `Any`, with either of the following equivalent definitions.

```julia
addclassic(a::Any, b::Any) = a + b
addclassic(a, b) = a + b
```

This leaves us back with our JS style string concatenation that we were defining our special strict `add` function to get away from. We want to add numbers and nothing else, so let's target `Number`.
"""

# ╔═╡ aba57c40-6653-11eb-0fa6-01eae675683e
addclassic(a::Number, b::Number) = a + b

# ╔═╡ 83505ca2-6654-11eb-3a24-8b83a78ec479
addclassic(1, 1)

# ╔═╡ 860f7ca0-6654-11eb-2536-27ebe0cda50d
addclassic(Int8(1), Int8(1))

# ╔═╡ 91285e40-6654-11eb-3960-b3226865c76d
addclassic("1", "1")

# ╔═╡ 95b11ab0-6654-11eb-1dfc-7d7103cb1a5e
md"""
Success! `addclassic` works just like `+` used to before we upgraded it. Now nobody can complain.
"""

# ╔═╡ Cell order:
# ╟─60c13530-6625-11eb-0b68-43bb98153c01
# ╠═4e34af60-6629-11eb-3df9-537ac7a37f07
# ╠═40ef14a0-6627-11eb-27ca-8984ae94c309
# ╠═878872c0-662d-11eb-1ee3-dfdc633d89d6
# ╟─f5ad1f90-662c-11eb-1fb3-c96ee1d6be18
# ╠═fe89a5c0-662c-11eb-21a9-1590e2af58cc
# ╟─6868aae0-6632-11eb-22b3-ad8f1aa5654a
# ╠═cfd58da0-662e-11eb-0bb3-832ee64a0194
# ╟─0ab3be60-662f-11eb-3b12-ad38972ef557
# ╠═6603f930-662d-11eb-304d-771cf3e9011f
# ╠═68e40eb0-662d-11eb-2152-33ab3770c8b1
# ╟─ec4d6a30-662d-11eb-11e8-711d50e4f58d
# ╠═e38ae590-6636-11eb-35e0-8dd86e537f4f
# ╠═0b9de562-6631-11eb-077a-eb21ad4de957
# ╠═6d3603b0-662d-11eb-02a1-d5dffdd90d1e
# ╟─dc468b90-6636-11eb-2c2d-efac00304e64
# ╠═709b27b0-662d-11eb-2618-fdc4bfff6279
# ╟─f90c2c40-6630-11eb-06d0-b3877f1e7653
# ╠═d9e5f460-6638-11eb-3aef-e517d47f7251
# ╠═db84fe60-6638-11eb-2828-bbb42b4b733a
# ╟─ed740ee0-6638-11eb-2990-a38eccca8f31
# ╠═8c46a0a0-6639-11eb-1af7-b583bfcbdc20
# ╠═82b00a80-663f-11eb-3f2d-891a54c4e511
# ╟─901bd8a0-6646-11eb-1011-49da944c1584
# ╠═4231c040-6647-11eb-35d9-2901001b9f20
# ╠═2bb893c0-6647-11eb-174c-d948da03a90a
# ╟─ccbb2d40-6639-11eb-3ac3-d1e78b34f12e
# ╠═662f9f40-663c-11eb-27dd-5f3a6253d396
# ╠═608a9d5e-663c-11eb-39e0-f70eabad7b59
# ╟─fd3a0100-663c-11eb-2b00-2741aa087dc9
# ╠═2e3b8990-6651-11eb-2ffa-b1600faf3e74
# ╟─2fbfea2e-6652-11eb-0aa2-0b07461c90b0
# ╠═9e84d930-6652-11eb-2a7a-d543e31df803
# ╠═0d1571c0-6653-11eb-1b4c-ebe1e40a2c09
# ╠═0fe581ae-6653-11eb-0fae-dba6c6847d8b
# ╠═132e9230-6653-11eb-2ae6-ff6393016405
# ╠═15c0aec0-6653-11eb-139a-c7c7bc9d4496
# ╟─19443030-6653-11eb-2ab4-593b361d76f3
# ╠═aba57c40-6653-11eb-0fa6-01eae675683e
# ╠═83505ca2-6654-11eb-3a24-8b83a78ec479
# ╠═860f7ca0-6654-11eb-2536-27ebe0cda50d
# ╠═91285e40-6654-11eb-3960-b3226865c76d
# ╟─95b11ab0-6654-11eb-1dfc-7d7103cb1a5e
