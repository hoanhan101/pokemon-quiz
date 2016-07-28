//
//  DB.swift
//  GRE
//
//  Created by Hoanh An on 7/7/16.
//  Copyright © 2016 Hoanh An. All rights reserved.
//

import RealmSwift

class DB: Object{
    
    static let realm = try! Realm()
    
    //MARK: Pokemon
    static func createPokemon(pokemon : Pokemon) {
        try! realm.write {
            realm.add(pokemon)
        }
    }
    static func getPokemonByName(name : String) -> Pokemon! {
        let predicate = NSPredicate(format: "name = %@", name)
        return realm.objects(Pokemon).filter(predicate).first
    }
    
    //MARK: PACKCARD
    static func createPack(pack : PackCard){
        try! realm.write{
            realm.add(pack)
        }
    }
    
    static func getPackByName(name:String)->PackCard!{
        let predicate = NSPredicate(format: "name = %@", name)
        return realm.objects(PackCard).filter(predicate).first
    }
    
    static func getAllPacks()->[PackCard]{
        let packs = realm.objects(PackCard)
        var returnPacks = [PackCard]()
        for pack:PackCard in packs {
            returnPacks.append(pack)
        }
        return returnPacks
    }
    
    static func getNumberTagOfPack(pack: PackCard, tag:String) -> Int!{
        let findPack = getPackByName(pack.name)
        var numberCount = 0
        for card:Card in findPack.cards {
            if(card.tag == tag){
                numberCount += 1
            }
        }
        return numberCount
    }
    
    //MARK: CARD
    static func createCard(card : Card){
        try! realm.write{
            realm.add(card)
        }
    }
    
    static func getAllCards()->[Card]!{
        let cards = realm.objects(Card)
        var returnCards = [Card]()
        for card:Card in cards {
            returnCards.append(card)
        }
        return returnCards
    }
    
    static func getCardByWord(word : String) -> Card! {
        let predicate = NSPredicate(format: "word = %@", word)
        return realm.objects(Card).filter(predicate).first
    }
    
    static func getCardInPack(pack : PackCard, word : String) -> Card! {
        var card  : Card!
        for c in pack.cards {
            if c.word == word {
                card = c
            }
        }
        return card
    }
    
    static func updateTag(pack : PackCard,word : String, tag : String) {
        for card in pack.cards {
            if card.word == word {
                try! realm.write {
                    card.tag = tag
                }
            }
        }
        
    }
    static func updateTag(card : Card, tag : String) {
        try! realm.write {
            card.tag = tag
        }
    }
    
    //MARK: HighScore
    static func createHighScore(highScore: HighScore){
        try! realm.write{
            realm.add(highScore)
        }
    }
    static func updateHighScore(score : Int){
        let highScore = realm.objects(HighScore).first
        if(highScore != nil){
            try! realm.write{
                if(highScore?.score < score){
                    highScore?.score = score
                }
            }
        }else{
            HighScore.create(score)
            DB.updateHighScore(score)
        }
    }
    
    static func getHighScore() -> HighScore! {
        return (realm.objects(HighScore).first)
    }
    
    //MARK: Setting
    static func createSetting(setting : Setting){
        try! realm.write{
            realm.add(setting)
        }
    }
    
    static func updateSetting(turnOffSound: Int, turnOffMusic: Int){
        let setting = realm.objects(Setting).first
        if(setting != nil){
            try! realm.write {
                if(turnOffSound==0 || turnOffSound == 1){
                    setting?.turnOffSound = turnOffSound
                }
                if(turnOffMusic == 0 || turnOffMusic == 1){
                    setting?.turnOffMusic = turnOffMusic
                }
            }
        }else{
            Setting.create()
            DB.updateSetting(turnOffSound, turnOffMusic: turnOffMusic)
        }
    }
    
    static func updateSettings(turnOffSound: Int, turnOffMusic: Int, listGens: [Int]){
        let setting = realm.objects(Setting).first
        if(setting != nil){
            try! realm.write {
                if(turnOffSound==0 || turnOffSound == 1){
                    setting?.turnOffSound = turnOffSound
                }
                if(turnOffMusic == 0 || turnOffMusic == 1){
                    setting?.turnOffMusic = turnOffMusic
                }
                if(listGens.count <= 0){
                    // setting?.pickedGens.append(IntObject.create(0))
                }
                else{
                    setting?.pickedGens.removeAll()
                    for indexGen: Int in listGens{
                        let newIntObject = IntObject.create(indexGen)
                        setting?.pickedGens.append(newIntObject)
                    }
                }
            }
        }else{
            Setting.create()
            DB.updateSettings(turnOffSound, turnOffMusic: turnOffMusic,listGens: listGens)
        }
    }
    
    static func getSoundOn()->Bool{
        let setting = realm.objects(Setting).first
        if(setting != nil){
            if(setting?.turnOffSound == 1){
                return false
            }
        }
        return true
    }
    
    static func getMusicOn()->Bool{
        let setting = realm.objects(Setting).first
        if(setting != nil){
            if(setting?.turnOffMusic == 1){
                return false
            }
        }
        return true
    }
    static func getPickedGen()->[Int]{
        let setting = realm.objects(Setting).first
        var pickedGen = [Int]()
        if(setting != nil){
            for genIndex:IntObject in (setting?.pickedGens)! {
                pickedGen.append(genIndex.value)
            }
        }
        else{
            pickedGen.append(0)
            DB.updateSettings(-1, turnOffMusic: -1, listGens: pickedGen)
        }
        return pickedGen
    }
    static func checkSettingsStatus(){
        print("sound: \(DB.getSoundOn()) - music: \(DB.getMusicOn()) - genCount : \(DB.getPickedGen().count)")
    }
    
}
