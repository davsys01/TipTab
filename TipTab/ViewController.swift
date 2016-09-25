//
//  ViewController.swift
//  TipTab
//
//  Created by David Bocardo on 9/23/16.
//  Copyright © 2016 David Bocardo. All rights reserved.
//

import UIKit

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class ViewController: UIViewController {
    
    var textValue = 0.0
    var isDirty = false
    
    @IBOutlet weak var partySizeSlider: UISlider!
    @IBOutlet weak var partySizeLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var personTotalLabel: UILabel!
    @IBOutlet weak var billText: UITextField!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        if currentValue == 1 {
            partySizeLabel.text = "Party size (1 person)"
        }
        else {
            partySizeLabel.text = "Party size (\(currentValue) persons)"
        }
        
        calculateTip(sender)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        billText.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readDefaults()
        if isDirty {
            billText.text = String(format: "%.2f", textValue)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !(billText.text?.isEmpty)! {
            textValue = Double(billText.text!)!
            isDirty = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        
        let tipString = tipSegment.titleForSegment(at: tipSegment.selectedSegmentIndex)
        var tipNumeric = Double((tipString?.substring(to: (tipString?.index(before: (tipString?.endIndex)!))!))!)
        tipNumeric = Double(tipNumeric!/100).roundTo(places: 2)
        
        let bill = Double(billText.text!) ?? 0
        let tip = bill * tipNumeric!
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        let partySize = Int(partySizeSlider.value)
        if partySize > 1 {
            personTotalLabel.text = String(format: "$%.2f", total / Double(partySize))
        } else {
            personTotalLabel.text = String(format: "$%.2f", total)
        }
    }
    
    func readDefaults() -> Void {
        let defaults = UserDefaults.standard
        
        let sliderDefault = (defaults.integer(forKey: "sliderValue") == 0 ? 1: defaults.integer(forKey: "sliderValue"))
        let tipDefault = defaults.integer(forKey: "tipValue")
        
        tipSegment.selectedSegmentIndex = tipDefault
        partySizeSlider.value = Float(sliderDefault)
        
        self.sliderValueChanged(partySizeSlider)
    }
    
}

