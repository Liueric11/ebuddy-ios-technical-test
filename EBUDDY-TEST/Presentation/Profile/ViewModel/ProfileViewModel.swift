//
//  ProfileViewModel.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    var userDetailUseCase = UserDetailUseCase(
        repository: UserDataRepository()
    )
    
    @Published var user: UserJSON? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func getUserDetail() {
        self.isLoading = true
        
        Task {
            do {
                let userDetail = try await userDetailUseCase.execute()
                self.isLoading = false
                self.user = userDetail
            } catch {
                self.isLoading = false
                self.errorMessage = "error get user data"
            }
        }
    }
    
    func saveProfileImage(item: PhotosPickerItem) {
        guard let user, let uid = user.id else { return }
        
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let path = try await StorageManager.shared.saveImage(data: data)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await FirestoreManager.shared.updateUserProfileImage(uid: uid, path: url.absoluteString)
        }
    }
}
