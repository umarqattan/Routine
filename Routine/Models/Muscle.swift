//
//  BodyPart.swift
//  Routine
//
//  Created by Umar Qattan on 12/24/17.
//  Copyright © 2017 Umar Qattan. All rights reserved.
//

import Foundation

struct Body {
    var names:[String] = { return ["Chest", "Back", "Biceps", "Triceps", "Shoulders", "Quadriceps", "Hamstrings", "Glutes", "Abs", "Calves"].sorted() }()
}

class Muscle: NSObject, NSCoding {
    var name:String
    var exercises:[String]
    
    init(name:String, exercises:[String]) {
        self.name = name
        self.exercises = exercises
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "muscle_name") as! String
        self.exercises = aDecoder.decodeObject(forKey: "muscle_exercises") as! [String]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "muscle_name")
        aCoder.encode(exercises, forKey: "muscle_exercises")
    }
}
