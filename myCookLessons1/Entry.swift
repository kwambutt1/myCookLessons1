//
//  Entry.swift
//  myCookLessons1
//
//  Created by coder on 03.12.22.
//  Copyright © 2022 coder. All rights reserved.
//

import UIKit

class Entry: UIViewController, UINavigationControllerDelegate {

   //properties
    
   
    @IBOutlet weak var showAppVersion: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.showAppVersion.text = "myCookLessons v. \(String(describing: appVersion))"
        
        
    }
    
    @IBAction func accountButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "account", sender: nil)
    }
    
    
    @IBAction func enterbutton(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "enter", sender: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
