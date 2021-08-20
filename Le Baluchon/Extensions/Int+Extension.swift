//
//  Int+Extension.swift
//  LeBaluchon
//
//  Created by Birkyboy on 19/08/2021.
//

import Foundation

extension Int {

    func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}
