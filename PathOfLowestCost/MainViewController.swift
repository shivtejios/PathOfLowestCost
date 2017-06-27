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
    
    let lowestCost = LowestCostCalculator()
    var noOfColumns = 0
    var noOfRows = 0
    var resultPathIndexArr = [Int]()
    lazy var matrixArray: [[Int]] = {
        return LowestCostCalculator().matrixArray
    }()
    
    // MARK: - View life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Display results
    func displayResults() {
        print("Path success : \(lowestCost.isPathSuccess())\nTotal Cost : \(lowestCost.totalPathCost())\nPath : \(resultPathIndexArr)")
        
        IsCompletePathLbl.text = lowestCost.isPathSuccess().description
        totalCostLbl.text = lowestCost.totalPathCost().description
        pathLbl.text = "\(resultPathIndexArr)"
    }
    
    // MARK: - Validate the entered test
    func checkForAlphabets(enteredString:String) -> Bool {
        let letters = CharacterSet.letters
        let digits = CharacterSet.decimalDigits
        
        var letterCount = 0
        var digitCount = 0
        // Check for the number of letter and digits in the entered text
        for uni in enteredString.unicodeScalars {
            if letters.contains(uni) {
                letterCount += 1
            } else if digits.contains(uni) {
                digitCount += 1
            }
        }
        // If any letters are found, return false, else true
        if letterCount > 0 {
            return false
        } else {
            return true
        }
    }
    
    // Set LowestCostCalculator variables with local variables
    func setVariables() {
        lowestCost.numberOfColumns = noOfColumns
        lowestCost.numberOfRows = noOfRows
        lowestCost.matrixArray = matrixArray
    }
    
    // Clear all the data
    func clearData() {
        noOfRows = 0
        noOfColumns = 0
        matrixArray = []
        lowestCost.clearData()
    }
    
    // MARK:- IBAction Methods
    // IBAction for data entry
    @IBAction func enterData(_ sender: Any) {
        if let enteredText = dataTextField.text {
            // Check for alphabets, non-numeric characters and if entered text is empty. If not show alert
            if checkForAlphabets(enteredString: enteredText) && !enteredText.isEmpty {
                // Make an array of Ints with entered comma seperated text
                let columnIntArray = enteredText.components(separatedBy: ",").flatMap({ Int($0) })
                matrixArray.append(columnIntArray)
                if noOfColumns == 0 {
                    noOfRows = matrixArray[noOfColumns].count
                }
                // Check for entered rows are equal to that of first one, if not show alert
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
    // IBAction for finding lowest path
    @IBAction func findPath(_ sender: Any) {
        setVariables()
        resultPathIndexArr = lowestCost.findPath()
        displayResults()
        clearData()
    }
    
}

