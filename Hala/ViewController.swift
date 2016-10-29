//
//  ViewController.swift
//  Hala
//
//  Created by Marina Sauca on 07/10/2016.
//  Copyright © 2016 Mariwi Tech. All rights reserved.
//

import UIKit
import Hala


class ViewController: UIViewController, HalaCoreDelegate, UITextFieldDelegate{
    let global = Global.global
    let halaCore = Hala.core
    var myPlace: HalaPlace?
    
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var placeID: UILabel!
    @IBOutlet var enterButton: UIButton!
    @IBOutlet var demoButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        halaCore.delegate = self
        usernameTextField.delegate = self
        
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.items?[1].isEnabled = false
        tabBar.items?[2].isEnabled = false
        loadingLabel.isHidden = true
        loadingIndicator.isHidden = true
        enterButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let newUsername = self.usernameTextField.text
        if newUsername != nil {
            halaCore.changeUsername(newUsername: newUsername!)
            return false
        }
        else{
            halaCore.changeUsername(newUsername: "Anon")
            return false
        }
    }
    
    func halaPlaceIsReady(place: HalaPlace){
        self.loadingLabel.isHidden = true
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.myPlace = place
        self.nameLabel.text = place.getName()
        self.addressLabel.text = place.getAddress()
        self.global.componentID = place.getGpid()
        self.enterButton.isEnabled = true
    }
    
    @IBAction func getCurrentPlace(sender: UIButton) {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.items?[1].isEnabled = false
        tabBar.items?[2].isEnabled = false
        loadingLabel?.text = "Getting the Place"
        loadingLabel.isHidden = false
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        halaCore.getCurrentPlace()
    }    
    
    func didEnterHalaPlace(){
        let alert = UIAlertController(title: "Welcome to : ", message: self.nameLabel.text!+"!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok!", style: UIAlertActionStyle.default, handler: { action in
            self.global.componentID = (self.myPlace?.getGpid())!
            self.activateTab()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func enterCurrentPlace(sender: UIButton){
        loadingLabel?.text = "Entering the Place"
        loadingLabel.isHidden = false
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        halaCore.enterCurrentPlace()
    }
    
    func activateTab(){
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.items?[1].isEnabled = true
        tabBar.items?[2].isEnabled = true
        self.loadingLabel.isHidden = true
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
    }
}

