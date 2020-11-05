//
//  PlayerViewController.swift
//  SimpleMusicApp
//
//  Created by Trần Sơn on 11/5/20.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    public var position:Int = 0
    public var songs:[Song] = []
    
    @IBOutlet var holder :UIView?
    
    var player:AVAudioPlayer?
    
    
    private let albumImageView :UIImageView = {
        let imgageView = UIImageView()
        imgageView.contentMode = .scaleAspectFill
        return imgageView
    }()
    
    private let songNameLabel :UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let albumNameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let playPauseButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        if(holder!.subviews.count == 0)
        {
            configure()
        }
    }
    
    func configure() {
        let song = songs[position]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do
        {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else {
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)! )
            
            guard let player = player else {
                return
            }
            player.volume = 0.5
            
            player.play()
        }
        catch
        {
            print("Error occurred")
        }
        
        
//        setup user interface
        
//        album cover
        
        albumImageView.frame = CGRect(x: 10, y: 10, width: holder!.frame.size.width-20, height: holder!.frame.size.width-20)
        albumImageView.image = UIImage(named: song.imageName)
        holder?.addSubview(albumImageView)
//        Labels: Song name, album, artist
        
        songNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height, width: holder!.frame.size.width-20, height: 70)
        albumNameLabel.frame = CGRect(x: 10,y: albumImageView.frame.size.height + 50,width: holder!.frame.size.width-20,height: 70)
        artistNameLabel.frame = CGRect(x: 10,y: albumImageView.frame.size.height + 100,width: holder!.frame.size.width-20,height: 70)

        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        holder?.addSubview(songNameLabel)
        holder?.addSubview(albumNameLabel)
        holder?.addSubview(artistNameLabel)
//        Slider
        
        let slider = UISlider(frame: CGRect(x: 20, y: holder!.frame.size.height-60, width: holder!.frame.size.width-40, height: 50))
        
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holder?.addSubview(slider)
        
//      player controller
        //let playPauseButton = UIButton()
        let nextButton = UIButton()
        let backButton = UIButton()
        
//      Frame
        let yPosition = artistNameLabel.frame.origin.y + 70
        let size: CGFloat = 60
        
        playPauseButton.frame = CGRect(x: (holder!.frame.size.width - size) / 2.0,y: yPosition,width: size,height: size)

        nextButton.frame = CGRect(x: holder!.frame.size.width - size - 20, y: yPosition,width: size,height: size)

        backButton.frame = CGRect(x: 20,y: yPosition,width: size,height: size)
        
//      Action
        
        playPauseButton.addTarget(self, action: #selector (didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector (didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector (didTapBackButton), for: .touchUpInside)

        
        // images for button and styling for button
        
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        nextButton.tintColor = .black
        backButton.tintColor = .black
        
        holder?.addSubview(playPauseButton)
        holder?.addSubview(nextButton)
        holder?.addSubview(backButton)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let player = player{
            player.stop()
        }
    }
    
    @objc func didSlideSlider(_ slider:UISlider)
    {
        let value = slider.value
        player?.volume = value
    }
    
    @objc func didTapBackButton()
    {
        if(position>0)
        {
            position = position - 1
            player?.stop()
            for subview in holder!.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapNextButton()
    {
        if(position<(songs.count-1))
        {
            position = position + 1
            player?.stop()
            for subview in holder!.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapPlayPauseButton()
    {
        if(player?.isPlaying==true)
        {
            player?.pause()
            // show play button
            
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
            // shrink image
            UIView.animate(withDuration: 0.2, animations: {
                            self.albumImageView.frame = CGRect(x: 30,
                                                               y: 30,
                                                               width: self.holder!.frame.size.width-60,
                                                               height: self.holder!.frame.size.width-60)
                        })
            
           
        }
        else{
            player?.play()
            // show play button
            
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            // increase image size
            UIView.animate(withDuration: 0.2, animations: {
                            self.albumImageView.frame = CGRect(x: 10,
                                                          y: 10,
                                                          width: self.holder!.frame.size.width-20,
                                                          height: self.holder!.frame.size.width-20)
                        })
        }
    }

}
