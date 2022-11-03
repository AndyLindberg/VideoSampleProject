//
//  StackViewController.swift
//  VideoTestApp
//
//  Created by Andy Lindberg on 11/3/22.
//

import Foundation
import UIKit
import AVKit

class StackViewController: UIViewController {
    
    // AVKit Variables
    private let viewModel = VideoViewModel()
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var playerView = AVPlayerLayer()
    
    //UI Variables
    fileprivate lazy var contentStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 20
        stackview.backgroundColor = .purple
        stackview.distribution = .fill
        stackview.alignment = .center
        return stackview
    }()
    
    fileprivate lazy var labelStackview: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 20
        stackview.backgroundColor = .red
        stackview.distribution = .fill
        stackview.alignment = .center
        return stackview
    }()
    
    fileprivate lazy var buttonStackview: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 20
        stackview.backgroundColor = .purple
        stackview.distribution = .equalCentering
        stackview.alignment = .center
        return stackview
    }()
    
    
    fileprivate lazy var playButton: UIButton = {
        let button1 = UIButton()
        button1.setTitle("Play", for: .normal)
        button1.setTitleColor(.link, for: .normal)
        button1.backgroundColor = .white
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button1.widthAnchor.constraint(equalToConstant: 50).isActive = true


        return button1
    }()
    
    fileprivate lazy var pauseButton: UIButton = {
        let button2 = UIButton()
        button2.setTitle("Pause", for: .normal)
        button2.setTitleColor(.link, for: .normal)
        button2.backgroundColor = .systemPink
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button2.widthAnchor.constraint(equalToConstant: 50).isActive = true

        return button2
    }()
    
    fileprivate lazy var videoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.  "
        label.numberOfLines = 0
        label.backgroundColor = .red
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    fileprivate lazy var videoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
        label.numberOfLines = 0
        label.backgroundColor = .black
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    fileprivate lazy var videoContainerView: UIView = {
        let view = UIView()

        view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        //view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 9/16).isActive = true

        view.backgroundColor = .green
        return view
    }()
    
    private var videos: [VideoModel]? = [] {
        didSet {
            if let firstVideo = viewModel.getFirstVideo() {
                
                configureVideo(with: firstVideo)
                setup()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseVideo), for: .touchUpInside)
        
        viewModel.fetchVideos() { [weak self] in
            self?.videos = self?.viewModel.videos
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("ViewWillLayoutSubviews!!")
//        let screenSize = UIScreen.main.bounds
//        let screenWidth = screenSize.width
//        videoContainerView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
//        videoContainerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 150)
//        playerView.frame = videoContainerView.bounds
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerView.frame = videoContainerView.bounds
        //playerView.layoutIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
        }) { (context) in
          self.playerView.frame.size = self.videoContainerView.bounds.size
        }
      }
    
    private func setup() {
        view.addSubview(contentStackView)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        contentStackView.addArrangedSubview(videoContainerView)
        
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        videoContainerView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        videoContainerView.layer.addSublayer(playerView)
        playerView.frame = videoContainerView.bounds
        
        contentStackView.addArrangedSubview(labelStackview)
        
        labelStackview.translatesAutoresizingMaskIntoConstraints = false
        labelStackview.addArrangedSubview(videoTitleLabel)
        labelStackview.addArrangedSubview(videoDescriptionLabel)
        
        contentStackView.addArrangedSubview(buttonStackview)
        
        buttonStackview.translatesAutoresizingMaskIntoConstraints = false
        buttonStackview.addArrangedSubview(playButton)
        buttonStackview.addArrangedSubview(pauseButton)
        
        videoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        videoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureVideo(with videoModel: VideoModel?) {
        guard let model = videoModel, let videoURLString = model.videoURL else {
            return
        }
        //videoContainerView.layoutIfNeeded()
        videoTitleLabel.text = model.title
        videoDescriptionLabel.text = model.description

        guard let videoURL = URL(string: videoURLString) else { return }
        
        player = AVPlayer(url: videoURL)

        //playerView = AVPlayerLayer()
        playerView.player = player
//        playerView.frame = videoContainerView.bounds
        playerView.videoGravity = .resizeAspect
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
}
