//
//  XMLPathParser.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 23/02/21.
//

import Foundation
/* The XML delegate used to tell the listener whenever a specified path has been encountered
 The specified path will have string data and some type attribute data, but they will have an
 ID to identify which path has been encountered
 */
protocol XMLDelegate {
    
    func didEncounterPath( parser: XMLPathParser, path: String, id: Any, string: String )
    func didEncounterPath( parser: XMLPathParser, path: String, id: Any, string: String, attributes: [String:String] )
    
    func didStartElement( parser: XMLPathParser, element: String )
    func didEndElement( parser: XMLPathParser, element: String )

    func parse( _ parser: XMLPathParser, _ error: Error )
    func validation( _ parser: XMLPathParser, _ error: Error)
}

/* Context object to store the state of a element, the need to store the current elemenet
 state happens as you descend the recursive element structure.  The current element state is
 store on desceent into a new sub-element, and restored when that sub-element is exited */
class XMLContext {
    let currentPath: String
    let currentText: String
    let currentAttributes: [String : String]

    init( path: String, text: String, attributes: [String:String] ) {
        self.currentPath = path
        self.currentText = text
        self.currentAttributes = attributes
    }
}

/* This object is designed to make accessing a XML structure much more direct
 By specifying a path for each of the node in the xml of interest
 This object parses the XML while returning the data for each of the
 paths specified.
 
 See the XCTest for examples of USAGE
 */
class XMLPathParser: NSObject, XMLParserDelegate {
    
    //
    //MARK: - Private section
    //        Data encapulation here, no touching externally
    
    private let parser: XMLParser
    private var userPaths = [String : (String?,Any)]()
    private var contextStack = [XMLContext]()
    
    // current element being processed
    private var currentText = String()
    private var currentPath = String()
    private var currentAttributes = [String : String]()

    //
    //MARK: Public Member section
    //
    var delegate: XMLDelegate?
    
    //
    //MARK: - Object life cycle
    //

    /* Initialize the XMLPathParser with the XML to be parsed
     
     PARAMETERS:
        xmlData - The xml data to be parsed
        delegate - the listen which will be recieve the path info
     */
    init( xmlData: Data, delegate: XMLDelegate ) {
        self.parser = XMLParser(data: xmlData)
        self.delegate = delegate
        
        super.init()

        self.parser.delegate = self
    }
    
    /* Initialize the XMLPathParser with the XML to be parsed
     
     PARAMETERS:
        xmlData - The xml as a string to be parsed
        delegate - the listen which will be recieve the path info
     */
    convenience init( xmlString: String, delegate: XMLDelegate ) {
        let xmlData = xmlString.data(using: .utf8)!
        self.init(xmlData:xmlData, delegate:delegate )
    }

    //
    //MARK: - Public section
    //
    
    
    func addPath( path: String, id: Any ) {
        let pathOnly = self.removeLastElement(pathString: path, at:"@")
        let attributeKeys = self.attributePath(pathString: path, at: "@")
        self.userPaths[pathOnly == "" ? path : pathOnly] = (attributeKeys,id)
    }

    // same as above only with teh paths stored in a dictionary
    /*
     
     PARAMETER:
        paths - A dictionary of paths (key) and id (value)
     */
    func addPaths( paths: [String : Any] ) {
        for (key, value) in paths {
            self.addPath(path: key, id: value)
        }
    }
        
    // Start the XML parsing
    func parse() {
        self.parser.parse()
    }
    
    //
    //MARK: - XMLParserDelegate Section
    //
    
    internal func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.pushContext()
        self.addElementToPath(elementName)
        
        if attributeDict.isEmpty == false, let _ = self.match(path: self.currentPath, with: attributeDict) {
            self.currentAttributes = attributeDict
        }
    }
    
    internal func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if let pathID = self.userPaths[self.currentPath]?.1 {

            if self.currentAttributes.isEmpty == false {
                self.delegate?.didEncounterPath(parser: self, path: self.currentPath, id: pathID
                                               ,string: self.currentText, attributes: self.currentAttributes)
            } else if self.currentText.isEmpty == false {
                self.delegate?.didEncounterPath(parser: self, path: self.currentPath, id: pathID, string: self.currentText)
            }
        }
        
        self.popContext()
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentText += string
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error){
        self.delegate?.parse(self, parseError)
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error){
        self.delegate?.validation(self, validationError)
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        print("===================================")
    }
    
    //
    //MARK: - Helper section
    //
    
    private func addElementToPath( _ elementName: String ) {
        self.delegate?.didStartElement(parser: self, element: elementName)
        if self.currentPath.isEmpty {
            self.currentPath += elementName
        } else {
            self.currentPath += "." + elementName
        }
    }
    
    private func removeLastElement( pathString: String, at: String = "." ) -> String {
        self.notifyEndElement(pathString, ".")
        if let lastDot: Range<String.Index> = pathString.range(of: at, options: .backwards) {
            return String(pathString[..<lastDot.lowerBound])
        }
        return ""
    }
    
    private func notifyEndElement( _ pathString: String, _ at: String ){
        let strings = pathString.components(separatedBy: CharacterSet(charactersIn: at))
        if let lastElement = strings.last {
            self.delegate?.didEndElement(parser: self, element: lastElement)
        }
    }
    
    private func attributePath( pathString: String, at: String = "@" ) -> String? {
        
        guard pathString.contains(at) else {
            return nil
        }
        
        let seperated = pathString.components(separatedBy: CharacterSet(charactersIn:at))
        return seperated.last
    }
    
    private func match( path:String, with attributes:[String:String] ) -> Any? {

        if let pathValue = self.userPaths[self.currentPath] { // I have ( attribute key?, ID )
            
            if pathValue.0 == nil { // if there are no sub-attributes specified, then return them all
                return pathValue.1
            }
            
            // NOw match the attributes
            
            if let strings = pathValue.0?.components(separatedBy: CharacterSet(charactersIn: ","))  {
                let attributeKeys: [String] = attributes.keys.map { $0 }
                
                for string in strings {
                    if attributeKeys.contains(string)  == false {
                        return nil
                    }
                }
                return pathValue.1
            }
        }
        
        return nil
    }
    
    
    private func extractAttribute( pathString: String, at: String = "@", attributes: [String:String] ) -> [String:String]? {
        if let attributePath = self.attributePath(pathString: pathString) {
            
            let keys = attributePath.components(separatedBy: CharacterSet(charactersIn: ","))
            var output = [String:String]()
            
            for key in keys {
                if let value = attributes[key] {
                    output[key] = value
                } else {
                    return nil
                }
            }
            return output.isEmpty ? nil : output
        }
        
        return nil
    }
    
    private func overwriteContext() {
        let _ = self.contextStack.dropLast()
        self.pushContext()
    }
    
    private func pushContext( ) {
        self.contextStack.append(XMLContext(path:self.currentPath,text:self.currentText, attributes: self.currentAttributes))
        self.currentText = ""
        self.currentAttributes.removeAll()
    }
    
    private func popContext(){
        if let context = self.contextStack.last {
            self.currentText = context.currentText
            self.currentAttributes = context.currentAttributes
            let _ = self.contextStack.dropLast()
        }
        self.currentPath = self.removeLastElement(pathString: self.currentPath)
    }
    
    private func isNextPopAt( path: String ) -> Bool {
        if let context = self.contextStack.last {
            return context.currentPath == path
        }

        return false
    }
}

extension XMLParserDelegate {
    
    func parse( _ parser: XMLPathParser, _ error: Error ) {
        print( "\(#function) unimplemented" )
    }
    
    func validation( _ parser: XMLPathParser, _ error: Error) {
        print( "\(#function) unimplemented" )
    }

}
