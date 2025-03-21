//
//  ContentView.swift
//  iOS-WatchOS-ShareData
//
//  Created by ukseung.dev on 3/18/25.
//

import SwiftUI
import WatchConnectivity

class iOSDataManager: NSObject, WCSessionDelegate, ObservableObject {
    @Published var count: Int = 0
    @Published var text: String = ""
    var session: WCSession
    
    override init() {
        self.session = WCSession.default
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func sendCount() {
        let message = ["count": count]
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
    func sendTransfer() {
        session.transferUserInfo(["text": text])
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let receivedCount = message["count"] as? Int {
                self.count = receivedCount
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var manager: iOSDataManager = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(manager.count)")
            Button("increase Count(sendMessage)") {
                manager.count += 1
                manager.sendCount()
            }
            
            Spacer()
                .frame(height: 80)
            
            TextField("Enter Name", text: $manager.text)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
            
            Button("transferUserInfo") {
                manager.sendTransfer()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
