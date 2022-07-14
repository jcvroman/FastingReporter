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
    static let about = AlertItem(title: Text("\(Constants.appName) Version \(Constants.appVersion) (\(Constants.buildVersion))"),
                                 message: Text("Copyright © 2022 Jimmy Vroman. All rights reserved."),
                                 dismissButton: .default(Text("OK")))

    // NOTE: Errors
    static let fatal = AlertItem(title: Text("Fatal Error"),
                                 message: Text("A fatal error has occurred."),
                                 dismissButton: .default(Text("OK")))
}
