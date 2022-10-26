
import Foundation

struct RepoInformation : Decodable {
    let items : [Item]?
}

public struct Item : Decodable {
    
    let name : String?
    let privacy : Bool?
    let description : String?
    let language : String?

    enum CodingKeys: String, CodingKey {
        case name
        case privacy = "private"
        case description
        case language
    }
}
