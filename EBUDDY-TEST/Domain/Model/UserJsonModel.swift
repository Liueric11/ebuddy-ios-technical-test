//
//  UserJsonModel.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation

enum GenderEnum: Int, Codable, CaseIterable {
    case female = 0
    case male = 1

    var displayName: String {
        switch self {
        case .female: return "Female"
        case .male: return "Male"
        }
    }
}

struct UserJSON: Identifiable, Codable {
    let id: String?
    let email: String?
    let phoneNumber: String?
    let gender: GenderEnum?
    let profileImage: String?
    let rating: Double?
    let pricing: Double?
    let games: [String]?
    let username: String?

    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case email
        case phoneNumber
        case gender = "ge"
        case profileImage
        case rating
        case pricing
        case games
        case username
    }
}

