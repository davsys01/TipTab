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
    var themeDefault = 1
    
    struct colorTheme {
        let Dark = UIColor.black
        let Light = UIColor(red: 0.511442, green: 0.884617, blue: 0.804661, alpha: 1)
    }
    
    let color = colorTheme()

    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var partySizeSlider: UISlider!
    @IBOutlet weak var themeSegment: UISegmentedControl!
    
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
        themeDefault = themeSegment.selectedSegmentIndex
        
        self.view.backgroundColor = themeDefault == 0 ? color.Dark : color.Light
        
        //saveDefaults()
    }
    
    func readDefaults() -> Void {
        let defaults = UserDefaults.standard
        
        sliderDefault = (defaults.integer(forKey: "sliderValue") == 0 ? 1: defaults.integer(forKey: "sliderValue"))
        tipDefault = defaults.integer(forKey: "tipValue")
        themeDefault = defaults.integer(forKey: "themeValue")
        
        tipSegment.selectedSegmentIndex = tipDefault
        partySizeSlider.value = Float(sliderDefault)
        themeSegment.selectedSegmentIndex = themeDefault

        self.view.backgroundColor = themeDefault == 0 ? color.Dark : color.Light

        self.sliderValueChanged(partySizeSlider)
    }
    
    func saveDefaults() -> Void {
        let defaults = UserDefaults.standard
        
        defaults.setValue(sliderDefault, forKey: "sliderValue")
        defaults.setValue(tipDefault, forKey: "tipValue")
        defaults.setValue(themeDefault, forKey: "themeValue")
        
        defaults.synchronize()
    }

}
