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

class ViewController: UIViewController {

    @IBOutlet weak var labelStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
    }

    
    @IBAction func testLogin(_ sender: Any) {
        if let accessToken = AccessToken.current {
            labelStatus.text = "Connecté: \(accessToken)"
        } else {
            labelStatus.text = "Non connecté"
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
