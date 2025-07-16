//
//  WatchConnectivityManager.swift
//  WatchPracticeCoreMotion Watch App
//
//  Created by 이현주 on 7/13/25.
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchConnectivityManager()
    @Published var isReady = false

    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("watchOS WCSession activated: \(activationState)")
        if activationState == .activated {
            DispatchQueue.main.async { self.isReady = true }
        }
    }

    func sendStartTime(_ startTime: Date) {
        let session = WCSession.default
        guard session.activationState == .activated && session.isReachable else {
            print("Watch session not ready (state: \(session.activationState), reachable: \(session.isReachable))")
            return
        }
        let message = ["startTime": startTime.timeIntervalSince1970]
        session.sendMessage(message, replyHandler: nil) { error in
            print("Watch send error: \(error.localizedDescription)")
        }
    }
}
