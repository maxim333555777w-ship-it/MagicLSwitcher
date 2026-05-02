import Foundation

final class LegacyLayoutSwitcher {
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
    
    func hasLatin(_ text: String) -> Bool {
        return text.range(of: "[a-zA-Z]", options: .regularExpression) != nil
    }
    func hasCyrillic(_ text: String) -> Bool {
        return text.range(of: "[а-яА-ЯёЁ]", options: .regularExpression) != nil
    }
    func russianScore(_ text: String) -> Int {
        let lower = text.lowercased()
        let russianVowels: Set<Character> = [
            "а", "е", "ё", "и", "о", "у", "ы", "э", "ю", "я"
        ]
        let commonRussianPairs = [
            "пр", "ст", "но", "ра", "по", "то", "ко", "ни", "ро", "на",
            "ло", "ре", "ли", "ка", "де", "го", "во", "не"
        ]
        var score = 0
        var vowelCount = 0
        var consonantStreak = 0
        var maxConsonantStreak = 0
        var previousChar: Character?
        var repeatCount = 1
        for char in lower {
            if russianVowels.contains(char) {
                vowelCount += 1
                consonantStreak = 0
                score += 2
            } else if char.isLetter {
                consonantStreak += 1
                maxConsonantStreak = max(maxConsonantStreak, consonantStreak)
                score += 1
            }
            if let previousChar, previousChar == char {
                repeatCount += 1
            } else {
                repeatCount = 1
            }
            if repeatCount >= 3 {
                score -= 3
            }
            previousChar = char
        }
        for pair in commonRussianPairs {
            if lower.contains(pair) {
                score += 2
            }
        }
        if vowelCount == 0 {
            score -= 4
        }
        if maxConsonantStreak >= 4 {
            score -= 4
        }
        return score
    }
    func englishScore(_ text: String) -> Int {
        let lower = text.lowercased()
        let englishVowels: Set<Character> = ["a", "e", "i", "o", "u", "y"]
        let commonEnglishPairs = [
            "th", "he", "in", "er", "an", "re", "on", "at", "en", "nd",
            "st", "ou", "ea", "ll", "ow", "ar", "hi", "ho"
        ]
        var score = 0
        var vowelCount = 0
        var consonantStreak = 0
        var maxConsonantStreak = 0
        var previousChar: Character?
        var repeatCount = 1
        for char in lower {
            if englishVowels.contains(char) {
                vowelCount += 1
                consonantStreak = 0
                score += 2
            } else if char.isLetter {
                consonantStreak += 1
                maxConsonantStreak = max(maxConsonantStreak, consonantStreak)
                score += 1
            }
            if let previousChar, previousChar == char {
                repeatCount += 1
            } else {
                repeatCount = 1
            }
            if repeatCount >= 3 {
                score -= 3
            }
            previousChar = char
        }
        for pair in commonEnglishPairs {
            if lower.contains(pair) {
                score += 2
            }
        }
        if vowelCount == 0 {
            score -= 4
        }
        if maxConsonantStreak >= 4 {
            score -= 4
        }
        return score
    }
    
    func shouldSwitchToRussian(from text: String) -> Bool {
        if text.count < 3 {
            return false
        }
        
        if hasCyrillic(text) || !hasLatin(text) {
            return false
        }
        let converted = convertToRussian(text).lowercased()
        let originalScore = russianScore(text)
        let convertedScore = russianScore(converted)
        return convertedScore - originalScore >= 3
       
    }
    func isWordCandidate(_ text: String) -> Bool {
        guard text.count >= 3 else { return false }
        for char in text {
            if !char.isLetter {
                return false
            }
        }
        return true
    }
    func shouldSwitchToEnglish(from text: String) -> Bool {
        if text.count < 3 {
            return false
        }
        if !hasCyrillic(text) || hasLatin(text) {
            return false
        }
        let converted = convertToEnglish(text).lowercased()
        let convertedScore = englishScore(converted)
        let originalScore = englishScore(text)
        return convertedScore - originalScore >= 3
       
    }
    func decision(for text: String, currentLayoutID: String?) -> SwitchDecision {
        guard isWordCandidate(text) else {
            return SwitchDecision(
                shouldSwitch: false,
                direction: nil,
                originalText: text,
                convertedText: nil
            )
        }
        guard let currentLayoutID = currentLayoutID else {
            return SwitchDecision(
                shouldSwitch: false,
                direction: nil,
                originalText: text,
                convertedText: nil
            )
        }
        if currentLayoutID == KeyboardLayout.english.rawValue {
            if shouldSwitchToRussian(from: text) {
                let converted = convertToRussian(text)
                return SwitchDecision(
                    shouldSwitch: true,
                    direction: .russian,
                    originalText: text,
                    convertedText: converted
                )
            }
        } else if currentLayoutID == KeyboardLayout.russian.rawValue {
            if shouldSwitchToEnglish(from: text) {
                let converted = convertToEnglish(text)
                return SwitchDecision(
                    shouldSwitch: true,
                    direction: .english,
                    originalText: text,
                    convertedText: converted
                )
            }
        }
        return SwitchDecision(
            shouldSwitch: false,
            direction: nil,
            originalText: text,
            convertedText: nil
        )
    }
}
