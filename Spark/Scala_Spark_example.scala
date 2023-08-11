// this example is based on having started a `spark-shell` via command line
// and running our NatWest DQ Engine project which is multiple spark-scala JAR files
// packaaged into a solution
// this code is EXAMPLE only - I have not retained the actual base code of DQ Engine
import scala.util.control.Exception._
import dq.analytical.Analytical // this is one of the sub sections of DQ engine code base 
import dq.streamsets._ // again, a sub section within DQ Engine 
import org.apache.spark.sql.types.{StructType, StructField, BooleanType}
import org.apache.spark.sql.{Row}
import scala.collection.JavaConversions._

// create a dummy input dataFrame : was required when DQ engine was sourcing in-memory data
val inputData = spark.createDataFrame(Seq(Row(true)), StructType(Array(StructField("__no_input_data__", BooleanType, true))))

// create pipeline object and provide params for DQ Analytical Engine 
// Pipeline comes from dq.streamsets import 
val pipeline: Pipeline = new Pipeline(
    params = Map(
        "dq_ruleset_id"   -> "1915",
        "addl_params"     -> """"extractDate":"2023-01-01"""".trim
    ),
    env = Map(
        "Pipeline User"    -> "Dan Collins",
        "Pipeline Version" -> "v0.01"
    )
)

// execute engine test 
Analytical.run(pipeline, inputData) 

// stop spark session
spark.stop()

// quit spark-shell 
:q