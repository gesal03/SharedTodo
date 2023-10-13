//
//  ProfileViewController.swift
//  SharedTODOList
//
//  Created by 이현승 on 2023/06/20.
//

import UIKit

class ProfileViewController: UIViewController {
    var user: User!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        deptLabel.text = user.dept.toString()
        positionLabel.text = user.position
        nameLabel.text = user.name

        print("Profile " + user.name)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
