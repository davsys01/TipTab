//
//  SettingsViewController.swift
//  TipTab
//
//  Created by David Bocardo on 9/23/16.
//  Copyright © 2016 David Bocardo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var sliderDefault = 1
    var tipDefault = 0

    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var partySizeSlider: UISlider!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readDefaults()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderDefault = Int(sender.value)
        
        if sliderDefault == 1 {
            partySizeLabel.text = "Default Party size (1 person)"
        }
        else {
            partySizeLabel.text = "Default Party size (\(sliderDefault) persons)"
        }
        
        //saveDefaults()
    }
    
    @IBAction func segmentValueChanged(_ sender: AnyObject) {
        tipDefault = tipSegment.selectedSegmentIndex
        
        //saveDefaults()
    }
    
    func readDefaults() -> Void {
        let defaults = UserDefaults.standard
        
        sliderDefault = (defaults.integer(forKey: "sliderValue") == 0 ? 1: defaults.integer(forKey: "sliderValue"))
        tipDefault = defaults.integer(forKey: "tipValue")
        
        tipSegment.selectedSegmentIndex = tipDefault
        partySizeSlider.value = Float(sliderDefault)
        
        self.sliderValueChanged(partySizeSlider)
    }
    
    func saveDefaults() -> Void {
        let defaults = UserDefaults.standard
        
        defaults.setValue(sliderDefault, forKey: "sliderValue")
        defaults.setValue(tipDefault, forKey: "tipValue")
        
        defaults.synchronize()
    }

}
