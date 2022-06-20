import UIKit


let FILTER_CHAR     = "@"
let FILTER_APACE    = " "
let FEMALE          = "F"
let MALE            = "M"
let QTY_BROTHERS    = 2
let DATE_FORMAT     = "dd/MM/yyyy"


extension StringProtocol {
    var firstUppercased: String { return self.prefix(1).uppercased() + dropFirst() }
}


/**User Model **/
struct UserModel {
    let name:String
    let fatherSurname:String
    let motherSurname:String
    let dni:Int
    let birthDate:String
    let sex:String
    let email:String
    let qtyBrothers:Int
    var user:String
    
    init(name:String, fatherSurname:String, motherSurname:String, dni:Int, birthDate:String, sex:String, email:String, qtyBrothers:Int) {
        self.name = name
        self.fatherSurname = fatherSurname
        self.motherSurname = motherSurname
        self.dni = dni
        self.birthDate = birthDate
        self.sex = sex
        self.email = email
        self.qtyBrothers = qtyBrothers
        self.user = ""
    }
    
    func getShortName() -> String {
        let letter = getValue( text: name, l: FILTER_APACE)
        let newName  = letter.lowercased().firstUppercased
        let fSurname = fatherSurname.lowercased().firstUppercased
        let mSurname = motherSurname.lowercased().firstUppercased
        return "\(newName) \(fSurname) \(Array(mSurname)[0])."
    }
    
    func getUserName() -> String {
        return getValue(text: email, l: FILTER_CHAR)
    }
    
    private func getValue(text:String, l:String) -> String {
        var range: Range<String.Index>!
        if let idd = text.range(of: l) {
            range = idd
        }else {
            return text
        }
        
        let index: Int = text.distance(from: text.startIndex, to: range.lowerBound )
        let result = text.index(text.startIndex, offsetBy: index)
        return String(text[..<result])
    }
    
    func calculateAge() -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = DATE_FORMAT
        let birthdayDate = dateFormater.date(from: birthDate)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let calcAge = calendar.components(.year, from: birthdayDate!, to: Date(), options: [])
        return calcAge.year!
    }
    
}


/**User Controller**/
class UserController {
    var userList = Array<UserModel>()
    
    init(){
        initUserList()
    }
    
    func initUserList(){
        let user1 = UserModel( name:"CARLOS JOSÉ",
                               fatherSurname:"ROBLES",
                               motherSurname:"GOMES",
                               dni: 78451245,
                               birthDate:"06/08/1995",
                               sex:"M",
                               email:"carlos.roblesg@hotmail.com",
                               qtyBrothers:2)
        
        let user2 = UserModel( name:"MIGUEL ANGEL",
                               fatherSurname:"QUISPE",
                               motherSurname:"OTERO",
                               dni: 79451654,
                               birthDate:"28/12/1995",
                               sex:"M",
                               email:"miguel.anguel@gmail.com",
                               qtyBrothers:0)
        
        let user3 = UserModel( name:"KARLA ALEXANDRA",
                               fatherSurname:"FLORES",
                               motherSurname:"ROSAS",
                               dni: 77485812,
                               birthDate:"15/02/1997",
                               sex:"F",
                               email:"Karla.alexandra@hotmail.com",
                               qtyBrothers:1)
        
        let user4 = UserModel( name:"NICOLAS",
                               fatherSurname:"QUISPE",
                               motherSurname:"ZEBALLOS",
                               dni: 71748552,
                               birthDate:"08/10/1990",
                               sex:"M",
                               email:"nicolas123@gmail.com",
                               qtyBrothers:1)
        
        let user5 = UserModel( name:"PEDRO ANDRE",
                               fatherSurname:"PICASSO",
                               motherSurname:"BETANCUR",
                               dni: 74823157,
                               birthDate:"17/05/1994",
                               sex:"M",
                               email:"pedroandrepicasso@gmail.com",
                               qtyBrothers:2)
        
        let user6 = UserModel( name:"FABIOLA MARIA",
                               fatherSurname:"PALACIO",
                               motherSurname:"VEGA",
                               dni: 76758254,
                               birthDate:"02/02/1992",
                               sex:"F",
                               email:"fabi@hotmail.com",
                               qtyBrothers:0)
        
        userList.append(user1)
        userList.append(user2)
        userList.append(user3)
        userList.append(user4)
        userList.append(user5)
        userList.append(user6)
        addUserNames()
    }
    
    private func addUserNames(){
        userList.forEach({ user in
            setUserName(email: user.email, user: user.getUserName().lowercased())
        })
        let  sortedList = userList.sorted { model1, model2 in
            model1.calculateAge() < model2.calculateAge()
        }
        userList = sortedList
    }
    
    private func setUserName(email:String, user:String){
        if let index = userList.firstIndex(where: { user in
            user.email == email
        }){
            userList[index].user = user
        }
    }
    
    func getList() -> Array<UserModel>{
        return userList
    }
    
    func getListBySex(sex:String) -> Array<UserModel>{
        let menList = userList.filter({ user in
            user.sex == sex
        })
        return menList
    }
    
    func filterListByQtyBrothers(qty:Int) -> Array<UserModel>{
        let list = userList.filter({ user in
            user.qtyBrothers > qty
        })
        return list
    }
    
    func toString() -> String {
        let minorAge        = userList.first?.calculateAge()
        let olderAge        = userList.last?.calculateAge()
        let qtyUserFemale   = getListBySex(sex: FEMALE).count
        let qtyUserMale     = getListBySex(sex: MALE).count
        let qtyBrothers     = filterListByQtyBrothers(qty: QTY_BROTHERS).count
        
        let message =   "Cantidad mujeres :: \(qtyUserFemale) \n"+"Cantidad hombres :: \(qtyUserMale) \nUsuarios con (Hermanos > 2) :: \(qtyBrothers) \nEdad mayor :: \(olderAge ?? 0) \nEdad menor :: \(minorAge ?? 0) "
        return message
    }
}



/**Test**/
let userController = UserController()

print(userController.toString())
print("")
print("***************** Lista de Usuarios *******************\n")
for person in userController.getList() {
    let shortName = person.getShortName()
    let userName = person.user.lowercased()
    print("NOMBRE :: \(shortName.firstUppercased)        USUARIO :: \(userName) ")
}















