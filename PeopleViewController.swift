//
//  PeopleViewController.swift
//  SharedTODOList
//
//  Created by 이현승 on 2023/06/20.
//

import UIKit

class PeopleViewController: UIViewController {
    var user: User!
    var userGroup: UserGroup!

    @IBOutlet weak var peopleTableVIew: UITableView!
    @IBOutlet weak var deptLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        deptLabel.text = user.dept.toString()
        peopleTableVIew.dataSource = self
        userGroup = UserGroup(parentNotification: nil)
        
        userGroup.queryData { [weak self] userCount in
            DispatchQueue.main.async {
                self?.peopleTableVIew.reloadData()
            }
        }
    }
}
extension PeopleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let userGroup = userGroup{
            return userGroup.getUsersByDept(dept:user.dept).count
        }
        return 0    // planGroup가 생성되기전에 호출될 수도 있다
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)

            let users = userGroup.getUsersByDept(dept: user.dept)
            let user = users[indexPath.row]
            print(user.name)

            // 적절히 cell에 데이터를 채움
            (cell.contentView.subviews[0] as! UILabel).text = user.dept.toString()
            (cell.contentView.subviews[1] as! UILabel).text = user.name
            (cell.contentView.subviews[2] as! UILabel).text = user.position

            return cell
        }
}
