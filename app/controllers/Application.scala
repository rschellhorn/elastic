package controllers

import Helpers._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.libs.iteratee._
import play.api.mvc._

object Application extends Controller {

    def index = Action {
        Async {
            ElasticSearch.httpAddress.map { address =>
                Ok(views.html.main(address.getOrElse("http://localhost:9200")))
            }
        }
    }

    def lom = Action {
        Ok(storage.entries.head.xml)
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