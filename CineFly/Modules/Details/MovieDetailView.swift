//
//  MovieDetailView.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {
    @Environment(\.nav) private var nav
    @Environment(\.modelContext) private var context
    @Query private var favorites: [MovieEntity]
    
    @StateObject var viewModel: MovieDetailViewModel
    
    private var isFavorite: Bool {
        favorites.contains(where: { $0.id == viewModel.movie.id })
    }
    
    init(movie: Movie) {
        self._viewModel = .init(wrappedValue: .init(movie: movie))
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: viewModel.movie.posterURL) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(minHeight: 100, maxHeight: 600)

                    VStack(alignment: .center, spacing: 8) {
                        Text(viewModel.movie.title ?? "Unknown Title")
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)

                        if let release_date = viewModel.movie.release_date {
                            Text(release_date)
                                .foregroundColor(.secondary)
                        }

                        Text(viewModel.movie.overview ?? ".....")
                            .padding(.top, 8)
                    }
                    .padding(.horizontal)

                    VStack(spacing: 8) {
                        getVideosSection()
                        getCharacterMovieSection()
                        getSimilarMovieSection()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.bottom, 24)
            }

            HStack(alignment: .center, spacing: 0) {
                Button(action: { nav.pop() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(Color.black.opacity(0.6)))
                }
                Spacer()
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(Color.black.opacity(0.6)))
                }
            }
            .padding(.top, 64)
            .padding(.horizontal, 24)
        }
        .ignoresSafeArea(edges: .top)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
        .task {
            await viewModel.fetchCredits()
            await viewModel.getMovieVideo()
            await viewModel.getSimilarMovies()
        }
    }
    private func toggleFavorite() {
        if let fav = favorites.first(where: { $0.id == viewModel.movie.id }) {
            context.delete(fav)
        } else {
            let fav = MovieEntity(movie: viewModel.movie)
            context.insert(fav)
        }
        try? context.save()
    }
    @ViewBuilder
    func getCharacterMovieSection() -> some View {
        if !viewModel.cast.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Cast")
                    .font(.headline)
                    .padding([.horizontal, .top])
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.cast) { char in
                            VStack {
                                AsyncImage(url: char.posterURL) { img in
                                    img.resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                
                                Text(char.name ?? "-")
                                    .font(.caption)
                                    .lineLimit(1)
                                    .frame(maxWidth: 80)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 8)
        }
    }
    
    @ViewBuilder
    func getSimilarMovieSection() -> some View {
        if !viewModel.similarMovies.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Related Movies")
                    .font(.headline)
                    .padding([.horizontal, .top])
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.similarMovies) { related in
                            VStack {
                                AsyncImage(url: related.posterURL) { img in
                                    img.resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 100, height: 150)
                                .clipped()
                                .cornerRadius(8)
                                
                                Text(related.title ?? "Unknown Title")
                                    .font(.caption)
                                    .lineLimit(1)
                                    .frame(maxWidth: 100)
                            }
                            .onTapGesture {
                                nav.push(.detail(related))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
        }
    }
    
    @ViewBuilder
    func getVideosSection() -> some View {
        if !viewModel.videos.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Videos")
                    .font(.title2).bold()
                    .padding([.horizontal, .top])

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.videos) { video in
                            VStack(alignment: .leading) {
                                ZStack {
                                    // Thumbnail
                                    AsyncImage(url: video.thumbnailURL) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 200, height: 120)
                                    .clipped()
                                    .cornerRadius(12)
                                    
                                    if let url = video.youtubeURL {
                                        Button {
                                            UIApplication.shared.open(url)
                                        } label: {
                                            Circle()
                                                .fill(Color.black.opacity(0.6))
                                                .frame(width: 50, height: 50)
                                                .overlay(
                                                    Image(systemName: "play.fill")
                                                        .font(.system(size: 24, weight: .bold))
                                                        .foregroundColor(.white)
                                                )
                                        }
                                        
                                    }
                                    

                                }

                                Text(video.name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: 200)
                            .padding(.vertical, 8)
                            
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
