import ApplicationServices
import Carbon


private func callback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    guard let userInfo = userInfo else {
        return Unmanaged.passUnretained(event)
        
    }
    guard  type == .keyDown else {
        return Unmanaged.passUnretained(event)
    }
    let detector = Unmanaged<KeyboardDetector>
        .fromOpaque(userInfo)
        .takeUnretainedValue()
    
    let keyCode = Int(event.getIntegerValueField(.keyboardEventKeycode))
    let frame = KeyInputFrame(
        keyCode: UInt16(keyCode),
        timeStamp: Date().timeIntervalSince1970,
        modifiers: [],
        eventType: .keyDown
    )
    let decision = detector.runtime.handleAndApply(frame: frame)
    print("Live decision:", decision.action)
    print("Live target:", decision.targetLayoutID ?? "nil")
    print("Live confidence:", decision.confidence)
    print("Live reason:", decision.reason)
    print("-----")
    
    
    
   //    switch keyCode {
    //case kVK_Space:
  //  detector.clearBuffer()
    
    //case kVK_Return:
   // detector.clearBuffer()
    //case kVK_Delete:
   // detector.removeLastFromBuffer()
    //default:
    //  var buffer = [UniChar](repeating: 0, count: 4)
    //  var length: Int = 0
    //   event.keyboardGetUnicodeString(
    //      maxStringLength: buffer.count,
    //      actualStringLength: &length,
    //      unicodeString: &buffer
    //  )
    //  if length > 0 {
    //     let char = Character(UnicodeScalar(buffer[0])!)
    //     detector.addToBuffer(char)
    //  }
    //  let text = detector.getBufferText()
    //  if text.count >= 3 {
    //    let currentLayoutID = detector.inputSourceManager.currentInputLayoutID()
    //   let decision = detector.layoutSwitcher.decision(for: text, currentLayoutID: currentLayoutID)
    //   if decision.shouldSwitch {
    //       if decision.direction == .english {
    //           detector.inputSourceManager.switchToInputSource(with: "com.apple.keylaout.ABC")
    //      } else if decision.direction == .russian {
    //         detector.inputSourceManager.switchToInputSource(with: "com.apple.keylayout.RussianWin")
    //     }
    //     detector.clearBuffer()
    // }
    // }
   // }
       return Unmanaged.passUnretained(event)
    }
    
    final class KeyboardDetector {
        var eventTap: CFMachPort?
        var runLoopSource: CFRunLoopSource?
        private var buffer = TextBuffer()
      //  let inputSourceManager = InputSourceManager()
   //     let layoutSwitcher = LayoutSwitcher()
        let runtime = SwitchRuntime()
        // MARK: - Buffer private let inputSourceManager = InputSourceManager()
        // MARK: - Run Loop private let layoutSwitcher = LayoutSwitcher()
        func clearBuffer() {
            buffer.clear()
        }
        func removeLastFromBuffer() {
            buffer.removeLast()
        }
        func addToBuffer(_ char: Character) {
            buffer.add(char)
        }
        func getBufferText() -> String {
            buffer.text
        }
        
        func start() {
            let eventsOfInterest = CGEventMask(1 << CGEventType.keyDown.rawValue)
            let tap = CGEvent.tapCreate(
                tap: .cghidEventTap,
                place: .headInsertEventTap,
                options: .defaultTap,
                eventsOfInterest: eventsOfInterest,
                callback: callback,
                userInfo: Unmanaged.passUnretained(self).toOpaque()
            )
            guard let tap = tap else { return }
            eventTap = tap
            let source = CFMachPortCreateRunLoopSource(
                kCFAllocatorDefault,
                tap,
                0
            )
            guard let source = source else { return }
            runLoopSource = source
            CFRunLoopAddSource(
                CFRunLoopGetCurrent(),
                source,
                CFRunLoopMode.commonModes
            )
            CGEvent.tapEnable(tap: tap, enable: true)
        }
    }

