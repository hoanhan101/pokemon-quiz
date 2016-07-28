//
//  FrontFlashCardViewModel.swift
//  GRE
//
//  Created by Hoanh An on 7/9/16.
//  Copyright © 2016 Hoanh An. All rights reserved.
//

import UIKit
import Spring

class FrontFlashCardViewModel: SpringView {
    
    @IBOutlet weak var imvPokemon: UIImageView!
    var pokemon : Pokemon! {
        didSet{
            self.layout()
        }
    }
    
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowRadius = 20
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    func layout() {
        if pokemon.img != "" {
            self.fillBlackColorToImage(self.imvPokemon, imageName: pokemon.img)
        }
    }
    
    func fillBlackColorToImage(imvIcon : UIImageView, imageName : String) {
            let rect = CGRectMake(0, 0, imvIcon.frame.width, imvIcon.frame.height)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            CGContextClipToMask(context, rect, UIImage(named: imageName)?.CGImage)
            CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
            CGContextFillRect(context, rect)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let flipImage = UIImage(CGImage: img.CGImage!, scale: 1.0, orientation: UIImageOrientation.DownMirrored)
            imvIcon.image = flipImage
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
