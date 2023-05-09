//
//  ViewController.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/5/9.
//

import UIKit

class ViewController: UIViewController {
    
    var testLabel: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        testLabel.text = "Hello World"
        
        view.addSubview(testLabel)
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        testLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }


}

