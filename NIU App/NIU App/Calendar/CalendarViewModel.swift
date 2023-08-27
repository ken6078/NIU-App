//
//  CalendarViewModel.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/8/27.
//

import Foundation

class CalendarViewModel {
    func pdfFileAlreadySaved(url:String, fileName:String)-> Bool {
        var status = false
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("NIUAPP-\(fileName).pdf") {
                        status = true
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
        return status
    }
    
    func showSavedPdf(url:String, fileName:String, show: @escaping (URL) -> ()) {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName).pdf") {
                        // its your file! do what you want with it!
                        show(url)
                    }
                }
            }
            catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
    }

    func savePdf(urlString:String, fileName:String, success: @escaping () -> ()) {
        Task {
            let url = URL(string: urlString)
//            let pdfData = try? Data.init(contentsOf: url!)
            let (pdfData, _) = try await URLSession.shared.data(from: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "NIUAPP-\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
                success()
            } catch {
                print("Pdf could not be saved")
            }
        }
    }

}
