//
//  ActivityCell.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/9/18.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    let screenSize:CGRect = UIScreen.main.bounds
    
    // MARK: nameLabel
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        
        label.frame = CGRect(x: 10, y: 0, width: screenSize.width*0.6, height: 70)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: statusLabel
    lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.frame = CGRect(x: screenSize.width*0.6 + 25, y: 0, width: 70, height: 70)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: rightArrowImageView
    func rightArrowImageView() -> UIImageView {
        let image = UIImage(systemName: "chevron.right")!.imageWithColor(newColor: .black)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: screenSize.width*0.85, y: 0, width: 15, height: 30)
        imageView.center.y = 35
        return imageView
    }
    
    // MARK: timeLabel
    func timeLabel(activity: Activity) -> UILabel {
        let label = UILabel()

        label.frame = CGRect(x: 10, y: 10, width: screenSize.width*0.8, height: 30)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let startDateString = dateFormatter.string(from: activity.startDate)
        let endDateString = dateFormatter.string(from: activity.endDate)
        
        label.text = "活動期間： \(startDateString) ~ \(endDateString)"
        
        return label
    }
    
    // MARK: peopleAndIdLabel
    func peopleAndIdLabel(activity: Activity) -> UILabel {
        let label = UILabel()

        label.frame = CGRect(x: 10, y: 30, width: screenSize.width*0.8, height: 30)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        
        label.text = "\(activity.people)\t"
        label.text! += "ID：\(activity.id)"
        
        return label
    }
    
    // MARK: informationLayout
    func informationLayout(activity: Activity) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 5, width: screenSize.width*0.95, height: 70)
        view.layer.cornerRadius = 12
        if (activity.status == .enable) {
            self.statusLabel.text = "報名中"
            view.backgroundColor = UIColor(red: 0.773, green: 0.949, blue: 0.8, alpha: 1)
        } else if (activity.status == .expried) {
            self.statusLabel.text = "過期"
            view.backgroundColor = UIColor(red: 0.908, green: 0.908, blue: 0.908, alpha: 1)
        } else if (activity.status == .full) {
            self.statusLabel.text = "滿人"
            view.backgroundColor = UIColor(red: 0.949, green: 0.875, blue: 0.827, alpha: 1)
        } else {
            self.statusLabel.text = "未開放"
            view.backgroundColor = UIColor(red: 0.908, green: 0.908, blue: 0.908, alpha: 1)
        }
        
        self.statusLabel.text! += "\n"
        
        if activity.certifiedType == .major {
            self.statusLabel.text! += "專業進取"
        } else if activity.certifiedType == .service {
            self.statusLabel.text! += "服務奉獻"
        } else if activity.certifiedType == .growth {
            self.statusLabel.text! += "多元成長"
        } else {
            self.statusLabel.text! += "非認證"
        }
        
        nameLabel.text = activity.name
        view.addSubview(nameLabel)
        view.addSubview(statusLabel)
        view.addSubview(rightArrowImageView())
        
        return view
    }
    
    // MARK: moreInformationLayout
    func moreInformationLayout(activity: Activity) -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 5, width: screenSize.width*0.95, height: 70)
        view.layer.cornerRadius = 12
        if (activity.status == .enable) {
            view.backgroundColor = UIColor(red: 0.773, green: 0.949, blue: 0.8, alpha: 1)
        } else if (activity.status == .expried) {
            view.backgroundColor = UIColor(red: 0.908, green: 0.908, blue: 0.908, alpha: 1)
        } else if (activity.status == .full) {
            view.backgroundColor = UIColor(red: 0.949, green: 0.875, blue: 0.827, alpha: 1)
        } else {
            view.backgroundColor = UIColor(red: 0.908, green: 0.908, blue: 0.908, alpha: 1)
        }
        
        view.addSubview(timeLabel(activity: activity))
        view.addSubview(peopleAndIdLabel(activity: activity))
        view.addSubview(rightArrowImageView())
        return view
    }
    
    // MARK: configure
    func configure (activity: Activity) {
        if (activity.select == false) {
            addSubview(informationLayout(activity: activity))
        } else {
            addSubview(moreInformationLayout(activity: activity))
        }
    }
}
