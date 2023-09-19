//
//  ActivityViewController.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/8/27.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    let activityViewModel = ActivityViewModel()
    var activitys: [Activity] = []
    
    var selectRow: Int = 1
    
    lazy var loadingText: UITextView = {
        var textView = UITextView()
        
        textView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 200)
        textView.center.x = screenSize.width / 2
        textView.center.y = screenSize.height / 2
        
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.text = "載入中~"
        
        return textView
    }()

    lazy var tableView: UITableView = {
        var tableView = UITableView()
        
        tableView.frame = CGRect(
            x: screenSize.width*0.025,
            y: screenSize.height*0.1,
            width: screenSize.width*0.95,
            height: screenSize.height*0.9
        )
        
        tableView.register(ActivityCell.self, forCellReuseIdentifier: "ActivityCell")
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    func errorAlert(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: "失敗",
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "活動"
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(loadingText)
        
        
        Task{
            activitys = await ActivityViewModel().getInformation()
            if (activitys.count == 0) {
                errorAlert(message: "伺服器連接錯誤，請稍後再試")
                return
            }
            DispatchQueue.main.async {
                self.view.addSubview(self.tableView)
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activitys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as? ActivityCell else {
            fatalError("ActivityCell is not defined!")
        }
        let activity = activitys[indexPath.row]
        cell.configure(activity: activity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow = indexPath.row
        activitys[indexPath.row].select = !activitys[indexPath.row].select
        tableView.reloadRows(at: [indexPath], with: .right)
    }

}
