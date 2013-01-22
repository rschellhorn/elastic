package controllers

import Helpers._
import play.api.libs.concurrent.Execution.Implicits._
import play.api.mvc._

object Application extends Controller {

    def sheets = Action { implicit request =>
        Async {
            ElasticSearch.httpAddress.map { address =>
                val entry = storage.entries.head
                Ok(views.html.main(
                    node = address.getOrElse("http://localhost:9200"),
                    lom = entry.xml,
                    lomAsJson = ElasticSearch.asJson(entry)
                ))
            }
        }
    }

    def index = Action {
        ElasticSearch.indexLoms()
        Ok("done")
    }

    def index2 = Action {
        query().foreach(ElasticSearch.index2)
        Ok
    }
}