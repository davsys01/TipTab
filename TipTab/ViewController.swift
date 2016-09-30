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

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
    }
}

class ViewController: UIViewController {
    
    var textValue = 0.0
    var isDirty = false
    
    let tolerance = 10 // Minutes
    
    struct colorTheme {
        let Dark = UIColor.black
        let Light = UIColor(red: 0.511442, green: 0.884617, blue: 0.804661, alpha: 1)
    }
    
    let color = colorTheme()
    
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

        NotificationCenter.default.addObserver(self, selector: #selector(self.readDefaults), name: .UIApplicationWillEnterForeground, object: nil)
        
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

        let locale = Locale.current
        let currencySymbol = locale.currencySymbol

        let tipString = tipSegment.titleForSegment(at: tipSegment.selectedSegmentIndex)
        var tipNumeric = Double((tipString?.substring(to: (tipString?.index(before: (tipString?.endIndex)!))!))!)
        tipNumeric = Double(tipNumeric!/100).roundTo(places: 2)
        
        let bill = Double(billText.text!) ?? 0
        let tip = bill * tipNumeric!
        let total = bill + tip
        
        tipLabel.text = String(format: "\(currencySymbol!)%.2f", tip)
        totalLabel.text = String(format: "\(currencySymbol!)%.2f", total)
        
        let partySize = Int(partySizeSlider.value)
        if partySize > 1 {
            personTotalLabel.text = String(format: "\(currencySymbol!)%.2f", total / Double(partySize))
        } else {
            personTotalLabel.text = String(format: "\(currencySymbol!)%.2f", total)
        }
    }
    
    func readDefaults() -> Void {
        let defaults = UserDefaults.standard
        
        let sliderDefault = (defaults.integer(forKey: "sliderValue") == 0 ? 1: defaults.integer(forKey: "sliderValue"))
        let tipDefault = defaults.integer(forKey: "tipValue")
        if let themeDefault: Int = defaults.object(forKey: "themeValue") as? Int {
          self.view.backgroundColor = themeDefault == 0 ? color.Dark : color.Light
        } else {
            self.view.backgroundColor = color.Light
            defaults.setValue(1, forKey: "themeValue")
            defaults.synchronize()
        }
        
        if let lastUsedDate: Date = defaults.object(forKey: "lastUsedValue") as? Date {
            let currentDate = Date()
            let minutesElapsed = currentDate.minutes(from: lastUsedDate)
            if minutesElapsed > tolerance {
                billText.text = ""
            }
        }
        
        tipSegment.selectedSegmentIndex = tipDefault
        partySizeSlider.value = Float(sliderDefault)
        
        //self.view.backgroundColor = themeDefault == 0 ? color.Dark : color.Light
        
        self.sliderValueChanged(partySizeSlider)
    }
}

