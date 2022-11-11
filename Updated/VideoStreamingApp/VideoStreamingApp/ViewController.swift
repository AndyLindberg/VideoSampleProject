//
//  ViewController.swift
//  VideoStreamingApp
//
//  Created by Andy Lindberg on 11/10/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    private var viewModel: ViewModelProtocol?
    
    private var player: AVPlayer?
    private var playerView = AVPlayerLayer()
    
    private var video: VideoModel?
//    private var video: VideoModel? = {
//        didSet {
////            if let firstVideo = viewModel?.getFirstVideo() {
////                configureVideo(with: firstVideo)
////                setupView()
////            }
//        }
//    }
    
    
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
            self?.video = self?.viewModel?.video
            self?.configureVideo(with: (self?.video)!)
            self?.setupView()
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
        guard let videoURLString = videoModel.videosArray[0].url else { return }
        
        titleLabel.text = videoModel.description
        descriptionLabel.text = "Description:"
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        guard let videoURL = URL(string: videoURLString) else { return }
        player = AVPlayer(url: videoURL)
        playerView.player = player
        playerView.videoGravity = .resizeAspect
        playerView.player?.volume = 0
    }
    
    private func setupView() {
        view.backgroundColor = .white
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
        labelStackView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 20).isActive = true
        labelStackView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -5).isActive = true
        labelStackView.addArrangedSubview(descriptionLabel)
        labelStackView.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentStackView.setCustomSpacing(100, after: labelStackView)
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
        playVideo()
    }
    
    @objc func playVideo() {
        player?.play()
    }
    
    @objc func pauseVideo() {
        player?.pause()
    }


}

