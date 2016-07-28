//
//  clvPackCell.swift
//  GRE
//
//  Created by Hoanh An on 7/11/16.
//  Copyright © 2016 Hoanh An. All rights reserved.
//

import UIKit

class clvPackCell: UICollectionViewCell {
    
    @IBOutlet weak var lblGen: UILabel!
    @IBOutlet weak var imvGen: UIImageView!
    @IBOutlet weak var lblRemaining: UILabel!
    @IBOutlet weak var progessDone: UIProgressView!
    @IBOutlet weak var imgDone: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self .layoutIfNeeded()
        self.layer.cornerRadius = 3.0;
    }
    
    func cellWithGen(gen : Int){
        switch (gen-1) {
        case 0:
            imvGen.image = UIImage.init(named: "Background_Gen1")
            lblGen.text = "GENERATION I"
            break
        case 1:
            imvGen.image = UIImage.init(named: "Background_Gen2")
            lblGen.text = "GENERATION II"
            break
        case 2:
            imvGen.image = UIImage.init(named: "Background_Gen3")
            lblGen.text = "GENERATION III"
            break
        case 3:
            imvGen.image = UIImage.init(named: "Background_Gen4")
            lblGen.text = "GENERATION IV"
            break
        case 4:
            imvGen.image = UIImage.init(named: "Background_Gen5")
            lblGen.text = "GENERATION V"
            break
        case 5:
            imvGen.image = UIImage.init(named: "Background_Gen6")
            lblGen.text = "GENERATION VI"
            break
        default:
            break
        }
    }
//    func cellWith(pack : PackCard){
//       // self.backgroundColor = COMMON1_PACK_COLOR
//        lblTitle.text = pack.name;
//        lblTotal.text = "\(pack.cards.count) cards in this pack"
//        let numberMasterCard = DB.getNumberTagOfPack(pack, tag: MASTER_TAG)
//        if(pack.cards.count == numberMasterCard){
//            lblRemaining.text = "All cards mastered"
//            imgDone.image = UIImage.init(named: "img-check")
//        }
//        else{
//            lblRemaining.text = "\(pack.cards.count - numberMasterCard) remaining to master"
//             imgDone.image = nil
//        }
//       progessDone.setProgress(Float(numberMasterCard)/Float(pack.cards.count), animated: false)
//    }
}
