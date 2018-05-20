//
//  Track.swift
//  urlsession
//
//  Created by 1 on 16/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import Foundation
import SwiftyJSON

class Track {
    let trackName: String
    let artistName: String
    let artworkUrl30: String
    let previewUrl: URL
    var saved = false
    
    init?(json: JSON) {
        self.trackName = json["trackName"].stringValue
        self.artistName = json["artistName"].stringValue
        self.artworkUrl30 = json["artworkUrl30"].stringValue
        guard let previewUrl = URL(string: json["previewUrl"].stringValue) else { return nil }
        self.previewUrl = previewUrl
    }
}

extension Track: Equatable {
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.previewUrl == rhs.previewUrl
    }
}



