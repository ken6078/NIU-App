//
//  ActivityModel.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/8/27.
//

import Foundation
import Kanna

enum ActivityStatus {
    case unable
    case enable
    case full
    case expried
}

enum CertifiedStatus {
    case unable //未認證
    case enable //已認證
    case none   //非認證
}

enum CertifiedType {
    case service //服務奉獻
    case growth  //多元成長
    case major   //專業進取
    case none    //非認證
}

class Activity {
    var id: Int
    var organizer: String
    var name: String
    var startDate: Date
    var endDate: Date
    var status: ActivityStatus
    var certifiedType: CertifiedType
    var certifiedStatus: CertifiedStatus
    var people: String
    var select: Bool = false
    
    // MARK: init(id, node)
    init (id: Int, node: Kanna.XMLElement) {
        let nodeText = node.text!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh-TW")
        dateFormatter.dateFormat = "yyyy/MM/ddahh:mm:ss"
        
        // 編號
        self.id = id
        
        // 主辦單位
        let organizerString = node.at_xpath("//div[contains(@class, 'enr-list-dep-nam')]")!["title"]!
        self.organizer = String(organizerString.split(separator: "：").last!)
        
        // 活動名稱
        self.name = node.at_xpath("//h3")?.text ?? ""
        self.name = self.name.replacingOccurrences(of: "\r", with: "")
        self.name = self.name.replacingOccurrences(of: "\n", with: "")
        self.name = self.name.replacingOccurrences(of: " ", with: "")
        
        // 認證種類
        if nodeText.contains("多元成長") {
            self.certifiedType = .growth
        } else if nodeText.contains("服務奉獻") {
            self.certifiedType = .service
        } else if nodeText.contains("專業進取") {
            self.certifiedType = .major
        } else {
            self.certifiedType = .none
        }
        
        // 認證狀態
        if nodeText.contains("已認證") {
            self.certifiedStatus = .enable
        } else if nodeText.contains("未認證") {
            self.certifiedStatus = .unable
        } else {
            self.certifiedStatus = .none
        }
        
        // 活動期間
        var timeString = (node.at_xpath("//i[contains(@class, 'calendar')]")?.parent?.text)!
        timeString = timeString.replacingOccurrences(of: "\r\n", with: "")
        timeString = timeString.replacingOccurrences(of: " ", with: "")
        let timeList = timeString.components(separatedBy: "~")
        self.startDate = dateFormatter.date(from:timeList[0])!
        self.endDate = dateFormatter.date(from:timeList[1])!
        
        //報名人數
        var peopleString = (node.at_xpath("//i[contains(@class, 'user')]")?.parent?.text)!
        peopleString = peopleString.replacingOccurrences(of: "\r\n", with: "")
        peopleString = peopleString.replacingOccurrences(of: " ", with: "")
        peopleString = peopleString.replacingOccurrences(of: "，", with: "\t")
        self.people = peopleString
        
        // 報名狀態
        if nodeText.contains("報名中") {
            self.status = .enable
            if Activity.checkStatus(status: self.people) {
                self.status = .full
            }
        } else if nodeText.contains("報名已截止") {
            self.status = .expried
        } else {
            self.status = .unable
        }
    }
    
    // MARK: init
    init(
        id: Int, name: String, organizer: String,
        startDate: Date, endDate: Date,
        status: ActivityStatus, certifiedType: CertifiedType, certifiedStatus: CertifiedStatus,
        people: String
    ) {
        self.id = id
        self.name = name
        self.organizer = organizer
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.certifiedType = certifiedType
        self.certifiedStatus = certifiedStatus
        self.people = people
    }
    
    // MARK: init
    init(){
        self.id = 0
        self.name = "測試活動"
        self.organizer = "測試主辦單位"
        self.startDate = Date()
        self.endDate = Date()
        self.status = .unable
        self.certifiedStatus = .none
        self.certifiedType = .none
        self.people = "正取：44/60\t備取：0/10"

    }
    
    // MARK: checkStatus(status)
    static func checkStatus(status: String) -> Bool {
        let split = status.components(separatedBy: "\t")
        for element in split {
            var number = element.components(separatedBy: "：").last!
            number = number.replacingOccurrences(of: " ", with: "")
            let list = number.components(separatedBy: "/")
            if list[0] != list[1]{
                return false
            }
        }
        return true
    }
}
