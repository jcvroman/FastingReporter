//
//  DateFormatter+Extension.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/12/22.
//

import Foundation

extension DateFormatter {
    static let dateShortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.autoupdatingCurrent       // NOTE: Always auto update to current locale.
        // logger.debug("DateFormatter: dateShortFormatter")
        print("DEBUG: DateFormatter: dateShortFormatter")

        return formatter
    }()

    static let timeShortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale.autoupdatingCurrent       // NOTE: Always auto update to current locale.
        // logger.debug("DateFormatter: timeShortFormatter")
        print("DEBUG: DateFormatter: timeShortFormatter")

        return formatter
    }()
}
