//
//  ContentView.swift
//  Watchout
//
//  Created by 나현흠 on 7/3/25.
//

import SwiftUI
import CoreMotion

struct MotionView: View {
    @State private var compressionTimestamps: [TimeInterval] = []
    @State private var lastTriggerTime: TimeInterval = 0
    @State private var rotationRate: CMRotationRate = .init()
    @State private var offset: CGSize = .zero
    @State private var isStarted: Bool = false
    @State private var shakeCount = 0
    @State private var isShaking = false
    @State private var acceleration: CMAcceleration = .init(x: 0, y: 0, z: 0)
    @State private var logs: [String] = []
    private let motionManager = CMMotionManager()
    
    var body: some View {
        VStack {
            Text("Shake Count: \(shakeCount)")
            Text("BPM: \(calculateBPM(), specifier: "%.1f")")
                .foregroundStyle(.blue)
            Text("리듬 일관성: ±\(calculateRhythm(), specifier: "%.3f")초")
                .foregroundStyle(.green)
                .padding()
            Text("x: \(acceleration.x, specifier: "%.2f")")
            Text("y: \(acceleration.y, specifier: "%.2f")")
            Text("z: \(acceleration.z, specifier: "%.2f")")
            VStack{
                Button(isShaking ? "멈추기" : "측정 시작") {
                    if isShaking {
                        motionManager.stopAccelerometerUpdates()
                    } else{
                        print("측정 시작")
                        startDetectingShakes()
                        
                    }
                    isShaking.toggle()
                }
                Button("횟수 초기화"){
                    shakeCount = 0
                }
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(logs.reversed(), id: \.self) { log in
                            Text(log)
                                .font(.system(size: 12))
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .frame(height: 150)
            }
        }
    }
    private func startDetectingShakes() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let acceleration = data?.acceleration else { return }
            
            self.acceleration = acceleration
            
            let thresholdZ = -1.2
            let now = Date().timeIntervalSince1970
            let minInterval = 0.35
            print("Z값: \(acceleration.z), 시간차: \(now - lastTriggerTime)")
            let logEntry = String(format: "Z값: %.3f, 시간차: %.3f", acceleration.z, now - lastTriggerTime)
            logs.append(logEntry)

            // 최대 50개까지만 유지
            if logs.count > 50 {
                logs.removeFirst()
            }

            if acceleration.z < thresholdZ && now - lastTriggerTime > minInterval {
                compressionTimestamps.append(now)
                shakeCount = compressionTimestamps.count
                lastTriggerTime = now
            }
        }
    }
    func calculateBPM() -> Double {
        
//        guard compressionTimestamps.count > 1 else { return 0 }
//
//                let intervals = zip(compressionTimestamps.dropFirst(), compressionTimestamps).map(-)
//                let avgInterval = intervals.reduce(0, +) / Double(intervals.count)
//                    return 60.0 / avgInterval
        //아래의 코드를 4줄만에 짜는 법 (by gpt)
        
        guard compressionTimestamps.count > 1 else { return 0 }

        var intervals: [Double] = []

        // 압박 시각들 사이의 차이를 계산해서 intervals 배열에 저장
        for i in 1..<compressionTimestamps.count {
            let previous = compressionTimestamps[i - 1]
            let current = compressionTimestamps[i]
            let interval = current - previous
            intervals.append(interval)
        }

        // 간격 평균 구하기
        var sum: Double = 0
        for interval in intervals {
            sum += interval
        }
        let averageInterval = sum / Double(intervals.count)

        // BPM 계산 (60초 ÷ 평균 간격)
        let bpm = 60.0 / averageInterval
        return bpm
    }
    
    func calculateRhythm() -> Double {
        guard compressionTimestamps.count > 1 else { return 0 }
        
        var intervals: [Double] = []
        
        for i in 1..<compressionTimestamps.count {
            let current = compressionTimestamps[i]
            let previous = compressionTimestamps[i - 1]
            let interval = current - previous
            intervals.append(interval)
        }
        
        var sum: Double = 0
        for interval in intervals {
            sum += interval
        }
        let mean = sum / Double(intervals.count)
        
        var squaredDifferences: [Double] = []
        
        for interval in intervals {
            let diff = interval - mean
            squaredDifferences.append(diff*diff)
        }
        
        var squaredSum: Double = 0
        for val in squaredDifferences {
            squaredSum += val
        }
        
        let variance = squaredSum / Double(squaredDifferences.count)
        let standardDeviation = sqrt(variance)
        
        return standardDeviation
        
    }
}

#Preview {
    MotionView()
}
