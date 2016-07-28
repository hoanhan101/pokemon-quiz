//
//  PlayViewController.swift
//  PokemonQuizEmAll
//
//  Created by Hoanh An on 7/18/16.
//  Copyright © 2016 Hoanh An. All rights reserved.
//

import UIKit
//import AVFoundation

class PlayViewController: UIViewController {
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblHighScoreTitle: UILabel!
    @IBOutlet weak var lblHighScore: UILabel!
    let ad = AppDelegate()

    
    override func viewWillAppear(animated: Bool) {
        setUpColor()
        if DB.getHighScore() != nil {
            lblHighScore.text = "\(DB.getHighScore().score)"
        }
        else {
            lblHighScore.text = "0"
        }
        
        lblHighScore.numberOfLines = 1;
        lblHighScore.adjustsFontSizeToFitWidth = true;
        //playMusic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBtn()
        DB.checkSettingsStatus()
        
        
    }
    func setUpColor(){
        //   UIView.animateWithDuration(0.5) {
        self.navigationController?.navigationBar.barTintColor = THEME_COLOR
        
      //  self.navigationController?.navigationBar.translucent = false
        // }
    }
    
    func setUpBtn()
    {
        btnPlay.addTarget(self, action: #selector(play), forControlEvents: .TouchUpInside)
        addBarButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addBarButton(){
        
        let title = UILabel.init(frame: CGRectMake(0, 0, 320, 40))
        title.textAlignment = .Left
        title.text = "Quiz 'Em All"
        self.navigationItem.titleView = title
        
        let btnSettings : UIButton = UIButton.init(frame: CGRectMake(0, 0, 30, 30))
        btnSettings.setImage(UIImage.init(named: "img-settings"), forState: .Normal)
        btnSettings.addTarget(self, action: #selector(btnSettingsDidTap), forControlEvents: .TouchUpInside)
        let btnBarSettings : UIBarButtonItem = UIBarButtonItem.init(customView: btnSettings)
        self.navigationItem.setRightBarButtonItem(btnBarSettings, animated: true)
    }
    
    func play(){
        let flashCard : FlashCardViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("FlashCardViewController") as? FlashCardViewController)!
        
        self.navigationController?.pushViewController(flashCard, animated: true)
    }
    //MARK: Button Settings
    
    @IBAction func btnSettingsDidTap(sender: AnyObject) {
                let settingsVC : SettingsViewController! = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") as? SettingsViewController
                self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
}
