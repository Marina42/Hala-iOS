//
//  Profile.swift
//  Hala
//
//  Created by Marina Sauca on 08/10/2016.
//  Copyright © 2016 Mariwi Tech. All rights reserved.
//

import Foundation
import UIKit

class Profile : UIViewController {
    
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var usernameLabel: UILabel!
    
    var uuid = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createUser(sender: UIButton){
        usernameLabel.text = usernameField.text
        createSensor()
    }
    
    private func createSensor(){
        let sensorName = usernameLabel.text!+"-"+uuid
        let dic: [String : String] = ["sensor":sensorName,
                                      "type":"presence"]
        let dict2 = ["sensors" : [dic]]

        let urlString: URL = URL(string: "http://api.sentilo.cloud/catalog/testProv")!
        var request: URLRequest = URLRequest(url: urlString)
        request.setValue("application/JSON", forHTTPHeaderField: "Accept")
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let data = try! JSONSerialization.data(withJSONObject: dict2, options: JSONSerialization.WritingOptions.prettyPrinted)
        // request.setValue(data!, forHTTPHeaderField: "Content-Length")
        request.httpBody = data
        request.setValue("9871f64997680d09aba8ce95c9867a8e22198de52b4d24c63ed303421da0129b", forHTTPHeaderField: "IDENTITY_KEY")
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: request){data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            //              let dic2 = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
            //              print(dic2)
        }
        dataTask.resume()
    }
    
    
}
