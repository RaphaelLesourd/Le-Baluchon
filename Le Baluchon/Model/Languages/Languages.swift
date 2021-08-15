//
//  Languages.swift
//  LeBaluchon
//
//  Created by Birkyboy on 14/08/2021.
//

import Foundation

struct Languages: Decodable {
    let data: Datas
}
struct Datas: Decodable {
    let languages: [Language]
}
struct Language: Decodable {
    let language, name: String
}
