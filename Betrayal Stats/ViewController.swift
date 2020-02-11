//
//  ViewController.swift
//  Betrayal Stats
//
//  Created by Bigler, Kenneth on 2/7/20.
//  Copyright © 2020 Bigler, Kenneth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var redPlayerButton: UIImageView!
    @IBOutlet weak var purplePlayerButton: UIImageView!
    @IBOutlet weak var grayPlayerButton: UIImageView!
    @IBOutlet weak var tealPlayerButton: UIImageView!
    @IBOutlet weak var orangePlayerButton: UIImageView!
    @IBOutlet weak var greenPlayerButton: UIImageView!
    
    func setHeaderColors() {
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground;
        navigationController?.navigationBar.tintColor = UIColor.label;
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label];
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setHeaderColors()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        setHeaderColors()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ["red", "purple", "gray", "teal", "orange", "green"].contains(segue.identifier ?? "missing") {
            guard let cc = segue.destination as? CharacterController else { return };
            cc.characterGroupColor = segue.identifier ?? "";
        }
    }
    
    func resetAllCharacters(_ sender: UIAlertAction) {
        let allCharacters = readDefaultJson();
        for key in ["red", "purple", "gray", "teal", "orange", "green"] {
            guard let character = allCharacters?[key] else { return }
            writeToTempDirectory(key, character: character);
        }
    }

    @IBAction func onGlobalStatReset(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Reset?", message: "Are you sure you want to reset all game stats?", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: self.resetAllCharacters));
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil));
        self.present(alert, animated: true);
    }
}
