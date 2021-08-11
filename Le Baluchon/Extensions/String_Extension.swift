//
//  String_Extension.swift
//  Le Baluchon
//
//  Created by Birkyboy on 11/08/2021.
//

import Foundation

extension String {
    func replaceDecimal() -> String {
        return self.replacingOccurrences(of: ",", with: ".")
    }
}
