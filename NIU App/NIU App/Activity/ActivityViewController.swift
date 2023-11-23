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
    
    // MARK: loadingLabel
    lazy var loadingLabel: UILabel = {
        var textLabel = UILabel()
        
        textLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 200)
        textLabel.center.x = screenSize.width / 2
        textLabel.center.y = screenSize.height / 2
        
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 24)
        textLabel.text = "載入中..."
        
        return textLabel
    }()

    // MARK: tableView
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
    
    // MARK: errorAlert
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
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "活動"
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(loadingLabel)
        
        
        Task{
            activitys = await ActivityViewModel().getInformation()
            if (activitys.count == 0) {
                errorAlert(message: "伺服器連接錯誤，請稍後再試")
                return
            }
            DispatchQueue.main.async {
                self.view.addSubview(self.tableView)
                self.loadingLabel.removeFromSuperview()
            }
            
        }
    }
    
    // MARK: tableView row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activitys.count
    }
    
    // MARK: set tableView row cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as? ActivityCell else {
            fatalError("ActivityCell is not defined!")
        }
        let activity = activitys[indexPath.row]
        cell.configure(activity: activity)
        return cell
    }
    
    // MARK: set tableView row click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow = indexPath.row
        activitys[indexPath.row].select = !activitys[indexPath.row].select
        tableView.reloadRows(at: [indexPath], with: .right)
    }
    
    // MARK: swipeAction
        // https://stackoverflow.com/questions/56588715
        internal func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let detailAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
                DispatchQueue.main.async {
                    let newViewController = ActivityDetailViewController()
                    if #available(iOS 15.0, *) {
                        newViewController.sheetPresentationController?.detents = [.medium()]
                    }
                    newViewController.activity = self.activitys[indexPath.row]
                    self.present(newViewController, animated: true)
                }
                completionHandler(false)
            }
            let applyAction = UIContextualAction(style: .normal, title: nil) { (action, view, completionHandler) in
                DispatchQueue.main.async {
                    let newViewController = ActivityApplyViewController()
                    if #available(iOS 15.0, *) {
                        newViewController.sheetPresentationController?.detents = [.medium()]
                    }
                    newViewController.activity = self.activitys[indexPath.row]
                    self.present(newViewController, animated: true)
                }
                completionHandler(true)
            }

            let detailView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            detailView.backgroundColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
            detailView.layer.cornerRadius = 12
            let detailLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            detailLabel.center = detailView.center
            detailLabel.font = UIFont.systemFont(ofSize: 16)
            detailLabel.text = "詳細資料"
            detailLabel.textColor = .white
            detailLabel.textAlignment = .center
            detailView.addSubview(detailLabel)
            detailAction.image = UIImage(view: detailView)

            let applyView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            applyView.backgroundColor = UIColor(red: 1, green: 0.604, blue: 0.604, alpha: 1)
            applyView.layer.cornerRadius = 12
            let applyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            applyLabel.center = detailView.center
            applyLabel.font = UIFont.systemFont(ofSize: 16)
            applyLabel.text = "報名"
            applyLabel.textColor = .white
            applyLabel.textAlignment = .center
            applyView.addSubview(applyLabel)
            applyAction.image = UIImage(view: applyView)

            detailAction.backgroundColor = .white
            applyAction.backgroundColor = .white

            if (activitys[indexPath.row].status == .enable) {
                return UISwipeActionsConfiguration(actions: [applyAction, detailAction])
            } else {
                return UISwipeActionsConfiguration(actions: [detailAction])
            }
        }

}
