//
//  HomeViewController.swift
//  AppleMusicStApp
//
//  Created by joonwon lee on 2020/01/11.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    // TODO: 트랙관리 객체 추가
    
    @IBOutlet weak var trackCollectionView: UICollectionView!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    let trackManager = TrackManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackManager.loadOtherTodaysTrack()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackManager.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollecionViewCell.identifier, for: indexPath) as? TrackCollecionViewCell else {
            return UICollectionViewCell()
        }
        let track = trackManager.track(at: indexPath.item)
        cell.updateUI(item: track)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            guard let target = trackManager.todayTrack else {
                return UICollectionReusableView()
            }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackCollectionHeaderView.identifier, for: indexPath) as? TrackCollectionHeaderView else {
                return UICollectionReusableView()
            }
            
            header.update(with: target)
            header.tapHandler = { target in
                let sb = UIStoryboard(name: "Player", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
                vc.simplePlayer.replaceCurrentItem(with: target)
                self.present(vc, animated: true)
            }
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let target = trackManager.tracks[indexPath.item]
        
        let sb = UIStoryboard(name: "Player", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        vc.simplePlayer.replaceCurrentItem(with: target)
        self.present(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 20 - card(width) - 20 - card(width) - 20
        // TODO: 셀사이즈 구하기
        let margin: CGFloat = 20
        let cellSpacing: CGFloat = 20
        let width = view.frame.width/2 - margin - cellSpacing/2
        let height = width + 60
        return CGSize(width: width, height: height)
    }
}
