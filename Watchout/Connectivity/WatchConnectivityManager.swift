//
//  WatchConnectivityManager.swift
//  PracticeCoreMotion
//
//  Created by 이현주 on 7/13/25.
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchConnectivityManager()
    static let startBlinkingNotification = Notification.Name("StartBlinking")

    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("iOS WCSession activated: \(activationState)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("iOS received message: \(message)")
        if let ts = message["startTime"] as? TimeInterval {
            NotificationCenter.default.post(name: Self.startBlinkingNotification, object: Date(timeIntervalSince1970: ts))
        }
    }
}
