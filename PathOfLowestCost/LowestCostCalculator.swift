//
//  LowestCostCalculator.swift
//  PathOfLowestCost
//
//  Created by Shiva Teja Celumula on 6/26/17.
//  Copyright © 2017 Photon. All rights reserved.
//

import Foundation

class LowestCostCalculator: NSObject {
    
    var matrixArray:[[Int]] = []
    var numberOfColumns = 0
    var numberOfRows = 0
    var totalCost:Int = 0
    var resultPathIndexArray:[Int] = []
    var resultPathValueArray:[Int] = []
    let MaxAllowedCost = 50
    var isSuccess:Bool = false
    var lowestCostRowIndex = 0
    
    //MARK:- Path of lowest cost methods
    func findPath() -> [Int]{
        
        if numberOfColumns == 1 /* Single column scenario*/ {
            singleColumn()
        } else if numberOfRows == 1 /* Single row scenario */ {
            singleRow()
        } else  /*Multiple rows and mutliple columns scenario*/{
            multipleRowsAndColumns()
        }
        return resultPathIndexArray
    }
    
    // Check for the successful path
    func isPathSuccess() -> Bool {
        
        let totalCostValue = resultPathValueArray.reduce(0, +)
        
        // Path is not successful :
        // 1. If total cost is more than maximum allowed cost
        // 2. If count of final path array is not same as the total number of columns and
        // 3. If first object of path array is zero
        if totalCostValue > MaxAllowedCost || resultPathValueArray.count != numberOfColumns || resultPathValueArray.first == 0 {
            isSuccess = false
        } else {
            isSuccess = true
        }
        return isSuccess
    }
    
    // Total path cost is sum of the values of path array
    func totalPathCost() -> Int{
        return resultPathValueArray.reduce(0, +)
    }
    
    // MARK: - All scenarios of matrices
    func singleRow() {
        for cost in matrixArray {
            // Total cost of singe row matrix will be sum of all values in that row
            totalCost += cost[0]
            // If totalCost is more than max allowed cost, remove last object from total cost and return false, else append it to path array
            if totalCost>MaxAllowedCost {
                totalCost -= cost[0]
                break
            } else {
                resultPathValueArray.append(cost[0])
            }
        }
        resultPathIndexArray = Array(repeating: numberOfRows, count: resultPathValueArray.count)
    }
    
    func singleColumn() {
        if let cost = matrixArray.first?.min() {
            totalCost = cost
            // If totalCost is more than max allowed cost, set tota lcost to zero and add zero to path array
            // Else append the (current index + 1) to path index array and cost to path value array
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
    }
    
    func multipleRowsAndColumns() {
        
        var columnIndex = 0
        var evaluationValueArray:[Int] = matrixArray[columnIndex]
        var evaluationIndexArray:[Int]
        
        // Iterate throughout the columns
        repeat {
            if let lowestCost =  evaluationValueArray.min()   {
                // Check for total cost for each iteration
                if totalPathCost() < MaxAllowedCost {
                    // For the first column
                    if columnIndex == 0 {
                        // lowestCostIndex is the index minimum value of first column
                        if let lowestCostIndex = matrixArray[columnIndex].index(of:lowestCost) {
                            lowestCostRowIndex =  lowestCostIndex
                        }
                        // Append lowest cost to path value array and (lowest index + 1) to path index array
                            resultPathValueArray.append(lowestCost)
                            resultPathIndexArray.append(lowestCostRowIndex+1)
                    } else /*For non-first columns*/ {
                        // If previous lowest cost index is zero, consider last object, first object and second object for the lowest cost path
                        if lowestCostRowIndex == 0 {
                            let topNextValue = matrixArray[columnIndex][numberOfRows-1]
                            let centerNextValue = matrixArray[columnIndex][lowestCostRowIndex]
                            let bottomNextValue = matrixArray[columnIndex][lowestCostRowIndex+1]
                            
                            evaluationValueArray = [topNextValue, centerNextValue, bottomNextValue]
                            evaluationIndexArray = [numberOfRows-1, lowestCostRowIndex, lowestCostRowIndex+1]
                        } else if lowestCostRowIndex == (numberOfRows - 1) /* If previous lowest cost index is last index, consider last object, last but one object and first object for the lowest cost path*/ {
                            let topNextValue = matrixArray[columnIndex][lowestCostRowIndex-1]
                            let centerNextValue = matrixArray[columnIndex][lowestCostRowIndex]
                            let bottomNextValue = matrixArray[columnIndex][0]
                            
                            evaluationValueArray = [topNextValue, centerNextValue, bottomNextValue]
                            evaluationIndexArray = [lowestCostRowIndex-1, lowestCostRowIndex, 0]
                        } else /* For all other indexes, consider top object, center object and bottom object for the lowest cost path*/ {
                            let topNextValue = matrixArray[columnIndex][lowestCostRowIndex-1]
                            let centerNextValue = matrixArray[columnIndex][lowestCostRowIndex]
                            let bottomNextValue = matrixArray[columnIndex][lowestCostRowIndex+1]
                            
                            evaluationValueArray = [topNextValue, centerNextValue, bottomNextValue]
                            evaluationIndexArray = [lowestCostRowIndex-1, lowestCostRowIndex, lowestCostRowIndex+1]
                        }
                        // Append lowest cost index to path index array and lowest value to path value array
                        if let lowerCost = evaluationValueArray.min(), let evaluationIndex = evaluationValueArray.index(of: lowerCost) {
                            lowestCostRowIndex = evaluationIndexArray[evaluationIndex]
                            resultPathValueArray.append(lowerCost)
                            resultPathIndexArray.append(lowestCostRowIndex+1)
                        }
                    }
                } else /* If total cost is more than maximum allowed cost */ {
                    resultPathIndexArray.removeLast()
                    resultPathValueArray.removeLast()
                    break
                }
                // Increment the current column index
                columnIndex += 1
            }
        } while columnIndex < numberOfColumns
    }
    
    // Clear local variables
    func clearData() {
        totalCost = 0
        matrixArray = []
        resultPathIndexArray = []
        resultPathValueArray = []
    }
}
