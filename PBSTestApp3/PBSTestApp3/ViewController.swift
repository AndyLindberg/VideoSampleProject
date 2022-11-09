//
//  ViewController.swift
//  PBSTestApp3
//
//  Created by Andy Lindberg on 11/9/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    //AVKit for Video Player
    private var player: AVPlayer?
    private var playerView = AVPlayerLayer()
    
    private var viewModel: ViewModelProtocol?
    
    private var videos: [VideoModel]? = [] {
        didSet {
            if let firstVideo = viewModel?.getFirstVideo() {
                configureVideo(with: firstVideo)
                setupView()
            }
        }
    }
    
    fileprivate lazy var contentStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    fileprivate lazy var labelStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()
    
    fileprivate lazy var buttonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    fileprivate lazy var videoContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    fileprivate lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    fileprivate lazy var pauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(viewModel: ViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseVideo), for: .touchUpInside)
        viewModel?.fetchVideos() { [weak self] in
            self?.videos = self?.viewModel?.videos
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerView.frame = videoContainerView.bounds
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            self.playerView.frame = self.videoContainerView.bounds
        })
    }
    
    private func configureVideo(with videoModel: VideoModel) {
        guard let videoURLString = videoModel.videoURL else { return }
        
        titleLabel.text = videoModel.title
        descriptionLabel.text = videoModel.description
        
        guard let videoURL = URL(string: videoURLString) else { return }
        player = AVPlayer(url: videoURL)
        playerView.player = player
        playerView.videoGravity = .resizeAspectFill
        playerView.player?.volume = 0
    }
    
    private func setupView() {
        view.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        contentStackView.addArrangedSubview(videoContainerView)
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        videoContainerView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
        videoContainerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        videoContainerView.layer.addSublayer(playerView)
        
        contentStackView.setCustomSpacing(5, after: videoContainerView)
        contentStackView.addArrangedSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentStackView.setCustomSpacing(200, after: labelStackView)
        contentStackView.addArrangedSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(playButton)
        buttonStackView.addArrangedSubview(pauseButton)
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pauseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    private func playVideoPlayer() {
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback)
//        }catch {
//            print(error.localizedDescription)
//        }
        playVideo()
    }
    
    @objc func playVideo() {
        player?.play()
    }
    
    @objc func pauseVideo() {
        player?.pause()
    }


}

