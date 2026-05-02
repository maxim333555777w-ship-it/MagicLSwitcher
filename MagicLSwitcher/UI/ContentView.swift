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
        .onAppear() {
         //   testGraph()
          //   testKeyboardLayoutBridge()
          //  printLayouts()
            // testAllLayout()
            //  testLayoutProjection()
            // testSwitchDecisionEngine()
            // testSwitchRuntime()
          //  testCurrentLayout()
          //  testSwitchLayout()
          //  testSwitchRuntimeApply()
        }
    }
    private func testSwitchRuntimeApply() {
        let runtime = SwitchRuntime()
        let frames = [
            KeyInputFrame(keyCode: 12),
            KeyInputFrame(keyCode: 0),
            KeyInputFrame(keyCode: 1),
            KeyInputFrame(keyCode: 13)
        ]
        for frame in frames {
            let decision = runtime.handleAndApply(frame: frame)
            print("Decision action:", decision.action)
            print("Decision target:", decision.targetLayoutID ?? "nil")
            print("Decision confidence:", decision.confidence)
            print("Decision reason:", decision.reason)
            print("-----")
        }
    }
    private func testSwitchLayout() {
        let okRU = KeyboardLayoutBridge.selectLayoutID("com.apple.keylayout.RussianWin")
        print("Switch RU ok:", okRU)
        let okABC = KeyboardLayoutBridge.selectLayoutID(
            "com.apple.keylayout.ABC"
        )
        print("Switch ABC ok:", okABC)
    }
    private func testCurrentLayout() {
        let current = KeyboardLayoutBridge.currentLayoutID()
        print("Current layout:", current ?? "nil")
    }
    private func testSwitchRuntime() {
        let runtime = SwitchRuntime()
        let frames = [
            KeyInputFrame(keyCode: 12),
            KeyInputFrame(keyCode: 0),
            KeyInputFrame(keyCode: 1),
            KeyInputFrame(keyCode: 13)
        ]
        for frame in frames {
            let decision = runtime.handle(frame: frame)
            
            print("Decision action:", decision.action)
            print("Decision target:", decision.targetLayoutID ?? "nil")
            print("Decision confidence:", decision.confidence)
            print("-----")
        }
    }
    private func testSwitchDecisionEngine() {
    let frames = [KeyInputFrame(keyCode: 12), KeyInputFrame(keyCode: 0), KeyInputFrame(keyCode: 1), KeyInputFrame(keyCode: 13)]
    let abcProjection = LayoutProjection.build(layoutID: "com.apple.keylayout.ABC", frames: frames)
    let ruProjection = LayoutProjection.build(layoutID: "com.apple.keylayout.RussianWin", frames: frames)
    let engine = SwitchDecisionEngine()
    let decision = engine.decide(projection: [abcProjection, ruProjection])
    print("ABC projection:", abcProjection.text)
    print("RU projection:", ruProjection.text)
    print("Decision action:", decision.action)
    print("Decision target:", decision.targetLayoutID ?? "nil")
    print("Decision confidence:", decision.confidence)
    print("Decision reason:", decision.reason)
}
    private func testLayoutProjection() {
        let frames = [KeyInputFrame(keyCode: 12), KeyInputFrame(keyCode: 0), KeyInputFrame(keyCode: 1)]
        let abcProjection = LayoutProjection.build(layoutID: "com.apple.keylayout.ABC", frames: frames)
        let ruProjection = LayoutProjection.build(layoutID: "com.apple.keylayout.RussianWin", frames: frames)
        print("ABC projection:", abcProjection.text)
        print("RU projection:", ruProjection.text)
    }
    private func testAllLayout() {
        let layouts = KeyboardLayoutBridge.availableLAyoutIDs()
        
        for layoutID in layouts {
            let char = KeyboardLayoutBridge.translateKeyCode(12, modifiers: 0, layoutID: layoutID)
            print(layoutID, "=>", char ?? "nil")
        }
    }
    private func printLayouts() {
        let layouts = KeyboardLayoutBridge.availableLAyoutIDs()
        
        for layout in layouts {
            print("layout:", layout)
        }
    }
    private func testKeyboardLayoutBridge() {
        let abc = KeyboardLayoutBridge.translateKeyCode(
            12,
            modifiers: 0,
            layoutID: "com.apple.keylayout.ABC"
        )
        
        let ru = KeyboardLayoutBridge.translateKeyCode(
            12,
            modifiers: 0,
            layoutID: "com.apple.keylayout.RussionWin"
        )
        print("ABC:", abc ?? "nil")
        print("RussianWin:", ru ?? "nil")
    }
 //   private func testGraph() {
      //  let scorer = GraphScorer()
      //  let graph = InputHypothesisGraph()
        
     //   let nodeEN = GraphNode(
       //     layoutID: "EN",
      //      text: "ghbdtn",
     //       position: 6,
     //       score: scorer.score(text: "ghbdtn"),
       //     parentID: nil
      //  )
     //   let nodeRU = GraphNode(
      //      layoutID: "RU",
      //      text: "привет",
      //      position: 6,
        //    score: scorer.score(text: "привет"),
        //    parentID: nil
       // )
     //   graph.addNode(nodeEN)
     //   graph.addNode(nodeRU)
        
      //  print("EN score:", nodeEN.score)
      //  print("RU score:", nodeRU.score)
        
     //   if let best = graph.bestNode() {
      //      print("Best node layout:", best.layoutID)
      //      print("Best node text:", best.text)
       //     print("Best node score:", best.score)
    //    } else {
     //       print("No best node found")
     //   }
    //}
}

#Preview {
    ContentView()
}



