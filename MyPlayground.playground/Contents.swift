//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var map = function (fn){
    return function(arr){
        return arr.map(fn)
    }
}

var add = function (a){
    return function(b){
        return a + b
    }
}

var add1 = add(1);
var add1toarr = map(add(1))
map(add(1))([1,2])

