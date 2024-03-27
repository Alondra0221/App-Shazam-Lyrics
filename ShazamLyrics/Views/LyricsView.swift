//
//  LyricsView.swift
//  ShazamLyrics
//
//  Created by Alondra García Morales on 26/03/24.
//

import SwiftUI

struct LyricsView: View {
    
    @StateObject private var lyrics = LyricsViewModel()
    var artist : String
    var title : String
    
    var body: some View {
        VStack{
            Text(title)
                .font(.title2)
                .foregroundStyle(.white)
                .bold()
                .padding(5)
            ScrollView{
                Text(lyrics.lyricsModel.lyrics ?? "Lyrics not founded")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
            }
        }.navigationTitle(artist)
            .task {
                await lyrics.fetc(artist: artist, title: title)
            }
    }
}


