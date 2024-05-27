//
//  Lesson11Practice.swift
//  combineRoadmap
//
//  Created by Adlet Zhantassov on 27.05.2024.
//

import SwiftUI
import Combine

struct URLSessionDataTaskPublisherView: View {
    var body: some View {
        VStack {
            Image(.rickLogo)
                .frame(maxWidth: .infinity, maxHeight: 104)
            switch viewModel.state {
            case .start:
                EmptyView()
            case .loading:
                Spacer()
                    .frame(height: 150)
                Image(.portal)
                    .rotationEffect(Angle(degrees: portalIsAnimation ? 360.0 : 0.0))
                    .frame(width: 200, height: 200)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 2).repeatForever()) {
                            portalIsAnimation = true
                        }
                    }
            case .data(let episodes):
                List(episodes, id: \.id) { episode in
                    crateEpisodeCell(episode: episode)
                }
                .listStyle(.plain)
                .listRowSpacing(55)
                .hideListIndicatorsView()
            case .error(let error):
                Text("\(error.localizedDescription))")
            }
        }
        .onAppear {
            viewModel.fetch()
        }
    }
    
    @StateObject private var viewModel = URLSessionDataTaskPublisherViewModel()
    @State private var portalIsAnimation = false
    
    private func crateEpisodeCell(episode: Episode) -> some View {
        VStack {
            createImage(episode)
            HStack {
                Text(episode.characterName ?? "")
                    .font(.title3.bold())
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, 20)
            HStack {
                Image(.playIcon)
                Text("Pilot | \(episode.serialNumerTitle)")
                Spacer()
                Image(.likeEpisodeHeart)
            }
            .padding()
            .frame(height: 71)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.appSoftLight)
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(.white)
                .shadow(radius: 4)
        )
        .listRowSeparator(.hidden)
    }
    
    private func createImage(_ episode: Episode) -> some View {
        AsyncImage(url: episode.characterImage) { state in
            switch state {
            case .empty:
                EmptyView()
                    .frame(height: 232)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 232)
                    .cornerRadius(8, corners: [.topLeft, .topRight])
            case .failure(_):
                Image(systemName: "questionmark.app.dashed")
                    .frame(height: 232)
            @unknown default:
                EmptyView()
                    .frame(height: 232)
            }
        }
    }
}

#Preview {
    URLSessionDataTaskPublisherView()
}
