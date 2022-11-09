//
//  ViewController.swift
//  CalendarView
//
//  Created by Yuvaraj on 11/08/2022.
//  Copyright (c) 2022 Yuvaraj. All rights reserved.
//

import UIKit
import CalendarView

class ViewController: UIViewController, CalendarDataSource, CalendarDelegate {
    
    @IBOutlet weak var calendarView: CalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register whichever cell classes you want.
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.reuseIdentifier)
        calendarView.register(CalendarHeaderView.self, forSupplementaryViewOfKind: CalendarHeaderView.elementKind, withReuseIdentifier: CalendarHeaderView.reuseIdentifier)
        
        // Assign delegates.
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
    }
    
    // Move backwards
    @IBAction func backPressed(_ sender: UIButton) {
        calendarView.moveToPreviousMonth(animate: true)
    }
    
    // Move forwards
    @IBAction func nextPressed(_ sender: UIButton) {
        calendarView.moveToNextMonth(animate: true)
    }
    
    // Use your own configuration or pass the default one.
    func configuration(for calendar: CalendarView) -> CalendarViewConfiguration {
        return .DefaultConfiguration
    }
    
    // Use your own cell class, or use the default cell class. This method also provides `CalendarDay`, so you can use it with your own model.
    func calendar(_ calendar: CalendarView, cellForItemAt indexPath: IndexPath, day: CalendarDay) -> UICollectionViewCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath) as! CalendarCell
        cell.day = day
        return cell
    }
    
    // Use your own header class, or use the default cell class. This method also provides `CalendarMonth`, so you can use it with your own model.
    func calendar(_ calendar: CalendarView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath, for month: CalendarMonth) -> UICollectionReusableView {
        let header = calendar.dequeueReusableSupplementaryView(ofKind: CalendarHeaderView.elementKind, withReuseIdentifier: CalendarHeaderView.reuseIdentifier, for: indexPath) as! CalendarHeaderView
        header.month = month
        return header
    }
    
    // Called when user clicks a day.
    func calendar(_ calendar: CalendarView, didSelectDay day: CalendarDay, in: IndexPath) {
        print("DAY SELECTED: ", day.date)
    }
    
    // Called when scrolling stops.
    func calendar(_ calendar: CalendarView, didMonthChange month: CalendarMonth) {
        print("MONTH CHANGED: ", month.name)
    }
}

