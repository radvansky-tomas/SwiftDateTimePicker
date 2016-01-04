//
//  TestViewController.swift
//  DateTimePickerViewController
//
//  Created by Tomas Radvansky on 04/01/2016.
//  Copyright © 2016 Tomas Radvansky. All rights reserved.
//

import UIKit
import FSCalendar
import DateTools

@objc public protocol DatePickerDelegate
{
    func datePickingSelected(date:NSDate, controller:DatePickerViewController)
    func datePickingCancelled(controller:DatePickerViewController)
}

public class DatePickerViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,FSCalendarDelegate,UINavigationBarDelegate {
    var navBar:UINavigationBar!
    var calendarView: FSCalendar!
    var hoursView: UIPickerView!
    var minutesView: UIPickerView!
    
    var selectedDate:NSDate = NSDate()
    public var delegate:DatePickerDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setup()
        self.displayDateTime(selectedDate)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup()
    {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        self.navBar.translucent = false
        self.navBar.delegate = self
        let navItem:UINavigationItem = UINavigationItem(title: "Date Time Picker")
        let cancelBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelBtnClicked:")
        let doneBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneBtnClicked:")
        navItem.leftBarButtonItem = cancelBtn
        navItem.rightBarButtonItem = doneBtn
        self.navBar.items = [navItem]
        
        //Setup Calendar view
        self.calendarView = FSCalendar(frame:CGRectMake(0, 0, 320, 320))
        self.calendarView.delegate = self
        
        //Setup pickers
        self.hoursView = UIPickerView(frame: CGRectMake(0, 0, 160, 320))
        self.minutesView = UIPickerView(frame: CGRectMake(160, 0, 160, 320))
        self.hoursView.delegate = self
        self.minutesView.delegate = self
        self.hoursView.dataSource = self
        self.minutesView.dataSource = self
        
        //Prep auto layout
        self.navBar.translatesAutoresizingMaskIntoConstraints = false
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        self.hoursView.translatesAutoresizingMaskIntoConstraints = false
        self.minutesView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.navBar)
        self.view.addSubview(self.calendarView)
        self.view.addSubview(self.hoursView)
        self.view.addSubview(self.minutesView)
        
    }
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
    
    
    override public func updateViewConstraints() {
        
        //Autolayout
        let views = ["navBar": self.navBar,
            "calendarView": self.calendarView,
            "hoursView": self.hoursView,
            "minutesView": self.minutesView]
        
      
        
        self.calendarView.removeFromSuperview()
        self.minutesView.removeFromSuperview()
        self.hoursView.removeFromSuperview()
        self.navBar.removeFromSuperview()
        
        //Add new constrains
        
        self.view.addSubview(self.navBar)
        self.view.addSubview(self.calendarView)
        self.view.addSubview(self.hoursView)
        self.view.addSubview(self.minutesView)
        
        
        if UIDevice.currentDevice().orientation.isPortrait
        {
            //Horizontal constraints
            let horizontalNavBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[navBar]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            self.view.addConstraints(horizontalNavBarConstraints)
            
            let horizontalCalendarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            self.view.addConstraints(horizontalCalendarConstraints)
            
            let horizontalPickerConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[hoursView(==minutesView)]-[minutesView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            self.view.addConstraints(horizontalPickerConstraints)
            
            //Vertical constraints
            let vertical1NavBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(self.statusBarHeight())-[navBar(44.0)]-[calendarView(==hoursView)]-[hoursView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            
            self.view.addConstraints(vertical1NavBarConstraints)
            
            let vertical2NavBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[calendarView]-[minutesView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            
            self.view.addConstraints(vertical2NavBarConstraints)
        }
        else
        {
            //Horizontal constraints
            let horizontalNavBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[navBar]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            self.view.addConstraints(horizontalNavBarConstraints)
            let halfSize:CGFloat = self.view.frame.size.width/2
            let horizontalCalendarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView(\(halfSize))]-[hoursView(==minutesView)]-[minutesView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            self.view.addConstraints(horizontalCalendarConstraints)
            
            //Vertical constraints
            let vertical1NavBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(self.statusBarHeight())-[navBar(44.0)]-[calendarView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            
            self.view.addConstraints(vertical1NavBarConstraints)
            
            let vertical2NavBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[navBar]-[hoursView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            
            self.view.addConstraints(vertical2NavBarConstraints)
            
            let vertical3NavBarConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[navBar]-[minutesView]|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            
            self.view.addConstraints(vertical3NavBarConstraints)
        }
        super.updateViewConstraints()
    }
    
    public func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    //MARK:- FSCalendarDelegate
    public func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        //Update Day
        self.selectedDate = NSDate(year: date.year(), month: date.month(), day: date.day(), hour: self.selectedDate.hour(), minute: self.selectedDate.minute(), second: 0)
    }
    
    //MARK:- Helper
    func displayDateTime(dateTime:NSDate)
    {
        self.calendarView.selectDate(dateTime)
        self.hoursView.selectRow(dateTime.hour(), inComponent: 0, animated: true)
        self.minutesView.selectRow(dateTime.minute(), inComponent: 0, animated: true)
    }
    
    //MARK:- UIPickerViewDataSource,UIPickerViewDelegate
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == hoursView
        {
            return 24
        }
        else
        {
            return 60
        }
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == hoursView
        {
            return String(format: "%02d", row)
        }
        else
        {
            return String(format: "%02d", row)
        }
    }
    
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hoursView
        {
            //Update Hour
            self.selectedDate = NSDate(year: self.selectedDate.year(), month: self.selectedDate.month(), day: self.selectedDate.day(), hour: row, minute: self.selectedDate.minute(), second: 0)
        }
        else
        {
            //Update Minute
            self.selectedDate = NSDate(year: self.selectedDate.year(), month: self.selectedDate.month(), day: self.selectedDate.day(), hour: self.selectedDate.hour(), minute: row, second: 0)
        }
    }
    
    //MARK:- Actions
    
    func doneBtnClicked(sender: AnyObject) {
        self.delegate?.datePickingSelected(self.selectedDate, controller: self)
    }
    
    func cancelBtnClicked(sender: AnyObject) {
        self.delegate?.datePickingCancelled(self)
    }
    
}
