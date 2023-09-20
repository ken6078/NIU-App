//
//  MenuViewController.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/8/20.
//

import UIKit

class MenuViewController: UIViewController {
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    let weatherViewModel: WeatherViewModel = WeatherViewModel()
    
    let username: String
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(username: String = "未知使用者") {
        self.username = username
        
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var nameLabel: UILabel = {
        let width = screenSize.width * 0.7
        let heigth = screenSize.height * 0.08
        let x = screenSize.width * 0.1
        let y = screenSize.height * 0.06
        
        let nameLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: heigth))
        nameLabel.text = "你好，" + username
        nameLabel.font = UIFont.systemFont(ofSize: 24)

        return nameLabel
    }()
    
    lazy var userButton: UIButton = {
        let width = screenSize.width * 0.16
        let heigth = screenSize.width * 0.16
        let x = screenSize.width * 0.75
        let y = screenSize.height * 0.06
        
        var button = UIButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        button.layer.cornerRadius = screenSize.width * 0.08
        button.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        // icon
        let imageWidth = screenSize.width * 0.1
        let imageHeigth = screenSize.width * 0.1
        let imageX = screenSize.width * 0.03
        let imageY = screenSize.width * 0.03
        var imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeigth))
        guard let image = UIImage(named: "user") else {return button}
        imageView.image = image
        button.addSubview(imageView)
        
        return button
    }()
    
    lazy var weatherLayout: UIView = {
        let width = screenSize.width * 0.5
        let heigth = width*(110/200)
        let x = CGFloat(0)
        let y = CGFloat(0)
        
        var view = UIView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(red: 0.454, green: 0.738, blue: 1, alpha: 1)
        
        let loadingLabel = UILabel()
        loadingLabel.frame = CGRect(x: 5, y: 5, width: width-10, height: heigth-10)
        loadingLabel.text = "載入中..."
        loadingLabel.textAlignment = .center
        view.addSubview(loadingLabel)
        
        Task {
            let weather = await weatherViewModel.getWeatherInformation()
            
            let tempLabel = UILabel()
            tempLabel.frame = CGRect(x: width*0.5, y: heigth*0.15, width: width*0.5, height: heigth*0.40)
            tempLabel.font = UIFont.systemFont(ofSize: 28)
            tempLabel.text = weather.TEMP.description + "°C"
            view.addSubview(tempLabel)
            
            let humdLabel = UILabel()
            humdLabel.frame = CGRect(x: width*0.5, y: heigth*0.45, width: width*0.5, height: heigth*0.40)
            humdLabel.font = UIFont.systemFont(ofSize: 20)
            humdLabel.textAlignment = .left
            humdLabel.text = (weather.HUMD*100).description + "%"
            view.addSubview(humdLabel)
            
            var imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: heigth*0.6, height: heigth*0.6))
            imageView.center.y = heigth/2
            let image: UIImage
            
            if (weather.status == .cloud) {
                view.backgroundColor = UIColor(red: 0.086, green: 0.401, blue: 0.692, alpha: 1)
                image = UIImage(named: "cloud")!
                tempLabel.textColor = .white
                humdLabel.textColor = .white
            } else if (weather.status == .rain) {
                view.backgroundColor = UIColor(red: 0.133, green: 0.337, blue: 0.525, alpha: 1)
                image = UIImage(named: "rain")!
                tempLabel.textColor = .white
                humdLabel.textColor = .white
            } else if (weather.status == .storm){
                view.backgroundColor = UIColor(red: 0.045, green: 0.28, blue: 0.496, alpha: 1)
                image = UIImage(named: "storm")!
                tempLabel.textColor = .white
                humdLabel.textColor = .white
            } else {
                image = UIImage(named: "sun")!
            }
            imageView.image = image
            view.addSubview(imageView)
            
            loadingLabel.removeFromSuperview()
        }
        
        return view
    }()
    
    lazy var calendarButton: UIButton = {
        let width = screenSize.width * 0.3
        let heigth = width*(110/200)*(5/3)
        let x = screenSize.width * 0.53
        let y = CGFloat(0)
        
        var button = UIButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 0.569, green: 0.663, blue: 0.851, alpha: 1)
        button.addTarget(self, action: #selector(self.calendar), for: .touchUpInside)
        // icon
        let imageWidth = heigth * 0.7
        let imageHeigth = heigth * 0.7
        let imageX = heigth * 0.1
        let imageY = heigth * 0.15
        var imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeigth))
        guard let image = UIImage(named: "calendar") else {return button}
        imageView.image = image
        button.addSubview(imageView)
        //text
        let textWidth = heigth * 0.2
        let textHeigth = heigth * 0.7
        let textX = heigth * 0.8
        let textY = heigth * 0.15
        var label = UILabel(frame: CGRect(x: textX, y: textY, width: textWidth, height: textHeigth))
        label.text = "行事曆"
        label.font = UIFont.systemFont(ofSize: heigth * 0.15)
        label.numberOfLines = 0
        button.addSubview(label)

        return button
    }()
    
    @objc func calendar() {
        DispatchQueue.main.async {
            let newViewController = CalendarViewController()
            self.navigationController!.pushViewController(newViewController, animated: false)
        }
    }
    
    lazy var timeTabelButton: UIButton = {
        let width = screenSize.width * 0.3
        let heigth = width*(110/200)*(5/3)
        let x = CGFloat(0)
        let y = heigth + (screenSize.height * 0.02)
        
        var button = UIButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 0.851, green: 0.741, blue: 0.792, alpha: 1)
        // icon
        let imageWidth = heigth * 0.6
        let imageHeigth = heigth * 0.6
        let imageX = heigth * 0.1
        let imageY = heigth * 0.2
        var imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeigth))
        guard let image = UIImage(named: "alarm-clock") else {return button}
        imageView.image = image
        button.addSubview(imageView)
        //text
        let textWidth = heigth * 0.2
        let textHeigth = heigth * 0.7
        let textX = heigth * 0.8
        let textY = heigth * 0.15
        var label = UILabel(frame: CGRect(x: textX, y: textY, width: textWidth, height: textHeigth))
        label.text = "課表"
        label.font = UIFont.systemFont(ofSize: heigth * 0.15)
        label.numberOfLines = 0
        button.addSubview(label)
        
        return button
    }()
    
    lazy var activityButton: UIButton = {
        let width = screenSize.width * 0.3
        let heigth = width*(110/200)*(5/3)
        let x = CGFloat(0)
        let y = (heigth * 2) + (screenSize.height * 0.02 * 2)
        
        var button = UIButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 0.655, green: 0.722, blue: 0.851, alpha: 1)
        button.addTarget(self, action: #selector(self.activity), for: .touchUpInside)
        // icon
        let imageWidth = heigth * 0.6
        let imageHeigth = heigth * 0.6
        let imageX = heigth * 0.1
        let imageY = heigth * 0.2
        var imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeigth))
        guard let image = UIImage(named: "speaker") else {return button}
        imageView.image = image
        button.addSubview(imageView)
        //text
        let textWidth = heigth * 0.2
        let textHeigth = heigth * 0.7
        let textX = heigth * 0.8
        let textY = heigth * 0.15
        var label = UILabel(frame: CGRect(x: textX, y: textY, width: textWidth, height: textHeigth))
        label.text = "活動"
        label.font = UIFont.systemFont(ofSize: heigth * 0.15)
        label.numberOfLines = 0
        button.addSubview(label)
        
        return button
    }()
    
    @objc func activity() {
        DispatchQueue.main.async {
            let newViewController = ActivityViewController()
            self.navigationController!.pushViewController(newViewController, animated: false)
        }
    }
    
    lazy var noteButton: UIButton = {
        let width = screenSize.width * 0.5
        let unitHeigth = width*(110/200)
        let heigth = unitHeigth * 2 + (screenSize.height * 0.02)
        let x = screenSize.width * 0.33
        let y = unitHeigth + (screenSize.height * 0.02)
        
        var button = UIButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        // icon
        let imageWidth = width * 0.12
        let imageHeigth = width * 0.12
        let imageX = width * 0.3
        let imageY = width * 0.07
        var imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeigth))
        guard let image = UIImage(named: "megaphone") else {return button}
        imageView.image = image
        button.addSubview(imageView)
        //text
        let textWidth = width * 0.8
        let textHeigth = width * 0.15
        let textX = width * 0.44
        let textY = width * 0.05
        var label = UILabel(frame: CGRect(x: textX, y: textY, width: textWidth, height: textHeigth))
        label.text = "公告"
        label.font = UIFont.systemFont(ofSize: width * 0.12)
        label.numberOfLines = 0
        button.addSubview(label)
        
        return button
    }()
    
    lazy var scoreButton: UIButton = {
        let width = screenSize.width * 0.3
        let heigth = width*(110/200)*(5/3)
        let x = CGFloat(0)
        let y = (heigth * 3) + (screenSize.height * 0.02 * 3)
        
        var button = UIButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 0.851, green: 0.765, blue: 0.569, alpha: 1)
        // icon
        let imageWidth = heigth * 0.6
        let imageHeigth = heigth * 0.6
        let imageX = heigth * 0.1
        let imageY = heigth * 0.2
        var imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeigth))
        guard let image = UIImage(named: "exam") else {return button}
        imageView.image = image
        button.addSubview(imageView)
        //text
        let textWidth = heigth * 0.2
        let textHeigth = heigth * 0.7
        let textX = heigth * 0.8
        let textY = heigth * 0.15
        var label = UILabel(frame: CGRect(x: textX, y: textY, width: textWidth, height: textHeigth))
        label.text = "成績"
        label.font = UIFont.systemFont(ofSize: heigth * 0.15)
        label.numberOfLines = 0
        button.addSubview(label)

        return button
    }()
    
    lazy var graduateButton: UIButton = {
        let width = screenSize.width * 0.5
        let heigth = width*(110/200)
        let x = screenSize.width * 0.33
        let y = (heigth * 3) + (screenSize.height * 0.02 * 3)
        
        var button = UIButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 0.763, green: 0.763, blue: 0.763, alpha: 1)
        // icon
        let imageWidth = heigth * 0.7
        let imageHeigth = heigth * 0.7
        let imageX = heigth * 0.15
        let imageY = heigth * 0.15
        var imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeigth))
        guard let image = UIImage(named: "graduate") else {return button}
        imageView.image = image
        button.addSubview(imageView)
        //text
        let textWidth = width * 0.8
        let textHeigth = heigth * 0.7
        let textX = heigth * 1.0
        let textY = heigth * 0.15
        var label = UILabel(frame: CGRect(x: textX, y: textY, width: textWidth, height: textHeigth))
        label.text = "畢業"
        label.font = UIFont.systemFont(ofSize: width * 0.15)
        label.numberOfLines = 0
        button.addSubview(label)

        return button
    }()
    
    lazy var leaveButton: UIButton = {
        let width = screenSize.width * 0.5
        let heigth = width*(110/200)
        let x = CGFloat(0)
        let y = (heigth * 4) + (screenSize.height * 0.02 * 4)
        
        var button = UIButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 0.612, green: 0.851, blue: 0.616, alpha: 1)
        // icon
        let imageWidth = heigth * 0.7
        let imageHeigth = heigth * 0.7
        let imageX = heigth * 0.15
        let imageY = heigth * 0.15
        var imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeigth))
        guard let image = UIImage(named: "sick") else {return button}
        imageView.image = image
        button.addSubview(imageView)
        //text
        let textWidth = width * 0.8
        let textHeigth = heigth * 0.7
        let textX = heigth * 1.0
        let textY = heigth * 0.15
        var label = UILabel(frame: CGRect(x: textX, y: textY, width: textWidth, height: textHeigth))
        label.text = "請假"
        label.font = UIFont.systemFont(ofSize: width * 0.15)
        label.numberOfLines = 0
        button.addSubview(label)
        
        return button
    }()
    
    lazy var moreButton: UIButton = {
        let width = screenSize.width * 0.3
        let heigth = width*(110/200)*(5/3)
        let x = screenSize.width * 0.53
        let y = (heigth * 4) + (screenSize.height * 0.02 * 4)
        
        var button = UIButton(frame: CGRect(x: x, y: y, width: width, height: heigth))
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
        // icon
        let imageWidth = width * 0.7
        let imageHeigth = width * 0.7
        let imageX = width * 0.15
        let imageY = width * 0.15
        var imageView = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeigth))
        guard let image = UIImage(named: "ellipsis") else {return button}
        imageView.image = image
        button.addSubview(imageView)
        
        return button
    }()
    
    lazy var selectPannel: UIScrollView = {
        let width = screenSize.width * 0.83
        let heigth = screenSize.height * 0.83
        let x = screenSize.width * 0.07
        let y = screenSize.height * 0.17
        
        var scrollView = UIScrollView(frame: CGRect(x: x, y: y, width: width, height: heigth))
        let unitHeigth = screenSize.width * 0.5 * (110/200)
        let contentHeight = unitHeigth*5 + (screenSize.height * 0.02 * 5)
        scrollView.contentSize = CGSize(width: width, height: contentHeight)
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubview(self.weatherLayout)
        scrollView.addSubview(self.calendarButton)
        scrollView.addSubview(self.timeTabelButton)
        scrollView.addSubview(self.activityButton)
        scrollView.addSubview(self.noteButton)
        scrollView.addSubview(self.scoreButton)
        scrollView.addSubview(self.graduateButton)
        scrollView.addSubview(self.leaveButton)
        scrollView.addSubview(self.moreButton)
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(self.userButton)
        view.addSubview(self.nameLabel)
        view.addSubview(self.selectPannel)
    }
}
