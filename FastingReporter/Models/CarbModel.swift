//
//  CarbModel.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 6/25/21.
//

import Foundation

struct CarbModel: Identifiable {
    var id = UUID()
    var carbs: Int
    var date: Date
}

// MARK: - Comparable
extension CarbModel: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.date > rhs.date
    }
}
