//
//  CalendarCell.swift
//  CalendarView
//
//  Created by Yuvaraj on 09/11/22.
//

import Foundation
import UIKit

/// Default cell for ``CalendarView``.
public class CalendarCell: UICollectionViewCell {
    public static let reuseIdentifier = String(describing: CalendarCell.self)
    
    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .systemRed
        return view
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var accessibilityDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return dateFormatter
    }()
    
    private var isSmallScreenSize: Bool {
        let isCompact = traitCollection.horizontalSizeClass == .compact
        let smallWidth = UIScreen.main.bounds.width <= 350
        let widthGreaterThanHeight = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        
        return isCompact && (smallWidth || widthGreaterThanHeight)
    }
    
    public var day: CalendarDay? {
        didSet {
            guard let day = day else { return }
            numberLabel.text = day.number
            updateSelectionStatus()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(numberLabel)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.deactivate(selectionBackgroundView.constraints)
        
        let size = traitCollection.horizontalSizeClass == .compact ?
        min(min(frame.width, frame.height) - 10, 60) : 45
        
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
            selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor)
        ])
        
        selectionBackgroundView.layer.cornerRadius = size / 2
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutSubviews()
    }
    
    private func updateSelectionStatus() {
        guard let day = day else { return }
        
        if day.isToday {
            applySelectedStyle()
        } else {
            applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
        }
    }
    
    private func applySelectedStyle() {
        numberLabel.textColor = isSmallScreenSize ? .systemRed : .white
        selectionBackgroundView.isHidden = isSmallScreenSize
    }
    
    private func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
        numberLabel.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
        selectionBackgroundView.isHidden = true
    }
}
