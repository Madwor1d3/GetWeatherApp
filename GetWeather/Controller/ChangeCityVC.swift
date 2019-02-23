//
//  ChangeCityVC.swift
//  GetWeather
//
//  Created by Madwor1d3 on 12/02/2019.
//  Copyright © 2019 Madwor1d3. All rights reserved.
//

import UIKit


protocol ChangeCityDelegate {
    
    func userEnteredANewCityName(city: String)
}


class ChangeCityVC: UIViewController {
    
    
    var delegate: ChangeCityDelegate?

    
    
    @IBOutlet weak var changeCityTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func getWeatherButtonPressed(_ sender: UIButton) {
        
        let cityName = changeCityTextField.text!
        delegate?.userEnteredANewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
