//
//  GameViewController.swift
//  Global Magnitude
//
//  Created by sheen vempeny on 12/31/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

import UIKit

class GameViewController: GradientViewController {

    private var questions:[Question]!
    private var index:Int = -1{
        didSet{
         
            if self.index > -1 {
                self.logger.questionStarted(index: self.index)
            }
        }
    }
    let questGenerator:QuestionGenerator = QuestionGenerator()
    let questionUpdator:QuestionUpdator = QuestionUpdator()
    var optionsUpdator:OptionsUpdator = OptionsUpdator()
    var logger:ActivityLogger = ActivityLogger()
    
    @IBOutlet weak var questContainerView:UIView!
    @IBOutlet weak var optContainerView:UIView!
    @IBOutlet weak var loadingView:UIView!
    
    @IBOutlet weak var lblHeader:UILabel!
    @IBOutlet weak var lblFirstNum:UILabel!
    @IBOutlet weak var lblSecondNum:UILabel!
    @IBOutlet weak var lblAns:UILabel!
   
     @IBOutlet  var buttons:[UIButton]!
    
    private func currentQuestion() -> Question{
        return self.questions[self.index]
    }
    
    
    @IBAction func gotSelection(sender:AnyObject){
        
        let answer:Answer = self.currentQuestion().options[sender.tag]
        self.logger.questionStopped(index: self.index, isCorrect: answer.isCorrect)
        
        if (self.index + 1) < self.questions.count {
            self.index += 1
            self.updateQuestion()
        }
        else{
            
            self.performSegue(withIdentifier: "showSummary", sender: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        func updateQuestUpdator(){
            self.questionUpdator.lblHeader = self.lblHeader
            self.questionUpdator.lblFirstNum = self.lblFirstNum
            self.questionUpdator.lblSecondNum = self.lblSecondNum
            self.questionUpdator.lblAns = self.lblAns
        }
        
        self.optionsUpdator = OptionsUpdator()
        self.optionsUpdator.buttons = self.buttons
        
        updateQuestUpdator()
        self.genrateQuestions()
    }
    
    private func updateQuestion(){
        self.questionUpdator.updateQuestion(question: self.currentQuestion(), headerVal: String.init(format: "%d/%d", self.index+1,self.questions.count))
        self.optionsUpdator.update(options: self.currentQuestion().options)
    }
    
    private func startQuiz(){
        self.logger.reset()
        self.index = 0
        self.updateQuestion()
    }
    
    private func genrateQuestions(){
        
        self.loadingView.isHidden = false
        self.questContainerView.isHidden = true
        self.optContainerView.isHidden = true
        
        DispatchQueue.global(qos: .background).async {
            self.questions = self.questGenerator.generate(numOfQuestions: 20, numOfOptions: 6)
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.questContainerView.isHidden = false
                self.optContainerView.isHidden = false
                self.startQuiz()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let vcc = segue.destination as? SummaryViewController {
            vcc.roundSummary = self.logger.summary()
        }
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

class OptionsUpdator{
    
     var buttons:[UIButton]!
    
    func update(options:[Answer]){
        
        for button in self.buttons {
            
            let index:Int = button.tag
            let answer:Answer = options[index]
            button.setTitle(String(answer.value), for: UIControlState.normal)
            button.setTitle(String(answer.value), for: UIControlState.highlighted)
            button.zoomAnimate()
            
        }
        
    }
    
}


class QuestionUpdator{
    
     weak var lblHeader:UILabel!
     weak var lblFirstNum:UILabel!
     weak var lblSecondNum:UILabel!
     weak var lblAns:UILabel!
    
    
    func updateQuestion(question:Question,headerVal:String){
        
        lblFirstNum.text = String(question.firstNum)
        lblFirstNum.zoomAnimate()
        lblSecondNum.text = String(question.secondNum)
        lblSecondNum.zoomAnimate()
        lblAns.text = "?"
        lblHeader.text = "Question:" + headerVal
    }
    
}

extension UIView{
    
    func zoomAnimate(){
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 1,y: 1)
            
        })
    }
    
}
