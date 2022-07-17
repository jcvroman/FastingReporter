//
//  Sequence+Extension.swift
//  FastingReporter
//
//  Created by Jimmy Vroman on 7/17/22.
//

import Foundation

extension Sequence {
    // NOTE: Custom sorting using key paths.
    //       USAGE: fastList = fastList.sorted(by: \.diffSeconds, using: >)
    func sorted<T: Comparable>(
        by keyPath: KeyPath<Element, T>,
        using comparator: (T, T) -> Bool = (<)
    ) -> [Element] {
        sorted { a, b in
            comparator(a[keyPath: keyPath], b[keyPath: keyPath])
        }
    }
}
