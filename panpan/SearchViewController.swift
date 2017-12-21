//
//  SearchViewController.swift
//  panpan
//
//  Created by Dorian Delorme on 19/12/2017.
//  Copyright © 2017 Dorian Delorme. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Alamofire
import SwiftyJSON
import DatePickerDialog
import KeychainSwift

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
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    var departure = ""
    var destination = ""
    var stock1 = JSON()
    var stock2 = JSON()
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerTextField.delegate = self
        SearchButton.backgroundColor = UIColor(red: 92/255, green: 133/255, blue: 218/255, alpha: 1)
        // Do any additional setup after loading the view.
        print(self.keychain.get("jwt")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                                formatter.dateFormat = "yyyy-MM-dd"
                                self.datePickerTextField.text = formatter.string(from: dt)
                            }
        }
    }
    
    func sendCheckTripRequest() {
        
        let date = datePickerTextField.text
        let start = startTimeTextField.text! + ":00"
        let end = endTimeTextField.text! + ":00"
        print(departure, destination, date!, start, end)
        
        Analytics.logEvent("research", parameters: [
            "research_departure": departure as NSObject,
            "research_destination": destination as NSObject,
            "research_date"  : date! as NSObject,
            "research_hours"  : start as NSObject])
        
        /**
         Check Trip
         post https://panpan-api.herokuapp.com/check
         */
        
        // Add Headers
        let headers = [
            "Content-Type":"application/x-www-form-urlencoded; charset=utf-8",
            ]
        
        // Form URL-Encoded Body
        // FRFAC FRECE 2017-12-24 10:00:00 22:00:00
//        FRPST" \
//        --data-urlencode "end_station=FRENC" \
//        --data-urlencode "start_time=08:00:00" \
//        --data-urlencode "end_time=21:00:00" \
//        --data-urlencode "date=2018-01-17"
        let body = [
            "start_station": "FRPST", //departure
            "end_station":  "FRENC", //destination
            "start_time": "08:00:00", //start
            "end_time": "21:00:00", //end
            "date": "2018-01-17", //date
            ]
        
        // Fetch Request
        Alamofire.request("https://panpan-api.herokuapp.com/check", method: .post, parameters: body, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    let data = response.result.value
                    let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "tripList") as! TripListViewController
                    newViewController.data = data
                    self.present(newViewController, animated: true, completion: nil)
                    
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }
    
    @IBAction func ClickFirstButton(_ sender: UIButton) {
        DepartureTextField.text = FirstSuggestionButton.title(for: .normal)
        departure = stock1[0]["code"].string!.uppercased()
        clearSuggestion()
    }
    
    @IBAction func ClickSecondButton(_ sender: Any) {
        DepartureTextField.text = SecondSuggestionButton.title(for: .normal)
        departure = stock1[1]["code"].string!.uppercased()
        clearSuggestion()
    }
    
    @IBAction func ClickThirdButton(_ sender: Any) {
        DepartureTextField.text = ThirdSuggestionButton.title(for: .normal)
        departure = stock1[2]["code"].string!.uppercased()
        clearSuggestion()
    }
    
    @IBAction func ClickFourthButton(_ sender: Any) {
        DestinationTextField.text = FourthSuggestionButton.title(for: .normal)
        destination = stock2[0]["code"].string!.uppercased()
        clearSuggestion()
    }
    
    @IBAction func ClickFifthSuggestion(_ sender: Any) {
        DestinationTextField.text = FifthSuggestionButton.title(for: .normal)
        destination = stock2[1]["code"].string!.uppercased()
        clearSuggestion()
    }
    
    @IBAction func ClickSixthSuggestion(_ sender: Any) {
        DestinationTextField.text = SixthSuggestionButton.title(for: .normal)
        destination = stock2[2]["code"].string!.uppercased()
        clearSuggestion()
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
                    self.stock1 = json
//                    print(json[0]["name"])
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
                    self.stock2 = json
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
    
    
    @IBAction func ValidateSearchButton(_ sender: Any) {
        sendCheckTripRequest()
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
