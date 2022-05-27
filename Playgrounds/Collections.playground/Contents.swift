import Darwin
import UIKit

// Collections.
// Compare adjacent elements in a collection.
let array = [9, 1, 3, 5, 10, 2, 4, 7, 1]
var biggest = 0

for (lhs, rhs) in zip(array, array.dropFirst()) {
    if lhs > rhs {
        print("\(lhs) > \(rhs)")
        print("do something")
        if lhs > biggest { biggest = lhs }
    } else {
        print("\(lhs) <= \(rhs)")
        print("do nothing")
    }
}

print("biggest: \(biggest)")
