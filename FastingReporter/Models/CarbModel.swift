//
//  CarbModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

// BUG: TODO: carbs should be a Double.
struct CarbModel: Identifiable {
    var id = UUID()
    var carbs: Int
    var date: Date
    var previousDate: Date?
    var diffSeconds: Int?
}

// MARK: - Comparable
extension CarbModel: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.date > rhs.date     // NOTE: Sort by descending date.
    }
}
