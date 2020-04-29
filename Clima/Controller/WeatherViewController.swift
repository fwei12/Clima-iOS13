//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        // dismiss keyboard
        searchTextField.endEditing(true)
    }
    
    // do something when return key is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismiss keyboard
        searchTextField.endEditing(true)
        return true
    }
    
    // clear search bar when end editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        // use searchField.text to get the weather
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        // set search bar blank
        searchTextField.text = ""
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
    }
}
