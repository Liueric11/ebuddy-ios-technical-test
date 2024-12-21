//
//  StorageManager.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    func saveImage(data: Data) async throws -> String{
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let resultMetaData = try await imagesReference.child(path).putDataAsync(data, metadata: meta)
        
        guard let resultPath = resultMetaData.path else {
            throw URLError(.badServerResponse)
        }
        
        return resultPath
    }
    
    func getUrlForImage(path: String) async throws -> URL {
        return  try await Storage.storage().reference(withPath: path).downloadURL()
    }
}

