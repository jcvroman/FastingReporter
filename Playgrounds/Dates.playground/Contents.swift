import Darwin
import UIKit

// Dates.
// Calcuate time between dates (e.g. seconds, minutes).
let now = Date.now
let soon = Date.now.addingTimeInterval(3600)

now == soon
now != soon
now < soon
now > soon

// Time Interval.
let diffSecondsSince = soon.timeIntervalSince(now)
let diffSecondsRefDate = soon.timeIntervalSinceReferenceDate

// Calendar.
let diffSeconds = Calendar.current
    .dateComponents([.second], from: now, to: soon)
    .second

let diffMinutes = Calendar.current
    .dateComponents([.minute], from: now, to: soon)
    .minute

let diffHours = Calendar.current
    .dateComponents([.hour], from: now, to: soon)
    .hour


// FIXME: TODO: Collections playground not editable. Why? So, added Collections code to Dates for now.
// import Darwin
// import UIKit

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
