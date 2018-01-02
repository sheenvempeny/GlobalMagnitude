//
//  QuestionGenerator.swift
//  Global Magnitude
//
//  Created by sheen vempeny on 12/30/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

import UIKit

let minVal = 10
let maxVal = 99

// shuffle array
extension Array {
    
    func shuffled() -> [Element] {
        var results = [Element]()
        var indexes = (0 ..< count).map { $0 }
        while indexes.count > 0 {
            let indexOfIndexes = Int(arc4random_uniform(UInt32(indexes.count)))
            let index = indexes[indexOfIndexes]
            results.append(self[index])
            indexes.remove(at: indexOfIndexes)
        }
        return results
    }
    
}

func randomInt(min: Int, max:Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

class Answer{
    
    var value:Int!
    var isCorrect:Bool!
    
    init(inVal:Int,status:Bool) {
        self.value = inVal
        self.isCorrect = status
    }
}

class Question{
    
    var firstNum:Int!
    var secondNum:Int!
    weak var rightAnswer:Answer!
    var options:[Answer]!
}


class QuestionGenerator: NSObject {
    
    private var returnArray:[Question] = []
    //Generating questions
    func generate(numOfQuestions:Int,numOfOptions:Int) -> [Question]{
        returnArray.removeAll()
        while returnArray.count < numOfQuestions {
            
            let aQuestion = self.getAQuestion(options: numOfOptions)
            returnArray.append(aQuestion)
        }
        
        return returnArray
    }
    //checking the same question already added
    private func isQuestionInArray(question:Question) -> Bool{
        let rightAnswerVal = question.firstNum * question.secondNum
        for inQuestion in returnArray {
            
            if inQuestion.rightAnswer.value == rightAnswerVal  {
                
                if inQuestion.firstNum == question.firstNum || inQuestion.firstNum == question.secondNum{
                    return true
                }
            }
            
        }
        
        return false
    }
    
    private func getAQuestion(options:Int) -> Question{
        
        func newQuestion() -> Question {
            
            let mQuestion:Question = Question()
            mQuestion.firstNum = randomInt(min: minVal, max: maxVal)
            mQuestion.secondNum = randomInt(min: minVal, max: maxVal)
            
            return mQuestion
        }
        
        var mQuestion:Question!
        for  _ in minVal...maxVal{
            let  aQuestion = newQuestion()
            if self.isQuestionInArray(question: aQuestion) == false{
                mQuestion = aQuestion
                break
            }
        }
        
        var answers:[Answer] = []
        let rightAnswer:Answer = Answer(inVal: mQuestion.firstNum * mQuestion.secondNum, status: true)
        answers.append(rightAnswer)
        mQuestion.rightAnswer = rightAnswer
        
        while answers.count < options {
            
            let aRandom = randomInt(min: minVal, max: maxVal) *
                randomInt(min: minVal, max: maxVal)
            //We are adding different answers
            if aRandom != rightAnswer.value {
                let newAnswer:Answer = Answer(inVal: aRandom, status: false)
                answers.append(newAnswer)
            }
        }
        
        mQuestion.options = answers.shuffled()
        return mQuestion
    }
    
}
