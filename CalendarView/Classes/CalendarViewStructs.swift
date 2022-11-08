//
//  CalendarViewStructs.swift
//  CalendarView
//
//  Created by Yuvaraj on 08/11/22.
//

import Foundation

/// The configuration for ``CalendarView``.
public struct CalendarViewConfiguration {
    /// Setting this to `true` will generate start of the next month, so that the section is fully filled with days.
    public let fillNextMonthDates: Bool
    
    /// Defines the layout behavior. If layout is `nil`, this will also modify the default layout of ``CalendarView``.
    public let layoutBehavior: LayoutBehavior
    
    /// The layout for `CalendarView` to use.
    public var layout: UICollectionViewLayout? = nil
    
    /// The calendar for `CalendarView` to use.
    public let calendar: Calendar
    
    /// The starting date for date generation of ``CalendarView``.
    public let startDate: Date
    
    /// The ending date for date generation of ``CalendarView``.
    public let endDate: Date
    
    /// The default configuration.
    public static var DefaultConfiguration: CalendarViewConfiguration {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: startDate)!
        return CalendarViewConfiguration(fillNextMonthDates: true,
                                         layoutBehavior: .Default,
                                         layout: nil, calendar: Calendar.current,
                                         startDate: startDate,
                                         endDate: endDate)
    }
}

/// The behavior of layout.
public struct LayoutBehavior {
    /// The scroll direction of ``CalendarView``.
    public let scrollDirection: UICollectionView.ScrollDirection
    
    
    /// The scroll behavior of ``CalendarView``.
    public let scrollBehavior: ScrollingBehavior
    
    
    /// The default behavior.
    public static var Default: LayoutBehavior {
        return LayoutBehavior(scrollDirection: .horizontal, scrollBehavior: .month)
    }
}

/// Meta-data for ``CalendarMonth``.
public struct MonthMetadata {
    /// The actual number of days.
    /// - Note: This doesn't include pre or post fill dates.
    public let numberOfDays: Int
    
    
    /// The first day in the month.
    /// - Note: This will be the date with the end time of previous month. e.g., if current month is January, then this will be, 31st Decemember 24:00. i.e., the ``lastDay`` of the previous month. To perform calculations with this use `datecomponents` method, do not use any date formatters or add a day to this value.
    public let firstDay: Date
    
    /// The last day of the month.
    /// - Note: This will be the date with the end time of the current month. i.e., this will be the ``firstDay`` of the next month. To perform calculations with this use `datecomponents` method, do not use any date formatters or add a day to this value.
    public let lastDay: Date
    
    /// The value of first week day of the month. This determines how many days to generate from previous month.
    public let firstDayWeekday: Int
}

/// The day data for ``CalendarView``.
public struct CalendarDay {
    /// The date of the day.
    /// - Note: This will the end time of the previous day. i.e., if current date is 1st January, this will be 31st December 24:00. To perform calculations with this use `datecomponents` method, do not use any date formatters, or add a day to this value.
    public let date: Date
    
    /// The date number in string format. Though the `Date` value is end of time of previous day, this is calculated by adding 1 day to the `Date`.
    public let number: String
    
    /// A boolean value indicating whether this is the current day or not.
    public let isToday: Bool
    
    /// A boolean value indicating whether this belongs to the currently displayed month or not.
    public let isWithinDisplayedMonth: Bool
}


/// The month data for ``CalendarView``.
/// - Note: All date values inside this will be the end time of the day. i.e., 24:00.
public struct CalendarMonth {
    /// The name of the month.
    public let name: MonthsOfYear
    
    /// The number of the month ranging from 1 to 12.
    public let number: Int
    
    /// The index of the month.
    /// - Note: This is not the actual month number (1 - 12), rather, the positional value in the total number of months the ``CalendarView`` uses. If you want the month number in laymen terms, use ``number`` instead.
    public let index: Int
    
    /// The array of ``CalendarDay`` for this month.
    /// - Note: This also includes pre and post generated days.
    public let days: [CalendarDay]
    
    /// The year this month belongs to.
    public let year: Int
    
    /// The meta-data of this month.
    public let metaData: MonthMetadata
    
    /// A boolean value indicating whether this is the first month in the generated range or not.
    public let isFirstDisplayableMonth: Bool
    
    /// A boolean value indicating whether this is the last month in the generated range or not.
    public let isLastDisplayableMonth: Bool
}

public enum ScrollingBehavior {
    case continous
    case month
}

public enum CalendarDataError: Error {
    case metadataGeneration
}

public enum MonthsOfYear: Int, CaseIterable {
    case january, february, march, april, may, june, july, august, september, october, november, december
}

public enum Day {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

@propertyWrapper
public struct Positive {
    public var wrappedValue: Int {
        didSet {
            wrappedValue = abs(wrappedValue)
            
        }
    }
    
    public init(wrappedValue: Int) {
        self.wrappedValue = abs(wrappedValue)
    }
}
