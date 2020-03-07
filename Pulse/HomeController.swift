//
//  HomeController.swift
//  Pulse
//
//  Created by Alejo Castaño on 01/03/2020.
//  Copyright © 2020 Alejo Castaño. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth

class HomeController: UIViewController {

    func setupViews() {
        view.backgroundColor = UIColor.white
        view.layer.addSublayer(playerLayerView())
    
        view.addSubview(playbackSlider())
        view.addSubview(playButtonView())
        view.addSubview(signOutButton())
    }
    
    var player: AVPlayer?
    var playerItem:AVPlayerItem?
    var videoAsset: AVAsset?
    var playButton:UIButton?
    
    func setPlayerItem() {
        
        let token: String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJhZTYyMTM4OC1lOWVkLTQ0ZTAtYTIyMC0wMzZmOWFkMWIzN2IiLCJ1c2VyIjp7ImlkIjoxMjExNTQ5LCJlbWFpbCI6InNyc2thbnR1c0BnbWFpbC5jb20ifX0.swFSmm8H82utuyxyQvqM2tDD8qnvF2gZWt0YuBm3zFhpvdH5P_MgWA-odCIEkV-xPP3iEeOwk_DEFTCnISaZuQ"
        
        let videoUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
        
        // https://bitdash-a.akamaihd.net/content/sintel/subtitles/subtitles_es.vtt
        // https://www.domestika.org/api/v2/video_item_srts/1392.vtt
        let vttURL = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/subtitles/subtitles_es.vtt")!

        let videoPlusSubtitles = AVMutableComposition()
        
        let headers: [AnyHashable : Any] = [
            "content-type": "application/json",
            "authorization": "Bearer \(token)"
        ]
        
        videoAsset = AVURLAsset(url: videoUrl)
        
        let subtitleAsset = AVURLAsset(url: vttURL, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        
        let subtitleTrack = videoPlusSubtitles.addMutableTrack(withMediaType: .text, preferredTrackID: kCMPersistentTrackID_Invalid)
        try? subtitleTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset!.duration),
                                            of: subtitleAsset.tracks(withMediaType: .text)[0],
                                            at: CMTime.zero)
        
        let videoTrack = videoPlusSubtitles.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        try? videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset!.duration),
                                         of: videoAsset!.tracks(withMediaType: .video)[0],
                                         at: CMTime.zero)
        
        let requiredAssetKeys = ["playable", "hasProtectedContent"]
        
        let playerItem: AVPlayerItem = AVPlayerItem(asset: videoPlusSubtitles, automaticallyLoadedAssetKeys: requiredAssetKeys)
        
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [], context: nil)
        
        player = AVPlayer(playerItem: playerItem)
    }
    
    func playerLayerView() -> AVPlayerLayer {
        setPlayerItem()
        
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = view.bounds
        playerLayer.position.y = 180
        
        return playerLayer
    }
    
    func playButtonView() -> UIButton {
        playButton = UIButton(type: UIButton.ButtonType.system) as UIButton
        playButton!.frame = CGRect(x:5, y:300, width:view.bounds.width - 10, height:45)
        playButton!.backgroundColor = UIColor.lightGray
        playButton!.setTitle("Play", for: UIControl.State.normal)
        playButton!.tintColor = UIColor.black
        playButton!.addTarget(self, action: #selector(self.playButtonTapped(_:)), for: .touchUpInside)
        
        return playButton!
    }
    
    func playbackSlider() -> UISlider {
        let playbackSlider = UISlider(frame:CGRect(x:10, y:260, width: view.bounds.width - 20, height:20))
        let seconds: Float64 = CMTimeGetSeconds(videoAsset!.duration)
        playbackSlider.minimumValue = 0
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
        playbackSlider.tintColor = UIColor.green
        playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        
        return playbackSlider
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over status value
            switch status {
            case .readyToPlay:
                print("---------------------> Player item is ready to play.")
                break
            case .failed:
                print("---------------------> Player item failed. See error")
                break
            case .unknown:
                print("---------------------> Player item is not yet ready")
                break
            @unknown default:
                fatalError()
            }
        }
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
       
        player!.seek(to: targetTime)
       
        if player!.rate == 0 {
           player?.play()
        }
    }
       
    @objc func playButtonTapped(_ sender:UIButton) {
       if player?.rate == 0 {
            player!.play()
           //playButton!.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Pause", for: UIControl.State.normal)
       } else {
           player!.pause()
           //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Play", for: UIControl.State.normal)
       }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc func onSignOutPress() {
        try? Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
