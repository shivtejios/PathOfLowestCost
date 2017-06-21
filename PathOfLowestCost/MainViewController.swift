//
//  MainViewController.swift
//  PathOfLowestCost
//
//  Created by Shiva Teja Celumula on 6/20/17.
//  Copyright © 2017 Photon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var displayTextView: UITextView!
    
    //    let matrixArray = [[3, 6, 5, 8], [4, 1, 9, 4], [1, 8, 3, 1], [2, 2, 9, 3], [8, 7, 9, 2]]

    var matrixArray:[[Int]] = []
    var noOfColumns = 0
    var noOfRows = 0
    var totalCost:Int = 0
    var resultPathIndexArray:[Int] = []
    var resultPathValueArray:[Int] = []
    let MaxAllowedCost = 50
    var isSuccess:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findPath()
        // Do any additional setup after loading the view.
    }
    
    func findPath() {
        
        if noOfColumns == 1 {
            singleColumn()
        } else if noOfRows == 1 {
            singleRow()
        } else {
            multipleRowsAndColumns()
        }
    }
    
    func isPathSuccess() -> Bool {
        let totalCostValue = resultPathValueArray.reduce(0, +)
        
        if totalCostValue > MaxAllowedCost || resultPathValueArray.count != noOfColumns{
            isSuccess = false
        } else {
            isSuccess = true
        }
        return isSuccess
    }
    
    func singleRow() {
        for cost in matrixArray {
            totalCost += cost[0]
            if totalCost>50 {
                totalCost -= cost[0]
                isSuccess = false
                break
            } else {
                resultPathValueArray.append(cost[0])
            }
        }
        resultPathIndexArray = Array(repeating: noOfRows, count: resultPathValueArray.count)
        printResults()
    }
    
    func singleColumn() {
        if let cost = matrixArray.first?.min() {
            totalCost = cost
            resultPathValueArray.append(cost)
        }
        if let index = matrixArray.first?.index(of: totalCost) {
            resultPathIndexArray.append(index+1)
        }
        
        printResults()
    }
    
    func multipleRowsAndColumns() {
        
        var columnIndex = 0
        var evaluationArray:[Int] = matrixArray[columnIndex]
        var tempArray:[Int] = matrixArray[columnIndex]
        
        repeat {
            
            if let lowestCost =  evaluationArray.min(),  let lowestCostRowIndex = matrixArray[columnIndex].index(of:lowestCost) {
                if columnIndex == 0 {
                    resultPathValueArray.append(lowestCost)
                    resultPathIndexArray.append(lowestCostRowIndex)
                }
                
                let topNextValue = matrixArray[columnIndex+1][lowestCostRowIndex-1]
                let nextValue = matrixArray[columnIndex+1][lowestCostRowIndex]
                let bottomNextValue = matrixArray[columnIndex+1][lowestCostRowIndex+1]
                evaluationArray = [topNextValue, nextValue, bottomNextValue]
                
                if let lowerCost = evaluationArray.min(), let lowerCostRowIndex = matrixArray[columnIndex+1].index(of: lowerCost) {
                    resultPathValueArray.append(lowerCost)
                    resultPathIndexArray.append(lowerCostRowIndex)
                }
            }
            columnIndex += 1
            print("columnIndex : \(columnIndex)")
        } while columnIndex < noOfColumns
    }
    
    func printResults() {
        print("Path success : \(isPathSuccess())\nTotal Cost : \(totalCost)\nPath : \(resultPathIndexArray)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func enterData(_ sender: Any) {
        if let columnIntArray = dateTextField.text?.components(separatedBy: ",").flatMap({ Int($0) })  {
            matrixArray.append(columnIntArray)
            if noOfColumns == 0 {
                noOfRows = matrixArray[noOfColumns].count
            }
//            matrixArray[noOfColumns] = columnIntArray
            if matrixArray[noOfColumns].count != noOfRows {
                isSuccess = false
                printResults()
                return
            }
            noOfColumns += 1
        }
        
        displayTextView.text = "\(matrixArray)"
    }
    
    
    @IBAction func FindPath(_ sender: Any) {
        findPath()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
