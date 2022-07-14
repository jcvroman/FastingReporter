//
//  Constants.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/14/22.
//

import Foundation

public enum Constants {
    static let appName: String = Bundle.main.infoDictionary?["CFBundleName"] as! String
    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    static let buildVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
}
