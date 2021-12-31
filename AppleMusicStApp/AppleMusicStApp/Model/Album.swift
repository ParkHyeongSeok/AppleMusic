//
//  Album.swift
//  AppleMusicStApp
//
//  Created by 박형석 on 2021/12/31.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

import UIKit

struct Album {
    let title: String
    let tracks: [Track]
    
    var thumbnail: UIImage? {
        return tracks.first?.artwork
    }
    
    var artist: String? {
        return tracks.first?.artist
    }
    
    init(title: String, tracks: [Track]) {
        self.title = title
        self.tracks = tracks
    }
}
