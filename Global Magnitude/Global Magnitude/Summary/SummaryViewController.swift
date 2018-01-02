//
//  SummaryViewController.swift
//  Global Magnitude
//
//  Created by sheen vempeny on 1/1/18.
//  Copyright © 2018 sheen vempeny. All rights reserved.
//

import UIKit

class SummaryViewController: GradientViewController {

    var roundSummary:Summary!
    
     let summaryUpdator:SummaryUpdator = SummaryUpdator()
    
    @IBOutlet weak var lblTotalQuestions:UILabel!
    @IBOutlet weak var lblRightAnswer:UILabel!
    @IBOutlet weak var lblPercentage:UILabel!
    @IBOutlet weak var lblAvgTime:UILabel!
    @IBOutlet weak var lblMatchTime:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LeaderDataManager.update(inSummary: self.roundSummary, userId: SettingsHandler.shared.gameHandle!, completion: {(status:Bool) in
            
            if status == true {
                print("posted")
            }
            else{
                print("error in posting")
            }
        })
        
        // Do any additional setup after loading the view.
       summaryUpdator.lblTotalQuestions = self.lblTotalQuestions
        summaryUpdator.lblRightAnswer = self.lblRightAnswer
        summaryUpdator.lblMatchTime = self.lblMatchTime
        summaryUpdator.lblAvgTime = self.lblAvgTime
        summaryUpdator.lblPercentage = self.lblPercentage
        summaryUpdator.update(inSummary: self.roundSummary)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class SummaryUpdator{
    
    weak var lblTotalQuestions:UILabel!
    weak var lblRightAnswer:UILabel!
    weak var lblAvgTime:UILabel!
    weak var lblMatchTime:UILabel!
    weak var lblPercentage:UILabel!
    
    func update(inSummary:Summary)  {
        
        self.lblAvgTime.text = String(format:"%.2f s", inSummary.avgTime)
        self.lblMatchTime.text = String(format:"%.2f s", inSummary.matchTime)
        self.lblPercentage.text =  String(inSummary.score()) + " %"
        self.lblRightAnswer.text = String(inSummary.rightAnswers)
        self.lblTotalQuestions.text = String(inSummary.totalQuestions)
        
    }
}
