//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = true
        titleLabel.text = ""
        let text = K.nameApp
        var charIndex = 0.0
        
        for i in text {
            Timer.scheduledTimer(withTimeInterval: 0.5 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(i)
                charIndex += 1
            }
        }
        
    }
}
