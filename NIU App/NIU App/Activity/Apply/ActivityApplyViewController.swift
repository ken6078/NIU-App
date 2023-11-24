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
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 100, width: 50, height: 50))
        loadingView.color = .gray
        loadingView.style = .medium
        loadingView.startAnimating()
        loadingView.center.x = self.view.center.x
        return loadingView
    }()
    
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
        let image = UIImage(named: "cross")!.imageWithColor(newColor: .blue)
        imageView.image = image
        view.addSubview(imageView)
        
        width = screenSize.width * 0.8
        heigth = 72
        x = 0
        y = screenSize.height * 0.22
        let textView = UITextView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        textView.text = "失敗"
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
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(loadingView)
        
        loadingView.stopAnimating()
//        view.addSubview(seccessView)
        view.addSubview(failView(message: "這功能還沒做"))
    }
}
