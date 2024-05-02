//
//  DatePickerDialogViewController.swift
//  smartsigner
//
//  Created by Serdar Coskun on 6.11.2018.
//  Copyright © 2018 Seneka. All rights reserved.
//

import UIKit
import FSCalendar
import MaterialComponents


class DatePickerDialogViewController: UIViewController {

    var selectedDate:Date?
    @IBOutlet weak var calendar:FSCalendar?
    @IBOutlet weak var lblSelectedDate:UILabel?
    @IBOutlet weak var btnSelect:MDCButton?
    @IBOutlet weak var btnCancel:MDCButton?
    
    let dateFormatter:DateFormatter = DateFormatter()
    var sourceView:String?
    
    convenience init() {
        self.init(nibName: "DatePickerDialogViewController", bundle: .main)
    }

    override func viewDidLoad() {
        ThemeManager.applyButtonColorTheme(button: self.btnSelect!)
        ThemeManager.applyButtonColorTheme(button: self.btnCancel!)
        self.btnSelect?.setTitle(LocalizedStrings.select.localizedString(), for: .normal)
        self.btnCancel?.setTitle(LocalizedStrings.cancel.localizedString(), for: .normal)
        self.calendar?.delegate = self
        self.calendar?.dataSource = self
        self.btnCancel?.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        self.btnSelect?.addTarget(self, action: #selector(didTapSelect), for: .touchUpInside)
        self.dateFormatter.dateFormat = "EEEE, dd.MMMM.yyyy"
        self.updateLabel()
        
        self.calendar?.tintColor = .primaryColor
        
    }
    @objc func didTapCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSelect(){
        Observers.did_select_date.post(userInfo: [Observers.keys.selected_date : self.selectedDate ?? Date(),Observers.keys.source_view:self.sourceView ?? "<no view attached>"])
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateLabel(){
        self.lblSelectedDate?.text = self.dateFormatter.string(from: self.selectedDate ?? Date())
    }
}

extension DatePickerDialogViewController:FSCalendarDataSource,FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDate = date
        self.updateLabel()
    }
}
