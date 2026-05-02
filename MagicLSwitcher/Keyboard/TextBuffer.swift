import Foundation


final class TextBuffer {
   private(set) var text: String = ""
    var isEmpty: Bool {
        text.isEmpty
    }
    var count: Int {
        text.count
    }
    
    func add(_ char: Character) {
        text.append(char)
    }
    func clear() {
        text = ""
    }
    func removeLast() {
        guard !text.isEmpty else { return }
            text.removeLast()
        }
    }
    

