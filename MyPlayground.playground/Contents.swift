import SwiftUI


var currentDate = Date()
let formatter = DateFormatter()
formatter.dateFormat = "EEEE"

var yesterdayDate = Calendar.current.date(byAdding: .day, value: -2, to: currentDate)


for val in stride(from: 0, through: -7, by: -1) {
    let newDate = Calendar.current.date(byAdding: .day, value: val, to: currentDate)
    print(formatter.string(from: newDate!))
}
