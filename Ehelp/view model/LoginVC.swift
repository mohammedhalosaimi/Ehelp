//
//  LoginVC.swift
//  Ehelp
//
//  Created by Mohammed on 18/9/19.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    var userViewModel : [[String:AnyObject]]! {
        return Global.shared.users
    }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        email.text = ""
        password.text = ""
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if(validateUser()){
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
            self.present(nextVC, animated: true, completion: nil)
        }else {
            invalidUser()
        }
    }

    func validateUser() -> Bool {
        if let index = userViewModel!.firstIndex(where: { (($0["email"] ?? "" as AnyObject) as! String) == email.text! }) {
            if(userViewModel![index]["password"] as! String == password.text! ){
                return true
            }
        }
        return false
    }
    
    func invalidUser() {
        let alertController:UIAlertController = UIAlertController(title: "Error", message: "Username/Password is not valid", preferredStyle: UIAlertController.Style.alert)
        
        let alertAction:UIAlertAction = UIAlertAction(title: "Back", style: UIAlertAction.Style.default, handler:nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        email.text = ""
        password.text = ""
    }
}
