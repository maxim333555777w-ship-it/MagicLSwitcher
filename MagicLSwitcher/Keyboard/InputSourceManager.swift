import Foundation
import Carbon


final class InputSourceManager {
    func currentInputLayoutID() -> String? {
        let currentSource = TISCopyCurrentKeyboardInputSource()
        guard let currentSource = currentSource else { return nil }
        let inputSource = currentSource.takeUnretainedValue()
        let id = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID)
        guard let id = id else { return nil }
        let layoutID = Unmanaged<CFString>
            .fromOpaque(id)
            .takeUnretainedValue() as String
        return layoutID
    }
    func inputSource(for id: String) -> TISInputSource? {
        let source = TISCreateInputSourceList(nil, false)
        guard let source = source else { return nil }
        let inputSource = source.takeUnretainedValue() as NSArray
        for source in inputSource {
            let inputSource = source as! TISInputSource
            let sourceID = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID)
            guard let sourceID = sourceID else { continue }
            let layoutID = Unmanaged<CFString>
                .fromOpaque(sourceID)
                .takeUnretainedValue() as String
            if layoutID == id {
                return inputSource
            }
        }
        return nil
    }
    func switchToInputSource(with id: String) {
        guard let source = inputSource(for: id) else { return }
        TISSelectInputSource(source)
    }
    
}
