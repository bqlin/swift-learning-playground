//: # 访问控制
//: *访问控制*可以限定其它源文件或模块中的代码对你的代码的访问级别。这个特性可以让我们隐藏代码的一些实现细节，并且可以为其他人可以访问和使用的代码提供接口。
//:
//: 你可以明确地给单个类型（类、结构体、枚举）设置访问级别，也可以给这些类型的属性、方法、构造器、下标等设置访问级别。协议也可以被限定在一定的范围内使用，包括协议里的全局常量、变量和函数。
//:
//: Swift 不仅提供了多种不同的访问级别，还为某些典型场景提供了默认的访问级别，这样就不需要我们在每段代码中都申明显式访问级别。其实，如果只是开发一个单一 target 的应用程序，我们完全可以不用显式声明代码的访问级别。
//:
//: > 为了简单起见，对于代码中可以设置访问级别的特性（属性、基本类型、函数等），在下面的章节中我们会称之为“实体”。
//:
//: ## 模块和源文件
//:
//: Swift 中的访问控制模型基于模块和源文件这两个概念。
//:
//: *模块*指的是独立的代码单元，框架或应用程序会作为一个独立的模块来构建和发布。在 Swift 中，一个模块可以使用 `import` 关键字导入另外一个模块。
//:
//: 在 Swift 中，Xcode 的每个 target（例如框架或应用程序）都被当作独立的模块处理。如果你是为了实现某个通用的功能，或者是为了封装一些常用方法而将代码打包成独立的框架，这个框架就是 Swift 中的一个模块。当它被导入到某个应用程序或者其他框架时，框架内容都将属于这个独立的模块。
//:
//: *源文件*就是 Swift 中的源代码文件，它通常属于一个模块，即一个应用程序或者框架。尽管我们一般会将不同的类型分别定义在不同的源文件中，但是同一个源文件也可以包含多个类型、函数之类的定义。
//:
//: ## 访问级别
//:
//: Swift 为代码中的实体提供了五种不同的*访问级别*。这些访问级别不仅与源文件中定义的实体相关，同时也与源文件所属的模块相关。
//:
//: - *Open* 和 *Public* 级别可以让实体被同一模块源文件中的所有实体访问，在模块外也可以通过导入该模块来访问源文件里的所有实体。通常情况下，你会使用 Open 或 Public 级别来指定框架的外部接口。Open 和 Public 的区别在后面会提到。
//: - *Internal* 级别让实体被同一模块源文件中的任何实体访问，但是不能被模块外的实体访问。通常情况下，如果某个接口只在应用程序或框架内部使用，就可以将其设置为 Internal 级别。
//: - *File-private* 限制实体只能在其定义的文件内部访问。如果功能的部分细节只需要在文件内使用时，可以使用 File-private 来将其隐藏。
//: - *Private* 限制实体只能在其定义的作用域，以及同一文件内的 extension 访问。如果功能的部分细节只需要在当前作用域内使用时，可以使用 Private 来将其隐藏。
//:
//: Open 为最高访问级别（限制最少），Private 为最低访问级别（限制最多）。
//:
//: Open 只能作用于类和类的成员，它和 Public 的区别如下：
//:
//: * Public 或者其它更严访问级别的类，只能在其定义的模块内部被继承。
//: * Public 或者其它更严访问级别的类成员，只能在其定义的模块内部的子类中重写。
//: * Open 的类，可以在其定义的模块中被继承，也可以在引用它的模块中被继承。
//: * Open 的类成员，可以在其定义的模块中子类中重写，也可以在引用它的模块中的子类重写。
//:
//: 把一个类标记为 `open`，明确的表示你已经充分考虑过外部模块使用此类作为父类的影响，并且设计好了你的类的代码了。
//:
//: ### 访问级别基本原则
//:
//: Swift 中的访问级别遵循一个基本原则：*不可以在某个实体中定义访问级别更低（更严格）的实体*。
//:
//: 例如：
//:
//: - 一个 Public 的变量，其类型的访问级别不能是 Internal，File-private 或是 Private。因为无法保证变量的类型在使用变量的地方也具有访问权限。
//: - 函数的访问级别不能高于它的参数类型和返回类型的访问级别。因为这样就会出现函数可以在任何地方被访问，但是它的参数类型和返回类型却不可以的情况。
//:
//: ### 默认访问级别
//:
//: 如果你没有为代码中的实体显式指定访问级别，那么它们默认为 `internal` 级别（有一些例外情况，稍后会进行说明）。因此，在大多数情况下，我们不需要显式指定实体的访问级别。
//:
//: ### 单 target 应用程序的访问级别
//:
//: 当你编写一个单目标应用程序时，应用的所有功能都是为该应用服务，而不需要提供给其他应用或者模块使用，所以我们不需要明确设置访问级别，使用默认的访问级别 Internal 即可。但是，你也可以使用 `fileprivate` 访问或 `private` 访问级别，用于隐藏一些功能的实现细节。
//:
//: ### 框架的访问级别
//:
//: 当你开发框架时，就需要把一些对外的接口定义为 Open 或 Public，以便使用者导入该框架后可以正常使用其功能。这些被你定义为对外的接口，就是这个框架的 API。
//:
//: > 框架依然会使用默认的 `internal` ，也可以指定为 `fileprivate` 访问或者 `private` 访问级别。当你想把某个实体作为框架的 API 的时候，需显式为其指定开放访问或公开访问级别。
//:
//: ### 单元测试 target 的访问级别
//:
//: 当你的应用程序包含单元测试 target 时，为了测试，测试模块需要访问应用程序模块中的代码。默认情况下只有 `open` 或 `public` 级别的实体才可以被其他模块访问。然而，如果在导入应用程序模块的语句前使用 `@testable` 特性，然后在允许测试的编译设置（`Build Options -> Enable Testability`）下编译这个应用程序模块，单元测试目标就可以访问应用程序模块中所有内部级别的实体。
//:
//: ## 访问控制语法
//:
//: 通过修饰符 `open`，`public`，`internal`，`fileprivate`，`private` 来声明实体的访问级别：
//:
//public class SomePublicClass {}
//internal class SomeInternalClass {}
//fileprivate class SomeFilePrivateClass {}
//private class SomePrivateClass {}
//
//public var somePublicVariable = 0
//internal let someInternalConstant = 0
//fileprivate func someFilePrivateFunction() {}
//private func somePrivateFunction() {}

//: 除非专门指定，否则实体默认的访问级别为 `internal`，可以查阅[默认访问级别]()这一节。这意味着在不使用修饰符显式声明访问级别的情况下，`SomeInternalClass` 和 `someInternalConstant` 仍然拥有隐式的 `internal`：
//:
//class SomeInternalClass {}   // 隐式 internal
//var someInternalConstant = 0 // 隐式 internal

//: ## 自定义类型
//:
//: 如果想为一个自定义类型指定访问级别，在定义类型时进行指定即可。新类型只能在它的访问级别限制范围内使用。例如，你定义了一个 `fileprivate` 级别的类，那这个类就只能在定义它的源文件中使用，可以作为属性类型、函数参数类型或者返回类型，等等。
//:
//: 一个类型的访问级别也会影响到类型*成员*（属性、方法、构造器、下标）的默认访问级别。如果你将类型指定为 `private` 或者 `fileprivate` 级别，那么该类型的所有成员的默认访问级别也会变成 `private` 或者 `fileprivate` 级别。如果你将类型指定为公开或者 `internal` （或者不明确指定访问级别，而使用默认的 `internal` ），那么该类型的所有成员的默认访问级别将是内部访问。
//:
//: > 上面提到，一个 `public` 类型的所有成员的访问级别默认为 `internal` 级别，而不是 `public` 级别。如果你想将某个成员指定为 `public` 级别，那么你必须显式指定。这样做的好处是，在你定义公共接口的时候，可以明确地选择哪些接口是需要公开的，哪些是内部使用的，避免不小心将内部使用的接口公开。
//:
public class SomePublicClass {                  // 显式 public 类
	public var somePublicProperty = 0            // 显式 public 类成员
	var someInternalProperty = 0                 // 隐式 internal 类成员
	fileprivate func someFilePrivateMethod() {}  // 显式 fileprivate 类成员
	private func somePrivateMethod() {}          // 显式 private 类成员
}

class SomeInternalClass {                       // 隐式 internal 类
	var someInternalProperty = 0                 // 隐式 internal 类成员
	fileprivate func someFilePrivateMethod() {}  // 显式 fileprivate 类成员
	private func somePrivateMethod() {}          // 显式 private 类成员
}

fileprivate class SomeFilePrivateClass {        // 显式 fileprivate 类
	func someFilePrivateMethod() {}              // 隐式 fileprivate 类成员
	private func somePrivateMethod() {}          // 显式 private 类成员
}

private class SomePrivateClass {                // 显式 private 类
	func somePrivateMethod() {}                  // 隐式 private 类成员
}

//: ### 元组类型
//:
//: 元组的访问级别将由元组中访问级别最严格的类型来决定。例如，如果你构建了一个包含两种不同类型的元组，其中一个类型为 `internal`，另一个类型为 `private`，那么这个元组的访问级别为 `private`。
//:
//: > 元组不同于类、结构体、枚举、函数那样有单独的定义。元组的访问级别是在它被使用时自动推断出的，而无法明确指定。
//:
//: ### 函数类型
//:
//: 函数的访问级别根据访问级别最严格的参数类型或返回类型的访问级别来决定。但是，如果这种访问级别不符合函数定义所在环境的默认访问级别，那么就需要明确地指定该函数的访问级别。
//:
//: 下面的例子定义了一个名为 `someFunction()` 的全局函数，并且没有明确地指定其访问级别。也许你会认为该函数应该拥有默认的访问级别 `internal`，但事实并非如此。事实上，如果按下面这种写法，代码将无法通过编译：
//:
//func someFunction() -> (SomeInternalClass, SomePrivateClass) {
//	// 此处是函数实现部分
//}

//: 我们可以看到，这个函数的返回类型是一个元组，该元组中包含两个自定义的类（可查阅[自定义类型](#custom_types)）。其中一个类的访问级别是 `internal`，另一个的访问级别是 `private`，所以根据元组访问级别的原则，该元组的访问级别是 `private`（元组的访问级别与元组中访问级别最低的类型一致）。
//:
//: 因为该函数返回类型的访问级别是 `private`，所以你必须使用 `private` 修饰符，明确指定该函数的访问级别：
//:
private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
	// 此处是函数实现部分
	return (SomeInternalClass(), SomePrivateClass())
}

//: 将该函数指定为 `public` 或 `internal`，或者使用默认的访问级别 `internal` 都是错误的，因为如果把该函数当做 `public` 或 `internal` 级别来使用的话，可能会无法访问 `private` 级别的返回值。
//:
//: ### 枚举类型
//:
//: 枚举成员的访问级别和该枚举类型相同，你不能为枚举成员单独指定不同的访问级别。
//:
public enum CompassPoint {
	case North
	case South
	case East
	case West
}

//: #### 原始值和关联值
//:
//: 枚举定义中的任何原始值或关联值的类型的访问级别至少不能低于枚举类型的访问级别。例如，你不能在一个 `internal` 的枚举中定义 `private` 的原始值类型。
//:
//: ### 嵌套类型
//:
//: 如果在 `private` 的类型中定义嵌套类型，那么该嵌套类型就自动拥有 `private` 访问级别。如果在 `public` 或者 `internal` 级别的类型中定义嵌套类型，那么该嵌套类型自动拥有 `internal` 访问级别。如果想让嵌套类型拥有 `public` 访问级别，那么需要明确指定该嵌套类型的访问级别。
//:
//: ## 子类
//:
//: 子类的访问级别不得高于父类的访问级别。例如，父类的访问级别是 `internal`，子类的访问级别就不能是 `public`。
//:
//: 此外，你可以在符合当前访问级别的条件下重写任意类成员（方法、属性、构造器、下标等）。
//:
public class A {
	fileprivate func someMethod() {}
}

internal class B: A {
	override internal func someMethod() {
		super.someMethod()
	}
}

//: ## 常量、变量、属性、下标
//:
//: 常量、变量、属性不能拥有比它们的类型更高的访问级别。例如，你不能定义一个 `public` 级别的属性，但是它的类型却是 `private` 级别的。同样，下标也不能拥有比索引类型或返回类型更高的访问级别。
//:
//: 如果常量、变量、属性、下标的类型是 `private` 级别的，那么它们必须明确指定访问级别为 `private`：
//:
//private var privateInstance = SomePrivateClass()

//: ### Getter 和 Setter
//:
//: 常量、变量、属性、下标的 `Getters` 和 `Setters` 的访问级别和它们所属类型的访问级别相同。
//:
//: `Setter` 的访问级别可以低于对应的 `Getter` 的访问级别，这样就可以控制变量、属性或下标的读写权限。在 `var` 或 `subscript` 关键字之前，你可以通过 `fileprivate(set)`，`private(set)` 或 `internal(set)` 为它们的写入权限指定更低的访问级别。
//:
//: > 这个规则同时适用于存储型属性和计算型属性。即使你不明确指定存储型属性的 `Getter` 和 `Setter`，Swift 也会隐式地为其创建 `Getter` 和 `Setter`，用于访问该属性的后备存储。使用 `fileprivate(set)`，`private(set)` 和 `internal(set)` 可以改变 `Setter` 的访问级别，这对计算型属性也同样适用。
//:
public struct TrackedString {
	public private(set) var numberOfEdits = 0
	public var value: String = "" {
		didSet {
			numberOfEdits += 1
		}
	}
	public init() {}
}

var stringToEdit = TrackedString()
stringToEdit.value = "This string will be tracked."
stringToEdit.value += " This edit will increment numberOfEdits."
stringToEdit.value += " So will this one."
print("The number of edits is \(stringToEdit.numberOfEdits)")
// 打印“The number of edits is 3”

//: ## 构造器
//:
//: 自定义构造器的访问级别可以低于或等于其所属类型的访问级别。唯一的例外是[必要构造器](Initialization)，它的访问级别必须和所属类型的访问级别相同。
//:
//: 如同函数或方法的参数，构造器参数的访问级别也不能低于构造器本身的访问级别。
//:
//: ### 默认构造器
//:
//: 如[默认构造器](Initialization)所述，Swift 会为结构体和类提供一个默认的无参数的构造器，只要它们为所有存储型属性设置了默认初始值，并且未提供自定义的构造器。
//:
//: 默认构造器的访问级别与所属类型的访问级别相同，除非类型的访问级别是 `public`。如果一个类型被指定为 `public` 级别，那么默认构造器的访问级别将为 `internal`。如果你希望一个 `public` 级别的类型也能在其他模块中使用这种无参数的默认构造器，你只能自己提供一个 `public` 访问级别的无参数构造器。
//:
//: ### 结构体默认的成员逐一构造器
//:
//: 如果结构体中任意存储型属性的访问级别为 `private`，那么该结构体默认的成员逐一构造器的访问级别就是 `private`。否则，这种构造器的访问级别依然是 `internal`。
//:
//: 如同前面提到的默认构造器，如果你希望一个 `public` 级别的结构体也能在其他模块中使用其默认的成员逐一构造器，你依然只能自己提供一个 `public` 访问级别的成员逐一构造器。
//:
//: ## 协议
//:
//: 如果想为一个协议类型明确地指定访问级别，在定义协议时指定即可。这将限制该协议只能在适当的访问级别范围内被遵循。
//:
//: 协议中的每一个要求都具有和该协议相同的访问级别。你不能将协议中的要求设置为其他访问级别。这样才能确保该协议的所有要求对于任意遵循者都将可用。
//:
//: > 如果你定义了一个 `public` 访问级别的协议，那么该协议的所有实现也会是 `public` 访问级别。这一点不同于其他类型，例如，当类型是 `public` 访问级别时，其成员的访问级别却只是 `internal`。
//:
//: ### 协议继承
//:
//: 如果定义了一个继承自其他协议的新协议，那么新协议拥有的访问级别最高也只能和被继承协议的访问级别相同。例如，你不能将继承自 `internal` 协议的新协议定义为 `public` 协议。
//:
//: ### 协议遵循
//:
//: 一个类型可以遵循比它级别更低的协议。例如，你可以定义一个 `public` 级别类型，它能在别的模块中使用，但是如果它遵循一个 `internal` 协议，这个遵循的部分就只能在这个 `internal` 协议所在的模块中使用。
//:
//: 遵循协议时的上下文级别是类型和协议中级别最小的那个。如果一个类型是 `public` 级别，但它要遵循的协议是 `internal` 级别，那么这个类型对该协议的遵循上下文就是 `internal` 级别。
//:
//: 当你编写或扩展一个类型让它遵循一个协议时，你必须确保该类型对协议的每一个要求的实现，至少与遵循协议的上下文级别一致。例如，一个 `public` 类型遵循一个 `internal` 协议，这个类型对协议的所有实现至少都应是 `internal` 级别的。
//:
//: > Swift 和 Objective-C 一样，协议遵循是全局的，也就是说，在同一程序中，一个类型不可能用两种不同的方式实现同一个协议。
//:
//: ## Extension
//:
//: Extension 可以在访问级别允许的情况下对类、结构体、枚举进行扩展。Extension 的成员具有和原始类型成员一致的访问级别。例如，你使用 extension 扩展了一个 `public` 或者 `internal` 类型，extension 中的成员就默认使用 `internal` 访问级别，和原始类型中的成员一致。如果你使用 extension 扩展了一个 `private` 类型，则 extension 的成员默认使用 `private` 访问级别。
//:
//: 或者，你可以明确指定 extension 的访问级别（例如，`private extension`），从而给该 extension 中的所有成员指定一个新的默认访问级别。这个新的默认访问级别仍然可以被单独指定的访问级别所覆盖。
//:
//: 如果你使用 extension 来遵循协议的话，就不能显式地声明 extension 的访问级别。extension 每个 protocol 要求的实现都默认使用 protocol 的访问级别。
//:
//: ### Extension 的私有成员
//:
//: 扩展同一文件内的类，结构体或者枚举，extension 里的代码会表现得跟声明在原类型里的一模一样。也就是说你可以这样：
//:
//: - 在类型的声明里声明一个私有成员，在同一文件的 extension 里访问。
//: - 在 extension 里声明一个私有成员，在同一文件的另一个 extension 里访问。
//: - 在 extension 里声明一个私有成员，在同一文件的类型声明里访问。
//:
protocol SomeProtocol {
	func doSomething()
}

struct SomeStruct {
	private var privateVariable = 12
}

extension SomeStruct: SomeProtocol {
	func doSomething() {
		print(privateVariable)
	}
}

//: ## 泛型
//:
//: 泛型类型或泛型函数的访问级别取决于泛型类型或泛型函数本身的访问级别，还需结合类型参数的类型约束的访问级别，根据这些访问级别中的最低访问级别来确定。
//:
//: ## 类型别名
//:
//: 你定义的任何类型别名都会被当作不同的类型，以便于进行访问控制。类型别名的访问级别不可高于其表示的类型的访问级别。例如，`private` 级别的类型别名可以作为 `private`、`file-private`、`internal`、`public` 或者 `open` 类型的别名，但是 `public` 级别的类型别名只能作为 `public` 类型的别名，不能作为 `internal`、`file-private` 或 `private` 类型的别名。
//:
//: > 这条规则也适用于为满足协议遵循而将类型别名用于关联类型的情况。
//:



//: [上一页](@previous) | [下一页](@next)
