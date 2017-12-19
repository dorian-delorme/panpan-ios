//
//  ViewController.swift
//  panpan
//
//  Created by Dorian Delorme on 18/12/2017.
//  Copyright © 2017 Dorian Delorme. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FirebaseAuth
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailSigninTextField: UITextField!
    @IBOutlet weak var PasswordSigninTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
    }
    @IBAction func SigninButton(_ sender: Any) {
        sendCreateUserRequest()
    }
    
    func sendCreateUserRequest() {
        let name = FirstNameTextField.text! + " " + LastNameTextField.text!
        let email = EmailSigninTextField.text
        let password = PasswordSigninTextField.text
        
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
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }
    
}

extension ViewController : LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        // logged out
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        switch result {
        case .failed(let error):
            print(error.localizedDescription)
            return
        case .cancelled:
            print("cancelled")
        case .success( _, _, let token):
            let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error)
                    return
                }
                print("c'est un succès bravo à tous")
                if let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewLogged") as UIViewController? {
                    self.present(view, animated: true, completion: nil)
                }
            }
        }
    }
}
