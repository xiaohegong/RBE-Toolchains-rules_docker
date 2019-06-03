# Go Cheat Sheet

### Packages
Must import package `main` in order to run program.

*Syntax*: To import packages ***fmt*** and ***math/rand***
```
import (
        "fmt"
        "math/rand"
)
```
Alternatively, can also have multiple import statements.
```
import "fmt"
import "math"
```

To use the names from an *imported package*, must use its exported name with first letter capitalized.

### Functions
*Syntax:* for a simple `add` function

```
package main

import "fmt"

       param type   return type
            ⬇          ⬇
func add(x int, y int) int {
    return x + y
}

# Alternatively, with 2+ consecutive function parameters
func add(x, y int) int {
    return x + y
}


func main(){
    fmt.Println(
                add(42, 13)
    )
}
```

**Note：**
- Functions can return multiple results
    ```
        package main

        import "fmt"

        func swap(x, y string)(string, string){
            return y, x
        }

        func main(){
            a, b := swap("hello", "world")
            fmt.Println(a, b)
            #Outputs: world hello
        }
    ```

- Return values can be (1) named (2) naked
  ```
  package main

  import "fmt"

                named return val
                       ⬇
  func split(sum int) (x, y int){
      x = sum * 4 / 9
      y = sum - x

      # Outputs: 7 10
      return
  }

  func main(){
      fmt.Println(split(17))
  }
  ```

### Variables
Use `var` statement to declare a list of variables

```
package main

import "fmt"

            type declared at last
                     ⬇
var c, python, java bool

# To initialize values for variables
var i, j int = 1, 2

func main(){
    var i int
    fmt.Println(i, c, python, java)
}
```

Alternatively, can have short variable declarations
```
package main

import "fmt"

func main(){
    var i, j int = 1, 2
    k := 3
    c, python, java := true, false, "no!"

    fmt.Println(i, j, k, c, python, java)
    # Outputs:   1 2 3 true false no!
}
```

Variables without explicit initial value are given a default zero value for respective types.

The type a variable may be inferred from the value on the right hand side.

### For
This is a `for` loop
```
func main() {
	sum := 0
	for i := 0; i < 10; i++ {
		sum += i
	}
	fmt.Println(sum) // Prints 45
}
```
No parentheses and the braces `{}` are always required.

Note there is no `while` loop in Go.

### If
An `if` statement
```
func sqrt(x float64) string {
	if x < 0 {
		return sqrt(-x) + "i"
	}
	return fmt.Sprint(math.Sqrt(x))
}
```

### Switch
A `switch` statement in Go executes the first case that satisfies the condition.
  - Switch cases cannot be constants and values involved cannot be integers
  - `break` statement is automatically appended

```
  switch os := runtime.GOOS; os {
	case "darwin":
		fmt.Println("OS X.")
	case "linux":
		fmt.Println("Linux.")
	default:
		// freebsd, openbsd,
		// plan9, windows...
		fmt.Printf("%s.\n", os)
	}
```

### Defer
A `defer` statement defers the execution of a function until the surrounding function returns.
Deferred functions are pushed onto a stack, when a function returns, its deferred calls are executed in last-in-first-out order.


### Pointers
Go has pointers. A pointer holds the memory address of a value.
The type `var p *int` is a pointer to a `int` value.
Other syntax looks similar to that of C.
```
i, j := 42, 2701

	p := &i         // point to i
	fmt.Println(*p) // read i through the pointer
	*p = 21         // set i through the pointer
	fmt.Println(i)  // see the new value of i
  ```

### Structs
Let `p` be a struct pointer. Then `(*p).X` is equivalent to `p.X`.

##### Struct literals
Denotes a newly allocated struct value by listing the values of its fields.
```
type Vertex struct {
	X, Y int
}

v1 = Vertex{1, 2}  // has type Vertex
v2 = Vertex{X: 1}  // Y:0 is implicit
v3 = Vertex{}      // X:0 and Y:0
p  = &Vertex{1, 2} // has type *Vertex
```

### Arrays
The type `var a [10]int` denotes variable `a` as an array of ten integers.

##### Slice literals
An array without the length

An array literal: `[3]bool{true, true, false}`
A slice literal: `[]bool{true, true, false}
`
This first builds an array literal then builds a slice that references it.
Here is another example syntax with structs.
```
s := []struct {
		i int
		b bool
	}{
		{2, true},
		{3, false},
		{5, true},
		{7, true},
		{11, false},
		{13, true},
	}
  ```

##### Slicing
Slicing works similar with python
```
a[0:10]
a[:10]
a[0:]
a[:]
```
A slice with length and capacity of 0 is `nil`.

Can also create a slice with `make`
```
b := make([]int, 0, 5) // len=0 cap=5 []

c := b[:2]  // len=2 cap=5 [0 0]

d := c[2:5] // len=3 cap=3 [0 0 0]
```

###### Appending to a slice
To append new elements to a slice, use the `append` function.
```
var s []int  // len=0 cap=0 []
s = append(s, 2, 3, 4) // len=3 cap=4 [2 3 4]
```

##### Range
```
var pow = []int{1, 2, 4, 8, 16, 32, 64, 128}

func main() {
	for i, v := range pow {
		fmt.Printf("2**%d = %d\n", i, v)
	}
}
```
The `range` of a slice returns index and copy of the lement at that index.
Can also skip the index or value using `_`
```
for i, _ := range pow
for _, value := range pow
```

### Maps
Maps keys to values.
Use `make` to get a map of the given type
```
type Vertex struct {
	Lat, Long float64
}

var m map[string]Vertex

func main() {
	m = make(map[string]Vertex)
	m["Bell Labs"] = Vertex{
		40.68433, -74.39967,
	}
	// m["Bell Labs"] -> {40.68433 -74.39967}
}
```

##### Map literals
This creates a map literal with type string, Vertex
```
var m = map[string]Vertex{
	"Bell Labs": Vertex{
		40.68433, -74.39967,
	},
	"Google": Vertex{
		37.42202, -122.08408,
	},
}

// m: map[Bell Labs:{40.68433 -74.39967} Google:{37.42202 -122.08408}]
```
##### Mutating maps
To insert, update, retrieve, delete or check if a key is present
```
delete(m, key)
m[key] = elem

// Test if a key is present, if key is in m, ok is true, false otherwise
elem, ok = m[key]
```

### Function values
Can pass functions around just like other values, similar usage as in C.

##### Function closures
Go functions may be closures. The function may access and assign to the variables that are bound to itself.
