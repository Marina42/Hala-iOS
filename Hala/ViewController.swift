//
//  ViewController.swift
//  Hala
//
//  Created by Marina Sauca on 07/10/2016.
//  Copyright © 2016 Mariwi Tech. All rights reserved.
//

import UIKit
import Hala


class ViewController: UIViewController, HalaCoreDelegate{
    let global = Global.global
    let halaCore = Hala.core
    var myPlace: HalaPlace?
    
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var placeID: UILabel!
    @IBOutlet var enterButton: UIButton!
    @IBOutlet var demoButton: UIButton!
    @IBOutlet weak var loadingPlaceLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        halaCore.delegate = self
        
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.items?[1].isEnabled = false;
        tabBar.items?[2].isEnabled = false;
        loadingPlaceLabel.isHidden = true;
        loadingIndicator.isHidden = true;
        enterButton.isEnabled = false;
    }
    
    func halaPlaceIsReady(place: HalaPlace){
        self.myPlace = place
        self.nameLabel.text = place.getName()
        self.addressLabel.text = place.getAddress()
        self.placeID.text = place.getGpid()
        self.global.componentID = place.getGpid()
        self.enterButton.isEnabled = true
    }
    
    @IBAction func getCurrentPlace(sender: UIButton) {
        halaCore.getCurrentPlace()
    }    
    
    func didEnterHalaPlace(){
        let alert = UIAlertController(title: "Welcome to : ", message: "self.nameLabel.text!"+"!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok!", style: UIAlertActionStyle.default, handler: { action in
            self.global.componentID = self.placeID.text!
            self.activateTab()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func enterCurrentPlace(sender: UIButton){
        loadingPlaceLabel.isHidden = false;
        loadingIndicator.isHidden = false;
        loadingIndicator.startAnimating();
        halaCore.enterCurrentPlace()
    }
    
    func activateTab(){
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.items?[1].isEnabled = true;
        tabBar.items?[2].isEnabled = true;
        self.loadingPlaceLabel.isHidden = true;
        self.loadingIndicator.stopAnimating();
        self.loadingIndicator.isHidden = true;
    }
}

