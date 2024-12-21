//
//  UserJsonModel.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation

enum GenderEnum: Int, Codable {
    case female = 0
    case male = 1
}

struct UserJSON: Identifiable, Codable {
    let id: String?
    let email: String?
    let phoneNumber: String?
    let gender: GenderEnum?

    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case email
        case phoneNumber
        case gender = "ge"
    }
}

