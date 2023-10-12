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
    
    let connect = URL(string: "https://files01.allegiance-it.com/app?operation=ws&u= &p=")!
    var login = URLRequest(url: connect)
    
    let task = URLSession.shared.dataTask(with: login) { data, response, error in
        if let error = error {
            print ("error: \(error)")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
            print("server error")
            return
        }
        
        let data = data!
        let string = String(data: data, encoding: .utf8)!
        if string.contains("<response code=\"3\">") {
            print("success")
        }
    }
    task.resume()
}
