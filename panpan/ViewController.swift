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
    
    
    @IBOutlet weak var AccountCreateButton: UIButton!
    @IBOutlet weak var LogButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Facebook Login
//        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
//        loginButton.center = view.center
//        loginButton.delegate = self
//
//        view.addSubview(loginButton)
        
        AccountCreateButton.titleLabel?.textColor = UIColor(red: 35/255, green: 39/255, blue: 50/255, alpha: 1)
        AccountCreateButton.backgroundColor = UIColor.white
        LogButton.backgroundColor = UIColor(red: 84/255, green: 193/255, blue: 157/255, alpha: 1)
        
    }
    @IBAction func GoToSigninButton(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SigninView") as! SigninViewController
        self.present(newViewController, animated: true, completion: nil)
        
        print("Go to Signin")
    }
    
    @IBAction func GoToLoginButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
        self.present(newViewController, animated: true, completion: nil)
        
        print("Go to Login")
    }
    
}

//extension ViewController : LoginButtonDelegate {
//    func loginButtonDidLogOut(_ loginButton: LoginButton) {
//        // logged out
//    }
//
//    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
//
//        switch result {
//        case .failed(let error):
//            print(error.localizedDescription)
//            return
//        case .cancelled:
//            print("cancelled")
//        case .success( _, _, let token):
//            let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
//            Auth.auth().signIn(with: credential) { (user, error) in
//                if let error = error {
//                    print(error)
//                    return
//                }
//                print("c'est un succès bravo à tous")
//                if let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewLogged") as UIViewController? {
//                    self.present(view, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//}

