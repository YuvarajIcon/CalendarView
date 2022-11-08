//
//  CalendarViewProtocols.swift
//  CalendarView
//
//  Created by Yuvaraj on 08/11/22.
//

import Foundation
import UIKit

public protocol CalendarDataSource {
    
    /// Asks the dataSource to provide configuration to be used throughtout the calendar.
    ///
    /// Called when `calendarDataSource` is assigned or changed.
    /// - Parameter calendar: The ``CalendarView`` object.
    /// - Returns: The ``CalendarViewConfiguration`` to be used throughout ``CalendarView``.
    func configuration(for calendar: CalendarView) -> CalendarViewConfiguration
    
    /// Asks the datasource a cell for the indexpath.
    ///
    /// Called whenever `UICollectionViewDataSource` calls `cellForItemAt` protocol function.
    /// - Parameters:
    ///   - calendar: The ``CalendarView`` object.
    ///   - indexPath: The `IndexPath` for the cell.
    ///   - day: The ``CalendarDay`` for the indexpath.
    /// - Returns: An `UICollectionViewCell`.
    func calendar(_ calendar: CalendarView, cellForItemAt indexPath: IndexPath, day: CalendarDay) -> UICollectionViewCell
    
    
    /// Asks the datasource a summplementary view for the indexpath.
    ///
    /// Called whenever `UICollectionViewDataSource` calls `viewForSupplementaryElementOfKind` protocol function.
    /// - Parameters:
    ///   - calendar: The ``CalendarView`` object.
    ///   - kind: A string value representing the element kind.
    ///   - indexPath: The `IndexPath` for the cell.
    ///   - month: The ``CalendarMonth`` for the indexpath.
    /// - Returns: An `UICollectionReusableView`.
    func calendar(_ calendar: CalendarView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath, for month: CalendarMonth) -> UICollectionReusableView
}

public protocol CalendarDelegate: AnyObject {
    
    /// Notifies the delegate that a day has been selected.
    /// - Parameters:
    ///   - calendar: The ``CalendarView`` object.
    ///   - didSelectDay: The selected ``CalendarDay``.
    ///   - in: The `IndexPath` for the selected day.
    func calendar(_ calendar: CalendarView, didSelectDay: CalendarDay, in: IndexPath)
    
    /// Notifies the delegate that the currently displayed month is changed.
    /// - Parameters:
    ///   - calendar: The ``CalendarView`` object.
    ///   - didMonthChange: The changed ``CalendarMonth``.
    /// - Note: If the ``ScrollingBehavior`` is `continous`, then this will give the first visible month as the changed value.
    func calendar(_ calendar: CalendarView, didMonthChange: CalendarMonth)
}

//Default Implementations
extension CalendarDataSource {
    func calendar(_ calendar: CalendarView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath, for month: CalendarMonth) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
}
