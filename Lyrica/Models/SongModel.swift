
import Foundation
import FirebaseFirestore

struct SongModel {
    let id: String
    let title: String
    let genre: String
    let lyricsPreview: String
    let price: Int
    let createdAt: Date
    let authorUID: String
    let authorName: String
    
    var dictionary: [String: Any] {
        [
            "id": id,
            "title": title,
            "genre": genre,
            "lyricsPreview": lyricsPreview,
            "price": price,
            "createdAt": createdAt,
            "authorUID": authorUID,
            "authorName": authorName
        ]
    }
    
    init?(from dict: [String:Any]) {
        guard
            let id = dict["id"] as? String,
            let title = dict["title"] as? String,
            let genre = dict["genre"] as? String,
            let price = dict["price"] as? Int,
            let lyricsPreview = dict["lyricsPreview"] as? String,
            let authorUID = dict["authorUID"] as? String
        else { return nil }
        
        self.id = id
        self.title = title
        self.genre = genre
        self.price = price
        self.lyricsPreview = lyricsPreview
        self.authorUID = authorUID
        self.authorName = dict["authorName"] as? String ?? ""
        
        if let timestamp = dict["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
    
    init(id: String = UUID().uuidString, title: String, genre: String, price: Int, lyricsPreview: String, createdAt: Date = Date(), authorUID: String, authorName: String) {
        self.id = id
        self.title = title
        self.genre = genre
        self.price = price
        self.lyricsPreview = lyricsPreview
        self.createdAt = createdAt
        self.authorUID = authorUID
        self.authorName = authorName
    }
    
    
    
}
