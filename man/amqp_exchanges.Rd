% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/exchange.R
\name{amqp_exchanges}
\alias{amqp_exchanges}
\alias{amqp_declare_exchange}
\alias{amqp_delete_exchange}
\title{Declare or Delete Exchanges}
\usage{
amqp_declare_exchange(conn, exchange, type = "direct", passive = FALSE,
  durable = FALSE, auto_delete = FALSE, internal = FALSE, ...)

amqp_delete_exchange(conn, exchange, if_unused = FALSE)
}
\arguments{
\item{conn}{An object returned by \code{\link{amqp_connect}}.}

\item{exchange}{The name of an exchange.}

\item{type}{The type of exchange. Usually one of \code{"direct"},
\code{"fanout"}, or \code{"topic"}.}

\item{passive}{When \code{TRUE}, raise an error if the exchange does not
already exist.}

\item{durable}{When \code{TRUE}, the exchange will persist between server
restarts.}

\item{auto_delete}{When \code{TRUE}, the exchange is automatically deleted
when all queues have finished using it.}

\item{internal}{When \code{TRUE}, the exchange cannot be used for publishing
messages; it can only be \link[=amqp_bindings]{bound} to other exchanges.
This is for creating complex routing topologies that are not visible to
consumers.}

\item{...}{Additional arguments, used to declare broker-specific AMQP
extensions. See \strong{Details}.}

\item{if_unused}{Delete the exchange only if it is unused (i.e. no queues are
\link[=amqp_bindings]{bound} to it).}
}
\description{
AMQP exchanges route messages to queues. By default the server will have a
few exchanges declared (including the default exchange \code{""}), but
additional exchanges can be declared and subsequently deleted by clients.

Both \code{amqp_declare_exchange()} and \code{amqp_delete_exchange()} will
raise errors if there is a problem declaring/deleting the exchange.
}
\details{
Additional arguments can be used to declare broker-specific extensions. An
incomplete list is as follows:

\describe{
  \item{\code{"alternate-exchange"}}{Specify an
    \href{https://www.rabbitmq.com/ae.html}{alternate exchange} to handle
    messages the broker is unable to route.}
}
}
\examples{
\dontrun{
conn <- amqp_connect()
amqp_declare_exchange(conn, "test_exchange", "fanout")
amqp_delete_exchange(conn, "test_exchange")
amqp_disconnect(conn)
}

}
