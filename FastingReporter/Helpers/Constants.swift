//
//  Constants.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/14/22.
//

import Foundation
import SwiftUI

public enum Constants {
    // MARK: - Bundle Info.
    static let appName: String = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "appName"
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "appVersion"
    static let buildVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "buildVersion"

    // MARK: - Strings: Miscellaneous.
    static let lineReturn: String = "\r\n"
    static let notApplicableStr: String = "---"
    static let defaultCarbBlankStr: String = "     "

    // MARK: - Ints: Miscellaneous.
    static let fastColorLevelA: Int = 16
    static let fastColorLevelB: Int = 14
    static let fastColorLevelC: Int = 12

    // MARK: - Colors: Miscellaneous.
    static let fastColorLevelAColor: Color = .green
    static let fastColorLevelBColor: Color = .blue
    static let fastColorLevelCColor: Color = .orange
    static let fastColorLevelDefaultColor: Color = .secondary
}
