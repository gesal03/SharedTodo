//
//  SignUpViewController.swift
//  SharedTODOList
//
//  Created by 이현승 on 2023/06/20.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var deptPickerView: UIPickerView!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var pwTextView: UITextField!
    @IBOutlet weak var idTextView: UITextField!
    @IBOutlet weak var posTextView: UITextField!
    
    var user: User?
    var saveChangeDelegate: ((User)->Void)?
    
    @IBAction func submitUser(_ sender: UIButton) {
        user!.id = idTextView.text!
        user!.pw = pwTextView.text!
        user!.name = nameTextView.text!
        user!.position = posTextView.text!
        user!.dept = User.Dept(rawValue: deptPickerView.selectedRow(inComponent: 0))!
        
        let userFirebase = UserFirebase(parentNotification: nil)
        userFirebase.saveChange(user: user!, action: .Add)
        performSegue(withIdentifier: "Login", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        deptPickerView.dataSource=self
        deptPickerView.delegate=self
        
        user = User()
    }

}
extension SignUpViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return User.Dept.count   // Plan.swift파일에서 count를 확인하라
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let type = User.Dept(rawValue: row)    // 정수를 해당 Kind 타입으로 변환하는 것이다.
        return type!.toString()
    }
}
