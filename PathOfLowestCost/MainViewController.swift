//
//  MainViewController.swift
//  PathOfLowestCost
//
//  Created by Shiva Teja Celumula on 6/20/17.
//  Copyright © 2017 Photon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var displayTextView: UITextView!
    
    @IBOutlet weak var IsCompletePathLbl: UILabel!
    @IBOutlet weak var totalCostLbl: UILabel!
    @IBOutlet weak var pathLbl: UILabel!
    
    var matrixArray:[[Int]] = []
    var noOfColumns = 0
    var noOfRows = 0
    var totalCost:Int = 0
    var resultPathIndexArray:[Int] = []
    var resultPathValueArray:[Int] = []
    let MaxAllowedCost = 50
    var isSuccess:Bool = false
    var lowestCostRowIndex = 0
    
    // MARK: - View life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Path of lowest cost methods
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
        
        if totalCostValue > MaxAllowedCost || resultPathValueArray.count != noOfColumns || resultPathValueArray.first == 0 {
            isSuccess = false
        } else {
            isSuccess = true
        }
        return isSuccess
    }
    
    func totalPathCost() -> Int{
        return resultPathValueArray.reduce(0, +)
    }
    
    // MARK: - Different scenarios of matrices
    func singleRow() {
        for cost in matrixArray {
            totalCost += cost[0]
            if totalCost>MaxAllowedCost {
                totalCost -= cost[0]
                isSuccess = false
                break
            } else {
                resultPathValueArray.append(cost[0])
            }
        }
        resultPathIndexArray = Array(repeating: noOfRows, count: resultPathValueArray.count)
        displayResults()
    }
    
    func singleColumn() {
        if let cost = matrixArray.first?.min() {
            totalCost = cost
            if totalCost > MaxAllowedCost {
                totalCost = 0
                resultPathValueArray.append(0)
            } else {
                if let index = matrixArray.first?.index(of: totalCost) {
                    resultPathIndexArray.append(index+1)
                }
                resultPathValueArray.append(cost)
            }
        }
        displayResults()
    }
    
    func multipleRowsAndColumns() {
        
        var columnIndex = 0
        var evaluationValueArray:[Int] = matrixArray[columnIndex]
        var evaluationIndexArray:[Int]
        
        repeat {
            if let lowestCost =  evaluationValueArray.min()   {
                if totalPathCost() < MaxAllowedCost {
                    if columnIndex == 0 {
                        if let lowestCostIndex = matrixArray[columnIndex].index(of:lowestCost) { lowestCostRowIndex =  lowestCostIndex}
                        resultPathValueArray.append(lowestCost)
                        resultPathIndexArray.append(lowestCostRowIndex+1)
                    } else {
                        if lowestCostRowIndex == 0 {
                            let topNextValue = matrixArray[columnIndex][noOfRows-1]
                            let centerNextValue = matrixArray[columnIndex][lowestCostRowIndex]
                            let bottomNextValue = matrixArray[columnIndex][lowestCostRowIndex+1]
                            
                            evaluationValueArray = [topNextValue, centerNextValue, bottomNextValue]
                            evaluationIndexArray = [noOfRows-1, lowestCostRowIndex, lowestCostRowIndex+1]
                        } else if lowestCostRowIndex == (noOfRows - 1) {
                            let topNextValue = matrixArray[columnIndex][lowestCostRowIndex-1]
                            let centerNextValue = matrixArray[columnIndex][lowestCostRowIndex]
                            let bottomNextValue = matrixArray[columnIndex][0]
                            
                            evaluationValueArray = [topNextValue, centerNextValue, bottomNextValue]
                            evaluationIndexArray = [lowestCostRowIndex-1, lowestCostRowIndex, 0]
                        } else {
                            let topNextValue = matrixArray[columnIndex][lowestCostRowIndex-1]
                            let centerNextValue = matrixArray[columnIndex][lowestCostRowIndex]
                            let bottomNextValue = matrixArray[columnIndex][lowestCostRowIndex+1]
                            
                            evaluationValueArray = [topNextValue, centerNextValue, bottomNextValue]
                            evaluationIndexArray = [lowestCostRowIndex-1, lowestCostRowIndex, lowestCostRowIndex+1]
                        }
                        
                        if let lowerCost = evaluationValueArray.min(), let evaluationIndex = evaluationValueArray.index(of: lowerCost) {
                            lowestCostRowIndex = evaluationIndexArray[evaluationIndex]
                            resultPathValueArray.append(lowerCost)
                            resultPathIndexArray.append(lowestCostRowIndex+1)
                        }
                    }
                } else {
                    resultPathIndexArray.removeLast()
                    resultPathValueArray.removeLast()
                    break
                }
                columnIndex += 1
            }
        } while columnIndex < noOfColumns
        
        displayResults()
    }
    
    //MARK: - Display results
    func displayResults() {
        print("Path success : \(isPathSuccess())\nTotal Cost : \(totalPathCost())\nPath : \(resultPathIndexArray)")
        
        IsCompletePathLbl.text = isPathSuccess().description
        totalCostLbl.text = totalPathCost().description
        pathLbl.text = "\(resultPathIndexArray)"
    }
    
    // MARK: - Validate the entered test
    func checkForAlphabets(enteredString:String) -> Bool {
        
        let letters = CharacterSet.letters
        let digits = CharacterSet.decimalDigits
        
        var letterCount = 0
        var digitCount = 0
        
        for uni in enteredString.unicodeScalars {
            if letters.contains(uni) {
                letterCount += 1
            } else if digits.contains(uni) {
                digitCount += 1
            }
        }
        if letterCount > 0 {
            return false
        } else {
            return true
        }
    }
    
    // MARK:- IBAction Methods
    @IBAction func enterData(_ sender: Any) {
        
        if let enteredText = dataTextField.text {
            if checkForAlphabets(enteredString: enteredText) && !enteredText.isEmpty {
                let columnIntArray = enteredText.components(separatedBy: ",").flatMap({ Int($0) })
                matrixArray.append(columnIntArray)
                if noOfColumns == 0 {
                    noOfRows = matrixArray[noOfColumns].count
                }
                if matrixArray[noOfColumns].count != noOfRows {
                    let alert = UIAlertController(title: "Please enter same number of row values for all columns", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    matrixArray.removeLast()
                    dataTextField.text = ""
                    return
                }
                noOfColumns += 1
                displayTextView.text = "\(matrixArray)"
            } else {
                let alert = UIAlertController(title: "Please enter valid values", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        dataTextField.text = ""
    }
    
    @IBAction func findPath(_ sender: Any) {
        findPath()
    }
}

