//
//  Date+Extension.swift
//  Le Baluchon
//
//  Created by Birkyboy on 13/08/2021.
//

import Foundation

extension Date {
    /// Format `Date`object to readable date.
    /// - Returns: Date string with date and time.
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.calendar = .current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let str = dateFormatter.string(from: self)
        return str
    }
}
