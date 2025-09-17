//
//  SearchView.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @StateObject private var navManager = NavigationManager()
    
    @Environment(\.modelContext) private var modelContext
    @Query(
        sort: [
            SortDescriptor(\CachedSearch.timestamp, order: .reverse)
        ],
    ) private var searchList: [CachedSearch]
    
    @Query(
        sort: [
            SortDescriptor(\MovieEntity.timestamp, order: .reverse)
        ],
    ) private var favorites: [MovieEntity]
    
    @StateObject private var viewModel: SearchViewModel
    
    init(context: ModelContext) {
        self._viewModel = .init(wrappedValue: SearchViewModel(context: context))
    }
    
    @State private var query = ""
    
    var body: some View {
        NavigationStack(path: $navManager.path) {
            VStack {
                VStack(content: {
                    TextField("Search movies...", text: $query, onCommit: {
                        Task { await viewModel.search(query: query) }
                    })
                    Divider()
                })
                .padding()
                
                if viewModel.errorMessage != nil && viewModel.movies.isEmpty {
                    getErrorView()
                } else if viewModel.isLoading {
                    getLoadingView()
                } else {
                    if viewModel.movies.isEmpty {
                        getEmptyView()
                    } else {
                        List(viewModel.movies) { movie in
                            MovieRow(movie: movie)
                                .onTapGesture {
                                    navManager.push(.detail(movie))
                                }
                                .onAppear {
                                    if movie.id == viewModel.movies.last?.id {
                                        Task { await viewModel.loadMore(query: query) }
                                    }
                                }
                        }
                        .listStyle(.plain)
                    }
                }
                
                if viewModel.isLoading && !viewModel.movies.isEmpty {
                    ProgressView("Loading...")
                        .padding(.vertical, 24)
                }
                if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                }
                
                
            }
            .navigationDestination(for: ViewRouter.self) { route in
                switch route {
                case .detail(let movie):
                    MovieDetailView(movie: movie)
                case .favorite:
                    EmptyView()
                }
            }
        }
        .environment(\.nav, navManager)
    }
    
    @ViewBuilder
    func getFavoriteSection() -> some View {
        if !favorites.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("You Favorites")
                    .font(.headline)
                    .padding([.horizontal, .top])
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(favorites, id: \.id) { related in
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
                                
                                Text(related.title)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .frame(maxWidth: 100)
                            }
                            .onTapGesture {
                                navManager.push(.detail(related.getMovie()))
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
    func getEmptyView() -> some View {
        getHistoryList()
        getFavoriteSection()
        Image("empty-state")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200, alignment: .center)
        
        Text("Can't find any movies")
            .fontWeight(.medium)
        Spacer()
    }
    @ViewBuilder
    func getHistoryList() -> some View {
        if !searchList.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Recent Searches")
                    .font(.headline)

                ForEach(searchList.prefix(5), id: \.query) { search in
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.gray)
                        Button(action: {
                            query = search.query
                            Task {
                                await viewModel.search(query: query)
                            }
                        }) {
                            Text(search.query)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(Color.gray)
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
    @ViewBuilder
    func getErrorView() -> some View {
        Spacer()
        Image("error-state")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100, alignment: .center)
        
        Text("Can't find any movies")
            .fontWeight(.medium)
        
        Button("Retry") {
            Task {
                await viewModel.search(query: query)
            }
        }
        Spacer()
    }
    
    @ViewBuilder
    func getLoadingView() -> some View {
        VStack(alignment: .leading) {
            LoadingMovieRow()
            LoadingMovieRow()
            LoadingMovieRow()
            Spacer()
        }
    }
}
