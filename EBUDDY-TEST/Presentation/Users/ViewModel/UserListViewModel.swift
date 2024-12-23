//
//  UserListViewModel.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 23/12/24.
//

import Foundation

@MainActor
final class UserListViewModel: ObservableObject {
    @Published var filterActive = false
    @Published var filterRating = false
    @Published var filterFemale = false
    @Published var filterPricing = false
    @Published var users: [UserJSON]? = nil
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func isFilterActive(_ filter: Filter) -> Bool {
        switch filter {
        case .active: return filterActive
        case .rating: return filterRating
        case .female: return filterFemale
        case .pricing: return filterPricing
        }
    }
    
    func toggleFilter(_ filter: Filter) {
        switch filter {
        case .active: filterActive.toggle()
        case .rating: filterRating.toggle()
        case .female: filterFemale.toggle()
        case .pricing: filterPricing.toggle()
        }
    }
    
    func fetchUsers() {
        self.isLoading = true
        self.errorMessage = nil
        Task {
            do {
                let fetchedUsers = try await FirestoreManager.shared.getAllUsers(
                    filterActive: filterActive,
                    filterRating: filterRating,
                    filterFemale: filterFemale,
                    filterPricing: filterPricing
                )
                self.isLoading = false
                self.users = fetchedUsers
            } catch {
                self.isLoading = false
                self.errorMessage = "Failed to load users"
            }
        }
    }
}
