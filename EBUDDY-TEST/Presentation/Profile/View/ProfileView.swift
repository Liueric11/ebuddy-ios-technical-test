//
//  ProfileView.swift
//  EBUDDY-TEST
//
//  Created by Eric Fernando on 21/12/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject private var routeManager: NavigationRouter
    @State private var showErrorModal = false
    @Binding var showLoginView: Bool
    
    var imageWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }

    var imageHeight: CGFloat {
        imageWidth * 1.15
    }
    
    var body: some View {
        ScrollView {
            VStack{
                if let user = profileViewModel.user {
                    HStack{
                        HStack(spacing: 16){
                            Button{
                                routeManager.push(to: .settingView(showLoginView: $showLoginView))
                            }label:{
                                Text(user.username ?? "N/A")
                                    .font(.system(size: 48))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.textPrimary)
                                    .lineLimit(1)
                            }
                            
                            Circle()
                                .fill(.success)
                                .frame(width: 16, height: 16)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        HStack(spacing: 16){
                            Image("verified")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .scaledToFit()
                            
                            Image("instagram")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .scaledToFit()
                        }
                    }
                    
                    VStack{
                        if let urlString = user.profileImage, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .frame(width: imageWidth, height: imageHeight)
                                    .scaledToFit()
                                    .cornerRadius(40)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: imageWidth, height: imageHeight)
                            }
                            .padding(0)
                        } else {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .frame(width: imageWidth, height: imageHeight)
                                .cornerRadius(40)
                        }
                        
                        HStack(spacing: 8){
                            Image("lightning")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .scaledToFit()
                            
                            Text("Available today!")
                                .font(.system(size: 24))
                                .fontWeight(.regular)
                                .foregroundStyle(.textPrimary)
                        }
                        .padding(.vertical, 12)
                        .frame(width: imageWidth - 48)
                        .background(
                            ZStack {
                                BlurView()
                                    .cornerRadius(100)
                            }
                        )
                        .offset(y: -imageHeight + 16)
                        
                        HStack{
                            if let games = user.games {
                                HStack(spacing: -30) {
                                    ForEach(Array(games.prefix(2).enumerated()), id: \.element) { index, imageName in
                                        Image(imageName)
                                            .resizable()
                                            .frame(width: 96, height: 96)
                                            .scaledToFit()
                                            .padding(0)
                                            .overlay {
                                                if index == 1 && games.count > 2 {
                                                    Text("+\(games.count - 2)")
                                                        .font(.system(size: 32))
                                                        .fontWeight(.regular)
                                                        .foregroundStyle(.textGames)
                                                        .background{
                                                            Circle()
                                                                .fill(Color.white.opacity(0.6))
                                                                .frame(width: 96, height: 96)
                                                        }
                                                }
                                            }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            Image("voice")
                                .resizable()
                                .frame(width: 62, height: 62)
                                .scaledToFit()
                                .padding(0)
                                .background {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [.gradient1, .gradient2, .gradient3]),
                                                startPoint: .topTrailing,
                                                endPoint: .bottomLeading
                                            )
                                        )
                                        .frame(width: 96, height: 96)
                                }
                                .offset(x: -15)
                        }
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(y: -125)
                    }
                    .padding(.bottom, -110)
                    
                    VStack(alignment: .leading, spacing: 4){
                        HStack(spacing: 8){
                            Image("star")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .scaledToFit()
                            
                            Text("\(user.rating.map { String(format: "%.1f", $0) } ?? "N/A")")
                                .font(.system(size: 32))
                                .fontWeight(.bold)
                                .foregroundStyle(.textPrimary)
                            
                            Text("(61)")
                                .font(.system(size: 32))
                                .fontWeight(.regular)
                                .foregroundStyle(.textTertiary)
                        }
                        
                        HStack(spacing: 8){
                            Image("mana")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .scaledToFit()
                            
                            HStack(alignment: .bottom, spacing: 0) {
                                Text("\(user.pricing.map { String(format: "%.0f", $0) } ?? "N/A")")
                                    .font(.system(size: 48))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.textPrimary)
                                
                                Text(".00/1Hr")
                                    .font(.system(size: 24))
                                    .fontWeight(.regular)
                                    .foregroundStyle(.textPrimary)
                                    .baselineOffset(8)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(16)
        }
        .refreshable {
            profileViewModel.getUserDetail()
        }
        .onAppear {
            profileViewModel.getUserDetail()
        }
        .alert(isPresented: $showErrorModal) {
            Alert(
                title: Text("Error"),
                message: Text(profileViewModel.errorMessage ?? "Unknown error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .overlay {
            if profileViewModel.isLoading {
                ProgressView("loading...").progressViewStyle(
                    CircularProgressViewStyle())
            }
        }
        .onChange(of: profileViewModel.errorMessage) { oldValue, newValue in
            if newValue != nil {
                showErrorModal = true
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var routerManager = NavigationRouter()
    @Previewable @StateObject var profileViewModel = ProfileViewModel()
        
    NavigationStack(path: $routerManager.routes){
        ProfileView(showLoginView: .constant(false))
            .navigationDestination(for: Route.self) { $0 }
    }
    .environmentObject(routerManager)
    .environmentObject(profileViewModel)
}
