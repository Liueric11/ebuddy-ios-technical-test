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
        guard document.exists else {
            throw URLError(.badServerResponse)
        }
        return try document.data(as: UserJSON.self)
    }
    
    func updateUserProfileImage(uid: String, path: String) async throws {
        let data: [String:Any] = [
            UserJSON.CodingKeys.profileImage.rawValue: path
        ]
        
        try await db.collection("USERS").document(uid).updateData(data)
    }
    
    func updateUserData(uid: String, email: String, phone: String, gender: Int, username: String, pricing: Double) async throws {
        let data: [String:Any] = [
            UserJSON.CodingKeys.email.rawValue: email,
            UserJSON.CodingKeys.phoneNumber.rawValue: phone,
            UserJSON.CodingKeys.gender.rawValue: gender,
            UserJSON.CodingKeys.username.rawValue: username,
            UserJSON.CodingKeys.pricing.rawValue: pricing
        ]
        
        try await db.collection("USERS").document(uid).updateData(data)
    }
    
    func getAllUsers(
        filterActive: Bool,
        filterRating: Bool,
        filterFemale: Bool,
        filterPricing: Bool
    ) async throws -> [UserJSON] {
        var query: Query = db.collection("USERS")
        
        if filterActive {
            query = query.order(by: UserJSON.CodingKeys.activeDate.rawValue, descending: true)
        }
        
        if filterRating {
            query = query.order(by: UserJSON.CodingKeys.rating.rawValue, descending: true)
        }
        
        if filterFemale {
            query = query.whereField(UserJSON.CodingKeys.gender.rawValue, isEqualTo: 0)
        }
        
        if filterPricing {
            query = query.order(by: UserJSON.CodingKeys.pricing.rawValue, descending: false)
        }
        
        let snapshot = try await query.getDocuments()
        
        let users = snapshot.documents.compactMap { document -> UserJSON? in
            do {
                let user = try document.data(as: UserJSON.self)
                return user
            } catch {
                return nil
            }
        }
        
        return users
    }
}

