//
//  ThirdOnBoardViewController.swift
//  iOptic
//
//  Created by Santhosh on 20/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class ThirdOnBoardViewController: UIViewController,OnBoardPlayAnimation {

    @IBOutlet weak var headerLabel:UILabel!
    @IBOutlet weak var continueButton:UIButton!
    @IBOutlet weak var imgView: UIImageView!
    var playerViewController:AVPlayerViewController = AVPlayerViewController()
    var player:AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspectFill;
        playerViewController.showsPlaybackControls = false
        playerViewController.view.frame = self.view.frame
        self.imgView.addSubview(playerViewController.view)
        self.view.bringSubview(toFront:headerLabel)
        self.view.bringSubview(toFront:continueButton)
        
        self.playAnimation();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    @IBAction func startedTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showLoginScreen()
        UserDefaults.standard.set(true, forKey: "isTutorialShown")

    }

    func playAnimation()
    {
        DispatchQueue.main.async() {
            let bundle = Bundle.main;
            let moviePath = bundle.path(forResource: "3", ofType: "mov")
            let movieUrl = NSURL.fileURL(withPath: moviePath!)
            self.player = AVPlayer.init(url: movieUrl)
            NotificationCenter.default.addObserver(self, selector: #selector(ThirdOnBoardViewController.playerDidFinishPlaying),
                                                             name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
            self.playerViewController.player = self.player
            self.playerViewController.player?.play()
        }
    }
    
    func playerDidFinishPlaying()
    {
        NotificationCenter.default.removeObserver(self)
        playAnimation()
    }

}
