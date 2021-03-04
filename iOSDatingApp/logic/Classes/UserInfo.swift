//
//  UserInfo.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 01/03/2021.
//

import Foundation
class UserInfo {
    /*
        UserInfo class in Server contains:
                      1.  uid            int
                      2.  about          String
                      3.  wight          GeoPoint
                      4.  height         String
                      5.  birthDate      ArrayList<Integer>
                      6.  relationship   ArrayList<Room>
                      7.  religion       UserInfo
                      8.  orientation    Orientation(Enum)
                      9.  ethnicity      Ethnicity(Enum)
                      10. stds           STD[](Enums)
                      11. role           Role(Enum)
                      12. disabilities   Disability[](Enums)
                      13. notInDB        boolean
    */
    
    static public let ABOUT = "about"
    static public let WEIGHT = "weight"
    static public let HEIGHT = "height"
    static public let BIRTH_DATE = "birthDate"
    static public let RELATIONSHIP = "relationship"
    static public let RELIGION = "religion"
    static public let ORIENTATION = "orientation"
    static public let ETHNICITY = "ethnicity"
    static public let REFERENCE = "reference"
    static public let STDS = "stDs"
    static public let ROLE = "role"
    static public let DISABILITIES = "disabilities"
    static public let UID = "uid"
    static public let YEAR = 100
    static public let MONTH = 200
    static public let DAY = 300
    
    public var uid: Int?
    public var about: String?
    public var weight, height: Int?
    public var birthDate: Date?
    public var relationship: Relationship?
    public var religion: Religion?
    public var orientation: Orientation?
    public var ethnicity: Ethnicity?
    public var reference: Reference?
    public var stDs: [STD]?
    public var role: Role?
    public var disabilities: [Disability]?
    
    init(uid: Int, about: String, weight: Int, height: Int, birthDate: Date, relationship: Relationship, religion: Religion, orientation: Orientation, ethnicity: Ethnicity, reference: Reference, stDs: [STD], role: Role, disabilities: [Disability]) {
        self.uid = uid
        self.about = about
        self.weight = weight
        self.height = height
        self.birthDate = birthDate
        self.relationship = relationship
        self.religion = religion
        self.orientation = orientation
        self.ethnicity = ethnicity
        self.reference = reference
        self.stDs = stDs
        self.role = role
        self.disabilities = disabilities
    }
    
    init(dictionary: Dictionary<String, Any>){
        if let uid = dictionary[UserInfo.UID] as? Int {
            self.uid = uid
        }
        if let about = dictionary[UserInfo.ABOUT] as? String {
            self.about = about
        }
        if let weight = dictionary[UserInfo.WEIGHT] as? Int {
            self.weight = weight
        }
        if let height = dictionary[UserInfo.HEIGHT] as? Int {
            self.height = height
        }
        if let birthDate = dictionary[UserInfo.BIRTH_DATE] as? Date {
            self.birthDate = birthDate
        }
        if let relationship = dictionary[UserInfo.RELATIONSHIP] as? Relationship {
            self.relationship = relationship
        }
        if let religion = dictionary[UserInfo.RELIGION] as? Religion {
            self.religion = religion
        }
        if let orientation = dictionary[UserInfo.ORIENTATION] as? Orientation {
            self.orientation = orientation
        }
        if let ethnicity = dictionary[UserInfo.ETHNICITY] as? Ethnicity {
            self.ethnicity = ethnicity
        }
        if let reference = dictionary[UserInfo.REFERENCE] as? Reference {
            self.reference = reference
        }
        if let stdS = dictionary[UserInfo.STDS] as? [Any] {
            self.stDs = STD.getArrayOfEnumsFrom(values: stdS as! [String])
        }
        if let role = dictionary[UserInfo.ROLE] as? Role {
            self.role = role
        }
        if let disabilities = dictionary[UserInfo.DISABILITIES] as? [Any] {
            self.disabilities = Disability.getArrayOfEnumsFrom(values: disabilities as! [String])
        }
    }
    
    public enum Relationship {
            case NOT_DEFINED,
            IN_RELATIONSHIP_SOLO,
            IN_RELATIONSHIP_COUPLE,
            IN_AN_OPEN_RELATIONSHIP,
            SINGLE,
            DIVORCED,
            WIDOWED,
            ITS_COPMLICATED
        static public func getValOf(relationship: Relationship) -> Int {
            switch (relationship){
            case IN_RELATIONSHIP_SOLO:
                return 1
            case IN_RELATIONSHIP_COUPLE:
                return 2
            case IN_AN_OPEN_RELATIONSHIP:
                return 3
            case SINGLE:
                return 4
            case DIVORCED:
                return 5
            case WIDOWED:
                return 6
            case ITS_COPMLICATED:
                return 7
            default:
                return 0
            }
        }
        static public func getEnumValOf(code: Int) -> Relationship {
            switch (code){
            case 1:
                return IN_RELATIONSHIP_SOLO
            case 2:
                return IN_RELATIONSHIP_COUPLE
            case 3:
                return IN_AN_OPEN_RELATIONSHIP
            case 4:
                return SINGLE
            case 5:
                return DIVORCED
            case 6:
                return WIDOWED
            case 7:
                return ITS_COPMLICATED
            default:
                return NOT_DEFINED
            }
        }
    }

    public enum Religion {
        case NOT_DEFINED,
        CHRISTIAN,
        MUSLIM,
        JEW,
        ATHEIST

        static public func getValOf(enumObj: Religion) -> Int {
            switch (enumObj){
            case CHRISTIAN:
                return 1
            case MUSLIM:
                return 2
            case JEW:
                return 3
            case ATHEIST:
                return 4
            default:
                return 0
            }
        }
        static public func getEnumValOf(code: Int) -> Religion {
            switch (code){
            case 1:
                return CHRISTIAN
            case 2:
                return MUSLIM
            case 3:
                return JEW
            case 4:
                return ATHEIST
            default:
                return NOT_DEFINED
            }
        }

    }

    public enum Orientation {
        case NOT_DEFINED,
        STRAIGHT,
        GAY,
        BISEXUAL,
        TRANSEXUAL,
        TRANSGENDER,
        PANSEXUAL

        static public func getValOf(enumObj: Orientation) -> Int {
            switch (enumObj){
            case STRAIGHT:
                return 1
            case GAY:
                return 2
            case BISEXUAL:
                return 3
            case TRANSEXUAL:
                return 4
            case TRANSGENDER:
                return 5
            case PANSEXUAL:
                return 6
            default:
                return 0
            }
        }
        static public func getEnumValOf(code: Int) -> Orientation {
            switch (code){
            case 1:
                return STRAIGHT
            case 2:
                return GAY
            case 3:
                return BISEXUAL
            case 4:
                return TRANSEXUAL
            case 5:
                return TRANSGENDER
            case 6:
                return PANSEXUAL
            default:
                return NOT_DEFINED
            }
        }
    }

    public enum Ethnicity {
        case NOT_DEFINED,
        MIDDLE_EASTERN,
        NATIVE_AMERICAN,
        AFRICAN_AMERICAN,
        EUROPEAN,
        LATINO

        static public func getValOf(enumObj: Ethnicity) -> Int {
            switch (enumObj){
            case MIDDLE_EASTERN:
                return 1
            case NATIVE_AMERICAN:
                return 2
            case AFRICAN_AMERICAN:
                return 3
            case EUROPEAN:
                return 4
            case LATINO:
                return 5
            default:
                return 0
            }
        }
        static public func getEnumValOf(code: Int) -> Ethnicity {
            switch (code){
            case 1:
                return MIDDLE_EASTERN
            case 2:
                return NATIVE_AMERICAN
            case 3:
                return AFRICAN_AMERICAN
            case 4:
                return EUROPEAN
            case 5:
                return LATINO
            default:
                return NOT_DEFINED
            }
        }
    }

    public enum Reference {
        case NOT_DEFINED,
        HE,
        SHE,
        HE_SHE,
        THEY,
        OTHER

        static public func getValOf(enumObj: Reference) -> Int {
            switch (enumObj){
            case HE:
                return 1
            case SHE:
                return 2
            case HE_SHE:
                return 3
            case THEY:
                return 4
            case OTHER:
                return 5
            default:
                return 0
            }
        }
        static public func getEnumValOf(code: Int) -> Reference {
            switch (code){
            case 1:
                return HE
            case 2:
                return SHE
            case 3:
                return HE_SHE
            case 4:
                return THEY
            case 5:
                return OTHER
            default:
                return NOT_DEFINED
            }
        }
    }

    public enum STD: CaseIterable {
        case NOT_DEFINED,
        NO_STDS,
        HIV_POS,
        HIV_NEG

        static public func getEnumsFrom(codes: [Int]) -> [STD] {
            var stds: [STD] = []
            for i in 0..<codes.count {
                stds[i] = getEnumValOf(code: codes[i])
            }
            return stds
        }

        static public func getArrayOfEnumsFrom(codes: [Int]) -> [STD] {
            var stds: [STD] = []
            for code in codes {
                stds.append(getEnumValOf(code: code))
            }
            return stds
        }

        static public func getArrayOfEnumsFrom(values: [String]) -> [STD] {
            var stds: [STD] = []
            for val in values {
                stds.append(STD.from(string: val) ?? NOT_DEFINED)
            }
            return stds
        }

        static public func getArrayOfIntsFrom(values: [STD]) -> [Int] {
            var stds: [Int] = []
            for val in values {
                stds.append(getValOf(enumObj: val))
            }
            return stds
        }

        static public func getValOf(enumObj: STD) -> Int {
            switch (enumObj){
            case NO_STDS:
                return 1
            case HIV_POS:
                return 2
            case HIV_NEG:
                return 3
            default:
                return 0
            }
        }
        static public func getEnumValOf(code: Int) -> STD {
            switch (code){
            case 1:
                return NO_STDS
            case 2:
                return HIV_POS
            case 3:
                return HIV_NEG
            default:
                return NOT_DEFINED
            }
        }
    }

    public enum Role {
        case NOT_DEFINED,
        TOP,
        BOTTOM,
        VERSATILE,
        VERSATILE_TOP,
        VERSATILE_BOTTOM

        static public func getValOf(enumObj: Role) -> Int {
            switch (enumObj){
            case TOP:
                return 1
            case BOTTOM:
                return 2
            case VERSATILE:
                return 3
            case VERSATILE_TOP:
                return 4
            case VERSATILE_BOTTOM:
                return 5
            default:
                return 0
            }
        }
        static public func getEnumValOf(code: Int) -> Role {
            switch (code){
            case 1:
                return TOP
            case 2:
                return BOTTOM
            case 3:
                return VERSATILE
            case 4:
                return VERSATILE_TOP
            case 5:
                return VERSATILE_BOTTOM
            default:
                return NOT_DEFINED
            }
        }
    }

    public enum Disability: CaseIterable {
        case NOT_DEFINED,
             BLIND

        static public func getEnumsFrom(codes: [Int]) -> [Disability] {
            var disabilities: [Disability] = []
            for i in 0..<codes.count {
                disabilities[i] = getEnumValOf(code: codes[i])
            }
            return disabilities
        }

        static public func getArrayOfEnumsFrom(codes: [Int]) -> [Disability] {
            var disabilities: [Disability] = []
            for code in codes {
                disabilities.append(getEnumValOf(code: code))
            }
            return disabilities
        }

        static public func getArrayOfIntsFrom(values: [Disability]) -> [Int] {
            var stds: [Int] = []
            for val in values {
                stds.append(getValOf(enumObj: val))
            }
            return stds
        }

        static public func getArrayOfEnumsFrom(values: [String]) -> [Disability] {
            var disabilities: [Disability] = []
            for val in values {
                disabilities.append(Disability.from(string: val) ?? NOT_DEFINED)
            }
            return disabilities
        }

        static public func getValOf(enumObj: Disability) -> Int {
            switch (enumObj){
            case BLIND:
                return 1
            default:
                return 0
            }
        }
        static public func getEnumValOf(code: Int) -> Disability {
            switch (code){
            case 1:
                return BLIND
            default:
                return NOT_DEFINED
            }
        }
    }
}

extension CaseIterable {
    static func from(string: String) -> Self? {
        return Self.allCases.first { string == "\($0)" }
    }
    func toString() -> String { "\(self)" }
}
