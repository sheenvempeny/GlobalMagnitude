//
//  ViewController.swift
//  Global Magnitude
//
//  Created by sheen vempeny on 12/29/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showSimpleAlert(message:String){
        // create the alert
        let alert = UIAlertController(title: "Global Magnitude", message: message, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}


class SettingsHandler:NSObject{
    //Singleton
    private let gameHandleKey = "GameHandle"
    static let shared = SettingsHandler()
    private override init() {}
    //update name
    var gameHandle:String?{
        get{
            return UserDefaults.standard.string(forKey: gameHandleKey)
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: gameHandleKey)
        }
    }
    //Returns the leader url
    func leaderUrl() -> String?{
        var answer:String?
        let key:String = "leaderPath"
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let resourceFileDictionary = NSDictionary(contentsOfFile: path)
            answer = resourceFileDictionary?.object(forKey: key) as? String
        }
        
        return answer
    }
    
    
}

class SettingsViewController: GradientViewController {
    
    private var leaders:[Leader]?
    private var isNameSet:Bool! = false
    @IBOutlet weak var txtName:UITextField!
    @IBAction func changeName(sender:AnyObject?){
        if self.isStringValid(str: self.txtName.text) == false {
            self.showSimpleAlert(message: "Please enter a valid Game Handle.")
        }
        else{
            SettingsHandler.shared.gameHandle = self.txtName.text
            
            if self.isNameSet == true {
                
                self.cancel(sender: self)
            }
            else{
                self.performSegue(withIdentifier: "startGame", sender: self)
            }
        }
    }
    
    @IBAction func cancel(sender:AnyObject?){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isNameSet = (SettingsHandler.shared.gameHandle != nil) ? true:false
        SettingsViewUpdator.updateName(txtName: txtName)
        LeaderDataManager.getLeaders { (inLeaders:[Leader]?) in
            self.leaders = inLeaders
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func isStringValid(str:String?) -> Bool{
        guard str != nil else {
            return false
        }
        
        let trimmedString:String = str!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedString.count == 0 {
            return false
        }
        
        if SettingsHandler.shared.gameHandle == str {
            return true
        }
        
        let filter = self.leaders?.filter{ $0.userid ==  trimmedString}
        
        guard filter != nil else{
            return true
        }
        
        if filter!.count > 0 {
            return false
        }
        
        return true
    }
 
    
}

class SettingsViewUpdator{
    
    class func updateName(txtName:UITextField){
        txtName.text = SettingsHandler.shared.gameHandle ?? ""
    }
    
}

