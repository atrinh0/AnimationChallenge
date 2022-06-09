import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    private let model = SymbolModel()

    @State private var scale = 5.0
    @State private var focusImage = "italic"
    @State private var opacity = 1.0

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let resetTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        Grid {
            ForEach(0..<11) { row in
                GridRow {
                    ForEach(0..<21) { column in
                        if row == 5 && column == 10 {
                            Image(systemName: focusImage)
                                .renderingMode(.original)
                                .imageScale(.large)
                                .frame(width: 40, height: 40)
                        } else {
                            randomAnimatedImage
                                .opacity(opacity)
                        }
                    }
                }
                .offset(x: (row % 2 == 0) ? 20 : 0)
            }
        }
        .scaleEffect(scale, anchor: .center)
        .onAppear {
            withAnimation(.easeInOut(duration: 3)) {
                scale = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                opacity = 0
            }
        }
        .onReceive(timer) { _ in
            if focusImage == "italic" {
                focusImage = "heart.fill"
            } else if focusImage == "heart.fill" {
                focusImage = "swift"
                self.timer.upstream.connect().cancel()
            }
        }
        .onReceive(resetTimer) { _ in
            focusImage = "italic"
            withAnimation(.easeInOut(duration: 0.5)) {
                scale = 5.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                AppState.shared.id = UUID()
            }
        }
    }

    private var randomAnimatedImage: AnimatedImage {
        AnimatedImage(symbols: (0...10).map { _ in randomSymbol })
    }

    private var randomSymbol: String {
        model.symbols.randomElement()?.name ?? "leaf"
    }
}

struct AnimatedImage: View {
    let symbols: [String]

    private let showTimer = Timer.publish(every: Double(Int.random(in: 5...10))/10.0, on: .main, in: .common).autoconnect()

    @State private var displayedSymbol = "leaf"
    @State private var opacity = 0.0
    @State private var scale = 3.0
    @State private var blur = 4.0

    var body: some View {
        TimelineView(.periodic(from: .now, by: Double(Int.random(in: 5...10))/20.0)) { _ in
            Image(systemName: symbols.randomElement() ?? "leaf")
                .renderingMode(.original)
                .imageScale(.large)
        }
        .frame(width: 40, height: 40)
        .opacity(opacity)
        .scaleEffect(scale, anchor: .center)
        .blur(radius: blur)
        .onReceive(showTimer) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                opacity = 1
                scale = 1
                blur = 0
            }
            self.showTimer.upstream.connect().cancel()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                opacity = 0
                scale = 0.1
            }
        }
    }
}
