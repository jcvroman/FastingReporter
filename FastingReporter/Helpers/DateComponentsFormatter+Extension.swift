//
//  DateComponentsFormatter+Extension.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/15/22.
//

import Foundation

extension DateComponentsFormatter {
    static let hoursMinutesAbbreviatedFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        formatter.calendar?.locale = Locale.autoupdatingCurrent // TODO: Verify this is right.
        // logger.debug("DateFormatter: hoursMinutesFormatter")
        print("DEBUG: DateFormatter: hoursMinutesFormatter")

        return formatter
    }()
}
