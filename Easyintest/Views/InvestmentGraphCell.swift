//
//  InvestmentGraphCell.swift
//  Easyintest
//
//  Created by Gilson Gil on 20/03/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import Cartography
import Charts

final class InvestmentGraphCell: UITableViewCell {
  fileprivate lazy var lineChartView: LineChartView = {
    let chartView = LineChartView()
    chartView.rightAxis.enabled = false
    chartView.leftAxis.spaceBottom = 0
    chartView.leftAxis.granularity = 1
    chartView.leftAxis.axisMinimum = 0
    chartView.leftAxis.valueFormatter = PercentageAxisFormatter()
    chartView.leftAxis.axisLineColor = .clear
    chartView.leftAxis.labelTextColor = UIColor.easyGreyish
    
    chartView.xAxis.labelPosition = .bottom
    chartView.xAxis.granularity = 1
    chartView.xAxis.drawGridLinesEnabled = false
    chartView.xAxis.axisLineColor = .clear
    chartView.xAxis.labelTextColor = UIColor.easyGreyish
    chartView.chartDescription?.enabled = false
    chartView.drawMarkers = false
    chartView.highlighter = nil
    return chartView
  }()
  
  fileprivate var initialMonth: Int = 0
  fileprivate var initialYear: Int = 0
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setUp()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUp()
  }
  
  private func setUp() {
    addSubview(lineChartView)
    
    let margin = CGFloat(Constants.defaultMargin)
    constrain(lineChartView) { lineChartView in
      lineChartView.top == lineChartView.superview!.top + margin
      lineChartView.left == lineChartView.superview!.left + margin
      lineChartView.bottom == lineChartView.superview!.bottom - margin
      lineChartView.right == lineChartView.superview!.right - margin
      
      lineChartView.height == 220
    }
  }
}

// MARK: - Updatable
extension InvestmentGraphCell: Updatable {
  typealias ViewModel = InvestmentGraphViewModel
  
  func update(_ viewModel: InvestmentGraphViewModel) {
    initialMonth = Int((viewModel.x.first ?? "").components(separatedBy: "/").first ?? "") ?? 0
    initialYear = Int((viewModel.x.first ?? "").components(separatedBy: "/").last ?? "") ?? 0
    lineChartView.xAxis.valueFormatter = DateAxisFormatter(initialMonth: initialMonth, initialYear: initialYear)
    lineChartView.leftAxis.gridLineDashPhase = 2
    lineChartView.leftAxis.gridLineDashLengths = [4]
    lineChartView.leftAxis.gridColor = UIColor.easyGreyish
    var cdi = [ChartDataEntry]()
    var date: Double = 0
    viewModel.cdi.forEach {
      let data = ChartDataEntry(x: date, y: Double($0))
      cdi.append(data)
      date += 1
    }
    date = 0
    var fund = [ChartDataEntry]()
    viewModel.fund.forEach {
      let data = ChartDataEntry(x: date, y: Double($0))
      fund.append(data)
      date += 1
    }
    let cdiSet = LineChartDataSet(values: cdi, label: "CDI")
    cdiSet.colors = [UIColor.easyGraph1]
    cdiSet.drawValuesEnabled = false
    cdiSet.drawCirclesEnabled = false
    let fundSet = LineChartDataSet(values: fund, label: "FUND")
    fundSet.colors = [UIColor.easyGraph2]
    fundSet.drawValuesEnabled = false
    fundSet.drawCirclesEnabled = false
    let data = LineChartData(dataSets: [cdiSet, fundSet])
    lineChartView.data = data
    
    
    lineChartView.data?.notifyDataChanged()
    lineChartView.notifyDataSetChanged()
  }
}

final class DateAxisFormatter: NSObject, IAxisValueFormatter {
  let initialMonth: Int
  let initialYear: Int
  
  required init?(coder aDecoder: NSCoder) {
    return nil
  }
  
  init(initialMonth: Int, initialYear: Int) {
    self.initialMonth = initialMonth
    self.initialYear = initialYear
    super.init()
  }
  
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    let month = (initialMonth + Int(value)) % 12 + 1
    let year = (initialYear + Int((initialMonth + Int(value)) / 12))
    let dateString = String(format: "%2.d/%d", arguments: [month, year])
    
    return dateString
  }
}

final class PercentageAxisFormatter: NSObject, IAxisValueFormatter {
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return String(format: "%.0f%%", arguments: [value])
  }
}
