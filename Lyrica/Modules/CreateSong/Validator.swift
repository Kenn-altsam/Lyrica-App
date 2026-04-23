

import Foundation
import UIKit

struct Validator {
    static func validate(title: String) -> String? {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        let isDigit = trimmedTitle.allSatisfy { ("0"..."9").contains($0) }
        
        if trimmedTitle.isEmpty {
            return "Title is required"
        }
        if isDigit {
            return "Title cannot contain only digits"
        }
        
        return nil
    }
    
    static func validate(lyrics: String) -> String? {
        let trimmed = lyrics.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return "Lyrics are required"
        }
        
        if trimmed.count < 20 {
            return "Lyrics must be at least 20 characters"
        }
        
        return nil
    }
    
    static func validate(priceText: String) -> String? {
        guard let price = Int(priceText), price > 0 else {
            return "Price must be a positive integer"
        }
        return nil
    }
}
