//
//  DataAccessors.swift
//  Betrayal Stats
//
//  Created by Bigler, Kenneth on 2/10/20.
//  Copyright © 2020 Bigler, Kenneth. All rights reserved.
//

import Foundation

// MARK: Data Access
func getTempDirectoryURL(_ characterGroupColor: String) -> URL {
    let path = NSTemporaryDirectory() + "\(characterGroupColor).json";
    return URL.init(fileURLWithPath: path);
}

func writeToTempDirectory(_ characterGroupColor: String, character: [Character]) {
    let fileURL = getTempDirectoryURL(characterGroupColor);
    guard let encodedJson = try? JSONEncoder().encode(character) else { return };
    do { try encodedJson.write(to: fileURL) } catch { print(error) }
}

func readFromTempDirectory(_ characterGroupColor: String) -> [Character]? {
    let fileURL = getTempDirectoryURL(characterGroupColor);
    guard let data = try? Data(contentsOf: fileURL, options: .mappedIfSafe) else { return nil }
    guard let characters = try? JSONDecoder().decode(CharacterArray.self, from: data) else { return nil }
    print("read from Temp Directory");
    return characters;
}

func readDefaultJson() -> CharacterPage? {
    // bundle to access local xcode/bundle path
    guard let path = Bundle.main.path(forResource: "characters", ofType: "json") else { return nil }
    let fileURL = URL.init(fileURLWithPath: path);
    guard let data = try? Data(contentsOf: fileURL, options: .mappedIfSafe) else { return nil }
    guard let decodedJson = try? JSONDecoder().decode(CharacterPage.self, from: data) else { return nil }
    print("read from JSON Defaults");
    return decodedJson;
}

func readDefaultJsonByColor(_ characterGroupColor: String) -> [Character]? {
    // bundle to access local xcode/bundle path
    let decodedJson = readDefaultJson();
    guard let characters = decodedJson?[characterGroupColor] else { return nil }
    print("read from JSON Defaults");
    return characters;
}
