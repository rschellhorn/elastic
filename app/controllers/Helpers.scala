package controllers

import java.nio.file.{ FileSystems, Files, Path }
import org.joda.time.Period
import play.api.libs.concurrent.Execution.Implicits._
import play.api.libs.json._
import play.api.libs.ws.WS
import scala.collection.JavaConversions._
import scala.concurrent.Await
import scala.concurrent.duration._
import scala.util.Try
import scala.xml.{ Node, NodeSeq, XML }
import play.api.libs.json.Json.toJsFieldJsValueWrapper
import scala.Option.option2Iterable
import scala.collection.immutable.Stream.consWrapper

object Helpers {
    val host = "http://localhost:9200"
    val storage = FileSystems.getDefault().getPath("/Users/robschellhorn/Documents/kennisnet/edurep/storage")

    def query(from: Long = 0, size: Int = 100): Stream[JsValue] = Await.result(
        WS.url(s"${host}/edurep/lom/_search").post(Json.obj(
            "from" -> from,
            "size" -> size,
            "query" -> Json.obj(
                "match_all" -> Json.obj()
            )
        )).map { response =>
            val hits = (response.json\"hits"\"hits").as[List[JsValue]].toStream
            (response.json\"hits"\"total").as[Long] match {
                case total if total > from + size => hits #::: query(from + size, size)
                case _ => hits
            }
        }, 3 seconds
    )

    implicit class RichNodeSeq(val nodes: NodeSeq) extends AnyVal {

        private def langString(node: Node) = node.find { node => (node\"string"\"@language").text == "nl" }
                                         .orElse { node\"string" headOption }
                                         .map(_.text.trim)

        def asDuration = Try(Period.parse(nodes.text)).map(_.getHours()).toOption
        def bestValue = nodes.headOption.flatMap(langString).getOrElse("")
        def bestValues = nodes.flatMap(langString)
    }

    implicit class RichPath(val path: Path) extends AnyVal {
        implicit def toFile(path: Path) = path.toFile()
        def \(other: String) = path.resolve(other)
        def contents = play.api.libs.Files.readFile(path)
        def entries = Files.newDirectoryStream(path, "*").toStream
        def name = path.getName()
        def writeIfChanged(content: String) = play.api.libs.Files.writeFileIfChanged(path, content)
        def xml = XML.loadFile(path)
    }
}