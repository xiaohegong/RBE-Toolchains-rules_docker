#Go Cheat Sheet

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



