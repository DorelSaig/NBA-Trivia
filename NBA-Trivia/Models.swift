import Foundation

class MyData : Decodable {
    var allQuestions: [Quastion]?
    var allAnswers : [String]?
}

class Quastion : Decodable {
    var imageUrl : String?
    var answer : String?
}
