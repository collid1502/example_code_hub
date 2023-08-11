// simple function to add 1 to a number passed in 
package object adder {
    object addOne extends Function1[Int, Int] {
        def apply(m: Int): Int = m + 1 
    }
}
