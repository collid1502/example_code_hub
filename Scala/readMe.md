# Scala 

#### Creating a simple JAR file of Scala code and calling it 

- create a simple script `simpleAdder.scala` which contains the code we wish to package to a JAR file 
- then, from the CMD line, ensure you CD into the folder containing the scala code, & execute: `scalac simpleAdder.scala -d simple-adder.jar` **NOTE** - DO NOT execute this in scala shell, just regular command line 
- the above will build a JAR file in that location 
- now, to test the jar, run `scala -cp simple-adder.jar` which launches scala shell with the JAR added to the class path
- now, from within the Scala Shell, execute: `import adder.addOne` which will import the *addOne()* method from the package **adder** 
- Then, test it's use by executing `addOne(5)` which should return `val res0: Int = 6` 
- exit the Scala Shell 
