//
//  ContentView.swift
//  WatchApp Watch App
//
//  Created by ukseung.dev on 3/18/25.
//

import SwiftUI
import WatchConnectivity

class WatchDataManager: NSObject, WCSessionDelegate, ObservableObject {
    @Published var count: Int = 0
    @Published var text: String = ""
    var session: WCSession
    
    override init() {
        self.session = WCSession.default
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sendCount() {
        let message = ["count": count]
        session.sendMessage(message, replyHandler: nil) { error in
            print("Error sending message: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let receivedCount = message["count"] as? Int {
                self.count = receivedCount
            }
        }
    }
    
    // 다른 기기의 세션으로부터 transferUserInfo() 메서드로 데이터를 받았을 때 호출되는 메서드
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            self.text = userInfo["text"] as? String ?? "nil"
        }
    }
}

struct ContentView: View {
    @ObservedObject var manager: WatchDataManager = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(manager.count)")
            Button("increase Count") {
                manager.count += 1
                manager.sendCount()
            }
            
            Text("\(manager.text)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
