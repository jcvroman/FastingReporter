//
//  CarbViewModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/12/22.
//

import Foundation

// NOTE: CarbViewModel represents all CarbModel items plus some extra ones for display convenience.
struct CarbViewModel: Identifiable {
    private var carb: CarbModel

    init(carb: CarbModel) {
        self.carb = carb
    }

    // MARK: - CarbModel properties
    var id: UUID {
        carb.id
    }

    var carbs: Int {
        carb.carbs
    }

    var date: Date {
        carb.date
    }

    var previousDate: Date {
        carb.previousDate ?? Date()
    }

    var diffSeconds: Int {
        carb.diffSeconds ?? 0
    }

    // MARK: - New properties (i.e. not in CarbModel)
    var dateDateStr: String {
        DateFormatter.dateShortFormatter.string(from: carb.date)
    }

    var dateTimeStr: String {
        DateFormatter.timeShortFormatter.string(from: carb.date)
    }

    var previousDateDateStr: String {
        DateFormatter.dateShortFormatter.string(from: carb.previousDate ?? Date())
    }

    var previousDateTimeStr: String {
        DateFormatter.timeShortFormatter.string(from: carb.previousDate ?? Date())
    }

    var diffHoursMinutesStr: String {
        if let seconds = carb.diffSeconds {
            let remaining: TimeInterval = TimeInterval(seconds)
            if let result = DateComponentsFormatter.hoursMinutesAbbreviatedFormatter.string(from: remaining) {
                return result
            }
        }
        return Constants.notApplicableStr
    }
}

// MARK: - Comparable
extension CarbViewModel: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.date > rhs.date     // NOTE: Sort by descending date.
    }
}
