//
//  GeoChat.swift
//  Hala
//
//  Created by Marina Sauca on 08/10/2016.
//  Copyright © 2016 Mariwi Tech. All rights reserved.
//

import Foundation
import UIKit

class GeoChat : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var textField: UITextField!
    @IBOutlet var tableView: UITableView!
    var geoTimeLog: [String]!
    var geoMessLog: [String]!
    let global = Global.global
    
    override func viewDidLoad() {
        super.viewDidLoad()
        geoTimeLog = [String]()
        geoMessLog = [String]()
        getMessages()
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        geoTimeLog = [String]()
        geoMessLog = [String]()
        getMessages()
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "geoMessage") as! GeoMessageCell
            
        cell.timeLabel.text = geoTimeLog[indexPath.row]
        
        let aString = geoMessLog[indexPath.row]
        var newString = aString.replacingOccurrences(of: "_", with: " ")
        newString = newString.replacingOccurrences(of: "~", with: "?")
        
        cell.messageField.text = newString
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoTimeLog.count
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        sendMessage()
        return false
    }
    
    @IBAction func sendPressed(){
        self.view.endEditing(true)
        sendMessage()
    }
    
    func sendMessage(){
        let dic: [String : String] = ["value":self.textField.text!]
        let dict2 = ["observations" : [dic]]
        
        let urlString: URL = URL(string: "http://api.sentilo.cloud/data/HalaMasterMind/"+global.componentID+"-log")!
        var request: URLRequest = URLRequest(url: urlString)
        request.setValue("application/JSON", forHTTPHeaderField: "Accept")
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let data = try! JSONSerialization.data(withJSONObject: dict2, options: JSONSerialization.WritingOptions.prettyPrinted)
        request.httpBody = data
        request.setValue("9474d27ab5df36ebdc966d6ff5a2c019cf05c02587df5eedd216e007eb37f8ea", forHTTPHeaderField: "IDENTITY_KEY")
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: request){data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                
            }
        }
        dataTask.resume()
        textField.text = ""
        getMessages()
    }
    
    func sendMessage_OLD(){
        let aString = self.textField.text!
        var newString = aString.replacingOccurrences(of: " ", with: "_")
        newString = newString.replacingOccurrences(of: "?", with: "~")
        
        let urlString: URL = URL(string: "http://api.sentilo.cloud/data/HalaMasterMind/"+global.componentID+"-log/"+newString)!
        var request: URLRequest = URLRequest(url: urlString)
        request.httpMethod = "PUT"
        request.setValue("9474d27ab5df36ebdc966d6ff5a2c019cf05c02587df5eedd216e007eb37f8ea", forHTTPHeaderField: "IDENTITY_KEY")
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: request){data, response, error in
        }
        dataTask.resume()
        textField.text = ""
        getMessages()
    }
    
    func getMessages(){
        let url: URL = URL(string: "http://api.sentilo.cloud/data/HalaMasterMind/"+global.componentID+"-log?limit=20")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("9474d27ab5df36ebdc966d6ff5a2c019cf05c02587df5eedd216e007eb37f8ea", forHTTPHeaderField: "IDENTITY_KEY")
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                let aux = todo["observations"] as? NSArray
                
                self.geoMessLog = [String]()
                self.geoTimeLog = [String]()
                
                for log in aux! {
                    let geo = log as! [String : String]
                    self.geoTimeLog.append(geo["timestamp"]!)
                    self.geoMessLog.append(geo["value"]!)
                }

                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
                
                //
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
    }
}
