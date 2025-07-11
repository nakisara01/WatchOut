//
//  MotionView.swift
//  Watchoutout Watch App
//
//  Created by 나현흠 on 7/9/25.
//

import SwiftUI
import CoreMotion

struct MotionView: View {
    @State private var rotationRate: CMRotationRate = .init()
    @State private var offset: CGSize = .zero
    @State private var isStarted: Bool = false
    @State private var shakeCount = 0
    @State private var isShaking = false
    @State private var acceleration: CMAcceleration = .init(x: 0, y: 0, z: 0)
    private let motionManager = CMMotionManager()
    
    var body: some View {
        VStack {
            Text("Shake Count: \(shakeCount)")
                .padding()
            Text("x: \(acceleration.x, specifier: "%.2f")")
            Text("y: \(acceleration.y, specifier: "%.2f")")
            Text("z: \(acceleration.z, specifier: "%.2f")")
            VStack{
                Button(isShaking ? "멈추기" : "측정 시작") {
                    if isShaking {
                        motionManager.stopAccelerometerUpdates()
                    } else{
                        startDetectingShakes()
                    }
                    isShaking.toggle()
                }
                Button("횟수 초기화"){
                    shakeCount = 0
                }
            }
        }
    }
    private func startDetectingShakes() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let acceleration = data?.acceleration else { return }
            
            self.acceleration = acceleration
            
            let threshold = 1.5
            let magnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
            print(magnitude)
            
            if magnitude > threshold {
                shakeCount += 1
            }
        }
    }
}

#Preview {
    MotionView()
}
