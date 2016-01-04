//
//  ExampleViewController.swift
//  DateTimePickerViewController
//
//  Created by Tomas Radvansky on 03/01/2016.
//  Copyright © 2016 Tomas Radvansky. All rights reserved.
//

import UIKit
import SwiftDateTimePicker

class ExampleViewController: UIViewController,DatePickerDelegate {

    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK:- Actions
    @IBAction func presentClicked(sender: AnyObject) {
        let pickerVC:DatePickerViewController = DatePickerViewController()
        pickerVC.delegate = self
        self.presentViewController(pickerVC, animated: true, completion: nil)
    }
    
    //MARK:- DatePickerDelegate
    func datePickingCancelled(controller: DatePickerViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func datePickingSelected(date: NSDate, controller: DatePickerViewController) {
        controller.dismissViewControllerAnimated(true) { () -> Void in
            self.resultLabel.text = date.descriptionWithLocale(NSLocale.currentLocale().localeIdentifier)
        }
    }
}
