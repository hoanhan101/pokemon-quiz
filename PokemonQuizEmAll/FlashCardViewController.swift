//
//  FlashCardViewController.swift
//  GRE
//
//  Created by Mr.Vu on 7/9/16.
//  Copyright © 2016 Hoanh An. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import AVFoundation
import Spring
import CircleProgressView

class FlashCardViewController: UIViewController {
    
    @IBOutlet weak var CircleProgress: CircleProgressView!
    @IBOutlet weak var btnAnswer3: UIButton!
    @IBOutlet weak var btnAnswer4: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!
    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var vFlashCard: UIView!

    var frontFlashCard : FrontFlashCardViewModel!
    var backFlashCard  : BackFlashCardViewModel!
    var trueAnswerIndex: Int!
    var isFlip = false
    var currentPokemon = 0
    var totalPokemon = 0
    var pokemonCollection = [Pokemon]()
    var totalTime = TOTAL_TIME
    let minusTime = 0.2
    var currentTime = TOTAL_TIME
  
    var colorVariable : Variable<String> = Variable("")
    var scoreVariable : Variable<Int> = Variable(0)

    override func viewWillAppear(animated: Bool) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configLayout()
        self.dumpData()
        self.clickOnButton()
        self.caculateScore()
        self.changeBackgroundColor()
        self.countTime(0.2)
    }
    
    //MARK: Animation
    func flipFlashCard() {
        let frame = CGRectMake(0, 0, self.vFlashCard.layer.frame.size.width,
                               self.vFlashCard.layer.frame.size.height)
        self.backFlashCard.frame = frame

        UIView.transitionFromView(self.frontFlashCard, toView: self.backFlashCard, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        self.isFlip = true
        let delay = 1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            
//            self.currentPokemon += 1
//            if self.currentPokemon == self.totalPokemon {
//                self.currentPokemon = 0
//            }
            self.currentPokemon = self.unsafeRandomIntFrom(0, to: self.totalPokemon - 1)
            UIView.transitionFromView(self.backFlashCard, toView: self.frontFlashCard, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            self.isFlip = false
            self.bindingData()
            if self.navigationItem.hidesBackButton && self.currentTime <= 0 {
                self.caculateHightScore()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func nextCard(view : SpringView) {
        view.delay = 0.1
        view.velocity = 0.5
        view.animateNext {
            view.animation = "slideRight"
            view.animateTo()
            view.x = self.view.bounds.width + self.vFlashCard.bounds.width
            view.animateToNext {
                view.animate()
            }
            view.x = 0
            view.animateToNext {
                view.animateTo()
            //    self.setButtuonEnable(true)
            }
        }
    }
    
    //MARK: Config UI
    func configLayout() {
        // Load FrontFlashCardView
        let frame = CGRectMake(0, 0, self.vFlashCard.layer.frame.size.width,
                                        self.vFlashCard.layer.frame.size.height)
        self.frontFlashCard = NSBundle.mainBundle().loadNibNamed("FrontFlashCardView", owner: self,options: nil) [0] as! FrontFlashCardViewModel
        self.frontFlashCard.frame = frame
        self.vFlashCard.addSubview(self.frontFlashCard)
        
        // Load BackFlashCardView
        self.backFlashCard = NSBundle.mainBundle().loadNibNamed("BackFlashCardView", owner: self,
            options: nil) [0] as! BackFlashCardViewModel
        self.backFlashCard.frame = frame
        
        // config button
        self.btnAnswer1.layer.cornerRadius = self.btnAnswer1.frame.height/2
        self.btnAnswer2.layer.cornerRadius = self.btnAnswer2.frame.height/2
        self.btnAnswer3.layer.cornerRadius = self.btnAnswer3.frame.height/2
        self.btnAnswer4.layer.cornerRadius = self.btnAnswer4.frame.height/2

    }
    
    func changeBackgroundColor() {
        _ = self.colorVariable.asObservable().subscribeNext {
            color in
            if color != "" {
                self.view.backgroundColor = self.hexStringToUIColor(color)
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
                self.navigationController?.navigationBar.translucent = false
                self.navigationController!.navigationBar.barTintColor = self.hexStringToUIColor(color)
                self.navigationController!.navigationBar.tintColor = .whiteColor();
            }
            else {
                let col = self.pokemonCollection[0].color
                self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
                self.navigationController?.navigationBar.translucent = false
                self.navigationController!.navigationBar.barTintColor = self.hexStringToUIColor(col)
                self.navigationController!.navigationBar.tintColor = .whiteColor();
            }
        }
    }
    
    func buttonUserInteration(block : Bool) {
        self.btnAnswer1.userInteractionEnabled = block
        self.btnAnswer2.userInteractionEnabled = block
        self.btnAnswer3.userInteractionEnabled = block
        self.btnAnswer4.userInteractionEnabled = block
        self.navigationItem.hidesBackButton = !block
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    //MARK: Chose Answer
    func delayThenFlipCard(time : Double) {
        NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: #selector(self.flipFlashCard), userInfo: nil, repeats: false)
    }
    
    func countTime(time : Double) {
        NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: #selector(self.reduceTime), userInfo: nil, repeats: true)
    }
    
    func reduceTime() {
        if self.currentTime > 0 {
            self.currentTime -= self.minusTime
            let scaleTime = self.currentTime/self.totalTime
            self.CircleProgress.progress = scaleTime
        }
        else {
            if !isFlip {
                self.caculateHightScore()
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func clickOnButton() {
        _ = self.btnAnswer1.rx_tap.subscribeNext {
            self.buttonUserInteration(false)
            self.showAnswer()
            if self.checkAnswer(self.pokemonCollection[self.currentPokemon].name, btnAnswer: self.btnAnswer1) {
                self.trueAnsert(self.btnAnswer1)
            }
            else {
                self.findTrueAnswer()
            }
        }
        
        _ = self.btnAnswer2.rx_tap.subscribeNext {
            self.buttonUserInteration(false)
            self.showAnswer()
            if self.checkAnswer(self.pokemonCollection[self.currentPokemon].name, btnAnswer: self.btnAnswer2) {
                self.trueAnsert(self.btnAnswer2)
            }
            else {
                self.findTrueAnswer()
            }
        }
        
        _ = self.btnAnswer3.rx_tap.subscribeNext {
            self.buttonUserInteration(false)
            self.showAnswer()
            if self.checkAnswer(self.pokemonCollection[self.currentPokemon].name, btnAnswer: self.btnAnswer3) {
                self.trueAnsert(self.btnAnswer3)
            }
            else {
                self.findTrueAnswer()
            }
        }
        
        _ = self.btnAnswer4.rx_tap.subscribeNext {
            self.buttonUserInteration(false)
            self.showAnswer()
            if self.checkAnswer(self.pokemonCollection[self.currentPokemon].name, btnAnswer: self.btnAnswer4) {
                self.trueAnsert(self.btnAnswer4)
            }
            else {
                self.findTrueAnswer()
            }
        }
    }
    
    func showAnswer() {
      // self.changeBackgroundColor()
        self.delayThenFlipCard(0.5)
    }
    
    func checkAnswer(answer : String, btnAnswer : UIButton) -> Bool {
        if btnAnswer.titleLabel?.text == answer {
            self.scoreVariable.value += 1
            return true
        }
        return false
    }
    
    func trueAnsert(trueBtn : UIButton) {
//        if self.currentTime < self.totalTime {
//            self.currentTime += 1
//        }
        trueBtn.backgroundColor = self.hexStringToUIColor("#5ad427")
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            trueBtn.backgroundColor = UIColor.whiteColor()
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.buttonUserInteration(true)
            }

        }

    }
    
    func falseAnswer(trueBtn : UIButton, failButton1 : UIButton, failButton2 : UIButton, failButton3 : UIButton) {
        trueBtn.backgroundColor = self.hexStringToUIColor("#5ad427")
        failButton1.backgroundColor = self.hexStringToUIColor("#FF3A2D")
        failButton2.backgroundColor = self.hexStringToUIColor("#FF3A2D")
        failButton3.backgroundColor = self.hexStringToUIColor("#FF3A2D")
        
        let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            trueBtn.backgroundColor = UIColor.whiteColor()
            failButton1.backgroundColor = UIColor.whiteColor()
            failButton2.backgroundColor = UIColor.whiteColor()
            failButton3.backgroundColor = UIColor.whiteColor()
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.buttonUserInteration(true)
            }
        }
    }
    
    func findTrueAnswer() {
        switch self.trueAnswerIndex {
        case 0:
            self.falseAnswer(btnAnswer1, failButton1: btnAnswer2, failButton2: btnAnswer3, failButton3: btnAnswer4)
        case 1:
            self.falseAnswer(btnAnswer2, failButton1: btnAnswer1, failButton2: btnAnswer3, failButton3: btnAnswer4)
        case 2:
            self.falseAnswer(btnAnswer3, failButton1: btnAnswer2, failButton2: btnAnswer1, failButton3: btnAnswer4)
        case 3:
            self.falseAnswer(btnAnswer4, failButton1: btnAnswer2, failButton2: btnAnswer3, failButton3: btnAnswer1)
        default:
            print("Answer Failed!")
        }
    }

    //MARK : Score
    func caculateScore() {
        _ = self.scoreVariable.asObservable().subscribeNext {
            score in
            self.lblScore.text = "\(score)"
        }
    }
    
    func caculateHightScore() {
        if DB.getHighScore() == nil {
            HighScore.create(self.scoreVariable.value)
        }
        else {
            print("xxx")
        }
        if self.scoreVariable.value > DB.getHighScore().score {
            DB.updateHighScore(self.scoreVariable.value)
        }
    }
    
    //MARK: Load data
    func dumpData() {
        
        if let file = NSBundle(forClass:AppDelegate.self).pathForResource("gen1", ofType: "json") {
            let data = NSData(contentsOfFile: file)!
            let json = JSON(data:data)
            self.totalPokemon = json.count
            for index in 0..<json.count{
                let name  = json[index]["name"].string!
                let id    = json[index]["id"].string!
                let img   = json[index]["img"].string!
                let gen   = json[index]["gen"].int!
                let color = json[index]["color"].string!
                if DB.getPokemonByName(name) == nil {
                    let pokemon = Pokemon.create(name, id: id, gen: gen, img: img, color: color)
                    self.pokemonCollection.append(pokemon)
                }
                else {
                    let pokemon = DB.getPokemonByName(name)
                    self.pokemonCollection.append(pokemon)
                }
            }
            self.currentPokemon = self.unsafeRandomIntFrom(0, to: self.totalPokemon - 1)
            self.bindingData()
        } else {
            print("file not exists")
        }
    }
    
    func matchingData() {
        self.frontFlashCard.pokemon = self.pokemonCollection[self.currentPokemon]
        self.backFlashCard.pokemon = self.pokemonCollection[self.currentPokemon]
        self.colorVariable.value = self.pokemonCollection[self.currentPokemon].color
    }
    
    func bindingData() {
        self.matchingData()
        let trueAnswerIndex = self.unsafeRandomIntFrom(0, to: 3)
        self.trueAnswerIndex = trueAnswerIndex
        switch trueAnswerIndex {
        case 0:
            self.setTitleForButton(btnAnswer1, failBtn1: btnAnswer2, failBtn2: btnAnswer3, failBtn3: btnAnswer4)
        case 1:
            self.setTitleForButton(btnAnswer2, failBtn1: btnAnswer1, failBtn2: btnAnswer3, failBtn3: btnAnswer4)
        case 2:
            self.setTitleForButton(btnAnswer3, failBtn1: btnAnswer2, failBtn2: btnAnswer1, failBtn3: btnAnswer4)
        case 3:
            self.setTitleForButton(btnAnswer4, failBtn1: btnAnswer2, failBtn2: btnAnswer3, failBtn3: btnAnswer1)
        default:
           print("Random Failed!")
        }
    }
    
    func setTitleForButton(trueBtn : UIButton, failBtn1 : UIButton, failBtn2 : UIButton, failBtn3 : UIButton) {
        let pokemon = self.pokemonCollection[self.currentPokemon]
        let pokemon1 = self.pokemonCollection[self.randomFailAnswer(self.currentPokemon)]
        let pokemon2 = self.pokemonCollection[self.randomFailAnswer(self.currentPokemon)]
        let pokemon3 = self.pokemonCollection[self.randomFailAnswer(self.currentPokemon)]
        
        trueBtn.setTitle(pokemon.name, forState: .Normal)
        failBtn1.setTitle(pokemon1.name, forState: .Normal)
        failBtn2.setTitle(pokemon2.name, forState: .Normal)
        failBtn3.setTitle(pokemon3.name, forState: .Normal)
        self.changeBackgroundColor()
    }
    
    func randomFailAnswer(currentIndex : Int) -> Int {
        var rand = 0
        repeat {
            rand = unsafeRandomIntFrom(0, to: self.totalPokemon - 1)
        } while rand == currentIndex
        return rand
    }
    
    func unsafeRandomIntFrom(start: Int, to end: Int) -> Int {
        return Int(arc4random_uniform(UInt32(end - start + 1))) + start
    }
}
