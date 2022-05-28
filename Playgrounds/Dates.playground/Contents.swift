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
