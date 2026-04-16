import Foundation


final class TextBuffer {
    var text: String = ""
    func add(_ char: Character) {
        text.append(char)
    }
    func clear() {
        text = ""
    }
    func removeLast() {
        if !text.isEmpty {
            text.removeLast()
        }
    }
    
}
