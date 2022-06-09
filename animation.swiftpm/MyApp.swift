import SwiftUI

@main
struct MyApp: App {
    @StateObject var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                ContentView().id(appState.id)
            } else {
                Text("iOS 16 required")
            }
        }
    }
}

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var id = UUID()
}
