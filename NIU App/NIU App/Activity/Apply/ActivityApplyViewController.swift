//
//  ActivityApplyViewController.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/11/22.
//

import UIKit

class ActivityApplyViewController: UIViewController {
    
    var activity: Activity = Activity()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 100, width: 50, height: 50))
        loadingView.color = .gray
        loadingView.style = .medium
        loadingView.startAnimating()
        loadingView.center.x = self.view.center.x
        return loadingView
    }()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(loadingView)
    }
}
