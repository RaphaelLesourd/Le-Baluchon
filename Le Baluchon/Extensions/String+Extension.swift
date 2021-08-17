//
//  String_Extension.swift
//  Le Baluchon
//
//  Created by Birkyboy on 11/08/2021.
//

import Foundation

extension String {
    /// Replaces the comma decimal sign to a period sign contained in a string.
    /// - Typically used when to convert decimal numbers in a String to a Double.
    /// - Returns: Formatted String
    func replaceDecimal() -> String {
        return self.replacingOccurrences(of: ",", with: ".")
    }
    /// Computed property return a bool depending if multiple '.' characters is present or not.
    /// - Check if characters are separated by a '.', if the count - 1 is over 1 then returns true.
    /// - count - 1 : For our use case to convert a string to a double we need at least one decimal point '.'
    var singleDecimalSymbol: Bool {
        return self.components(separatedBy: ".").count - 1 > 1
    }
}
