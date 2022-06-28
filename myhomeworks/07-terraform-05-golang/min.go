package main

import (
    "fmt"
)

    func Min(x[]int)int {
        min := x[0]
        for i:=0; i<len(x); i++ {
            if min>x[i] {
                min = x[i]
            }
        }
        return min
    }

    func main() {
        var test_arr = []int{48,96,86,68,-10,57,82,63,-12,70,37,34,-52,83,27,-88,19,97,9,17}
        fmt.Println("Список чисел: ", test_arr)
        fmt.Println("Минимальное число: ",Min(test_arr))
    }