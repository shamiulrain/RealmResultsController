//
//  RealmSectionSpec.swift
//  RealmResultsController
//
//  Created by Isaac Roldan on 7/8/15.
//  Copyright © 2015 Redbooth.
//

import Foundation
import Quick
import Nimble
import RealmSwift

@testable import RealmResultsController

class SectionSpec: QuickSpec {
    
    override func spec() {
        var sortDescriptors: [NSSortDescriptor]!
        var section: Section<Task>!
        var openTask: Task!
        var resolvedTask: Task!
        
        
        beforeSuite {
            sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
            section = Section<Task>(keyPath: "keyPath", sortDescriptors: sortDescriptors)
            openTask = Task()
            openTask.id = 1500
            openTask.name = "aatest"
            openTask.resolved = false
            
            resolvedTask = Task()
            resolvedTask.id = 1501
            resolvedTask.name = "bbtest"
            resolvedTask.resolved = false
        }
        
        describe("create a Section object") {
            it("has everything you need to get started") {
                expect(section.keyPath).to(equal("keyPath"))
                expect(section.sortDescriptors).to(equal(sortDescriptors))
            }
        }
        
        describe("insertSorted(object:)") {
            
            var index: Int!
            context("when the section is empty") {
                it ("beforeAll") {
                    index = section.insertSorted(openTask)
                }
                it("a has one item") {
                    expect(section.objects.count).to(equal(1))
                }
                it("item has index 0") {
                    expect(index).to(equal(0))
                }
            }
            
            context("when the section is not empty") {
                it("beforeAll") {
                    index = section.insertSorted(resolvedTask)
                }
                it("has two items") {
                    expect(section.objects.count).to(equal(2))
                }
                it("has index 0") { // beacuse of the sortDescriptor
                    expect(index).to(equal(0))
                }
            }
        }
        
        describe("delete(object:)") {
            var originalIndex: Int!
            var index: Int!
            context("when the object exists in section") {
                beforeEach {
                    section = Section<Task>(keyPath: "keyPath", sortDescriptors: sortDescriptors)
                    section.insertSorted(resolvedTask)
                    originalIndex = section.insertSorted(openTask)
                    index = section.delete(openTask)
                }
                it("removes it from array") {
                    expect(section.objects.containsObject(openTask)).to(beFalsy())
                }
                it("returns the index of the deleted object") {
                    expect(index).to(equal(originalIndex))
                }
            }
            
            context("the object does not exists in section") {
                var anotherTask: Task!
                beforeEach {
                    section = Section<Task>(keyPath: "keyPath", sortDescriptors: sortDescriptors)
                    section.insertSorted(resolvedTask)
                    section.insertSorted(openTask)
                    anotherTask = Task()
                    index = section.delete(anotherTask)
                }
                it("returns index nil") {
                    expect(index).to(beNil())
                }
            }
        }
        
        describe("deleteOutdatedObject(object:)") {
            var originalIndex: Int!
            var index: Int!
            context("when the object exists in section") {
                beforeEach {
                    section = Section<Task>(keyPath: "keyPath", sortDescriptors: sortDescriptors)
                    section.insertSorted(resolvedTask)
                    originalIndex = section.insertSorted(openTask)
                    index = section.deleteOutdatedObject(openTask)
                }
                it("removes it from array") {
                    expect(section.objects.containsObject(openTask)).to(beFalsy())
                }
                it("returns the index of the deleted object") {
                    expect(index).to(equal(originalIndex))
                }
            }
            var anotherTask: Task!
            context("the object does not exists in section") {
                beforeEach {
                    section = Section<Task>(keyPath: "keyPath", sortDescriptors: sortDescriptors)
                    section.insertSorted(resolvedTask)
                    section.insertSorted(openTask)
                    anotherTask = Task()
                    index = section.deleteOutdatedObject(anotherTask)
                }
                it("returns index nil") {
                    expect(index).to(beNil())
                }
            }
        }
        
        describe("insert(object:)") {
            context("when the section is empty") {
                it("beforeAll") {
                    section = Section<Task>(keyPath: "keyPath", sortDescriptors: sortDescriptors)
                    section.insert(openTask)
                }
                it("has one item") {
                    expect(section.objects.count).to(equal(1))
                }
                it("item is latest") {
                    expect(section.objects.lastObject === openTask).to(beTrue())
                }
            }
            
            context("when the section is not empty") {
                it("beforeAll") {
                    section.insert(resolvedTask)
                }
                it("has two items") {
                    expect(section.objects.count).to(equal(2))
                }
                it("item is latest") {
                    expect(section.objects.lastObject === resolvedTask).to(beTrue())
                }
            }
        }
        
        describe("sort()") {
            context("when the section is not empty") {
                it("beforeAll") {
                    section = Section<Task>(keyPath: "keyPath", sortDescriptors: sortDescriptors)
                    section.insert(openTask)
                    section.insert(resolvedTask)
                }
                it("before items have been sorted") {
                    expect(section.objects.firstObject === openTask).to(beTrue())
                    expect(section.objects.lastObject === resolvedTask).to(beTrue())
                }
                it("sort items") {
                    section.sort()
                }
                it("after items have been sorted") {
                    expect(section.objects.firstObject === resolvedTask).to(beTrue())
                    expect(section.objects.lastObject === openTask).to(beTrue())
                }
            }
        }
    }
}


