//
//  LeaderBoardUpdator.swift
//  Global Magnitude
//
//  Created by sheen vempeny on 12/29/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

import UIKit

class LeaderTableCell:UITableViewCell{
    
    @IBOutlet weak var txtName:UILabel!
    @IBOutlet weak var txtScore:UILabel!
    @IBOutlet weak var txtMTime:UILabel!
    @IBOutlet weak var txtQTime:UILabel!
}


class LeaderBoardUpdator: NSObject {

    class func update(cell:LeaderTableCell,leader:Leader){
        
        cell.txtName.text = leader.userid
        cell.txtScore.text = String(leader.score)
        cell.txtMTime.text = String(leader.mtime)
        cell.txtQTime.text = String(leader.qtime)
    }
}
