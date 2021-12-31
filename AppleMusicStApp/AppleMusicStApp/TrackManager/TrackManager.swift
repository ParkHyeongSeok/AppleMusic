//
//  TrackManager.swift
//  AppleMusicStApp
//
//  Created by joonwon lee on 2020/01/12.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import AVFoundation

class TrackManager {
    
    var tracks = [AVPlayerItem]()
    var album = [Album]()
    var todayTrack: AVPlayerItem?
    
    // 생성자 정의하기
    init() {
        self.tracks = loadTracks()
        self.album = loadAlbums(tracks: self.tracks)
        self.todayTrack = self.tracks.randomElement()
    }

    //  트랙 로드하기
    func loadTracks() -> [AVPlayerItem] {
        // 파일 읽어서 url 가져오기
        let urls = Bundle.main.urls(forResourcesWithExtension: ".mp3", subdirectory: nil) ?? []
        // AVPlayerItem으로 맵핑
        return urls.map { AVPlayerItem(url: $0) }
    }
    
    // 인덱스에 맞는 트랙 로드하기
    func track(at index: Int) -> Track? {
        let playItem = tracks[index]
        // 메타데이터로 AVPlayerItem을 Track으로 파싱
        return playItem.convertToTrack()
    }

    // 앨범 로딩메소드 구현
    func loadAlbums(tracks: [AVPlayerItem]) -> [Album] {
        let tracklist = tracks.compactMap { $0.convertToTrack() }
        // Dictionary grouping 하는 법
        let albumDics = Dictionary(grouping: tracklist) { track in
            track.albumName
        }
        let albums = albumDics.map { (key: String, value: [Track]) in
            return Album(title: key, tracks: value)
        }
        return albums
    }

    // 오늘의 트랙 랜덤으로 선책
    func loadOtherTodaysTrack() {
        self.todayTrack = self.tracks.randomElement()
    }
}
