//
//  EditWorkoutExercisesTableViewController.swift
//  Routine
//
//  Created by Umar Qattan on 1/1/18.
//  Copyright © 2018 Umar Qattan. All rights reserved.
//

import UIKit

class EditWorkoutExercisesTableViewController: UITableViewController {

    @IBOutlet weak var saveExerciseButton: UIButton!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var repsField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var setsField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    
    var exercise:Exercise!
    var workout:Workout!
    var cancelButtonTapped:Bool = false
    var activeTextField:UITextField? = nil
    var activeTextView:UITextView? = nil
    
    lazy var appDelegate:AppDelegate = {
        return UIApplication.shared.delegate as! AppDelegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        weightField.delegate = self
        setsField.delegate = self
        repsField.delegate = self
        notesTextView.delegate = self
        
        nameLabel.text = exercise.name
        addDoneButtonOnKeyboard()
        
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        cancelButtonTapped = true
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveExercise(_ sender: UIButton) {
        
        //exercise = workout.exercises.filter({$0.name.capitalized == exercise.name}).first!
        
        guard let oldWorkout = appDelegate.workouts.filter({$0 == workout}).first else {
            
            exercise.weight = Float(weightField.text!.components(separatedBy: [" "]).first!)!
            exercise.sets = Int(setsField.text!)!
            exercise.reps = Int(repsField.text!)!
            exercise.notes = notesTextView.text
            
            let defaults = UserDefaults.standard
            let encodedWorkouts = NSKeyedArchiver.archivedData(withRootObject: appDelegate.workouts)
            defaults.set(encodedWorkouts, forKey: "Workouts")
            defaults.synchronize()
            
            navigationController?.popViewController(animated: true)
            
            return
        }
        let newWorkout = oldWorkout
        
        
        
        exercise.weight = Float(weightField.text!.components(separatedBy: [" "]).first!)!
        exercise.sets = Int(setsField.text!)!
        exercise.reps = Int(repsField.text!)!
        exercise.notes = notesTextView.text
        
        newWorkout.exercises[oldWorkout.exercises.index(of: exercise)!] = exercise
        _ = appDelegate.workouts.remove(at: appDelegate.workouts.index(of: oldWorkout)!)
        appDelegate.workouts.append(newWorkout)
        
        let defaults = UserDefaults.standard
        let encodedWorkouts = NSKeyedArchiver.archivedData(withRootObject: appDelegate.workouts)
        defaults.set(encodedWorkouts, forKey: "Workouts")
        defaults.synchronize()
        
        navigationController?.popViewController(animated: true)
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
        
        notesTextView.inputAccessoryView = doneToolbar
        weightField.inputAccessoryView = doneToolbar
        setsField.inputAccessoryView = doneToolbar
        repsField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        if let activeTextField = activeTextField {
            activeTextField.resignFirstResponder()
        }
        
        if let activeTextView = activeTextView {
            activeTextView.resignFirstResponder()
        }
        
        if weightField.text! != "" && setsField.text! != "" && repsField.text! != ""  && notesTextView.text != "" {
            saveExerciseButton.isEnabled = true
        } else {
            saveExerciseButton.isEnabled = false
        }
        
    }
}

extension EditWorkoutExercisesTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == weightField {
            textField.text! += " lbs"
        }
        
        activeTextField = nil
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//
//        return true
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text! = ""
        activeTextField = textField
    }
    
    

}

extension EditWorkoutExercisesTableViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    
    
}

extension EditWorkoutExercisesTableViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if cancelButtonTapped {
            return
        }
        
    }
    
    
    
}
