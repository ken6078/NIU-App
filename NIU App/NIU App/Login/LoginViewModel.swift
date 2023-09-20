//
//  LoginViewModel.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/5/16.
//

import Foundation
import TensorFlowLiteTaskVision
import Kanna

class LoginViewModel: ObservableObject {
    
    let userDefault = UserDefaults()
    let options: ImageClassifierOptions
    
    // MARK: saveData
    func saveData(account: String, password: String) {
        userDefault.setValue(account, forKey: "account");
        userDefault.setValue(password, forKey: "password");
    }
    
    // MARK: login
    func login(account: String, password: String, time: Int = 0,
               success: @escaping (String) -> (),
               error: @escaping (String) -> ()
    ){
        if (account == "") {
            error("請輸入帳號")
        }
        if (password == ""){
            error("請輸入密碼")
        }
        Task {
            // 登入request
            let loginURL = URL(string: "https://ccsys.niu.edu.tw/SSO/Default.aspx")!
            var loginRequest = URLRequest(url: loginURL)
            loginRequest.allHTTPHeaderFields = headers
            // 驗證碼request
            let vaildateCodeURL = URL(string: "https://ccsys.niu.edu.tw/SSO/VaildateCode.ashx")!
            var vaildateCodeRequest = URLRequest(url: vaildateCodeURL)
            vaildateCodeRequest.allHTTPHeaderFields = headers
            
            do {
                // 獲取登入頁面
                let (loginPageData, _) = try await URLSession.shared.data(for: loginRequest)
                let loginPageHTML = String(decoding: loginPageData, as: UTF8.self)
                var doc = try? HTML(html: loginPageHTML, encoding: .utf8)
                // 獲取驗證碼並辨識
                let (vaildateCodeData, _) = try await URLSession.shared.data(for: vaildateCodeRequest)
                let validateCode = self.detactVaildateCode(data: vaildateCodeData)
                // 設定payload
                let __VIEWSTATE = doc!.xpath("//*[@id=\"__VIEWSTATE\"]")[0]["value"]!
                let __VIEWSTATEGENERATOR = doc!.xpath("//*[@id=\"__VIEWSTATEGENERATOR\"]")[0]["value"]!
                let __EVENTVALIDATION = doc!.xpath("//*[@id=\"__EVENTVALIDATION\"]")[0]["value"]!
                var urlParser = URLComponents()
                urlParser.queryItems = [
                    URLQueryItem(name: "__EVENTTARGET", value: ""),
                    URLQueryItem(name: "__EVENTARGUMENT", value: ""),
                    URLQueryItem(name: "__VIEWSTATE", value: __VIEWSTATE),
                    URLQueryItem(name: "__VIEWSTATEGENERATOR", value: __VIEWSTATEGENERATOR),
                    URLQueryItem(name: "__EVENTVALIDATION", value: __EVENTVALIDATION),
                    URLQueryItem(name: "txt_Account", value: account),
                    URLQueryItem(name: "txt_PWD", value: password),
                    URLQueryItem(name: "txt_validateCode", value: validateCode),
                    URLQueryItem(name: "ButLogin", value: "登入系統")
                ]
                let httpBodyString = urlParser.percentEncodedQuery!.urlEncoded()
                //傳送登入資訊
                var loginedRequest = URLRequest(url: loginURL)
                loginedRequest.httpMethod = "POST"
                loginedRequest.httpBody = httpBodyString.data(using: .ascii)
                loginedRequest.allHTTPHeaderFields = headers
                var (loginedData, _) = try await URLSession.shared.data(for: loginedRequest)
                var loginedHTML = String(decoding: loginedData, as: UTF8.self)
                if (loginedHTML.contains("您的密碼即將到期，建議儘快變更密碼。")) {
                    print("密碼即將到期")
                    let loginedURL = URL(string: "https://ccsys.niu.edu.tw/SSO/StdMain.aspx")!
                    (loginedData, _) = try await URLSession.shared.data(from: loginedURL)
                    loginedHTML = String(decoding: loginedData, as: UTF8.self)
                }
                if (loginedHTML.contains("請立即變更密碼!")) {
                    print("密碼已到期")
                    let loginedURL = URL(string: "https://ccsys.niu.edu.tw/SSO/StdMain.aspx")!
                    (loginedData, _) = try await URLSession.shared.data(from: loginedURL)
                    loginedHTML = String(decoding: loginedData, as: UTF8.self)
                }
                // 判斷登入狀態
                if loginedHTML.contains("目前錯誤累計已達") {
                    print("登入錯誤(密碼錯誤)")
                    error("密碼錯誤")
                } else if loginedHTML.contains("認證錯誤") {
                    print("登入錯誤(帳號錯誤)")
                    error("帳號錯誤")
                } else if loginedHTML.contains("驗證碼輸入錯誤") {
                    print("登入錯誤(驗證碼錯誤)")
                    if (time == 3) {
                        error("伺服器錯誤，請稍後再試")
                    }
                    self.login(
                        account: account,
                        password: password,
                        time: time+1,
                        success: success,
                        error: error
                    )
                } else if loginedHTML.contains("系所年級"){
                    print("登入成功")
                    // 取得使用者名稱
                    doc = try? HTML(html: loginedHTML, encoding: .utf8)
                    var username = doc!.xpath("//*[@id=\"Label1\"]")[0].text!
                    username = String(username.suffix(from: username.lastIndex(of: "：")!))
                    username = username.replacingOccurrences(of: "：", with: "")
                    success(username)
                } else {
                    error("伺服器錯誤，請稍後再試")
                }
                return
            } catch {
                
            }
            error("伺服器錯誤，請稍後再試")
        }
    }
    
    // MARK: detactVaildateCode
    func detactVaildateCode(data: Data) -> String {
        let xOffsets = [10, 35, 60, 85, 110, 135]
        let yOffset = 5
        let height = 30
        let width = 20
        
        var result = ""
        let image = UIImage(data: data)!
        let sourceCGImage = image.cgImage!
        for xOffset in xOffsets {
            do {
                let cropRect = CGRect(
                    x: xOffset,
                    y: yOffset,
                    width: width,
                    height: height
                ).integral
                let classifier = try ImageClassifier.classifier(options: options)
                let croppedCGImage = sourceCGImage.cropping(to: cropRect)!
                let croppedUIImage = UIImage.init(cgImage: croppedCGImage)
                let mlImage = MLImage(image: croppedUIImage)!
                let classificationResults = try classifier.classify(mlImage: mlImage)
                result += String(classificationResults.classifications[0].categories[0].index)
            } catch {
                print("ERROR")
            }
        }
        return result
    }
    
    // MARK: init
    init () {
        let account = userDefault.value(forKey: "account") ?? ""
        print("account: ", account)
        
        guard let modelPath = Bundle.main.path(
            forResource: "model-meta",
            ofType: "tflite"
        ) else {
            fatalError("Failed to load model")
        }
        options = ImageClassifierOptions(modelPath: modelPath)
    }
}
