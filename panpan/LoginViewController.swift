//
//  LoginViewController.swift
//  panpan
//
//  Created by Dorian Delorme on 19/12/2017.
//  Copyright © 2017 Dorian Delorme. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var EmailLoginTextField: UITextField!
    @IBOutlet weak var PasswordLoginTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginButton.backgroundColor = UIColor(red: 92/255, green: 133/255, blue: 218/255, alpha: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ValidateLoginButton(_ sender: Any) {
        sendGetUserTokenRequest()
    }
    
    func sendGetUserTokenRequest() {
        /**
         Get User Token
         post https://panpan-api.herokuapp.com/user_token
         */
        
        let email = EmailLoginTextField.text
        let password = PasswordLoginTextField.text
        
        // Add Headers
        let headers = [
            "Content-Type":"application/json; charset=utf-8",
            ]
        
        // JSON Body
        let body: [String : Any] = [
            "auth": [
                "email": email!,
                "password": password!
            ]
        ]
        
        // Fetch Request
        Alamofire.request("https://panpan-api.herokuapp.com/user_token", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    let data = response.result.value
                    let json = JSON(data)
                    let saver = json["jwt"].string
                    self.keychain.set(saver!, forKey: "jwt")
                    print(self.keychain.get("jwt"))
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
