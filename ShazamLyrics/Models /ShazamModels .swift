//
//  ShazamModels .swift
//  ShazamLyrics
//
//  Created by Alondra García Morales on 26/03/24.
//

import Foundation

struct ShazamModels : Decodable {
    let title : String?
    let artist : String?
    let album : URL?
}
