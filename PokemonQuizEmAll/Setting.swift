//
//  Settings.swift
//  GRE
//
//  Created by Hoanh An on 7/13/16.
//  Copyright © 2016 Hoanh An. All rights reserved.
//

import Foundation
import RealmSwift

class Setting : Object{
    dynamic var turnOffSound : Int = 0
    dynamic var turnOffMusic: Int = 0
    var pickedGens = List<IntObject>()
    static func create() -> Setting {
        let setting = Setting()
        setting.pickedGens.append(IntObject.create(0))
        DB.createSetting(setting)
        return setting
    }
}


class IntObject: Object {
    dynamic var value = 0
    
    static func create(value: Int) -> IntObject{
        let newIntObject = IntObject()
        newIntObject.value = value
        return newIntObject
    }

}