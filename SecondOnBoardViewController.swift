//
//  SecondOnBoardViewController.swift
//  iOptic
//
//  Created by Santhosh on 20/08/17.
//  Copyright © 2017 mycompany. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SecondOnBoardViewController: UIViewController,OnBoardPlayAnimation {

    @IBOutlet weak var headerLabel:UILabel!
    @IBOutlet weak var continueButton:UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var playerViewController:AVPlayerViewController = AVPlayerViewController()
    var player:AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspectFill;
        playerViewController.showsPlaybackControls = false
        playerViewController.view.frame = self.view.frame
        self.imageView.addSubview(playerViewController.view)
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


    
    @IBAction func continueTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.walkthough.nextPage()
    }

    func playAnimation()
    {
        DispatchQueue.main.async() {
            let bundle = Bundle.main;
            let moviePath = bundle.path(forResource: "2", ofType: "mov")
            let movieUrl = NSURL.fileURL(withPath: moviePath!)
            self.player = AVPlayer.init(url: movieUrl)
            self.playerViewController.player = self.player
            self.playerViewController.player?.play()
        }
    }

}
