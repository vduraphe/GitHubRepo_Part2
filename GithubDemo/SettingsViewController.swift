//
//  SettingsViewController.swift
//  
//
//  Created by Rohan Trivedi on 3/1/17.
//
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var starSlider: UISlider!
    
    var currentPrefs: Preferences!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentPrefs = currentPrefs ?? Preferences()
        
        starSlider.value = Float(currentPrefs.minStarRating)
        sliderValueChanged(self.starSlider)
    }
    
    func preferencesFromTableData() -> Preferences{
        let newPrefs = Preferences()
        newPrefs.minStarRating = Int(starSlider.value)
        
        return newPrefs
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        sliderLabel.text = String(currentValue)
    }
    
    @IBAction func cancelToReposResultsViewController(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
