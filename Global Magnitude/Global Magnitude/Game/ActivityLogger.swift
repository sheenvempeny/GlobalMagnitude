//
//  ActivityLogger.swift
//  Global Magnitude
//
//  Created by sheen vempeny on 1/1/18.
//  Copyright © 2018 sheen vempeny. All rights reserved.
//

import UIKit

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class Summary {
    
    var totalQuestions:Int!
    var rightAnswers:Int!
    var avgTime:TimeInterval!
    var matchTime:TimeInterval!
    
    func score() -> Int{
        let percetage = (Float(self.rightAnswers)/Float(self.totalQuestions)) * 100
        return Int(percetage)
    }
    
}

class ActivityLogger: NSObject {
    
    public private(set) var totalQuestions:Int = 0
    public private(set) var rightAnswers:Int = 0
    private var questStartTime:Date!
    public private(set) var matchTime:TimeInterval! = 0
    
    private func score() -> Int{
        //the score as a percentage of correct answers over total problems
        let score = (self.rightAnswers/self.totalQuestions) * 100
        return score
    }
    
    private func avgTime() -> Double {
        
        return self.matchTime/Double(self.totalQuestions)
    }
    
    func reset(){
        
        self.matchTime = 0
        self.totalQuestions = 0
        self.rightAnswers = 0
    }

    func questionStarted(index:Int){
        self.totalQuestions += 1
        self.questStartTime = Date()
    }
    
    func questionStopped(index:Int,isCorrect:Bool){
        
        if isCorrect == true {
            self.rightAnswers += 1
        }
        
        let elapsed:TimeInterval = Date().timeIntervalSince(self.questStartTime)
        self.matchTime =  self.matchTime + elapsed
    }
    
    func summary() -> Summary{
        
        let aSummary:Summary = Summary()
        aSummary.avgTime = self.avgTime().rounded(toPlaces: 2)
        aSummary.matchTime = self.matchTime.rounded(toPlaces: 2)
        aSummary.rightAnswers = self.rightAnswers
        aSummary.totalQuestions = self.totalQuestions
    
        return aSummary
    }
    
    
}
