//
//  SettingsViewController.swift
//  GRE
//
//  Created by Hoanh An on 7/13/16.
//  Copyright © 2016 Hoanh An. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var tbvButton: UITableView!
    @IBOutlet weak var clvGeneration: UICollectionView!
    let ad = AppDelegate()
    
    var pickGens = [Int]()
    
    override func viewWillAppear(animated: Bool) {
        UIView.animateWithDuration(0.2) {
            self.navigationController!.navigationBar.barTintColor = .whiteColor();
            self.navigationController!.navigationBar.tintColor = .blackColor();
        }
        // UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        pickGens = DB.getPickedGen()
    }
    override func viewWillDisappear(animated: Bool) {
        DB.checkSettingsStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvButton.tableFooterView = UIView()
        clvGeneration.registerNib(UINib.init(nibName: "clvPackCell", bundle: nil), forCellWithReuseIdentifier: "clvPackCell")
    }
    
    //MARK : TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 20
    //
    //    }
    
    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let headerView = UIView(frame: CGRectMake(0,0,self.view.bounds.width,40))
    //        let border = UIView(frame: CGRectMake(0,headerView.frame.size.height - 1,self.view.bounds.width,0.5))
    //        border.backgroundColor = tableView.separatorColor
    //        headerView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    //        headerView.addSubview(border)
    //        return headerView
    //
    //    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.row == CELL_TYPE_SWITCH_SOUND){
            
            var cell:SwitchCell! = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as? SwitchCell
            if (cell == nil) {
                tableView.registerNib(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
                cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as? SwitchCell
            }
            cell.setCellType(CELL_TYPE_SWITCH_SOUND)
            return cell
            
        }else {//if(indexPath.row == CELL_TYPE_SWITCH_RANDOM){
            
            var cell:SwitchCell! = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as? SwitchCell
            if (cell == nil) {
                tableView.registerNib(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
                cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as? SwitchCell
            }
            cell.setCellType(CELL_TYPE_SWITCH_RANDOM)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    //MARK: CollectionView
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6;
    }
    
    func  collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "clvPackCell"
        
        var cell: clvPackCell! = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? clvPackCell
        
        if (cell == nil) {
            collectionView.registerNib(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? clvPackCell
        }
        cell.cellWithGen(indexPath.row + 1)
        if(!pickGens.contains(indexPath.row)){
            cell.alpha = 0.5
        }
        else{
            cell.alpha = 1
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let width = collectionView.frame.size.width/2-16;
        let height = width*0.57;
        return CGSize.init(width:width, height: height);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10,0, 10) // margin between cells
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let genIndex = indexPath.row
        if (pickGens.contains(genIndex)){
            let removeIndex:Int = pickGens.indexOf(genIndex)!
            if(pickGens.count == 1){
                print("You must choose at least 1 gen")
                return
            }
            pickGens.removeAtIndex(removeIndex)
        }
        else{
            pickGens.append(genIndex)
        }
        print("pick count: \(pickGens.count)")
        DB.updateSettings(-1, turnOffMusic: -1, listGens: pickGens)
        collectionView .reloadData()
    }
}
