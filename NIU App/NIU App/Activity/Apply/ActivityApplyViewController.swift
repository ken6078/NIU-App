//
//  ActivityApplyViewController.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/11/22.
//

import UIKit

class ActivityApplyViewController: UIViewController {
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    var activity: Activity = Activity()
    var activityApplyViewModel: ActivityApplyViewModel = ActivityApplyViewModel()
    
    var checkView: UIView = UIView()
    
    lazy var seccessView: UIView = {
        var width = screenSize.width * 0.8
        var heigth = self.view.frame.height
        var x = screenSize.width * 0.1
        var y = 0.0
        let view = UIView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        
        width = screenSize.width * 0.2
        heigth = screenSize.width * 0.2
        x = screenSize.width * 0.3
        y = screenSize.height * 0.1
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        let image = UIImage(named: "check")!.imageWithColor(newColor: .blue)
        imageView.image = image
        view.addSubview(imageView)
        
        width = screenSize.width * 0.8
        heigth = 72
        x = 0
        y = screenSize.height * 0.22
        let textView = UITextView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        textView.text = "成功"
        textView.font =  UIFont.boldSystemFont(ofSize: 48)
        textView.textColor = .blue
        textView.textAlignment = .center
        view.addSubview(textView)
        
        return view
    }()
    
    func failView(message: String) -> UIView {
        var width = screenSize.width * 0.8
        var heigth = self.view.frame.height
        var x = screenSize.width * 0.1
        var y = 0.0
        let view = UIView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        
        width = screenSize.width * 0.2
        heigth = screenSize.width * 0.2
        x = screenSize.width * 0.3
        y = screenSize.height * 0.1
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        let image = UIImage(named: "cross")!.imageWithColor(newColor: .red)
        imageView.image = image
        view.addSubview(imageView)
        
        width = screenSize.width * 0.8
        heigth = 128
        x = 0
        y = screenSize.height * 0.22
        let textView = UILabel(frame: CGRect(x: x, y: y, width: width, height: heigth))
        textView.text = "失敗\n" + message
        textView.font =  UIFont.boldSystemFont(ofSize: 48)
        textView.textColor = .red
        textView.textAlignment = .center
        textView.numberOfLines = 2
        view.addSubview(textView)
        
        return view
    }
    
    lazy var acceptButton: LoaderButton = {
        let width = screenSize.width * 0.3
        let heigth = screenSize.width * 0.2
        let x = screenSize.width * 0.5
        let y = screenSize.height * 0.3
        let checkButton = LoaderButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        checkButton.setTitle("確定", for: .normal)
        checkButton.layer.cornerRadius = 15
        checkButton.backgroundColor = UIColor(rgb: 0x3638E0)
        checkButton.addTarget(self, action: #selector(accept), for: .touchUpInside)
        return checkButton
    }()
    
    lazy var cancleButton: LoaderButton = {
        let width = screenSize.width * 0.3
        let heigth = screenSize.width * 0.2
        let x = screenSize.width * 0
        let y = screenSize.height * 0.3
        let cancleButton = LoaderButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        cancleButton.setTitle("取消", for: .normal)
        cancleButton.layer.cornerRadius = 15
        cancleButton.backgroundColor = UIColor(rgb: 0xE0385F)
        cancleButton.addTarget(self, action: #selector(cancle), for: .touchUpInside)
        return cancleButton
    }()
    
    func confirmView(activity: Activity) -> UIView {
        var width = screenSize.width * 0.8
        var heigth = self.view.frame.height
        var x = screenSize.width * 0.1
        var y = 0.0
        let view = UIView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        
        width = screenSize.width * 0.8
        heigth = 128
        x = 0
        y = screenSize.height * 0.05
        let textView = UILabel(frame: CGRect(x: x, y: y, width: width, height: heigth))
        textView.text = "確定要報名以下活動?\n\"\(activity.name)\""
        textView.numberOfLines = 4
        textView.font =  UIFont.systemFont(ofSize: 20)
        textView.textAlignment = .center
        view.addSubview(textView)
        
        view.addSubview(acceptButton)
        view.addSubview(cancleButton)
        
        return view
    }
    
    @objc func accept() {
        acceptButton.isLoading = true
        cancleButton.isEnabled = false
        Task {
            let result = await activityApplyViewModel.applyActivity(activity:activity)
            self.checkView.removeFromSuperview()
            if result == "成功" {
                self.view.addSubview(seccessView)
            } else {
                self.view.addSubview(failView(message: result))
            }
        }
    }
    
    @objc func cancle() {
        dismiss(animated: true)
    }
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        checkView = confirmView(activity: activity)
        view.addSubview(checkView)
//        view.addSubview(failView(message: "這功能還沒做"))
    }
}
