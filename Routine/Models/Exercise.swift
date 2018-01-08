//
//  Exercise.swift
//  Routine
//
//  Created by Umar Qattan on 12/24/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import Foundation

class Exercise: NSObject, NSCoding {
    var name:String
    var weight:Float
    var sets:Int
    var reps:Int
    var notes:String
    
    
    init(name: String, weight:Float, sets:Int, reps: Int, notes:String) {
        self.name = name
        self.weight = weight
        self.sets = sets
        self.reps = reps
        self.notes = notes
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "exercise_name") as! String
        self.weight = aDecoder.decodeFloat(forKey: "exercise_weight")
        self.sets = aDecoder.decodeInteger(forKey: "exercise_sets")
        self.reps = aDecoder.decodeInteger(forKey: "exercise_reps")
        self.notes = aDecoder.decodeObject(forKey: "exercise_notes") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "exercise_name")
        aCoder.encode(weight, forKey: "exercise_weight")
        
        aCoder.encode(sets, forKey: "exercise_sets")
        aCoder.encode(reps, forKey: "exercise_reps")
        aCoder.encode(notes, forKey: "exercise_notes")
    }
}

