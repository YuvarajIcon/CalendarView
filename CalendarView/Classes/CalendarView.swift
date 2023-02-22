//
//  CalendarView.swift
//  CalendarView
//
//  Created by Yuvaraj on 08/11/22.
//

import Foundation
import UIKit

public class CalendarView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: PRIVATE VARIABLES
    
    /// The calendar data.
    private lazy var months = self.generateMonths(from: self.configuration.startDate, to: self.configuration.endDate)
    
    /// The calendar configuration.
    private lazy var configuration: CalendarViewConfiguration = {
        return calendarDataSource?.configuration(for: self) ?? .DefaultConfiguration
    }()
    
    /// The formatter used to generate string value of date.
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    //MARK: PUBLIC VARIABLES
    
    /// The object that provides data for `CalendarView`.
    public var calendarDataSource: CalendarDataSource? {
        didSet {
            self.configuration = calendarDataSource?.configuration(for: self) ?? .DefaultConfiguration
            self.months = self.generateMonths(from: self.configuration.startDate, to: self.configuration.endDate)
            self.collectionViewLayout = configuration.layout ?? defaultLayout()
        }
    }
    
    /// The object that acts as the delegate for `CalendarView`.
    public var calendarDelegate: CalendarDelegate?
    
    /// The currently visibly displayed month.
    ///
    /// Returns `nil` if no ``calendarDataSource`` is provided or when there are no visible cells.
    public var displayedMonth: CalendarMonth? {
        guard let indexPath = self.indexPathsForVisibleItems.first, months.isEmpty == false else {
            return nil
        }
        guard months.count > indexPath.section else {
            return nil
        }
        return months[indexPath.section]
    }
    
    /// The total number of months in the given configuration range.
    public var numberOfMonths: Int {
        return months.count
    }
    
    @available(*, unavailable, message: "Use numberOfMonths instead")
    /// Replaced by ``numberOfMonths``.
    public override var numberOfSections: Int {
        get { return super.numberOfSections }
        set {}
    }
    
    @available(*, unavailable, message: "Use calendarDelegate instead")
    /// Replaced by ``calendarDelegate``.
    public override var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set {}
    }
    
    @available(*, unavailable, message: "Use calendarDataSource instead")
    /// Replaced by ``calendarDataSource``.
    public override var dataSource: UICollectionViewDataSource? {
        get { return super.dataSource }
        set {}
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        self.calendarDelegate?.calendar(self, didMonthChange: self.months[0])
    }
    
    //MARK: INITIALIZERS
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.dataSource = self
        super.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        super.dataSource = self
        super.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.dataSource = self
        super.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    //MARK: PUBLIC METHODS
    
    /// Returns number of weeks in a given month index.
    ///
    /// Use this method if you plan to have your own expandable collectionview layout.
    /// - Parameter sectionIndex: Index value for a month.
    /// - Returns: The number of weeks.
    public func numberOfWeeks(for sectionIndex: Int) -> CGFloat {
        guard let weekArray = self.configuration.calendar.range(of: .weekOfMonth, in: .month, for: self.months[sectionIndex].metaData.firstDay) else {
            return 0
        }
        return CGFloat(weekArray.count)
    }
    
    /// Scrolls the calendar to the next month.
    /// - Note: If this is called when the `isLastDisplayableMonth` for the ``displayedMonth`` is `true`, the calendar will not scroll.
    /// - Parameter animate: A boolean value indicating whether to apply scrolling animation or not. Default is true.
    public func moveToNextMonth(animate: Bool = true) {
        guard let displayedMonth = displayedMonth else {
            return
        }
        guard displayedMonth.isLastDisplayableMonth == false else {
            return
        }
        let scrollPosition: ScrollPosition = self.configuration.layoutBehavior.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        let indexPath = IndexPath(row: 0, section: displayedMonth.index + 1)
        self.scrollToItem(at: indexPath, at: scrollPosition, animated: animate)
        let nextMonth = self.months[indexPath.section]
        calendarDelegate?.calendar(self, didMonthChange: nextMonth)
    }
    
    /// Scrolls the calendar to the previous month.
    /// - Note: If this is called when the `isFirstDisplayableMonth` for the ``displayedMonth`` is `true`, the calendar will not scroll.
    /// - Parameter animate: A boolean value indicating whether to apply scrolling animation or not. Default is true.
    public func moveToPreviousMonth(animate: Bool = true) {
        guard let displayedMonth = displayedMonth else {
            return
        }
        guard displayedMonth.isFirstDisplayableMonth == false else {
            return
        }
        let scrollPosition: ScrollPosition = self.configuration.layoutBehavior.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        let indexPath = IndexPath(row: 0, section: displayedMonth.index - 1)
        self.scrollToItem(at: indexPath, at: scrollPosition, animated: animate)
        let previousMonth = self.months[indexPath.section]
        calendarDelegate?.calendar(self, didMonthChange: previousMonth)
    }
    
    /// Scrolls the calendar to the specified date.
    /// - Parameters:
    ///   - date: The date to scroll to.
    ///   - animate: A boolean value indicating whether to apply scrolling animation or not. Default is true.
    /// - Note: If the given date is not within calendar range, the calendar will not scroll.
    public func moveTo(date: Date, animate: Bool = true) {
        let startOfDay = configuration.calendar.startOfDay(for: date)
        guard let indexTuple = self.months.map({ $0.days }).enumerated().compactMap({ enumeratedArray -> (sectionIndex: Int, rowIndex: Int)? in
            guard let dayIndex = enumeratedArray.element.firstIndex(where: { $0.date == startOfDay && $0.isWithinDisplayedMonth }) else {
                return nil
            }
            return (enumeratedArray.offset, dayIndex)
        }).first else {
            return
        }
        let indexPath = IndexPath(row: indexTuple.rowIndex, section: indexTuple.sectionIndex)
        let scrollPosition: ScrollPosition = self.configuration.layoutBehavior.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        self.scrollToItem(at: indexPath, at: scrollPosition, animated: animate)
        let month = self.months[indexPath.section]
        calendarDelegate?.calendar(self, didMonthChange: month)
    }
    
    /// Scrolls the calendar to the specified month.
    /// - Parameters:
    ///   - month: The name of the month to scroll to.
    ///   - offset: This specifies the ith iteration of the given month to scroll to.
    ///   Ex: If you have given `startDate` and `endDate` such that the range is 5 years, it means there will be 5 number of january iterations inside this range.
    ///   If you give the offset as 2 and month as january, the calendar will scroll to the 2nd iteration of january out of those 5 iterations.
    ///   - animate: A boolean value indicating whether to apply scrolling animation or not. Default is true.
    /// - Note: If the month is not within calendar range, the calendar will not scroll.
    /// - Important: The offset is always positive.
    public func moveTo(month: MonthsOfYear, @Positive offset: Int = 0, animate: Bool = true) {
        let indicesOfMonth = self.months.enumerated().filter({ $0.element.name == month }).map({ $0.offset })
        guard indicesOfMonth.count > offset - 1, self.months.count > indicesOfMonth[offset - 1] else {
            return
        }
        let sectionIndex = indicesOfMonth[offset - 1]
        let indexPathForMonth = IndexPath(row: 0, section: sectionIndex)
        let scrollPosition: ScrollPosition = self.configuration.layoutBehavior.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        self.scrollToItem(at: indexPathForMonth, at: scrollPosition, animated: animate)
        let month = self.months[indexPathForMonth.section]
        calendarDelegate?.calendar(self, didMonthChange: month)
    }

    /// Scrolls the calendar to the specified year.
    /// - Parameters:
    ///   - year: The year to scroll to.
    ///   - animate: A boolean value indicating whether to apply scrolling animation or not. Default is true.
    /// - Note: If the year provided is not within calendar range, the calendar will not scroll.
    public func moveTo(year: Int, animate: Bool = true) {
        guard let sectionIndex = self.months.firstIndex(where: { $0.year == year }) else {
            return
        }
        let indexPathForMonth = IndexPath(row: 0, section: sectionIndex)
        let scrollPosition: ScrollPosition = self.configuration.layoutBehavior.scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically
        self.scrollToItem(at: indexPathForMonth, at: scrollPosition, animated: animate)
        let month = self.months[indexPathForMonth.section]
        calendarDelegate?.calendar(self, didMonthChange: month)
    }
    
    //MARK: UICOLLECTIONVIEW DELEGATE & DATASOURCE
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        months[section].days.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        months.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = months[indexPath.section].days[indexPath.row]
        return calendarDataSource?.calendar(self, cellForItemAt: indexPath, day: day) ?? UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let month = months[indexPath.section]
        return calendarDataSource?.calendar(self, viewForSupplementaryElementOfKind: kind, at: indexPath, for: month) ?? UICollectionReusableView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = self.months[indexPath.section].days[indexPath.row]
        calendarDelegate?.calendar(self, didSelectDay: day, in: indexPath)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let displayedMonth = displayedMonth else {
            return
        }
        calendarDelegate?.calendar(self, didMonthChange: displayedMonth)
    }
    
    //MARK: DATE GENERATION
    
    private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        let range = configuration.calendar.range(of: .day, in: .month, for: baseDate)
        guard let numberOfDaysInMonth = range?.count, let interval = configuration.calendar.dateInterval(of: .month, for: baseDate) else {
            throw CalendarDataError.metadataGeneration
        }
        let firstDayOfMonth = interval.start
        let lastDayOfMonth = interval.end
        var firstDayWeekday = configuration.calendar.component(.weekday, from: firstDayOfMonth) + 1 - configuration.calendar.firstWeekday
        if firstDayWeekday <= 0 { //To accommodate different firstweekdays.
            firstDayWeekday = 7 - abs(firstDayWeekday)
        }
        return MonthMetadata(numberOfDays: numberOfDaysInMonth, firstDay: firstDayOfMonth, lastDay: lastDayOfMonth, firstDayWeekday: firstDayWeekday)
    }
    
    private func generateMonths(from startDate: Date, to endDate: Date) -> [CalendarMonth] {
        let differenceComponents = configuration.calendar.dateComponents([.month], from: configuration.startDate, to: configuration.endDate)
        let numberOfMonths = differenceComponents.month! + 1
        var months: [CalendarMonth] = []
        var monthNameIndex = configuration.calendar.component(.month, from: configuration.startDate) - 1
        for index in 0..<numberOfMonths {
            guard let currentMonthDate = configuration.calendar.date(byAdding: .month, value: index, to: configuration.startDate) else {
                continue
            }
            guard let metadata = try? monthMetadata(for: currentMonthDate) else {
                preconditionFailure("An error occurred when generating the metadata for \(currentMonthDate)")
            }
            let currentYear = configuration.calendar.component(.year, from: currentMonthDate)
            let days = generateDaysInMonth(for: currentMonthDate, with: metadata)
            let month = CalendarMonth(name: MonthsOfYear.allCases[monthNameIndex], number: MonthsOfYear.allCases[monthNameIndex].rawValue, index: index, days: days, year: currentYear, metaData: metadata, isFirstDisplayableMonth: index == 0, isLastDisplayableMonth: index == numberOfMonths - 1)
            months.append(month)
            monthNameIndex += 1
            if monthNameIndex > 11 { monthNameIndex = 0 }
        }
        return months
    }

    private func generateDaysInMonth(for baseDate: Date, with metaData: MonthMetadata) -> [CalendarDay] {
        let numberOfDaysInMonth = metaData.numberOfDays
        let offsetInInitialRow = metaData.firstDayWeekday
        let firstDayOfMonth = metaData.firstDay
        var days: [CalendarDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        
        if configuration.fillNextMonthDates {
            days += generateStartOfNextMonth(using: firstDayOfMonth)
        }
        
        return days
    }
    
    private func generateDay(offsetBy dayOffset: Int, for baseDate: Date, isWithinDisplayedMonth: Bool) -> CalendarDay {
        let date = configuration.calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        return CalendarDay(date: date, number: dateFormatter.string(from: date), isToday: configuration.calendar.isDate(date, inSameDayAs: Date()), isWithinDisplayedMonth: isWithinDisplayedMonth)
    }

    private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [CalendarDay] {
        guard let lastDayInMonth = configuration.calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfDisplayedMonth) else {
            return []
        }
        var additionalDays = 7 - configuration.calendar.component(.weekday, from: lastDayInMonth) - 1 + (configuration.calendar.firstWeekday)
        if additionalDays >= 7 { //To accommodate different firstweekdays.
            additionalDays = abs(7 - additionalDays)
        }
        guard additionalDays > 0 else {
            return []
        }
        let days: [CalendarDay] = (1...additionalDays).map {
            generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)
        }
        return days
    }
    
    //MARK: DEFAULT LAYOUT GENERATION

    private func defaultLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = self.configuration.layoutBehavior.scrollDirection
        
        if self.configuration.layoutBehavior.scrollBehavior == .month {
            self.isPagingEnabled = true
        }
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 7.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let numberOfWeeks = self.numberOfWeeks(for: sectionIndex)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0 / numberOfWeeks))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                         heightDimension: .fractionalHeight(1.0))
            let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize,
                                                               subitems: [group])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .estimated(100))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                            elementKind: CalendarHeaderView.elementKind,
                                                                            alignment: .top)
            
            if #available(iOS 16.0, *) {
                section.supplementaryContentInsetsReference = .automatic
            } else {
                section.supplementariesFollowContentInsets = false
            }
            if self.configuration.layoutBehavior.scrollDirection == .horizontal {
                section.contentInsets = .init(top: 100, leading: 0, bottom: 0, trailing: 0)
            }
            section.boundarySupplementaryItems = [sectionHeader]
            return section
            
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}
