//
//  SettingsViewController.swift
//  Overflowing Stacks
//
//  Created by Faisal Bhombal on 1/15/20.
//  Copyright © 2020 Faisal Bhombal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var quotaMax: Int = 0
    var quotaRemaining: Int = 0
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var quotaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Do any additional setup after loading the view.
        let durationString = Registrator.shared.value(forKey: .duration)
        
        let i = Registrator.shared.options.firstIndex(of: durationString) ?? 0
        self.pickerView.selectRow(i, inComponent: 0, animated: false)
        DispatchQueue.main.async {
            self.quotaLabel.text = " \(self.quotaRemaining) / \(self.quotaMax)"
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Registrator.shared.options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Registrator.shared.options[row]
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwind-to-home" {
            let row = self.pickerView.selectedRow(inComponent: 0)
            let s = Registrator.shared.options[row]
            Registrator.shared.set(value: s, forKey: .duration)
            guard let vc = segue.destination as? MasterViewController else {
                return
            }
            vc.durationDisplay.title = s
            vc.duration = s.hours
            vc.refresh()
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
