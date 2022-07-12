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

    var diffMinutes: Int {
        carb.diffMinutes ?? 0
    }

    var dateDateStr: String {
        DateFormatter.dateShortFormatter.string(from: carb.date)
    }

    var dateTimeStr: String {
        DateFormatter.timeShortFormatter.string(from: carb.date)
    }
}

// MARK: - Comparable
extension CarbViewModel: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.date > rhs.date     // NOTE: Sort by descending date.
    }
}
