//
//  Translation.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

struct Translation: Decodable {
    let data: Data
}

struct Data: Decodable {
    let translations: [TranslationText]
}

struct TranslationText: Decodable {
    let translatedText, detectedSourceLanguage: String?
}

