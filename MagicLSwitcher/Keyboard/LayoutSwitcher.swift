import Foundation

final class LayoutSwitcher {
    private let enToRu: [Character: Character] = [
        "q": "й", "w": "ц", "e": "у", "r": "к", "t": "е",
        "y": "н", "u": "г", "i": "ш", "o": "щ", "p": "з",
        "[": "х", "]": "ъ",
        
        "a": "ф", "s": "ы", "d": "в", "f": "а", "g": "п",
        "h": "р", "j": "о", "k": "л", "l": "д", ";": "ж",
        "'": "э",
        
        "z": "я", "x": "ч", "c": "с", "v": "м", "b": "и",
        "n": "т", "m": "ь", ",": "б", ".": "ю"
    ]
    private let ruToEn: [Character: Character] = [
        "й": "q", "ц": "w", "у": "e", "к": "r", "е": "t",
        "н": "y", "г": "u", "ш": "i", "щ": "o", "з": "p",
        "х": "[", "ъ": "]",
        
        "ф": "a", "ы": "s", "в": "d", "а": "f", "п": "g",
        "р": "h", "о": "j", "л": "k", "д": "l", "ж": ";",
        "э": "'",
        
        "я": "z", "ч": "x", "с": "c", "м": "v", "и": "b",
        "т": "n", "ь": "m", "б": ",", "ю": "."
    ]
    private let commonRussianWords: Set<String> = [
        "привет", "как", "дела", "пока", "спасибо", "хорошо", "да", "нет", "что", "это", "приветик"
    ]
    private let commonEnglishWords: Set<String> = [
        "hello", "hi", "how", "are", "you", "thanks", "thank",
        "good", "bad", "yes", "no", "what", "this", "that",
        "test", "word", "english", "swift", "keyboard"
    ]
    func convertToRussian(_ text: String) -> String {
        var result = ""
        for char in text {
            if let mapped = enToRu[char] {
                result.append(mapped)
            } else {
                result.append(char)
            }
        }
        return result
    }
    func convertToEnglish(_ text: String) -> String {
        var result = ""
        for char in text {
            if let mapped = ruToEn[char] {
                result.append(mapped)
            } else {
                result.append(char)
            }
        }
        return result
    }
    func shouldSwitchToRussian(from text: String) -> Bool {
        if text.count < 3 {
            return false
        }
        if !hasLatin(text) {
            return false
        }
        if hasCyrillic(text) {
            return false
        }
        let converted = convertToRussian(text).lowercased()
        return commonRussianWords.contains { $0.hasPrefix(converted) }
    }
    func shouldSwitchToEnglish(from text: String) -> Bool {
        if text.count < 3 {
            return false
        }
        if !hasCyrillic(text) {
            return false
        }
        let converted = convertToEnglish(text).lowercased()
        return commonEnglishWords.contains { $0.hasPrefix(converted) }
    }
    func hasLatin(_ text: String) -> Bool {
        return text.range(of: "[a-zA-Z]", options: .regularExpression) != nil
    }
    func hasCyrillic(_ text: String) -> Bool {
        return text.range(of: "[а-яА-ЯёЁ]", options: .regularExpression) != nil
    }
    func correctedRussianWord(from text: String) -> String {
        return convertToRussian(text)
    }
}
