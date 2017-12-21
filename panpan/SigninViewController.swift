//
//  SigninViewController.swift
//  panpan
//
//  Created by Dorian Delorme on 19/12/2017.
//  Copyright © 2017 Dorian Delorme. All rights reserved.
//

import UIKit
import Alamofire

class SigninViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ValidateSigninButton(_ sender: Any) {
        sendCreateUserRequest()
    }
    
    func sendCreateUserRequest() {
        let name = FirstNameTextField.text! + " " + LastNameTextField.text!
        let email = EmailTextField.text
        let password = PasswordTextField.text
        
        /**
         Create User
         post https://panpan-api.herokuapp.com/users
         */
        
        // Add Headers
        let headers = [
            "Content-Type":"application/json; charset=utf-8",
            ]
        
        // JSON Body
        let body: [String : Any] = [
            "user": [
                "email": email!,
                "fullname": name,
                "password": password!
            ]
        ]
        
        // Fetch Request
        Alamofire.request("https://panpan-api.herokuapp.com/users", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    print(response)
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "SearchView") as! SearchViewController
                    self.present(newViewController, animated: true, completion: nil)
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }

}
