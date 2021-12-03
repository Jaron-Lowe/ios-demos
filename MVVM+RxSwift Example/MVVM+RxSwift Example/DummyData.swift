//
//  DummyData.swift
//  MVVM+RxSwift Example
//
//  Created by Jaron Lowe on 11/18/21.
//

import Foundation

final class DummyData {
    
    // MARK: - People
    
    static let people = [Int](0..<100)
        .map { _ in randomPerson() }
        .sorted(by: { $0.firstName < $1.firstName })
    
    static let femaleProfilePictures = [Int](1...124).map {
        return "https://jaronlowe.com/services/Profile_Pictures/Female_\($0).jpeg"
    }
    static func randomFemaleProfilePicture() -> String {
        return femaleProfilePictures[Int.random(in: 0..<femaleProfilePictures.count)]
    }
    
    static let femaleFirstNames = [
        "Amy",
        "Amber",
        "Brianne",
        "Casandra",
        "Casey",
        "Cat",
        "Christina",
        "Dani",
        "Debbie",
        "Eden",
        "Erin",
        "Fiona",
        "Frida",
        "Gabriella",
        "Gracie",
        "Haley",
        "Hope",
        "Isabel",
        "Ivy",
        "Jaime",
        "Janet",
        "Karen",
        "Katelyn",
        "Katherine",
        "Kayla",
        "Kelly",
        "Kristin",
        "Lindsay",
        "Lizzy",
        "Mari",
        "Marie",
        "Marsha",
        "Megan",
        "Nancy",
        "Nicole",
        "Nikki",
        "Olivia",
        "Opal",
        "Page",
        "Patricia",
        "Quin",
        "Rachel",
        "Sarah",
        "Scarlett",
        "Shana",
        "Shelly",
        "Stacy",
        "Suyumi",
        "Teresa",
        "Ursula",
        "Valerie",
        "Veronica",
        "Vicky",
        "Violet",
        "Wendy",
        "Whitney",
        "Xena",
        "Yvette",
        "Yvonne",
        "Zarah",
        "Zoey",
    ]
    static func randomFemaleFirstName() -> String {
        return femaleFirstNames[Int.random(in: 0..<femaleFirstNames.count)]
    }
    
    static let maleProfilePictures = [Int](1...52).map {
        return "https://jaronlowe.com/services/Profile_Pictures/Male_\($0).jpeg"
    }
    static func randomMaleProfilePicture() -> String {
        return maleProfilePictures[Int.random(in: 0..<maleProfilePictures.count)]
    }
    
    static let maleFirstNames = [
        "Alex",
        "Brandon",
        "Brian",
        "Chris",
        "Chad",
        "Dallas",
        "Eric",
        "Freddy",
        "Garett",
        "Hayden",
        "Issac",
        "Jama",
        "Jaron",
        "Jeff",
        "Jesse",
        "John",
        "Jordan",
        "Juan",
        "Keith",
        "Lincoln",
        "Matt",
        "Michael",
        "Ned",
        "Orlando",
        "Paul",
        "Peter",
        "Quinton",
        "Rick",
        "Rilde",
        "Ryan",
        "Sam",
        "Steven",
        "Trevor",
        "Ulysses",
        "Vincent",
        "Wade",
        "Walter",
        "Wilson",
        "Xavior",
        "Youssef",
        "Yuriy",
        "Zane"
    ]
    static func randomMaleFirstName() -> String {
        return maleFirstNames[Int.random(in: 0..<maleFirstNames.count)]
    }
    
    static let lastNames = [
        "Adams",
        "Bird",
        "Browne",
        "Chavez",
        "Cummings",
        "Dellarco",
        "Espinoza",
        "Ferguson",
        "Freeman",
        "Fuller",
        "Goldberg",
        "Griffin",
        "Gurry",
        "Guzman",
        "Hager",
        "Hanewald",
        "Hardinge",
        "Harper",
        "Holt",
        "Ingle",
        "Irwin",
        "Jackson",
        "Jones",
        "Kier",
        "Le",
        "Leon",
        "Lowe",
        "Lusk",
        "Majewski",
        "Manalo",
        "McCaffrey",
        "McCarthy",
        "Medina",
        "Meridith",
        "Newman",
        "Norris",
        "O’Donoghue",
        "Ochoa",
        "Ogaard",
        "Oliver",
        "Packer",
        "Page",
        "Palmer",
        "Quiroz",
        "Reed",
        "Robinson",
        "Rogers",
        "Saka",
        "Titus",
        "Tracey",
        "Underhill",
        "Valentine",
        "Vasconcellos",
        "Wilbanks",
        "Xanthos",
        "Yates",
        "York",
        "Ziegler",
        "Zimmerman"
    ]
    static func randomLastName() -> String {
        return lastNames[Int.random(in: 0..<lastNames.count)]
    }
    
    static func randomFemale() -> Person {
        return Person(
            imageUrl: randomFemaleProfilePicture(),
            gender: .female,
            firstName: randomFemaleFirstName(),
            lastName: randomLastName()
        )
    }
    static func randomMale() -> Person {
        return Person(
            imageUrl: randomMaleProfilePicture(),
            gender: .male,
            firstName: randomMaleFirstName(),
            lastName: randomLastName()
        )
    }
    static func randomPerson() -> Person {
        let person = (Bool.random()) ? randomFemale() : randomMale()
        return person
    }

}
