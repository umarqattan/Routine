//
//  WorkoutExerciseTableViewCell.swift
//  Routine
//
//  Created by Umar Qattan on 12/26/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import UIKit

class WorkoutExerciseTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(exercise:Exercise) {
        nameLabel.text = exercise.name
        weightLabel.text = "\(exercise.weight)"
        setsLabel.text = "\(exercise.sets)"
        repsLabel.text = "\(exercise.reps)"
        notesTextView.text = exercise.notes
        print(notesTextView.text)
        print("Exercise Notes: \(exercise.notes)")
    }
    
    

}


