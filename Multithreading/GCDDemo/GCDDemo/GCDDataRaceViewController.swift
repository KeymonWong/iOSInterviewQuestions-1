//
//  GCDDataRaceViewController.swift
//  GCDDemo
//
//  Created by YJHou on 2017/4/20.
//  Copyright © 2017年 houmanager@hotmail.com. All rights reserved.
//

import UIKit

class GCDDataRaceViewController: UIViewController {

    
    let dispatchQueue = DispatchQueue(label: "com.houmananger.gcd", attributes: .concurrent)
    let dispatchGroup = DispatchGroup()
    let contacts = [("name1", "name1@mqq.com"), ("name2", "name2@qq.com"), ("name3", "name3@qq.com"), ("name4", "name4@qq.com")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        _addButtons()
    }
    
    func _addButtons() -> Void {
        
        let selector = #selector(selectorFunc)
        
        let btn1 = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        btn1.setTitle("方法1", for: .normal)
        btn1.addTarget(self, action: selector, for: .touchUpInside)
        btn1.backgroundColor = UIColor.orange
        btn1.tag = 1
        view.addSubview(btn1)
        
        let btn2 = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 50))
        btn2.setTitle("方法2", for: .normal)
        btn2.addTarget(self, action: selector, for: .touchUpInside)
        btn2.backgroundColor = UIColor.orange
        btn2.tag = 2
        view.addSubview(btn2)
        
    }
    
    @objc func selectorFunc(btn:UIButton) -> Void {
        
        let btnTag = btn.tag
        if btnTag == 1 {
            print("1111")
            let person = Person(name: "unknown", email: "unknown")
            updateContact(person: person, contacts: contacts)
        }else if btnTag == 2 {
            print("2222")
            let person = ThreadSafePerson(name: "unknown", email: "unknown")
            updateContact(person: person, contacts: contacts)
        }
    }
    
    private func updateContact(person: Person, contacts: [(String, String)]) {
        for (name, email) in contacts {
            dispatchQueue.async(group: dispatchGroup) {
                person.setProperty(name: name, email: email)
                print("Current person: \(person)")
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            print("==> Final person: \(person)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
