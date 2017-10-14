//
//  ViewController.swift
//  Hala
//
//  Created by Marina Sauca on 07/10/2016.
//  Copyright © 2016 Mariwi Tech. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker


class ViewController: UIViewController , CLLocationManagerDelegate{
    var  locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient?
   // var placePicker: GMSPlacePicker?
    let uuid = UUID().uuidString
    
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var placeID: UILabel!
    @IBOutlet var enterButton: UIButton!
    @IBOutlet var demoButton: UIButton!
    
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
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.items?[1].isEnabled = false;
        tabBar.items?[2].isEnabled = false;
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
                    global.componentID = self.placeID.text!
                    self.enterButton.isEnabled = true
                }
            }
        } )
    }
    
    @IBAction func enterCurrentPlace(sender: UIButton){
        createLogSensor()
        let alert = UIAlertController(title: "Welcome to "+self.nameLabel.text!+"!", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok!", style: UIAlertActionStyle.default, handler: { action in
            global.componentID = self.placeID.text!
            self.activateTab()
        }))
        self.present(alert, animated: true, completion: nil)
        /*let uuid = UUID().uuidString
        let dic: [String : String] = ["sensor":uuid+self.placeID.text!,
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
         
            }
        }
        dataTask.resume()*/
    }
    
    func activateTab(){
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.items?[1].isEnabled = true;
        tabBar.items?[2].isEnabled = true;
        
    }
    
    func createLogSensor(){
        var dic: [String : String] = ["sensor":global.componentID+"-log",
                                      "type":"presence",
                                      "dataType":"text",
                                      "component":global.componentID]
        var dict2 = ["sensors" : [dic]]
        let urlString: URL = URL(string: "http://api.thingtia.cloud/catalog/HalaMasterMind")!
        var request: URLRequest = URLRequest(url: urlString)
        request.setValue("application/JSON", forHTTPHeaderField: "Accept")
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var data = try! JSONSerialization.data(withJSONObject: dict2, options: JSONSerialization.WritingOptions.prettyPrinted)
        request.httpBody = data
        request.setValue(token, forHTTPHeaderField: "IDENTITY_KEY")
        
        var dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: request){data, response, error in
            if error != nil {
             
            }
        }
        dataTask.resume()
        
        dic = ["sensor":global.componentID+"-footprint",
                                      "type":"presence",
                                      "dataType":"text",
                                      "component":global.componentID]
        dict2 = ["sensors" : [dic]]
        request.setValue("application/JSON", forHTTPHeaderField: "Accept")
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        data = try! JSONSerialization.data(withJSONObject: dict2, options: JSONSerialization.WritingOptions.prettyPrinted)
        request.httpBody = data
        request.setValue(token, forHTTPHeaderField: "IDENTITY_KEY")
        
        dataTask = URLSession.shared.dataTask(with: request){data, response, error in
        }
        
        dataTask.resume()
        stepIn()
        
    }
    
    func stepIn(){
        let dic: [String : String] = ["value":self.uuid]
        let dict2 = ["observations" : [dic]]
        
        let urlString: URL = URL(string: "http://api.thingtia.cloud/data/HalaMasterMind/"+global.componentID+"-footprint")!
        var request: URLRequest = URLRequest(url: urlString)
        request.setValue("application/JSON", forHTTPHeaderField: "Accept")
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let data = try! JSONSerialization.data(withJSONObject: dict2, options: JSONSerialization.WritingOptions.prettyPrinted)
        request.httpBody = data
        request.setValue(token, forHTTPHeaderField: "IDENTITY_KEY")
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: request){data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                
            }
        }
        dataTask.resume()
    }
    

    // The code snippet below shows how to create a GMSPlacePicker
    // centered on Sydney, and output details of a selected place.
    @IBAction func pickPlace(sender: UIButton) {
    /*    guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.items?[1].isEnabled = false;
        tabBar.items?[2].isEnabled = false;
        let center = CLLocationCoordinate2DMake(51.5108396, -0.0922251)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlace(callback: { (place: GMSPlace?, error: Error?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                self.nameLabel.text = place.name
                self.addressLabel.text = place.formattedAddress!.components(separatedBy: ", ").joined(separator: "\n")
                self.placeID.text = place.placeID
                self.enterButton.isEnabled = true
            } else {
                print("No place selected")
            }
        })*/
    }
    
    
    
    
    func locationManager(_ lm : CLLocationManager, didUpdateLocations locations: [CLLocation]){}
    func locationManager(_ lm : CLLocationManager, didFailWithError error: Error){}
}

