//
//  UserDataSourceMock.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation
import FirebaseAuth

struct UserDataSourceMock: UserDataSourceProtocol {
    func signIn(email: String, password: String) async -> Bool {
        return true
    }
    
    func currentUser() throws -> AuthDataResultModel {
        return AuthDataResultModel(
            uid: "F912NhEjgwRgpw0acr4L",
            email: "ericfrndo@gmail.com",
            photoURL: nil
        )
    }
    
    func logout() throws {
    }
    
    func userDetail() async throws -> UserJSON {
        let user = UserJSON(
            id: "ZHY6Hd8GfDR3CWPZPHWSPjz7jLu2",
            email: "ericfrndo@gmail.com",
            phoneNumber: "082213231071",
            gender: .male,
            profileImage: "https://firebasestorage.googleapis.com:443/v0/b/deal-dulu.firebasestorage.app/o/images%2FC4652ECF-ACB4-44A8-82A4-C8CE74F176CF.jpeg?alt=media&token=d81f399a-2fd6-4dc5-88d6-3984087f186b",
            rating: 4.9,
            pricing: 110,
            games: ["cod", "ml", "dota", "pubg", "csgo"],
            username: "ericfrndo",
            activeDate: Date()
        )
        return user
    }
}
