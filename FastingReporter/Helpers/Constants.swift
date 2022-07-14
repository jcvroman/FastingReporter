//
//  Constants.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/14/22.
//

import Foundation

public enum Constants {
    static let appName: String = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "appName"
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "appVersion"
    static let buildVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "buildVersion"
}