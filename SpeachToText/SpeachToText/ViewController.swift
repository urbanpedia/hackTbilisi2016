//
//  ViewController.swift
//  SpeachToText
//
//  Created by GeoLab Edu on 12/19/15.
//  Copyright © 2015 hackTbilisi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let sdk = iSpeechSDK.sharedSDK()
        sdk.APIKey = "YOUR_API_KEY_HERE";
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

