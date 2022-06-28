package main

    import "fmt"

    func main() {
        for val:=1; val<101; val++ {
            if val%3==0 {
                fmt.Print(val, " ")
            }
        }
    }