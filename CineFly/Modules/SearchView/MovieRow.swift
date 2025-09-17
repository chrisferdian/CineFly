//
//  MovieRow.swift
//  CineFly
//
//  Created by chris on 16/09/25.
//

import SwiftUI

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            AsyncImage(url: movie.posterURL) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 60, height: 90)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(movie.title ?? "Unknown Title").font(.headline)
                Text(movie.release_date ?? "Unknown release date").font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
}

struct LoadingMovieRow: View {
    
    var body: some View {
        HStack(alignment: .top) {
            Color.gray.opacity(0.3)
                .frame(width: 60, height: 90)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text("Unknown Title")
                    .font(.headline)
                    .redacted(reason: .placeholder)
                Text("Unknown release date")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .redacted(reason: .placeholder)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }
}
