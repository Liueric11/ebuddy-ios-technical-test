//
//  UsersListView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 23/12/24.
//

import SwiftUI

enum Filter: String, CaseIterable {
    case active
    case rating
    case female
    case pricing
}

struct UsersListView: View {
    
    @StateObject private var viewModel = UserListViewModel()
    @State private var showErrorModal = false
    
    var body: some View {
        VStack{
            if let users = viewModel.users, users.isEmpty == false {
                List{
                    ForEach(users) { user in
                        VStack(alignment: .leading){
                            Text("username: \(user.username ?? "N/A")")
                                .font(.system(size: 14))
                            Text("Active Date: \(FormatDate.dateFormatter(date: user.activeDate))")
                                .font(.system(size: 14))
                            Text("rating: \(user.rating.map { String(format: "%.1f", $0) } ?? "N/A")")
                                .font(.system(size: 14))
                            Text("pricing: \(user.pricing.map { String(format: "%.0f", $0) } ?? "N/A")")
                                .font(.system(size: 14))
                            Text("Gender: \(user.gender != nil ? (user.gender == .male ? "Male" : "Female") : "N/A")")
                                .font(.system(size: 14))
                        }
                    }
                }
            } else {
                Text("No Data")
            }
        }
        .onAppear{
            viewModel.fetchUsers()
        }
        .alert(isPresented: $showErrorModal) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("loading...").progressViewStyle(
                    CircularProgressViewStyle())
            }
        }
        .onChange(of: viewModel.errorMessage) { oldValue, newValue in
            if newValue != nil {
                showErrorModal = true
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Filter.allCases, id: \.self) { filter in
                            Button(action: {
                                viewModel.toggleFilter(filter)
                                viewModel.fetchUsers()
                            }) {
                                Text(filter.rawValue)
                                    .padding(8)
                                    .background(viewModel.isFilterActive(filter) ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundStyle(.textPrimary)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        UsersListView()
    }
}
