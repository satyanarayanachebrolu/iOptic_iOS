//
//  FirstOnBoardViewController.swift
//  iOptic
//
//  Created by Santhosh on 20/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FirstOnBoardViewController: UIViewController,OnBoardPlayAnimation {

    @IBOutlet weak var headerLabel:UILabel!
    @IBOutlet weak var continueButton:UIButton!

    @IBOutlet weak var imageView: UIImageView!
    var playerViewController:AVPlayerViewController = AVPlayerViewController()
    var player:AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerViewController = AVPlayerViewController()
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspectFill;
        playerViewController.showsPlaybackControls = false
        playerViewController.view.frame = self.view.frame
        self.imageView.image = UIImage.init(named: "default_profile_icon")
        self.imageView.addSubview(playerViewController.view)
        self.view.bringSubview(toFront:headerLabel)
        self.view.bringSubview(toFront:continueButton)
        
        self.playAnimation();
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*if let player = self.player {
            self.playerViewController.player = player
            self.playerViewController.player?.play()
        }
        else  {
            DispatchQueue.main.async() {
                let bundle = Bundle.main;
                let moviePath = bundle.path(forResource: "1", ofType: "mov")
                let movieUrl = NSURL.fileURL(withPath: moviePath!)
                self.player = AVPlayer.init(url: movieUrl)
                self.playerViewController.player = self.player
                self.playerViewController.player?.play()

            }

        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    @IBAction func btnTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.walkthough.nextPage()
    }
    func playAnimation()
    {
        DispatchQueue.main.async() {
            let bundle = Bundle.main;
            let moviePath = bundle.path(forResource: "1", ofType: "mov")
            let movieUrl = NSURL.fileURL(withPath: moviePath!)
            self.player = AVPlayer.init(url: movieUrl)
            self.playerViewController.player = self.player
            self.playerViewController.player?.play()
        }

    }
 
}
