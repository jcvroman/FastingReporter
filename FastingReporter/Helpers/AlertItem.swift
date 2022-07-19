//
//  AlertItem.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/14/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text
    var dismissButton: Alert.Button?
}

enum AlertContext {
    // NOTE: About
    static let about = AlertItem(title: Text("\(Constants.appName)"),
                                 message: Text("\(aboutMessage)"),
                                 dismissButton: .default(Text("OK")))

    // NOTE: Help
    static let help = AlertItem(title: Text("Help"),
                                 message: Text("\(helpMessage)"),
                                 dismissButton: .default(Text("OK")))

    // NOTE: Errors
    static let fatal = AlertItem(title: Text("Fatal Error"),
                                 message: Text("A fatal error has occurred."),
                                 dismissButton: .default(Text("OK")))
}

// MARK: - Supporting Strings for AlertContext.
private let aboutMessage: String = "Version "
                                   + Constants.appVersion
                                   + " (\(Constants.buildVersion))"
                                   + Constants.lineReturn
                                   + Constants.lineReturn
                                   + "Copyright © 2022 Jimmy Vroman."
                                   + Constants.lineReturn
                                   + "All rights reserved."

private let helpMessage: String = "Track your fasts by entering your carbs eaten (as you eat) into the Health app."
    + Constants.lineReturn
    + Constants.lineReturn
    + "The Dashboard displays: Fast, Fast List, Carbs Entry List and Daily Carbs List."
    + Constants.lineReturn
    + Constants.lineReturn
    + "Fast: The current fast. I.e. The time since the latest carb entry (per it's date) in the Health app. "
    + "All carb entry values included (e.g. 0, 1, ... 100 ...)."
    + Constants.lineReturn
    + Constants.lineReturn
    + "Fast List: A list of the longest fast ending on a date (e.g. it may start on the previous date). "
    + "For a date, it includes a search back through the previous date."
    + Constants.lineReturn
    + Constants.lineReturn
    + "Carbs Entry List: A list of the carb entries on that date."
    + Constants.lineReturn
    + Constants.lineReturn
    + "Daily Carbs List: A list of the total carbs eaten on that date."
    + Constants.lineReturn
    + Constants.lineReturn
    + "Fast Levels: Displayed in the color (noted below) in the Fast List and Carbs Entry List."
    + Constants.lineReturn
    + "A >= \(Constants.fastColorLevelA) (\(Constants.fastColorLevelAColor.description.capitalized))"
    + Constants.lineReturn
    + "B >= \(Constants.fastColorLevelB) (\(Constants.fastColorLevelBColor.description.capitalized))"
    + Constants.lineReturn
    + "C >= \(Constants.fastColorLevelC) (\(Constants.fastColorLevelCColor.description.capitalized))"
    + Constants.lineReturn
    + "D < \(Constants.fastColorLevelC) (\(Constants.fastColorLevelDefaultColor.description.capitalized))"
    + Constants.lineReturn
    + Constants.lineReturn
    + "Thanks, Jimmy"
