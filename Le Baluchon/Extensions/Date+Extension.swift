//
//  Date+Extension.swift
//  Le Baluchon
//
//  Created by Birkyboy on 13/08/2021.
//

import Foundation

extension Date {

    enum DateStyle {
        case dateOnly
        case timeOnly
        case dateAndTime
    }
    /// Format `Date`object to readable date.
    /// - Returns: Date string with date and time.
    func toString(with style: DateStyle = .dateAndTime) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.calendar = .current
        switch style {
        case .dateOnly:
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
        case .timeOnly:
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
        case .dateAndTime:
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
        }

        let str = dateFormatter.string(from: self)
        return str
    }

    func dateToMiliseconds() -> Double {
       return self.timeIntervalSince1970
    }
}
