//
//  ComposeSessionViewController.swift
//  shareFileExtend
//
//  Created by Administrator on 6/7/23.
//

import MailKit
import SwiftUI
import Foundation

class ComposeSessionViewController: MEExtensionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view = NSHostingView(rootView: MailPopoverView())
    }

}

struct MailPopoverView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Upload File and Send a Download Link")
                .padding(.all)
        }
        
        Button("Choose File") {
            let openPanel = NSOpenPanel()
            openPanel.message = "Select a file:"

            openPanel.canChooseDirectories = false
            openPanel.allowsMultipleSelection = false

            openPanel.begin { response in
                if response == .OK {
                    let filePath = (openPanel.url)!
                    
                    let link = "stuff"
                    uploadFile(filePath: filePath)
                    
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(link, forType: .string)
                    
                }
            }
        }
        .padding(.all)
        .buttonStyle(.borderedProminent)
    }
}

struct Endpoints {
    var serverLocation: String
    var username: String
    var secret: String
}

struct FilmSummary : Codable {
    var name: String
}

struct MountingPoints : Codable {
    let allowWrite: String
    let allowRead: String
    let content: String
}

func uploadFile(filePath: URL) -> Void {
    
    let connect = URL(string: "https://files01.allegiance-it.com/app?operation=ws&u=support@allegiance-it.com&p=MakeItS0&s=3&rt=json")!
    var login = URLRequest(url: connect)
    
    let task = URLSession.shared.dataTask(with: login) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse,
            response.statusCode == 3 else {
            print ("server error")
            return
        }
        if let mimeType = response.mimeType,
            mimeType == "application/json",
            let data = data,
            let dataString = String(data: data, encoding: .utf8) {
            print ("got data: \(dataString)")
            
            let mounts = try! JSONDecoder().decode(MountingPoints.self, from: data)
            print (mounts.content)
        }
    }
    task.resume()
    
    /*
    do {
        let uploadData = try Data(contentsOf: filePath)
        
        let url = URL(string: "https://files01.allegiance-it.com/app?operation=ws&s=11&fn=Folder+1$test.txt")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }
        task.resume()
    } catch {
        return
    }
     */
    
    /*
    let url = URL(string: "https://swapi.dev/api/people/1")!
    var link = ""
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            return
        }
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
            return
        }
        if let mimeType = httpResponse.mimeType, mimeType == "text/html",
            let data = data,
            let string = String(data: data, encoding: .utf8) {
                link = string
            }
    }
    task.resume()
    
    return link
     */
}

//https://files01.allegiance-it.com/app?operation=ws&u=support@allegiance-it.com&p=MakeItS0&src=ip&s=3

//https://files01.allegiance-it.com/app?operation=ws&s=10&mp=Folder+1$&fp=/c://Users/admin/Desktop/test.txt&isupload=true

