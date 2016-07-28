//
//  BackFlashCardViewModel.swift
//  GRE
//
//  Created by Hoanh An on 7/9/16.
//  Copyright © 2016 Hoanh An. All rights reserved.
//

import UIKit
import Spring
import RxCocoa
import RxSwift

class BackFlashCardViewModel: SpringView {

    @IBOutlet weak var imvPokemon: UIImageView!
    @IBOutlet weak var lblPoId: UILabel!
    @IBOutlet weak var vContent: UIView!
    
    var pokemon : Pokemon! {
        didSet{
            self.layout()
        }
    }
    
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layout() {
       self.lblPoId.text = pokemon.id
        self.imvPokemon.image = UIImage(named: pokemon.img)
    }
}
