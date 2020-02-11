//
//  Characters.swift
//  Betrayal Stats
//
//  Created by Bigler, Kenneth on 2/7/20.
//  Copyright © 2020 Bigler, Kenneth. All rights reserved.
//

import Foundation

struct Character : Codable {
    var name: String;
    var age: Int;
    var height: String;
    var weight: String;
    var hobbies: String;
    var birthday: String;
    var might: [Int];
    var speed: [Int];
    var sanity: [Int];
    var knowledge: [Int];
    var mightIdx: Int;
    var speedIdx: Int;
    var sanityIdx: Int;
    var knowledgeIdx: Int;
}

typealias CharacterArray = [Character];
typealias CharacterPage = Dictionary<String, CharacterArray>;
