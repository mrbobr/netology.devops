package main

    import "fmt"

    func main() {
        input:= 1.0
        for input !=0 {
        input = 0
        fmt.Print("Enter number (0 for exit): ")
        fmt.Scanf("%f", &input)
        fmt.Printf("%.3f m = ", input)
        fmt.Printf("%.3f ft\n", input/0.3048)
        }
    }