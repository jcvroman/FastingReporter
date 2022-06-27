// import Darwin
import UIKit
/*
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
*/


// FIXME: TODO: Collections playground not editable. Why? So, added Collections code to Dates for now.
// import Darwin
// import UIKit

/*
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
*/

// Update item value in current element from adjacent element in a collection.
struct CarbModel {
    var id: Int
    var carbs: Int
    var nextCarbs: Int
}

var carbsList: [CarbModel] = []
var carbsList2: [CarbModel] = []
var carbs1: CarbModel = CarbModel(id: 1, carbs: 10, nextCarbs: 0)
var carbs2: CarbModel = CarbModel(id: 2, carbs: 20, nextCarbs: 0)
carbsList.append(carbs1)
carbsList.append(carbs2)


for (var lhs, rhs) in zip(carbsList, carbsList.dropFirst()) {
    print("lhs.id: \(lhs.id) | lhs.carbs: \(lhs.carbs) | lhs.nextCarbs: \(lhs.nextCarbs)")
    print("rhs.id: \(rhs.id) | rhs.carbs: \(rhs.carbs) | rhs.nextCarbs: \(rhs.nextCarbs)")
    lhs.nextCarbs = rhs.carbs
    carbsList2.append(lhs)
    print("lhs.id: \(lhs.id) | lhs.carbs: \(lhs.carbs) | lhs.nextCarbs: \(lhs.nextCarbs)")
    print("rhs.id: \(rhs.id) | rhs.carbs: \(rhs.carbs) | rhs.nextCarbs: \(rhs.nextCarbs)")
}

for element in carbsList2 {
    print("element.id: \(element.id) | element.carbs: \(element.carbs) | element.nextCarbs: \(element.nextCarbs)")
}


