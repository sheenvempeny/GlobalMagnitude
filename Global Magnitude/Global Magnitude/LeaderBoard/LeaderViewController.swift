//
//  LeaderViewController.swift
//  Global Magnitude
//
//  Created by sheen vempeny on 12/29/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

import UIKit

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.backgroundColor = uiColor.cgColor
        }
        get {
            guard let color = layer.backgroundColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
extension UIView{
    
    func setBlackGradientLayer() -> CAGradientLayer{
        
        let colorTop =  UIColor(red: 76.0/255.0, green: 76.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        let colorBottom = UIColor(red: 56.0/255.0, green: 56.0/255.0, blue: 56.0/255.0, alpha: 1.0)
       let layer = self.addGradientLayer(colorTop: colorTop, colorBottom: colorBottom)
        return layer
    }
    
    func addGradientLayer(colorTop:UIColor,colorBottom:UIColor) -> CAGradientLayer{
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradient.masksToBounds = true
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    
}

class GradientViewController:UIViewController{
    
    private weak var gradientLayer:CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradientLayer = self.view.setBlackGradientLayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
}


class LeaderViewController: GradientViewController {
    
    private var leaders:[Leader]?

    @IBOutlet weak var lstLeaders:UITableView!
    @IBAction func start(sender:AnyObject?){
        let identifier:String = SettingsHandler.shared.gameHandle != nil ? "showGameSegue":"showSettingsSegue"
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loading the view.
        self.lstLeaders.delegate = self
        self.lstLeaders.dataSource = self
        LeaderDataManager.getLeaders { (inLeaders:[Leader]?) in
            self.leaders = inLeaders
            DispatchQueue.main.async {
                self.lstLeaders.reloadData()
            }
        }
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

extension LeaderViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.leaders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textCellIdentifier = "LeaderTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let row = indexPath.row
        let rowLeader = self.leaders![row]
        LeaderBoardUpdator.update(cell: cell as! LeaderTableCell, leader: rowLeader)
        
        return cell
        
    }
    
    
    
    
}
