//
//  TrackCollectionViewCell.swift
//  AppleMusicStApp
//
//  Created by joonwon lee on 2020/01/12.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

class TrackCollecionViewCell: UICollectionViewCell {
    static let identifier = "TrackCollecionViewCell"
    
    @IBOutlet weak var trackThumbnail: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackArtist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackThumbnail.layer.cornerRadius = 4
        trackArtist.textColor = UIColor.systemGray2
    }
    
    func updateUI(item: Track?) {
        self.trackThumbnail.image = item?.artwork
        self.trackTitle.text = item?.title
        self.trackArtist.text = item?.artist
    }
}
