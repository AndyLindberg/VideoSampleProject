//
//  ProgramaticViewController.swift
//  VideoTestApp
//
//  Created by Andy Lindberg on 10/25/22.
//

import Foundation
import UIKit
import AVKit

class ProgramaticViewController: UIViewController {
    
    private let viewModel = VideoViewModel()
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var playerView = AVPlayerLayer()
    
    var videoContainerView: UIView = UIView()
    var videoTitle: UILabel = UILabel()
    var videoDescription: UILabel = UILabel()
    var playButton: UIButton = UIButton()
    var pauseButton: UIButton = UIButton()
    
    private var videos: [VideoModel]? = [] {
        didSet {
            print("videos count: \(videos?.count)")
            if let firstVideo = viewModel.getFirstVideo() {
                setupView()
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
//            self?.setupView()
            self?.videos = self?.viewModel.videos
        }
        
        self.videoContainerView.setNeedsLayout()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("ViewWillLayoutSubviews!!")
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        videoContainerView.frame = CGRect(x: 0, y: 50, width: screenWidth, height: 200)
        playerView.frame = videoContainerView.bounds
        
    }
    
    
    private func configureVideo(with videoModel: VideoModel?) {
        guard let model = videoModel, let videoURLString = model.videoURL else {
            return
        }
        videoContainerView.layoutIfNeeded()
        videoTitle.text = model.title
        videoDescription.text = model.description

        guard let videoURL = URL(string: videoURLString) else { return }
        
        player = AVPlayer(url: videoURL)

        //playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = videoContainerView.bounds
        playerView.videoGravity = .resizeAspectFill
        //videoContainerView.layer.addSublayer(playerView)
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
    
    private func setupView() {
        view.addSubview(videoContainerView)
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        videoContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0).isActive = true
        videoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        videoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        videoContainerView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        videoContainerView.backgroundColor = .magenta
        videoContainerView.layer.addSublayer(playerView)
        //videoContainerView.frame = view.bounds
        
        view.addSubview(videoTitle)
        videoTitle.translatesAutoresizingMaskIntoConstraints = false
        videoTitle.topAnchor.constraint(equalTo: videoContainerView.bottomAnchor, constant: 10.0).isActive = true
        videoTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        videoTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //videoTitle.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        view.addSubview(videoDescription)
        videoDescription.translatesAutoresizingMaskIntoConstraints = false
        videoDescription.topAnchor.constraint(equalTo: videoTitle.bottomAnchor, constant: 20.0).isActive = true
        videoDescription.leadingAnchor.constraint(equalTo: videoTitle.leadingAnchor).isActive = true
        videoDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.topAnchor.constraint(equalTo: videoDescription.bottomAnchor, constant: 150.0).isActive = true
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(.link, for: .normal)
        
        view.addSubview(pauseButton)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 40.0).isActive = true
        pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.setTitleColor(.link, for: .normal)
    }
    
    
}
