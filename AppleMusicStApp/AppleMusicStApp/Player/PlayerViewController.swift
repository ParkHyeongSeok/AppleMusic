//
//  PlayerViewController.swift
//  AppleMusicStApp
//
//  Created by joonwon lee on 2020/01/12.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var playControlButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    //TODO: SimplePlayer 만들고 프로퍼티 추가
    let simplePlayer = SimplePlayer.shared
    
    var timeObserver: Any?
    var isSeeking: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailImageView.layer.cornerRadius = 4
        updatePlayButton(false)
        updateTime(time: CMTime.zero)
        
        // TODO: TimeObserver 구현
        // 플레이어에서 곡을 재생할 때 0.1초씩 계속 관찰 -> CMTime 객체를 만들어서 줘야 한다.
        // 1초를 10개로 분할 -> 0.1초
        let time = CMTime(seconds: 1, preferredTimescale: 10)
        // CMTime: AVfoundation보다 낮은 수준. CoreMedia. 이 객체가 시간을
        timeObserver = simplePlayer.addPeriodicTimeObserver(forInterval: time, queue: DispatchQueue.main, using: { time in
            // 해당하는 곡의 현재 시간
            self.updateTime(time: time)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTintColor()
        updateTrackInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // TODO: 뷰나갈때 처리 > 심플플레이어
        simplePlayer.pause()
        simplePlayer.replaceCurrentItem(with: nil)
    }
    
    // didBeginDrag
    @IBAction func beginDrag(_ sender: UISlider) {
        isSeeking = true
    }
    
    // didEndDrag
    @IBAction func endDrag(_ sender: UISlider) {
        isSeeking = false
    }
    
    @IBAction func seek(_ sender: UISlider) {
        // TODO: 시킹 구현
        guard let currentItem = simplePlayer.currentItem else { return }
        let currentPosition = Double(sender.value)
        let second = currentPosition * currentItem.duration.seconds
        let time = CMTime(seconds: second, preferredTimescale: 100)
        simplePlayer.seek(to: time)
    }
    
    @IBAction func togglePlayButton(_ sender: UIButton) {
        // TODO: 플레이버튼 토글 구현
        if simplePlayer.isPlaying {
            simplePlayer.pause()
        } else {
            simplePlayer.play()
        }
        
        updatePlayButton(simplePlayer.isPlaying)
    }
}

extension PlayerViewController {
    func updateTrackInfo() {
        // TODO: 트랙 정보 업데이트
        self.thumbnailImageView.image = simplePlayer.currentItem?.convertToTrack()?.artwork
        self.titleLabel.text = simplePlayer.currentItem?.convertToTrack()?.title
        self.artistLabel.text = simplePlayer.currentItem?.convertToTrack()?.artist
    }
    
    func updateTintColor() {
        playControlButton.tintColor = DefaultStyle.Colors.tint
        timeSlider.tintColor = DefaultStyle.Colors.tint
    }
    
    func updateTime(time: CMTime) {
        // print(time.seconds)
        // currentTime label, totalduration label, slider
        
        // TODO: 시간정보 업데이트, 심플플레이어 이용해서 수정
        currentTimeLabel.text = secondsToString(sec: simplePlayer.currentTime)   // 3.1234 >> 00:03
        totalDurationLabel.text = secondsToString(sec: simplePlayer.totalDurationTime)  // 39.2045  >> 00:39
        
        if !isSeeking {
            // 노래 들으면서 시킹하면, 자꾸 슬라이더가 업데이트 됨, 따라서 시킹아닐때마 슬라이더 업데이트
            // TODO: 슬라이더 정보 업데이트
            timeSlider.value = Float(simplePlayer.currentTime / simplePlayer.totalDurationTime)
        }
    }
    
    func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00:00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", min, seconds)
    }
    
    func updatePlayButton(_ isPlaying: Bool) {
        // TODO: 플레이버튼 업데이트 UI작업 > 재생/멈춤
        let configuration = UIImage.SymbolConfiguration(pointSize: 40)
        if isPlaying {
            let image = UIImage(systemName: "pause.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "play.fill", withConfiguration: configuration)
            playControlButton.setImage(image, for: .normal)
        }
        
    }
}
