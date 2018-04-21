//
//  DiagramCell.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 28.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class DiagramCell: UICollectionViewCell, ARPieChartDelegate, ARPieChartItemDataSource {

    var pieChart: ARPieChart!
    var pieChartItems: [PieChartItem] = []
    var diagramDelegate: StatisticsVCDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pieChart = ARPieChart(frame: frame)
        pieChart.delegate = self
        pieChart.dataSource = self
        pieChart.showDescriptionText = true
        pieChart.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
        pieChart.translatesAutoresizingMaskIntoConstraints = false

        addSubview(pieChart)

        NSLayoutConstraint.activate([
            pieChart.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            pieChart.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            pieChart.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            pieChart.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: [Entry]) {
        pieChartItems.removeAll()
        
        for entry in data {
            let index = Int(entry.category!.colorIndex)
            let color = colors[index]
            pieChartItems.append(PieChartItem(value: Float(entry.amount), color: color, text: entry.category!.name))
        }
        
        sumByCategory()
        
        if pieChartItems.count == 0 {
            pieChartItems.append(PieChartItem(value: 1, color: .lightGray, text: NO_DATA_DIAGRAM_LABEL))
            pieChart.selectedPieOffset = 0
        } else if pieChartItems.count == 1 {
            pieChart.selectedPieOffset = 0
        } else {
            pieChart.selectedPieOffset = pieChart.innerRadius / 2.0
        }
        
        pieChart.outerRadius = (min(pieChart.frame.width, pieChart.frame.height) / 2) * 0.8
        pieChart.reloadData()
    }
    
    // MARK: - PieChart Delegate
    func pieChart(_ pieChart: ARPieChart, itemSelectedAtIndex index: Int) {
        if pieChartItems[index].text != NO_DATA_DIAGRAM_LABEL {
            diagramDelegate?.setAmount(category: pieChartItems[index].text!, amount: Double(pieChartItems[index].value))
        }
    }
    
    func pieChart(_ pieChart: ARPieChart, itemDeselectedAtIndex index: Int) {
        diagramDelegate?.hideAmount()
    }
    
    func numberOfSlicesInPieChart(_ pieChart: ARPieChart) -> Int {
        return pieChartItems.count
    }
    
    func pieChart(_ pieChart: ARPieChart, valueForSliceAtIndex index: Int) -> CGFloat {
        return CGFloat(pieChartItems[index].value)
    }
    
    func pieChart(_ pieChart: ARPieChart, colorForSliceAtIndex index: Int) -> UIColor {
        return pieChartItems[index].color
    }
    
    func pieChart(_ pieChart: ARPieChart, descriptionForSliceAtIndex index: Int) -> String {
        if let description = pieChartItems[index].text {
            return description
        }
        return ""
    }
    
    // MARK: - Supporting functions
    private func sumByCategory() {
        var tempItems: [PieChartItem] = []
        for item in pieChartItems {
            if !tempItems.contains(where: { $0.text == item.text }) {
                let filteredItems = pieChartItems.filter({ $0.text == item.text })
                let sum = filteredItems.reduce(0.0, { $0 + $1.value })
                let newItem = PieChartItem(value: sum, color: item.color, text: item.text)
                tempItems.append(newItem)
            }
        }
        pieChartItems = tempItems
    }
}
