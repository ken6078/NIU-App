//
//  ActivityApplyViewModel.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/11/22.
//

import Foundation
import Kanna

class ActivityApplyViewModel {
    
    let password: String
    let account: String
    
    func applyActivity(activity: Activity) async -> String {
        let loginURL = URL(string: "https://ccsys.niu.edu.tw/MvcTeam/Account/Login")!
        var getLoginPageRequest = URLRequest(url: loginURL)
        getLoginPageRequest.allHTTPHeaderFields = headers
            
        do {
            let (loginData, _) = try await URLSession.shared.data(for: getLoginPageRequest)
            let loginPageHTML = String(decoding: loginData, as: UTF8.self)
            var doc = try? HTML(html: loginPageHTML, encoding: .utf8)
            // 設定Payload
            var __RequestVerificationToken = doc!.at_css("input")!["value"]
            var urlParser = URLComponents()
            urlParser.queryItems = [
                URLQueryItem(name: "__RequestVerificationToken", value: __RequestVerificationToken),
                URLQueryItem(name: "Account", value: account),
                URLQueryItem(name: "Password", value: password),
            ]
            var httpBodyString = urlParser.percentEncodedQuery!.urlEncoded()
            // 傳送登入資訊
            var loginedRequest = URLRequest(url: loginURL)
            loginedRequest.httpMethod = "POST"
            loginedRequest.httpBody = httpBodyString.data(using: .ascii)
            loginedRequest.allHTTPHeaderFields = headers
            var (loginedData, _) = try await URLSession.shared.data(for: loginedRequest)
            var loginedHTML = String(decoding: loginedData, as: UTF8.self)
            if (!loginedHTML.contains("您好")) {
                return "伺服器錯誤"
            }
            let activityURL = URL(string: "https://ccsys.niu.edu.tw/MvcTeam/Act/Apply/\(activity.id)")!
            var activityRequest = URLRequest(url: activityURL)
            activityRequest.allHTTPHeaderFields = headers
            let (activityData, _) = try await URLSession.shared.data(for: activityRequest)
            let activityHTML = String(decoding: activityData, as: UTF8.self)
            doc = try? HTML(html: activityHTML, encoding: .utf8)
            // 設定Payload
            __RequestVerificationToken = doc!.at_css("input")!["value"]
            urlParser = URLComponents()
            urlParser.queryItems = [
                URLQueryItem(name: "__RequestVerificationToken", value: __RequestVerificationToken),
                URLQueryItem(name: "Account", value: account),
                URLQueryItem(name: "Password", value: password),
            ]
            httpBodyString = urlParser.percentEncodedQuery!.urlEncoded()
            // 傳送登入資訊
            var applyedRequest = URLRequest(url: activityURL)
            applyedRequest.httpMethod = "POST"
            applyedRequest.httpBody = httpBodyString.data(using: .ascii)
            applyedRequest.allHTTPHeaderFields = headers
            let (applyedData, _) = try await URLSession.shared.data(for: applyedRequest)
            // 檢查報名狀態
            let applyedHTML = String(decoding: applyedData, as: UTF8.self)
            if (!applyedHTML.contains("已報名")) {
                return "伺服器錯誤"
            }
            print("SUCCESS")
        }catch {
            print("ERROR")
            return "伺服器錯誤"
        }
        return "成功"
    }
    
    // MARK: init
    init () {
        let userDefault = UserDefaults()
        account = userDefault.value(forKey: "account") as! String
        password = userDefault.value(forKey: "password") as! String
    }
}
