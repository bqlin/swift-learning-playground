//: # 属性
//: *属性*将值跟特定的类、结构或枚举关联。存储属性存储常量或变量作为实例的一部分，而计算属性计算（不是存储）一个值。计算属性可以用于类、结构体和枚举，存储属性只能用于类和结构体。
//:
//: 存储属性和计算属性通常与特定类型的实例关联。但是，属性也可以直接作用于类型本身，这种属性称为类型属性。
//:
//: 另外，还可以定义属性观察器来监控属性值的变化，以此来触发一个自定义的操作。属性观察器可以添加到自己定义的存储属性上，也可以添加到从父类继承的属性上。
//:
//: ## 存储属性
//:
//: 简单来说，一个存储属性就是存储在特定类或结构体实例里的一个常量或变量。存储属性可以是*变量存储属性*（用关键字 `var` 定义），也可以是*常量存储属性*（用关键字 `let` 定义）。
//:
//: 下面的例子定义了一个名为 `FixedLengthRange` 的结构体，该结构体用于描述整数的范围，且这个范围值在被创建后不能被修改。
//:
struct FixedLengthRange {
	var firstValue: Int
	let length: Int
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
// 该区间表示整数0，1，2
rangeOfThreeItems.firstValue = 6
// 该区间现在表示整数6，7，8

//: ### 常量结构体的存储属性
//:
//: 如果创建了一个结构体的实例并将其赋值给一个常量，则无法修改该实例的任何属性，即使有属性被声明为变量也不行：
//:
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
// 该区间表示整数0，1，2，3
//rangeOfFourItems.firstValue = 6
// 尽管 firstValue 是个变量属性，这里还是会报错

//: 这种行为是由于结构体（struct）属于*值类型*。当值类型的实例被声明为常量的时候，它的所有属性也就成了常量。
//:
//: 属于*引用类型*的类（class）则不一样。把一个引用类型的实例赋给一个常量后，仍然可以修改该实例的变量属性。
//:
//: ### 延迟存储属性
//:
//: *延迟存储属性*是指当第一次被调用的时候才会计算其初始值的属性。在属性声明前使用 `lazy` 来标示一个延迟存储属性。
//:
//: > 必须将延迟存储属性声明成变量（使用 `var` 关键字），因为属性的初始值可能在实例构造完成之后才会得到。而常量属性在构造过程完成之前必须要有初始值，因此无法声明成延迟属性。
//:
//: 延迟属性很有用，当属性的值依赖于在实例的构造过程结束后才会知道影响值的外部因素时，或者当获得属性的初始值需要复杂或大量计算时，可以只在需要的时候计算它。
//:
class DataImporter {
	/*
	DataImporter 是一个负责将外部文件中的数据导入的类。
	这个类的初始化会消耗不少时间。
	*/
	var fileName = "data.txt"
	// 这里会提供数据导入功能
}

class DataManager {
	lazy var importer = DataImporter()
	var data = [String]()
	// 这里会提供数据管理功能
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
// DataImporter 实例的 importer 属性还没有被创建

//print(manager.importer.fileName)
// DataImporter 实例的 importer 属性现在被创建了
// 输出 "data.txt”

//: > 如果一个被标记为 `lazy` 的属性在没有初始化时就同时被多个线程访问，则无法保证该属性只会被初始化一次。
//:
//: ### 存储属性和实例变量
//:
//: 如果您有过 Objective-C 经验，应该知道 Objective-C 为类实例存储值和引用提供两种方法。除了属性之外，还可以使用实例变量作为属性值的后端存储。
//:
//: Swift 编程语言中把这些理论统一用属性来实现。Swift 中的属性没有对应的实例变量，属性的后端存储也无法直接访问。这就避免了不同场景下访问方式的困扰，同时也将属性的定义简化成一个语句。属性的全部信息——包括命名、类型和内存管理特征——作为类型定义的一部分，都定义在一个地方。
//:
//: ## 计算属性
//:
//: 除存储属性外，类、结构体和枚举可以定义*计算属性*。计算属性不直接存储值，而是提供一个 getter 和一个可选的 setter，来间接获取和设置其他属性或变量的值。
//:
struct Point {
	var x = 0.0, y = 0.0
}
struct Size {
	var width = 0.0, height = 0.0
}
struct Rect {
	var origin = Point()
	var size = Size()
	var center: Point {
		get {
			let centerX = origin.x + (size.width / 2)
			let centerY = origin.y + (size.height / 2)
			return Point(x: centerX, y: centerY)
		}
		set(newCenter) {
			origin.x = newCenter.x - (size.width / 2)
			origin.y = newCenter.y - (size.height / 2)
		}
	}
}
var square = Rect(origin: Point(x: 0.0, y: 0.0),
				  size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
//print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
// 打印 "square.origin is now at (10.0, 10.0)"

//: ### 简化 Setter 声明
//:
//: 如果计算属性的 setter 没有定义表示新值的参数名，则可以使用默认名称 `newValue`。下面是使用了简化 setter 声明的 `Rect` 结构体代码：
//:
struct AlternativeRect {
	var origin = Point()
	var size = Size()
	var center: Point {
		get {
			let centerX = origin.x + (size.width / 2)
			let centerY = origin.y + (size.height / 2)
			return Point(x: centerX, y: centerY)
		}
		set {
			origin.x = newValue.x - (size.width / 2)
			origin.y = newValue.y - (size.height / 2)
		}
	}
}

//: ### 只读计算属性
//:
//: 只有 getter 没有 setter 的计算属性就是*只读计算属性*。只读计算属性总是返回一个值，可以通过点运算符访问，但不能设置新的值。
//:
//: > 必须使用 `var` 关键字定义计算属性，包括只读计算属性，因为它们的值不是固定的。`let` 关键字只用来声明常量属性，表示初始化后再也无法修改的值。
//:
struct Cuboid {
	var width = 0.0, height = 0.0, depth = 0.0
	var volume: Double {
		return width * height * depth
	}
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
//print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")
// 打印 "the volume of fourByFiveByTwo is 40.0"

//: ## 属性观察器
//:
//: 属性观察器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，即使新值和当前值相同的时候也不例外。
//:
//: 你可以为除了延迟存储属性之外的其他存储属性添加属性观察器，也可以通过重写属性的方式为继承的属性（包括存储属性和计算属性）添加属性观察器。你不必为非重写的计算属性添加属性观察器，因为可以通过它的 setter 直接监控和响应值的变化。 属性重写请参考[重写](Inheritance)。
//:
//: 可以为属性添加如下的一个或全部观察器：
//:
//: - `willSet` 在新的值被设置之前调用
//: - `didSet` 在新的值被设置之后立即调用
//:
//: `willSet` 观察器会将新的属性值作为常量参数传入，在 `willSet` 的实现代码中可以为这个参数指定一个名称，如果不指定则参数仍然可用，这时使用默认名称 `newValue` 表示。
//:
//: 同样，`didSet` 观察器会将旧的属性值作为参数传入，可以为该参数命名或者使用默认参数名 `oldValue`。如果在 `didSet` 方法中再次对该属性赋值，那么新值会覆盖旧的值。
//:
//: > 父类的属性在子类的构造器中被赋值时，它在父类中的 `willSet` 和 `didSet` 观察器会被调用，随后才会调用子类的观察器。在父类初始化方法调用之前，子类给属性赋值时，观察器不会被调用。
//:
class StepCounter {
	var totalSteps: Int = 0 {
		willSet(newTotalSteps) {
//			print("About to set totalSteps to \(newTotalSteps)")
		}
		didSet {
			if totalSteps > oldValue  {
//				print("Added \(totalSteps - oldValue) steps")
			}
		}
	}
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps
stepCounter.totalSteps = 896
// About to set totalSteps to 896
// Added 536 steps

//: > 如果将属性通过 in-out 方式传入函数，`willSet` 和 `didSet` 也会调用。这是因为 in-out 参数采用了拷入拷出模式：即在函数内部使用的是参数的 copy，函数结束后，又对参数重新赋值。关于 in-out 参数详细的介绍，请参考[输入输出参数](Declarations)。
//:
//: ## 全局变量和局部变量
//:
//: 计算属性和属性观察器所描述的功能也可以用于*全局变量*和*局部变量*。全局变量是在函数、方法、闭包或任何类型之外定义的变量。局部变量是在函数、方法或闭包内部定义的变量。
//:
//: 前面章节提到的全局或局部变量都属于*存储型变量*，跟存储属性类似，它为特定类型的值提供存储空间，并允许读取和写入。
//:
//: 另外，在全局或局部范围都可以定义*计算型变量*和为存储型变量定义观察器。计算型变量跟计算属性一样，返回一个计算结果而不是存储值，声明格式也完全一样。
//:
//: > 全局的常量或变量都是延迟计算的，跟[延迟存储属性](#lazy_stored_properties)相似，不同的地方在于，全局的常量或变量不需要标记 `lazy` 修饰符。
//: >
//: > 局部范围的常量或变量从不延迟计算。
//:
//: ## 类型属性
//:
//: 实例属性属于一个特定类型的实例，每创建一个实例，实例都拥有属于自己的一套属性值，实例之间的属性相互独立。
//:
//: 也可以为类型本身定义属性，无论创建了多少个该类型的实例，这些属性都只有唯一一份。这种属性就是*类型属性*。
//:
//: 类型属性用于定义某个类型所有实例共享的数据，比如*所有*实例都能用的一个常量（就像 C 语言中的静态常量），或者所有实例都能访问的一个变量（就像 C 语言中的静态变量）。
//:
//: 存储型类型属性可以是变量或常量，计算型类型属性跟实例的计算型属性一样只能定义成变量属性。
//:
//: > 跟实例的存储型属性不同，必须给存储型类型属性指定默认值，因为类型本身没有构造器，也就无法在初始化过程中使用构造器给类型属性赋值。
//:
//: > 存储型类型属性是延迟初始化的，它们只有在第一次被访问的时候才会被初始化。即使它们被多个线程同时访问，系统也保证只会对其进行一次初始化，并且不需要对其使用 `lazy` 修饰符。
//:
//: ### 类型属性语法
//:
//: 在 C 或 Objective-C 中，与某个类型关联的静态常量和静态变量，是作为全局（*global*）静态变量定义的。但是在 Swift 中，类型属性是作为类型定义的一部分写在类型最外层的花括号内，因此它的作用范围也就在类型支持的范围内。
//:
//: 使用关键字 `static` 来定义类型属性。在为类定义计算型类型属性时，可以改用关键字 `class` 来支持子类对父类的实现进行重写。下面的例子演示了存储型和计算型类型属性的语法：
//:
struct SomeStructure {
	static var storedTypeProperty = "Some value."
	static var computedTypeProperty: Int {
		return 1
	}
}
enum SomeEnumeration {
	static var storedTypeProperty = "Some value."
	static var computedTypeProperty: Int {
		return 6
	}
}
class SomeClass {
	static var storedTypeProperty = "Some value."
	static var computedTypeProperty: Int {
		return 27
	}
	class var overrideableComputedTypeProperty: Int {
		return 107
	}
}

//: ### 获取和设置类型属性的值
//:
//: 跟实例属性一样，类型属性也是通过点运算符来访问。但是，类型属性是通过类型本身来访问，而不是通过实例。比如：
//:
//print(SomeStructure.storedTypeProperty)
// 打印 "Some value."
SomeStructure.storedTypeProperty = "Another value."
//print(SomeStructure.storedTypeProperty)
// 打印 "Another value.”
//print(SomeEnumeration.computedTypeProperty)
// 打印 "6"
//print(SomeClass.computedTypeProperty)
// 打印 "27"

struct AudioChannel {
	static let thresholdLevel = 10
	static var maxInputLevelForAllChannels = 0
	var currentLevel: Int = 0 {
		didSet {
			if currentLevel > AudioChannel.thresholdLevel {
				// 将当前音量限制在阈值之内
				currentLevel = AudioChannel.thresholdLevel
			}
			if currentLevel > AudioChannel.maxInputLevelForAllChannels {
				// 存储当前音量作为新的最大输入音量
				AudioChannel.maxInputLevelForAllChannels = currentLevel
			}
		}
	}
}

//: > 在第一个检查过程中，`didSet` 属性观察器将 `currentLevel` 设置成了不同的值，但这不会造成属性观察器被再次调用。
//:
var leftChannel = AudioChannel()
var rightChannel = AudioChannel()
leftChannel.currentLevel = 7
//print(leftChannel.currentLevel)
// 输出 "7"
//print(AudioChannel.maxInputLevelForAllChannels)
// 输出 "7"
rightChannel.currentLevel = 11
//print(rightChannel.currentLevel)
// 输出 "10"
//print(AudioChannel.maxInputLevelForAllChannels)
// 输出 "10"



//: [上一页](@previous) | [下一页](@next)
