//
//  FirestoreManager.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Firebase

final class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()

    private init() {}

    func fetchUser(uid: String) async throws -> UserJSON {
        let document = try await db.collection("USERS").document(uid).getDocument()
        guard let data = document.data() else {
            throw URLError(.badServerResponse)
        }

        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let user = try JSONDecoder().decode(UserJSON.self, from: jsonData)
        return user
    }
    
    func updateUserProfileImage(uid: String, path: String) async throws {
        let data: [String:Any] = [
            UserJSON.CodingKeys.profileImage.rawValue: path
        ]
        
        try await db.collection("USERS").document(uid).updateData(data)
    }
    
    func updateUserData(uid: String, email: String, phone: String, gender: Int) async throws {
        let data: [String:Any] = [
            UserJSON.CodingKeys.email.rawValue: email,
            UserJSON.CodingKeys.phoneNumber.rawValue: phone,
            UserJSON.CodingKeys.gender.rawValue: gender
        ]
        
        try await db.collection("USERS").document(uid).updateData(data)
    }
}

