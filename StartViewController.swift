//
//  StartViewController.swift
//  SharedTODOList
//
//  Created by 이현승 on 2023/06/20.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBAction func SignInBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "SignIn", sender: self)
    }
    @IBAction func SignUpBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "SignUp", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

extension StartViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignIn" {
            print("signIn")
            // 목적지 뷰 컨트롤러를 가져온다
            let LoginViewController = segue.destination as? LoginViewController

        }
        else if segue.identifier == "SignUp"{
            print("signUp")
            let SignUpViewController = segue.destination as! SignUpViewController
            
        }
    }
}

