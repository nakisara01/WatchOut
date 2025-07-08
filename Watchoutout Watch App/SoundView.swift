//
//  SoundView.swift
//  Watchoutout Watch App
//
//  Created by 나현흠 on 7/8/25.
//

import SwiftUI
import WatchKit
import AVFoundation

struct SoundView: View {
    @State private var mp3Name: String = "KoreanCountingOnetoTen"
    @StateObject private var soundManager = SoundManager()
    @State private var currentNumber = 1
    @State private var timer: Timer?
    @Binding var bpm: Int
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Text("BPM: \(bpm)")
                    Button ("STOP") {
                        soundManager.stop()
                        currentNumber = 1
                    }
                }
                List{
                    Button("영어 카운팅 재생") {
                        soundManager.play(mp3Name: "EnglishCounting")
                    }
                    Button("한국어 카운팅 재생") {
                        soundManager.play(mp3Name: "korean counting")
                    }
                    Button("한국어 1-10 카운팅 재생") {
                        soundManager.play(mp3Name: "KoreanCountingOnetoTen")
                    }
                }
                .listStyle(CarouselListStyle())
            }
            if soundManager.showSuccessScreen {
                Color.green
                    .ignoresSafeArea()
                    .overlay(
                        Text("\(soundManager.playCount)")
                            .font(.system(size: 180))
                            .foregroundColor(.white)
                    )
                    .transition(.opacity)
            }
        }
    }
}

class SoundManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var player: AVAudioPlayer?
    private var lastPlayedMp3Name: String?
    @Published var showSuccessScreen = false
    @Published var playCount = 0

    func play(mp3Name: String) {
        lastPlayedMp3Name = mp3Name
        guard let url = Bundle.main.url(forResource: mp3Name, withExtension: "mp3") else {
            print("파일 없음: \(mp3Name).mp3")
            return
        }
        print("파일 경로: \(url.path)")

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.play()
        } catch {
            print("재생 오류: \(error)")
        }
    }
    func stop() {
        player?.stop()
        print("재생 중지")
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playCount += 1
        showSuccessScreen = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showSuccessScreen = false
            if let mp3Name = self.lastPlayedMp3Name {
                self.play(mp3Name: mp3Name)
            }
        }
    }
}

#Preview {
    SoundView(bpm: .constant(120))
}
