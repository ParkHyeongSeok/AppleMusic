//
//  Extension+AVPlayerItem.swift
//  AppleMusicStApp
//
//  Created by joonwon lee on 2020/01/12.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import AVFoundation
import UIKit

extension AVPlayerItem {
    func convertToTrack() -> Track? {
        // asset안에는 해당 파일의 메타데이터(썸네일, 타이틀, 아티스트 등)이 있다.
        let metadatList = asset.metadata
        
        var trackTitle: String?
        var trackArtist: String?
        var trackAlbumName: String?
        var trackArtwork: UIImage?
        
        for metadata in metadatList {
            if let title = metadata.title {
                trackTitle = title
            }
            
            if let artist = metadata.artist {
               trackArtist = artist
            }
            
            if let albumName = metadata.albumName {
                trackAlbumName = albumName
            }
            
            if let artwork = metadata.artwork {
                trackArtwork = artwork
            }
        }
        
        guard let title = trackTitle,
            let artist = trackArtist,
            let albumName = trackAlbumName,
            let artwork = trackArtwork else {
                return nil
        }
        return Track(title: title, artist: artist, albumName: albumName, artwork: artwork)
    }
}
 
extension AVMetadataItem {
    var title: String? {
        guard let key = commonKey?.rawValue, key == "title" else {
            return nil
        }
        return stringValue
    }
    
    var artist: String? {
        guard let key = commonKey?.rawValue, key == "artist" else {
            return nil
        }
        return stringValue
    }
    
    var albumName: String? {
        guard let key = commonKey?.rawValue, key == "albumName" else {
            return nil
        }
        return stringValue
    }
    
    var artwork: UIImage? {
        guard let key = commonKey?.rawValue, key == "artwork", let data = dataValue, let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        // 현재 재생 중인 아이템이 있는지에 따라 재생 여부 판단
        guard self.currentItem != nil else { return false }
        // 재생 비율로 재생여부를 판단
        return self.rate != 0
    }
}
