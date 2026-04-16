import ApplicationServices
import Carbon


private func callback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, userInfo: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    guard let userInfo = userInfo else {
        return Unmanaged.passUnretained(event)
                                        
    }
    let detector = Unmanaged<KeyboardDetector>
            .fromOpaque(userInfo)
            .takeUnretainedValue()
    let keyCode = Int(event.getIntegerValueField(.keyboardEventKeycode))
    switch keyCode {
    case kVK_Space:
        let text = detector.buffer.text
        if detector.layoutSwitcher.shouldSwitchToRussian(from: text) {
            let corrected = detector.layoutSwitcher.correctedRussianWord(from: text)
            detector.deleteLastWord(length: text.count)
            detector.insertText(corrected)
            print("corrected:", corrected)
            detector.inputSourceManager.switchToInputSource(with: "com.apple.keylayout.RussianWin")
        }
        detector.buffer.clear()
        
    case kVK_Return: detector.buffer.clear()
    case kVK_Delete: detector.buffer.removeLast()
    default:
        var buffer = [UniChar](repeating: 0, count: 4)
        var length: Int = 0
        event.keyboardGetUnicodeString(
            maxStringLength: buffer.count,
            actualStringLength: &length,
            unicodeString: &buffer
        )
        if length > 0 {
            let char = Character(UnicodeScalar(buffer[0])!)
            detector.buffer.add(char)
            // TODO: enable auto layout switching after improving logic
                // let text = detector.buffer.text
           // if detector.layoutSwitcher.shouldSwitchToRussian(from: text) {
              //  detector.inputSourceManager.switchToInputSource(with: "com.apple.keylayout.RussianWin")
           // }
        }
    }
        return Unmanaged.passUnretained(event)
}

final class KeyboardDetector {
    var eventTap: CFMachPort?
    var runLoopSource: CFRunLoopSource?
    var buffer = TextBuffer()
    let inputSourceManager = InputSourceManager()
    let layoutSwitcher = LayoutSwitcher()
    
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
