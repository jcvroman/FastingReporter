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
