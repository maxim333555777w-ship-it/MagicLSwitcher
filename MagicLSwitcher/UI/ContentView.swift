import SwiftUI
import AppKit

private let detector = KeyboardDetector()
struct ContentView: View {
    @State private var isEnabled: Bool = false
    var body: some View {

        VStack {
            if isEnabled {
                Text("Access granted")
                Button("Open settings") {
                    let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")
                    if let url = url {
                        NSWorkspace.shared.open(url)
                    }
                }
            } else {
                Text("Access required")
                Button("Enable") {
                    _ = AccessibilityPermission.request()
                    isEnabled = AccessibilityPermission.isEnabled()
                    if isEnabled {
                        detector.start()
                    }
                
                }
            }
               
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
