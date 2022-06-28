package main

import (
    "testing"
)

func TestMin(t *testing.T) {
    var arr = []int{22,-5,36,124,4,-7,-12,95,38,-77,14,15,-12,43}
    exp:= -77
	var v = Min(arr)
	if v !=exp {
		t.Error("\nSearch error!",
		        "\nExpected: ", exp,
		        "\ngot: ", v)
	}
}