//
//  WatchPickerView.swift
//  Watchoutout Watch App
//
//  Created by 나현흠 on 7/16/25.
//

import SwiftUI

struct WatchPickerView: View {
    @State private var selectedNumber: Int = 0
    let numbers = Array(0...100)
    
    var body: some View {
        HStack{
            Button(action: {
                // 액션
            }) {
                Image(systemName: "info")
            }
            .frame(width: 34, height: 34)
            .clipShape(Circle())
            Spacer()
        }
        
        Text("사이클")
            .bold(true)
        Picker("숫자 선택", selection: $selectedNumber) {
            ForEach(numbers, id: \.self) { number in
                Text("\(number)")
                    .font(.system(size: 30))
                    .tag(number)
                    .bold()
            }
        }
        .frame(width: 85, height: 85)
        .background(Color.black.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 13))
        .overlay(
            RoundedRectangle(cornerRadius: 13)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(hex: "FB578B"), location: 0.0),
                            .init(color: Color(hex: "FB578B"), location: 0.3), // 첫 번째 색상을 70%까지 유지
                            .init(color: Color(hex: "1BF8FF"), location: 1.0)
                        ]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    ),
                    lineWidth: 2
                )
                .frame(width:84, height:84)
            
            //Color(hex: "FB578B"), Color(hex: "1BF8FF")
        )
        .labelsHidden()
        .pickerStyle(.wheel)
        Button("시작"){
            
        }
        .frame(width: 164, height: 51)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // "#" 기호 제거
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    WatchPickerView()
}
