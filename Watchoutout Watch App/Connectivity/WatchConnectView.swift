//
//  ContentView.swift
//  WatchPracticeCoreMotion Watch App
//
//  Created by 이현주 on 7/11/25.
//

import SwiftUI
import CoreMotion
import Combine

enum WatchViewState { case start, countdown, measurement }

struct WatchConnectView: View {
    @State private var viewState: WatchViewState = .start
    @State private var startTime: Date?
    @State private var countdownDone = false
    @State private var isGreen = false
    @State private var blinkTimer: Timer?

    @State private var roll = 0.0
    @State private var pitch = 0.0
    @State private var yaw = 0.0
    let motionManager = CMMotionManager()
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        ZStack {
            (isGreen ? Color.green : Color.black)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.1), value: isGreen)

            switch viewState {
            case .start:
                Button("Start") {
                    let sharedStart = Date().addingTimeInterval(3)
                    startTime = sharedStart
                    countdownDone = false
                    viewState = .countdown
                    WatchConnectivityManager.shared.sendStartTime(sharedStart)
                }
                .foregroundColor(.green)

            case .countdown:
                if let start = startTime {
                    CountdownView(startTime: start, isCountdownDone: $countdownDone)
                }

            case .measurement:
                VStack {
                    Text("좌우 회전: \(roll)")
                    Text("앞뒤 기울기: \(pitch)")
                    Text("방향: \(yaw)")
                }
            }
        }
        .onAppear {
            let manager = WatchConnectivityManager.shared
            manager.$isReady
                .receive(on: DispatchQueue.main)
                .sink { ready in
                    if ready { print("Watch session ready") }
                }
                .store(in: &cancellables)
        }
        .onChange(of: countdownDone) { done in
            if done {
                viewState = .measurement
                if let start = startTime {
                    startBlinking(from: start)
                    startMotion()
                }
            }
        }
    }

    func startBlinking(from startTime: Date) {
        let delay = startTime.timeIntervalSinceNow
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            blinkTimer = Timer.scheduledTimer(withTimeInterval: 60.0 / 110.0, repeats: true) { _ in
                isGreen.toggle()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                isGreen = false
                stopAll()
            }
        }
    }

    func startMotion() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { data, _ in
            if let att = data?.attitude {
                roll = att.roll; pitch = att.pitch; yaw = att.yaw
                print("좌우 회전: \(roll)")
                print("앞뒤 기울기: \(pitch)")
                print("방향: \(yaw)")
            }
        }
    }

    func stopAll() {
        blinkTimer?.invalidate()
        motionManager.stopDeviceMotionUpdates()
        viewState = .start
    }
}


