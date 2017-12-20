//
//  SearchViewController.swift
//  panpan
//
//  Created by Dorian Delorme on 19/12/2017.
//  Copyright © 2017 Dorian Delorme. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire

class SearchViewController: UIViewController {
    
    @IBOutlet weak var DepartureTextField: UITextField!
    @IBOutlet weak var DestinationTextField: UITextField!
    @IBOutlet weak var SearchDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ValidateSearchButton(_ sender: Any) {
        print(DepartureTextField.text!, "to", DestinationTextField.text!, "the", SearchDatePicker.date )
    }
    
    @IBAction func ValidateButton(_ sender: Any) {
        print("Here goes the autocompletion")
        
        let myString = "https://panpan-api.herokuapp.com/stations/search?term=" + DepartureTextField.text!
        
        print(myString)
        
        Alamofire.request(myString, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    print(response)
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }
    
}
