//
//  LeaderBoardDataManager.swift
//  Global Magnitude
//
//  Created by sheen vempeny on 12/29/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

import Foundation


//Leader class
class Leader: Codable {
    let userid: String
    let score: Int
    let mtime: Double
    let qtime: Double
    
    // Coding Keys
    enum CodingKeys: String, CodingKey {
        case userid = "userid"
        case score = "score"
        case mtime = "mtime"
        case qtime = "qtime"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userid, forKey: .userid)
        try container.encode(String(score), forKey: .score)
        try container.encode(String(mtime), forKey: .mtime)
         try container.encode(String(qtime), forKey: .qtime)
    }
    
    init(userid: String, score: Int, mtime: Double, qtime: Double) {
        self.userid = userid
        self.score = score
        self.mtime = mtime
        self.qtime = qtime
    }
}

class LeaderDataManager {
    
    class func update(inSummary:Summary,userId:String,completion:@escaping(Bool)->Swift.Void){
        
        let newLeader:Leader = Leader(userid: userId, score: inSummary.score(), mtime: inSummary.matchTime, qtime: inSummary.avgTime)
        LeaderDataManager.updateLeader(newLeader: newLeader,completion: completion)
    }
    
    private class func updateLeader(newLeader:Leader,completion:@escaping(Bool)->Swift.Void){
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(newLeader)
        let url = URL(string: SettingsHandler.shared.leaderUrl()!)
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {           // check for http errors
               completion(true)
            }
            else{
                completion(false)
            }
        }
        task.resume()
    }
    
    
   //Returns the leader Data
  private class  func leaderData( completion:@escaping(Data?)->Swift.Void) {
    
        let urlPath:String? = SettingsHandler.shared.leaderUrl()
    
        guard urlPath != nil else{
            //Error in url path
            completion(nil)
            return
        }
    
        guard let leaderUrl = URL.init(string: urlPath!) else {
            //Error in url creation
            completion(nil)
             return
        }
        
        let request = URLRequest(url: leaderUrl )
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                //Error in retreiving data
               completion(nil)
            } else{
                //Got data correctly
               completion(data)
            }
           
            
            }.resume()
      
    }
    
    class func getLeaders(completion:@escaping([Leader]?)->Swift.Void){
        
        LeaderDataManager.leaderData { (data:Data?) in
         
            guard data != nil else{
                //Error in getting data
                completion(nil)
                return
            }
            
            do {
                //Convert to Leader objects
                let decoder = JSONDecoder()
                let leaders = try decoder.decode([Leader].self, from: data!)
                let sortedLeaders = leaders.sorted { t1, t2 in
                    if t1.score == t2.score {
                        return t1.mtime < t2.mtime
                    }
                    return t1.score > t2.score
                }
                
                
                completion(sortedLeaders)
            } catch {
                //Error in Decoding
                completion(nil)
            }
        }
        
    }
}
