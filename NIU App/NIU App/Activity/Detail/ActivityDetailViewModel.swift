//
//  ActivityDetailViewModel.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/11/22.
//

import Foundation
import Kanna

class ActivityDetailViewModel {
    static func getinformation(activity: Activity) async -> ActivityDetail{
        let activityDetail = ActivityDetail()
        let webPageURL = URL(string: "https://ccsys.niu.edu.tw/MvcTeam/Act/Apply/\(activity.id)")!
        var activityRequest = URLRequest(url: webPageURL)
        activityRequest.allHTTPHeaderFields = headers
        do {
            let (activityPageData, _) = try await URLSession.shared.data(for: activityRequest)
            let activityPageHTML = String(decoding: activityPageData, as: UTF8.self)
            let doc = try? HTML(html: activityPageHTML, encoding: .utf8)
            var jumbotron = (doc!.at_xpath("//div[contains(@class,'jumbotron')]")?.innerHTML)!
            jumbotron = jumbotron.replacingOccurrences(of: "\r\n", with: "")
            jumbotron = jumbotron.trimmingCharacters(in: .whitespaces)
            jumbotron = jumbotron.replacingOccurrences(of: "<br>", with: "\n")
            activityDetail.explain = jumbotron
            activityDetail.success = true
        } catch {
            print("錯誤")
        }
        return activityDetail
    }
}
