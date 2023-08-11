// a simple UDF designed to be used with Scala Spark, which can clean 
// values to a standard USA format.
// designed to be packaged to a JAR, which is imported at Spark-Submit / spark-shell startup 

package object UScleaner { 
    def cleanCountry = (country: String) => {
        val allUSA = Seq("US", "USa", "USA", "United States", "United States of America") 
        if (allUSA.contains(country)) {
            "USA"
        }
        else {
            "unknown" 
        }
    }
}
