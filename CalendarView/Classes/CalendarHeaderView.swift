//
//  CalendarHeaderView.swift
//  CalendarView
//
//  Created by Yuvaraj on 09/11/22.
//

import Foundation
import UIKit

/// Default header for ``CalendarView``.
public class CalendarHeaderView: UICollectionReusableView {
    public static let reuseIdentifier = String(describing: CalendarHeaderView.self)
    public static let elementKind = "Default-Calender-Header"
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "\(self.month.name)"
        addSubview(label)
        return label
    }()
    
    private lazy var dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        addSubview(stackView)
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
        addSubview(view)
        return view
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
        return dateFormatter
    }()
    
    public var month: CalendarMonth! {
        didSet {
            self.monthLabel.text = "\(self.month.name)"
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        backgroundColor = .systemGroupedBackground
        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        layer.cornerCurve = .continuous
        layer.cornerRadius = 15
        for dayNumber in 1...7 {
            let dayLabel = UILabel()
            dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
            dayLabel.textColor = .secondaryLabel
            dayLabel.textAlignment = .center
            dayLabel.text = dayOfWeekLetter(for: dayNumber)
            dayOfWeekStackView.addArrangedSubview(dayLabel)
        }
    }
    
    private func dayOfWeekLetter(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "Su"
        case 2:
            return "Mo"
        case 3:
            return "Tu"
        case 4:
            return "We"
        case 5:
            return "Th"
        case 6:
            return "Fr"
        case 7:
            return "Sa"
        default:
            return ""
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            
            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -5),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
