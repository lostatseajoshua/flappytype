//
//  TextGameModel.swift
//  Flappy Typing Test
//
//  Created by Joshua Alvarado on 11/24/15.
//  Copyright © 2015 Joshua Alvarado. All rights reserved.
//

import Foundation
import UIKit

class TextGameModel {
    
    var gameModelWords = [String]()
    
    private var phrasesToType = ["government","problem","different","important","special","monday","tuesday","rivermonsters","wednesday","thursday","friday","saturday","sunday","accoutrements","accessories","quickness","developer","keenness","judgment","insight","anomalistic","deviation","departure","phenomenal","auspicious", "favorable", "prosperous", "bellwether", "weather", "trendsetter", "callipygian", "buttocks", "circumlocution", "unnecessarily", "roundabout", "expression", "southern", "georiga", "univeristy", "concupiscent", "especially", "coruscant", "convivality", "glittering", "cuddlesome", "suitable", "cupidity", "cynosure", "ebullient", "zestfully", "enthusiastic", "eqanimity", "excogitate", "gasconading", "idiosyncratic", "luminescent", "peculiar", "individual", "character", "luminescent", "magnanimous", "courageously", "nidificate", "osculator", "parsimonious", "frugal", "penultimate", "perfidiousness", "perspicacious", "discernment", "proficuous", "profitable", "advantageous", "remunerative", "profitability", "saxicolous", "sesquipedalian", "superabundant", "unencumbered", "responsibilities", "unparagoned", "paragon", "matchless", "peerless", "usufruct", "winebibber", "overboard", "suggestions", "subscribers", "american", "mircophone", "performing", "education", "abstinence", "adversity", "aesthetic", "amicable", "anonymous", "hypthesis", "impetuous", "inconsequential", "jubilattion", "nonchalant", "ostentatious", "procrastinate", "reconciliation", "spontaneity", "querulous", "inconsequential", "exasperation", "ephemeral", "evansecent", "demagogue", "congregation", "condescending", "clairvoyant", "camaraderie", "adulation", "disdian", "discredit", "ephemeral", "fortuitous", "hackneyed", "incompatible", "inconsequential", "lobbyist", "mundane", "nonchalant", "opulent", "parched", "perfidious", "pretentious", "prosperity", "rancorous", "resilient", "submissive", "spurious", "ortar", "longevity", "hedonist", "exemplary", "digression", "conditional", "collabrate", "camaraderie", "circuitous", "benevolent", "assiduous", "anachronistic", "perfidious", "qwerty", "processor", "mainframe", "retina", "advantage", "screenshots", "viewcontroller", "storyboard", "delegate", "frameworks", "supporting", "comparison", "relative", "objective", "collection", "finished", "running", "illusator", "photoshop", "navigate", "behavior", "services", "duplicate", "datemodel", "democrate", "republican", "multivitamin", "multimineral", "statement", "evaulated", "administration", "diagonse", "pharmacist", "coronary", "dietary", "purified", "processes", "dioxins", "mercury", "furans", "respectively", "nutritional", "imprinted", "artifical", "preservatives", "triglyceride", "wellness", "percent", "supportive", "conclusive"]
    
    private var wordsToType = ["time","person","year", "way", "day", "thing","where","shoelace","world","life","hand","part","child","little","woman","place","work","week","case","point","company","number","group","fact","be", "have", "great", "get", "know", "take", "see", "come", "think", "look", "stop", "other", "want", "give", "ate", "leave", "tea", "men", "women", "fit", "steep", "heat", "champ", "keep", "more", "less", "five", "right", "high", "small", "large", "next", "early", "young", "public", "able", "from", "about", "into", "over", "after", "beneath", "under", "above", "would", "there", "their", "worry", "cause", "spear", "dirt", "tarp", "rap", "snap", "please", "weird", "music", "river", "merry", "first", "cat", "mouse", "film", "steam", "fearless", "rivers", "queen", "quietly", "green", "blue", "purple", "indigo", "stoneage", "armor", "restless", "quickly", "pacing", "racing", "dancing", "clashed", "everyone", "wreckage", "hairy", "barebones", "outside", "inside", "watering", "dripping", "feeling", "quietly", "faith", "forty", "hundred", "twenty", "english", "semester", "aboard", "drowning", "reserve", "empty", "crown", "record", "transit", "taxi", "lifted", "lowered", "folder", "pencil", "power", "outlet", "matching", "stereo", "studio", "keyboard", "flappy", "guitar", "drums", "cymbal", "clash", "clans", "phones", "phone", "smartphone", "passion", "proper", "places", "safari", "arcade", "tweet", "book", "easier", "model", "modes", "roads", "fields", "tests", "resting", "fairway", "fairness", "republic", "heavy", "strong", "weak", "narrow", "highest", "tallest", "wired", "flippy", "trippy", "hairy", "monsters", "daring", "centrum", "zinc", "treat", "cure", "fish", "oil", "omega", "alpha", "remove", "heart", "attack", "health", "softgel", "liquid", "supply", "coma", "farm", "raise", "broken", "yeast", "gluten", "value", "vent", "prevent"]
    
    private var lettersToType = ["a","b","c","d","e","f","h", "is", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "use", "be","cd","bad","old", "own", "go", "hi", "hey", "new", "few", "like", "milk", "no", "same", "find", "tell", "ask", "work", "seem", "feel", "try", "eat", "call", "use", "big","good","dog","last","do","eye","cop","to", "of","in","for","on","with","at", "by", "up",  "the", "and", "that", "it", "not", "he", "as", "you", "this", "but", "his", "they", "her", "she", "or", "an", "will", "my", "one", "all", "if", "you", "were", "man", "peach", "pick", "quit", "exit", "tar", "ill", "bill", "check", "lap", "hop", "mop", "drop", "heap", "creep", "fur", "log", "ear", "wall", "rep", "jill", "hill", "bail", "gem", "rim", "dim", "sim", "aim", "pill", "pen", "hen", "fin", "den", "mail", "dead", "yeah", "wow", "now", "hope", "love", "pup", "cup", "tea", "pea", "corn", "mom", "dad", "sad", "pop", "tee", "wee", "zoo", "zip", "tip", "lip", "hip", "big", "bar", "rad", "cope", "kid", "did", "deer", "dear", "tear", "bear", "wine", "line", "mine", "dine", "fine", "leap", "peep", "deep", "wet", "lick", "sick", "rich", "fav", "rave", "bwm", "tie", "tat", "rat", "kit", "cid", "mid", "pull", "brew", "led", "bed", "bet", "vet", "zit", "zip", "bid", "nib", "rib", "fit", "god", "mod", "sod", "tod", "rod", "fill", "ben", "hick", "hike", "bike", "bin", "mob"]
    
    private func shuffleArrayOrder<T>(inout array: [T]) -> [T] {
        for i in 0..<array.count {
            let exchangeindex = Int(arc4random_uniform(UInt32(array.count)))
            if exchangeindex != i {
                swap(&array[i], &array[exchangeindex])
            }
        }
        return array
    }
    
    init() {
        gameModelWords.appendContentsOf(self.lettersToType)
        gameModelWords.appendContentsOf(self.phrasesToType)
        gameModelWords.appendContentsOf(self.wordsToType)
        self.shuffleArrayOrder(&self.gameModelWords)
    }
    
    func shuffleGameModelArray() {
        self.shuffleArrayOrder(&self.gameModelWords)
    }
}