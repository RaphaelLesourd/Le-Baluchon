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
}
