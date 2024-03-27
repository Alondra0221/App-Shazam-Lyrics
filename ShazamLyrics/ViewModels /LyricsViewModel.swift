//
//  LyricsViewModel.swift
//  ShazamLyrics
//
//  Created by Alondra García Morales on 26/03/24.
//

import Foundation

@MainActor

class LyricsViewModel : ObservableObject{
    
    
    @Published var lyricsModel = LyricsModel(lyrics: "" , error: "")
    
    func fetc(artist : String, title: String) async {
        do{
            let urlStr = "https://api.lyrics.ovh/v1/\(artist)/\(title)"
            guard let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? "") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let datos = try JSONDecoder().decode(LyricsModel.self, from: data)
            self.lyricsModel = datos
        }catch let error as NSError{
            print("Not found", error.localizedDescription)
        }
    }
}
