package controllers

import Helpers._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.libs.iteratee._
import play.api.libs.json._
import play.api.libs.ws.WS

object ElasticSearch {

    val (events, channel) = Concurrent.broadcast[String]

    case class Node(name: String, version: String, http_address: String)
    implicit val nodeReads = Json.reads[Node]

    def httpAddress = WS.url(s"${host}/_nodes").get.map { response =>
        (response.json\"nodes").as[Map[String, Node]].flatMap { case (id, node) =>
            node.http_address.drop("inet[".length).dropRight("]".length).split(",")
        }.headOption.filterNot(_.isEmpty).map("/"+_)
    }

    def indexLoms() = storage.entries.take(1000).foreach { entry =>

        val json = Json.obj(
            "title"       -> (entry.xml\"general"\"title").bestValue,
            "description" -> (entry.xml\"general"\"description").bestValue,
            "keyword"     -> (entry.xml\"general"\"keyword").bestValues,
            "context"     -> (entry.xml\"educational"\"context"\"value").map(_.text),
            "costs"       -> ((entry.xml\"rights"\"cost"\"value").text == "yes"),
            "duration"    -> (entry.xml\"educational"\"typicalLearningTime"\"duration").asDuration,
            "repository"  -> entry.name.split(":").headOption
        )

        WS.url(s"${host}/edurep/lom/${entry.name}").post(json).map { response =>
            channel.push(response.body)
        }
    }
}