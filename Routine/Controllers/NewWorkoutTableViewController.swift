//
//  NewWorkoutTableViewController.swift
//  Routine
//
//  Created by Umar Qattan on 12/27/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import UIKit

class NewWorkoutTableViewController: UITableViewController, SelectMusclesDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var addExerciseButton: UIButton!
    @IBOutlet weak var musclesContainerView: UIView!
    
    var newWorkout:Workout!
    var selectedDate:Date?
    let pickerView = UIDatePicker()
    let musclesPickerView = UIPickerView()
    
    let body = Body()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        
        nameField.delegate = self
        dateField.delegate = self
        

        musclesPickerView.delegate = self
        addExerciseButton.isEnabled = false
        
        addDoneButtonOnKeyboard()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewWorkout))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    @objc dynamic func cancelNewWorkout() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc dynamic func finishedSelectingDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        let date = dateFormatter.string(from: pickerView.date)
        self.dateField.text = date
        self.dateField.resignFirstResponder()
    }
    
//    @objc dynamic func finishedSelectingPrimaryMuscle() {
//        let muscle = body.names[musclesPickerView.selectedRow(inComponent: 0)]
//        primaryMuscleField.text = muscle
//        primaryMuscleField.resignFirstResponder()
//    }
//
//    @objc dynamic func finishedSelectingSecondaryMuscle() {
//        let muscle = body.names[musclesPickerView.selectedRow(inComponent: 0)]
//        secondaryMuscleField.text = muscle
//        secondaryMuscleField.resignFirstResponder()
//    }
    
    @IBAction func addExercises(_ sender: UIButton) {
        performSegue(withIdentifier: "NewWorkoutExercisesSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "MusclesSegue" {
            let vc = segue.destination as! MusclesTableViewController
            vc.musclesDelegate = self
        }
        
        if let identifier = segue.identifier, identifier == "NewWorkoutExercisesSegue" {
            let vc = segue.destination as! MusclesViewController
            newWorkout.name = nameField.text!
            newWorkout.date = dateField.text!
            vc.workout = newWorkout
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func sendSelectedMusclesToNewWorkoutTableViewController(muscles: [String]) {
        
        if muscles.count > 0 && nameField.text! != "" && dateField.text! != "" {
            newWorkout = Workout(name: nameField.text!, muscles: muscles, exercises: [], date: dateField.text!)
            addExerciseButton.isEnabled = true
        } else {
            addExerciseButton.isEnabled = false
        }
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y:0, width:320, height:44))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        
        
        var items:[UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        nameField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        nameField.resignFirstResponder()
    }
    
}

extension NewWorkoutTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return body.names.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return body.names[row]
    }
}

extension NewWorkoutTableViewController: UITextFieldDelegate {
    
    func configureDateTextFieldInputView(textField: UITextField) {
        pickerView.datePickerMode = .date
        textField.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        toolBar.tintColor = UIColor.gray
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finishedSelectingDate))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: true)
        textField.inputAccessoryView = toolBar
    }
    
    func configureMuscleTextFieldInputView(textField: UITextField) {
        
        textField.inputView = musclesPickerView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        toolBar.tintColor = UIColor.gray
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: true)
        textField.inputAccessoryView = toolBar
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateField {
            configureDateTextFieldInputView(textField: textField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
