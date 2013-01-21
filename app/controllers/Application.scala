package controllers

import Helpers._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.libs.iteratee._
import play.api.mvc._

object Application extends Controller {

    def index = Action { implicit request =>
        Async {
            ElasticSearch.httpAddress.map { address =>
                val entry = storage.entries.head
                Ok(views.html.main(
                    node = address.getOrElse("http://localhost:9200"),
                    lom = entry.xml
                ))
            }
        }
    }

    def lom = Action {
        Ok(ElasticSearch.asJson(storage.entries.head))
    }

    def join = WebSocket.using[String] { request =>
        val input = Iteratee.foreach[String] { msg =>
            msg match {
                case "index" => ElasticSearch.indexLoms()
                case _ =>
            }
        }

        (input, ElasticSearch.events)
    }
}