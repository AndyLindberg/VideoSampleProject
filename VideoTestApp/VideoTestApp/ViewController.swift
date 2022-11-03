//
//  ViewController.swift
//  VideoTestApp
//
//  Created by Andy Lindberg on 10/21/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    private let viewModel = VideoViewModel()
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var playerView = AVPlayerLayer()
    
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoDescription: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
        
    private var videos: [VideoModel]? = [] {
        didSet {
            print("videos count: \(videos?.count)")
            if let firstVideo = viewModel.getFirstVideo() {
                print("firstVideo url: \(firstVideo.videoURL)")
                configureVideo(with: firstVideo)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseVideo), for: .touchUpInside)

        
        viewModel.fetchVideos() { [weak self] in
            self?.videos = self?.viewModel.videos
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("ViewWillLayoutSubviews!!")
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        videoContainerView.frame = CGRect(x: 0, y: 50, width: screenWidth, height: 200)
        playerView.frame = videoContainerView.bounds
        
    }
    
    private func configureVideo(with videoModel: VideoModel?) {
        guard let model = videoModel, let videoURLString = model.videoURL else {
            return
        }
        
        videoTitle.text = model.title
        videoDescription.text = model.description

        guard let videoURL = URL(string: videoURLString) else { return }
        
        player = AVPlayer(url: videoURL)

        //playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = videoContainerView.bounds
        playerView.videoGravity = .resizeAspectFill
        videoContainerView.layer.addSublayer(playerView)
        player?.volume = 0
    }
    
    private func playPlayer() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print(error.localizedDescription)
        }
        player?.play()
    }
    
    @objc internal func playVideo () {
        playPlayer()
    }
    
    @objc internal func pauseVideo() {
        player?.pause()
    }
    
    
    
}

