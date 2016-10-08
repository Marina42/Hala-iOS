//
//  ViewController.swift
//  Hala
//
//  Created by Marina Sauca on 07/10/2016.
//  Copyright © 2016 Mariwi Tech. All rights reserved.
//

import UIKit
import GooglePlaces



class ViewController: UIViewController , CLLocationManagerDelegate{
    var  locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient?
    
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var placeID: UILabel!
    @IBOutlet var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.items?[1].isEnabled = false;
        tabBar.items?[2].isEnabled = false;
        enterButton.isEnabled = false;
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        placesClient = GMSPlacesClient.shared()
    }
    
    // Add a UIButton in Interface Builder, and connect the action to this function.
    @IBAction func getCurrentPlace(sender: UIButton) {
        placesClient?.currentPlace(callback: {
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: Error?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            self.placeID.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress!.components(separatedBy: ", ").joined(separator: "\n")
                    self.placeID.text = place.placeID
                    self.enterButton.isEnabled = true
                }
            }
        } )
    }
    
    @IBAction func enterCurrentPlace(sender: UIButton){
        let uuid = UUID().uuidString
        let dic: [String : String] = ["sensor":uuid,
                                      "type":"presence",
                                      "component":self.placeID.text!]
        let dict2 = ["sensors" : [dic]]
        
        let urlString: URL = URL(string: "http://api.sentilo.cloud/catalog/HalaMasterMind")!
        var request: URLRequest = URLRequest(url: urlString)
        request.setValue("application/JSON", forHTTPHeaderField: "Accept")
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let data = try! JSONSerialization.data(withJSONObject: dict2, options: JSONSerialization.WritingOptions.prettyPrinted)
        request.httpBody = data
        request.setValue("9474d27ab5df36ebdc966d6ff5a2c019cf05c02587df5eedd216e007eb37f8ea", forHTTPHeaderField: "IDENTITY_KEY")
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: request){data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                let alert = UIAlertController(title: "Welcome to "+self.nameLabel.text!+"!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok!", style: UIAlertActionStyle.default, handler: { action in
                    self.activateTab()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        dataTask.resume()
    }
    
    func activateTab(){
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.items?[1].isEnabled = true;
        tabBar.items?[2].isEnabled = true;
        
    }
    
    func locationManager(_ lm : CLLocationManager, didUpdateLocations locations: [CLLocation]){}
    func locationManager(_ lm : CLLocationManager, didFailWithError error: Error){}
}

