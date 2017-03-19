
//
//  ViewControllerRsyncParameters.swift
//  Rsync
//  The ViewController for rsync parameters.
//
//  Created by Thomas Evensen on 13/02/16.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//

import Foundation
import Cocoa

// protocol for returning if userparams is updated or not
protocol RsyncUserParams : class {
    func rsyncuserparamsupdated()
}

// Protocol for sending selected index in tableView
// The protocol is implemented in ViewControllertabMain
protocol GetSelecetedIndex : class {
    func getindex() -> Int?
}

class ViewControllerRsyncParameters: NSViewController {
    
    // Object for calculating rsync parameters
    var parameters : RsyncParameters?
    // Delegate returning params updated or not
    weak var userparamsupdated_delegate : RsyncUserParams?
    // Get index of selected row
    weak var getindex_delegate : GetSelecetedIndex?
    // Dismisser
    weak var dismiss_delegate:DismissViewController?
    // Reference to rsync parameters to use in combox
    var comboBoxValues = Array<String>()
    
    @IBOutlet weak var viewParameter1: NSTextField!
    @IBOutlet weak var viewParameter2: NSTextField!
    @IBOutlet weak var viewParameter3: NSTextField!
    @IBOutlet weak var viewParameter4: NSTextField!
    @IBOutlet weak var viewParameter5: NSTextField!
    // user selected parameter
    @IBOutlet weak var viewParameter8: NSTextField!
    @IBOutlet weak var viewParameter9: NSTextField!
    @IBOutlet weak var viewParameter10: NSTextField!
    @IBOutlet weak var viewParameter11: NSTextField!
    @IBOutlet weak var viewParameter12: NSTextField!
    @IBOutlet weak var viewParameter13: NSTextField!
    @IBOutlet weak var viewParameter14: NSTextField!
    @IBOutlet weak var rsyncdaemon: NSButton!
    @IBOutlet weak var sshport: NSTextField!
    // Comboboxes
    @IBOutlet weak var parameter8: NSComboBox!
    @IBOutlet weak var parameter9: NSComboBox!
    @IBOutlet weak var parameter10: NSComboBox!
    @IBOutlet weak var parameter11: NSComboBox!
    @IBOutlet weak var parameter12: NSComboBox!
    @IBOutlet weak var parameter13: NSComboBox!
    @IBOutlet weak var parameter14: NSComboBox!
    
    @IBAction func close(_ sender: NSButton) {
         self.dismiss_delegate?.dismiss_view(viewcontroller: self)
    }
    
    
    // Function for enabling backup of changed files in a backup catalog.
    // Parameters are appended to last two parameters (12 and 13).
    @IBAction func backup(_ sender: NSButton) {
        switch self.backupbutton.state {
        case 1:
            self.resetComboBox(self.parameter12, index: (self.parameters!.getvalueCombobox(self.parameters!.getBackupString()[0])))
            self.viewParameter12.stringValue = self.parameters!.getdisplayValue(self.parameters!.getBackupString()[0])
            self.resetComboBox(self.parameter13, index: (self.parameters!.getvalueCombobox(self.parameters!.getBackupString()[1])))
            self.viewParameter13.stringValue = self.parameters!.getdisplayValue(self.parameters!.getBackupString()[1])
        case 0:
            self.resetComboBox(self.parameter12, index: (0))
            self.viewParameter12.stringValue = ""
            self.resetComboBox(self.parameter13, index: (0))
            self.viewParameter13.stringValue = ""
        default : break
        }
    }
    
    // Function for enabling suffix date + time changed files. 
    // Parameters are appended to last parameter (14).
    
    @IBOutlet weak var suffixButton: NSButton!
    @IBAction func suffix(_ sender: NSButton) {
        switch self.suffixButton.state {
        case 1:
            self.resetComboBox(self.parameter14, index: (self.parameters!.getvalueCombobox(self.parameters!.getSuffixString()[0])))
            self.viewParameter14.stringValue = self.parameters!.getdisplayValue(self.parameters!.getSuffixString()[0])
        case 0:
            self.resetComboBox(self.parameter14, index: (0))
            self.viewParameter14.stringValue = ""
        default:
            break
        }
    }
    
    @IBOutlet weak var suffixButton2: NSButton!
    @IBAction func suffix2(_ sender: NSButton) {
        switch self.suffixButton2.state {
        case 1:
            self.resetComboBox(self.parameter14, index: (self.parameters!.getvalueCombobox(self.parameters!.getSuffixString2()[0])))
            self.viewParameter14.stringValue = self.parameters!.getdisplayValue(self.parameters!.getSuffixString2()[0])
        case 0:
            self.resetComboBox(self.parameter14, index: (0))
            self.viewParameter14.stringValue = ""
        default:
            break
        }
        
    }
    
    // Backup button - only for testing on state
    @IBOutlet weak var backupbutton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get index of seleceted row
        if let pvc = self.presenting as? ViewControllertabMain {
            self.userparamsupdated_delegate = pvc
            self.getindex_delegate = pvc
        }
        // Dismisser is root controller
        if let pvc2 = self.presenting as? ViewControllertabMain {
            self.dismiss_delegate = pvc2
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Create RsyncParameters object and load initial parameters
        self.parameters = RsyncParameters()
        self.comboBoxValues = parameters!.getComboBoxValues()
        
        self.backupbutton.state = 0
        self.suffixButton.state = 0
        self.suffixButton2.state = 0
        var configurations:[configuration] = SharingManagerConfiguration.sharedInstance.getConfigurations()
        let index = self.getindex_delegate?.getindex()
        self.viewParameter1.stringValue = configurations[index!].parameter1
        self.viewParameter2.stringValue = configurations[index!].parameter2
        self.viewParameter3.stringValue = configurations[index!].parameter3
        self.viewParameter4.stringValue = configurations[index!].parameter4
        self.viewParameter5.stringValue = configurations[index!].parameter5 + " " + configurations[index!].parameter6
        
        // There are seven user seleected rsync parameters
        
        self.resetComboBox(self.parameter8, index: self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 8).0)
        self.viewParameter8.stringValue = self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 8).1

        self.resetComboBox(self.parameter9, index: self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 9).0)
        self.viewParameter9.stringValue = self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 9).1
        
        self.resetComboBox(self.parameter10, index: self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 10).0)
        self.viewParameter10.stringValue = self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 10).1
        
        self.resetComboBox(self.parameter11, index: self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 11).0)
        self.viewParameter11.stringValue = self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 11).1
        
        self.resetComboBox(self.parameter12, index: self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 12).0)
        self.viewParameter12.stringValue = self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 12).1
        
        self.resetComboBox(self.parameter13, index: self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 13).0)
        self.viewParameter13.stringValue = self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 13).1
        
        self.resetComboBox(self.parameter14, index: self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 14).0)
        self.viewParameter14.stringValue = self.parameters!.getParameter(config: configurations[index!], rsyncparameternumber: 14).1
        
        if (configurations[index!].rsyncdaemon != nil) {
            self.rsyncdaemon.state = configurations[index!].rsyncdaemon!
        } else {
            self.rsyncdaemon.state = NSOffState
        }
        if (configurations[index!].sshport != nil) {
            self.sshport.stringValue = String(configurations[index!].sshport!)
        }
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        self.parameters = nil
    }
    
    // Function for saving changed or new parameters for one configuration.
    @IBAction func update(_ sender: NSButton) {
        var Configurations:[configuration] = persistentStoreAPI.sharedInstance.getConfigurations()
        guard Configurations.count > 0 else {
            // If Configurations == 0 by any change will not cause RsyncOSX to crash
            return
        }
        // Get the index of selected configuration
        let index = self.getindex_delegate?.getindex()
        
        guard index != nil else {
            return
        }
        
        Configurations[index!].parameter8 = self.parameters!.getRsyncParameter(indexComboBox:
            self.parameter8.indexOfSelectedItem, value: getValue(value: self.viewParameter8.stringValue))
        Configurations[index!].parameter9 = self.parameters!.getRsyncParameter(indexComboBox:
            self.parameter9.indexOfSelectedItem, value: getValue(value: self.viewParameter9.stringValue))
        Configurations[index!].parameter10 = self.parameters!.getRsyncParameter(indexComboBox:
            self.parameter10.indexOfSelectedItem, value: getValue(value: self.viewParameter10.stringValue))
        Configurations[index!].parameter11 = self.parameters!.getRsyncParameter(indexComboBox:
            self.parameter11.indexOfSelectedItem, value: getValue(value: self.viewParameter11.stringValue))
        Configurations[index!].parameter12 = self.parameters!.getRsyncParameter(indexComboBox:
            self.parameter12.indexOfSelectedItem, value: getValue(value: self.viewParameter12.stringValue))
        Configurations[index!].parameter13 = self.parameters!.getRsyncParameter(indexComboBox:
            self.parameter13.indexOfSelectedItem, value: getValue(value: self.viewParameter13.stringValue))
        Configurations[index!].parameter14 = self.parameters!.getRsyncParameter(indexComboBox:
            self.parameter14.indexOfSelectedItem, value: getValue(value: self.viewParameter14.stringValue))
        Configurations[index!].rsyncdaemon = self.rsyncdaemon.state
        if let port = self.sshport {
            Configurations[index!].sshport = Int(port.stringValue)
        }
        // Update configuration in memory before saving
        SharingManagerConfiguration.sharedInstance.updateConfigurations(Configurations[index!], index: index!)
        persistentStoreAPI.sharedInstance.saveConfigFromMemory()
        // notify an update
        self.userparamsupdated_delegate?.rsyncuserparamsupdated()
        // Send dismiss delegate message
        self.dismiss_delegate?.dismiss_view(viewcontroller: self)
    }
    
    // There are eight comboboxes
    // All eight are initalized during ViewDidLoad and
    // the correct index is set.
    private func resetComboBox (_ combobox:NSComboBox, index:Int) {
        combobox.removeAllItems()
        combobox.addItems(withObjectValues: self.comboBoxValues as [String]!)
        combobox.selectItem(at: index)
    }
    
    // Returns nil or value from stringvalue (rsync parameters)
    private func getValue(value:String) -> String? {
        if value.isEmpty {
            return nil
        } else {
            return value
        }
    }
    
}
