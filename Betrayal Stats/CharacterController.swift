//
//  CharacterController.swift
//  Betrayal Stats
//
//  Created by Bigler, Kenneth on 2/7/20.
//  Copyright © 2020 Bigler, Kenneth. All rights reserved.
//

import UIKit

func getCharacters(_ characterGroupColor: String) -> [Character]? {
    // check if exists in DB else get defaults
    if let characters = readFromTempDirectory(characterGroupColor) { return characters }
    else {
        guard let characters = readDefaultJsonByColor(characterGroupColor) else { return nil };
        writeToTempDirectory(characterGroupColor, character: characters);
        return characters;
    }
}

// MARK: ViewController
class CharacterController: UIViewController {
    // MARK: Outlets
    @IBOutlet var baseView: UIView!

    @IBOutlet weak var characterPhoto: UIImageView!

    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterInfoLabel: UILabel!

    @IBOutlet weak var mightCtrl: UISegmentedControl!
    @IBOutlet weak var mightStepper: UIStepper!
    @IBOutlet weak var mightRefresh: UIButton!
    @IBOutlet weak var mightHR: UIView!
    
    @IBOutlet weak var speedCtrl: UISegmentedControl!
    @IBOutlet weak var speedStepper: UIStepper!
    @IBOutlet weak var speedRefresh: UIButton!
    @IBOutlet weak var speedHR: UIView!
    
    @IBOutlet weak var sanityCtrl: UISegmentedControl!
    @IBOutlet weak var sanityStepper: UIStepper!
    @IBOutlet weak var sanityRefresh: UIButton!
    @IBOutlet weak var sanityHR: UIView!
    
    @IBOutlet weak var knowledgeCtrl: UISegmentedControl!
    @IBOutlet weak var knowledgeStepper: UIStepper!
    @IBOutlet weak var knowledgeRefresh: UIButton!
    @IBOutlet weak var knowledgeHR: UIView!
    
    // MARK: State
    var characterGroupColor = "";
    var characters: [Character]?;
    var characterNumber = 0;
    
    // MARK: Update UI Colors
    func updateUIColors() {
        // get character color
        var characterColor: UIColor;
        switch self.characterGroupColor {
        case "red":
            characterColor = UIColor.systemRed;
        case "purple":
            characterColor = UIColor.systemPurple;
        case "gray":
            characterColor = UIColor.systemGray;
        case "teal":
            characterColor = UIColor.systemTeal;
        case "orange":
            characterColor = UIColor.systemOrange;
        case "green":
            characterColor = UIColor.systemGreen;
        default:
            characterColor = UIColor.systemBlue;
        }

        // set navigation colors
        navigationController?.navigationBar.barTintColor = characterColor;
        navigationController?.navigationBar.tintColor = UIColor.black;
        
        // set character photo color
        characterPhoto.tintColor = characterColor;

        // set UI Element colors
        mightCtrl.selectedSegmentTintColor = characterColor;
        mightRefresh.tintColor = characterColor;
        mightHR.backgroundColor = characterColor;
        mightStepper.backgroundColor = characterColor;
        mightStepper.layer.cornerRadius = 9;
        /* // change the text color of the selected element
        mightCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: characterColor], for: .normal);
        mightCtrl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected); */

        speedCtrl.selectedSegmentTintColor = characterColor;
        speedRefresh.tintColor = characterColor;
        speedHR.backgroundColor = characterColor;
        speedStepper.backgroundColor = characterColor;
        speedStepper.layer.cornerRadius = 9;

        sanityCtrl.selectedSegmentTintColor = characterColor;
        sanityRefresh.tintColor = characterColor;
        sanityHR.backgroundColor = characterColor;
        sanityStepper.backgroundColor = characterColor;
        sanityStepper.layer.cornerRadius = 9;

        knowledgeCtrl.selectedSegmentTintColor = characterColor;
        knowledgeRefresh.tintColor = characterColor;
        knowledgeHR.backgroundColor = characterColor;
        knowledgeStepper.backgroundColor = characterColor;
        knowledgeStepper.layer.cornerRadius = 9;
    }
    
    // MARK: Set UI Data
    func initCharacterUI() {
        guard let character = self.characters?[self.characterNumber] else { return };
        // set name
        self.characterNameLabel.text = character.name;
        
        // set info
        let d = " · ";
        self.characterInfoLabel.text = "Age: \(character.age) \(d) Height: \(character.height) \(d) Weight: \(character.weight) \(d) Hobbies: \(character.hobbies) \(d) Birthday: \(character.birthday)";
        
        // set sliders
        // might
        for tup in (character.might).enumerated() {
            let (idx, val) = tup;
            mightCtrl.setTitle(String(val), forSegmentAt: idx);
        }
        mightCtrl.selectedSegmentIndex = character.mightIdx;
        mightStepper.value = Double(character.mightIdx);
        // speed
        for tup in (character.speed).enumerated() {
            let (idx, val) = tup;
            speedCtrl.setTitle(String(val), forSegmentAt: idx);
        }
        speedCtrl.selectedSegmentIndex = character.speedIdx;
        speedStepper.value = Double(character.speedIdx);
        // sanity
        for tup in (character.sanity).enumerated() {
            let (idx, val) = tup;
            sanityCtrl.setTitle(String(val), forSegmentAt: idx);
        }
        sanityCtrl.selectedSegmentIndex = character.sanityIdx;
        sanityStepper.value = Double(character.sanityIdx);
        // knowledge
        for tup in (character.knowledge).enumerated() {
            let (idx, val) = tup;
            knowledgeCtrl.setTitle(String(val), forSegmentAt: idx);
        }
        knowledgeCtrl.selectedSegmentIndex = character.knowledgeIdx;
        knowledgeStepper.value = Double(character.knowledgeIdx);
    }

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.characters = getCharacters(self.characterGroupColor);
        self.characterNumber = UserDefaults.standard.integer(forKey: "\(self.characterGroupColor)CharacterNumber");
        self.updateUIColors();
        self.initCharacterUI();
    }
    
    func saveData(_ characters: [Character]) {
        self.characters = characters;
        writeToTempDirectory(self.characterGroupColor, character: characters);
    }
    
    func resetCharacterStats(_ sender: UIAlertAction) {
        // read from json defaults file
        guard let characters = readDefaultJsonByColor(self.characterGroupColor) else { return }
        // set the UI
        mightCtrl.selectedSegmentIndex = characters[self.characterNumber].mightIdx;
        mightStepper.value = Double(characters[self.characterNumber].mightIdx);
        speedCtrl.selectedSegmentIndex = characters[self.characterNumber].speedIdx;
        speedStepper.value = Double(characters[self.characterNumber].speedIdx);
        sanityCtrl.selectedSegmentIndex = characters[self.characterNumber].sanityIdx;
        sanityStepper.value = Double(characters[self.characterNumber].sanityIdx);
        knowledgeCtrl.selectedSegmentIndex = characters[self.characterNumber].knowledgeIdx;
        knowledgeStepper.value = Double(characters[self.characterNumber].knowledgeIdx);
        // save defaults to temp storage
        saveData(characters);
    }
    
    // MARK: Menu Bar Item Controls
    @IBAction func onGlobalRefresh(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Reset Character?", message: "Are you sure you want to reset stats for this side of this character?", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: self.resetCharacterStats));
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil));
        self.present(alert, animated: true);
    }
    
    func flip(_ isFromRight: Bool = true) {
        let transitionOptions: UIView.AnimationOptions = [isFromRight ? .transitionFlipFromRight : .transitionFlipFromLeft, .showHideTransitionViews];

        UIView.transition(with: self.baseView, duration: 1.0, options: transitionOptions, animations: {
            self.baseView.isHidden = true;
        });

        UIView.transition(with: self.baseView, duration: 1.0, options: transitionOptions, animations: {
            self.baseView.isHidden = false;
        });
    }
    
    @IBAction func onCardFlip(_ sender: UIBarButtonItem) {
        self.characterNumber = self.characterNumber == 0 ? 1 : 0;
        UserDefaults.standard.set(self.characterNumber, forKey: "\(self.characterGroupColor)CharacterNumber");
        flip(self.characterNumber == 0);
        self.initCharacterUI();
    }
    
    // MARK: Stats UI Controls
    @IBAction func onTraitStep(_ sender: UIStepper) {
        // get the character
        guard var characters = self.characters else { return };
        // update UI and character model
        switch(sender.tag) {
        case 0:
            mightCtrl.selectedSegmentIndex = Int(sender.value);
            characters[self.characterNumber].mightIdx = Int(sender.value);
        case 1:
            speedCtrl.selectedSegmentIndex = Int(sender.value);
            characters[self.characterNumber].speedIdx = Int(sender.value);
        case 2:
            sanityCtrl.selectedSegmentIndex = Int(sender.value);
            characters[self.characterNumber].sanityIdx = Int(sender.value);
        case 3:
            knowledgeCtrl.selectedSegmentIndex = Int(sender.value);
            characters[self.characterNumber].knowledgeIdx = Int(sender.value);
        default:
            print("ERROR: unknown stepper pressed.")
        }
        // save character
        saveData(characters);
    }

    @IBAction func onTraitSegmentClick(_ sender: UISegmentedControl) {
        // get the character
        guard var characters = self.characters else { return };
        // update UI and character model
        switch(sender.tag) {
        case 0:
            mightStepper.value = Double(sender.selectedSegmentIndex);
            characters[self.characterNumber].mightIdx = sender.selectedSegmentIndex;
        case 1:
            speedStepper.value = Double(sender.selectedSegmentIndex);
            characters[self.characterNumber].speedIdx = sender.selectedSegmentIndex;
        case 2:
            sanityStepper.value = Double(sender.selectedSegmentIndex);
            characters[self.characterNumber].sanityIdx = sender.selectedSegmentIndex;
        case 3:
            knowledgeStepper.value = Double(sender.selectedSegmentIndex);
            characters[self.characterNumber].knowledgeIdx = sender.selectedSegmentIndex;
        default:
            print("ERROR: unknown segment pressed.");
        }
        // save character
        saveData(characters);
    }

    @IBAction func onTraitRefresh(_ sender: UIButton) {
        // read from json defaults file
        guard let characters = readDefaultJsonByColor(self.characterGroupColor) else { return }

        // set the UI
        switch(sender.tag) {
        case 0:
            mightCtrl.selectedSegmentIndex = characters[self.characterNumber].mightIdx;
            mightStepper.value = Double(characters[self.characterNumber].mightIdx);
        case 1:
            speedCtrl.selectedSegmentIndex = characters[self.characterNumber].speedIdx;
            speedStepper.value = Double(characters[self.characterNumber].speedIdx);
        case 2:
            sanityCtrl.selectedSegmentIndex = characters[self.characterNumber].sanityIdx;
            sanityStepper.value = Double(characters[self.characterNumber].sanityIdx);
        case 3:
            knowledgeCtrl.selectedSegmentIndex = characters[self.characterNumber].knowledgeIdx;
            knowledgeStepper.value = Double(characters[self.characterNumber].knowledgeIdx);
        default:
            print("ERROR: unknown refresh button pressed.")
        }
        
        // save defaults to temp storage
        saveData(characters);
    }
}
