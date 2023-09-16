//
//  ActivityViewController.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/8/27.
//

import UIKit

class ActivityViewController: UIViewController {
    
    let activityViewModel = ActivityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "活動"
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
}
