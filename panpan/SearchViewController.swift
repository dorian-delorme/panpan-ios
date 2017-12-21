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
import SwiftyJSON
import DatePickerDialog

class SearchViewController: UIViewController {
    
    @IBOutlet weak var DepartureTextField: UITextField!
    @IBOutlet weak var DestinationTextField: UITextField!
    @IBOutlet weak var FirstSuggestionButton: UIButton!
    @IBOutlet weak var SecondSuggestionButton: UIButton!
    @IBOutlet weak var ThirdSuggestionButton: UIButton!
    @IBOutlet weak var FourthSuggestionButton: UIButton!
    @IBOutlet weak var FifthSuggestionButton: UIButton!
    @IBOutlet weak var SixthSuggestionButton: UIButton!
    @IBOutlet weak var datePickerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ValidateSearchButton(_ sender: Any) {
        print(DepartureTextField.text!, "to", DestinationTextField.text! )
    }
    @IBAction func ClickFirstButton(_ sender: UIButton) {
        DepartureTextField.text = FirstSuggestionButton.title(for: .normal)
        clearSuggestion()
    }
    
    @IBAction func ClickSecondButton(_ sender: Any) {
        DepartureTextField.text = SecondSuggestionButton.title(for: .normal)
        clearSuggestion()
    }
    
    @IBAction func ClickThirdButton(_ sender: Any) {
        DepartureTextField.text = ThirdSuggestionButton.title(for: .normal)
        clearSuggestion()
    }
    
    @IBAction func ClickFourthButton(_ sender: Any) {
        DestinationTextField.text = FourthSuggestionButton.title(for: .normal)
        clearSuggestion()
    }
    
    @IBAction func ClickFifthSuggestion(_ sender: Any) {
        DestinationTextField.text = FifthSuggestionButton.title(for: .normal)
        clearSuggestion()
    }
    
    @IBAction func ClickSixthSuggestion(_ sender: Any) {
        DestinationTextField.text = SixthSuggestionButton.title(for: .normal)
        clearSuggestion()
    }
    
    
    func clearSuggestion() {
        let empty = ""
        self.FirstSuggestionButton.setTitle( empty, for: .normal)
        self.SecondSuggestionButton.setTitle( empty, for: .normal)
        self.ThirdSuggestionButton.setTitle( empty, for: .normal)
        self.FourthSuggestionButton.setTitle( empty, for: .normal)
        self.FifthSuggestionButton.setTitle( empty, for: .normal)
        self.SixthSuggestionButton.setTitle( empty, for: .normal)
    }
    
    @IBAction func ValidateButton(_ sender: Any) {
        print("Here goes the autocompletion")
        
        let myString = "https://panpan-api.herokuapp.com/stations/search?term=" + DepartureTextField.text!
        
        Alamofire.request(myString, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    let data = response.result.value
                    let json = JSON(data)
                    print(json[0]["name"])
                    let firstText = json[0]["name"].string
                    self.FirstSuggestionButton.setTitle( firstText, for: .normal)
                    let secondText = json[1]["name"].string
                    self.SecondSuggestionButton.setTitle( secondText, for: .normal)
                    let thirdText = json[2]["name"].string
                    self.ThirdSuggestionButton.setTitle( thirdText, for: .normal)

                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }
    @IBAction func DestinationChangedEvent(_ sender: Any) {
        let myString = "https://panpan-api.herokuapp.com/stations/search?term=" + DestinationTextField.text!
        
        Alamofire.request(myString, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    let data = response.result.value
                    let json = JSON(data)
                    print(json[0]["name"])
                    let firstText = json[0]["name"].string
                    self.FourthSuggestionButton.setTitle( firstText, for: .normal)
                    let secondText = json[1]["name"].string
                    self.FifthSuggestionButton.setTitle( secondText, for: .normal)
                    let thirdText = json[2]["name"].string
                    self.SixthSuggestionButton.setTitle( thirdText, for: .normal)
                    
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }
    
    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = +1
        let oneMonthLater = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        let datePicker = DatePickerDialog(textColor: UIColor(red: 35/255, green: 39/255, blue: 50/255, alpha: 1),
                                          buttonColor: UIColor(red: 35/255, green: 39/255, blue: 50/255, alpha: 1),
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        datePicker.show("Date du départ",
                        doneButtonTitle: "Valider",
                        cancelButtonTitle: "Annuler",
                        minimumDate: currentDate,
                        maximumDate: oneMonthLater,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy"
                                self.datePickerTextField.text = formatter.string(from: dt)
                            }
        }
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ datePickerTextField: UITextField) -> Bool {
        if datePickerTextField == self.datePickerTextField {
            datePickerTapped()
            return false
        }
        
        return true
    }
}
