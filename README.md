
<!-- README.md is generated from README.Rmd. Please edit that file. -->
longears
========

This repository contains an early stage RabbitMQ client for R. It wraps the [reference C library](https://github.com/alanxz/rabbitmq-c).

[RabbitMQ](https://www.rabbitmq.com/) is a popular and performant open-source message broker used to build highly distributed and asynchronous network topologies. This package may be of interest to you if you wish to have R speak to your organization's existing RabbitMQ servers; if you simply need a message queue library, you may be better off with [**txtq**](https://github.com/wlandau/txtq), [**litq**](https://github.com/r-lib/liteq), or the ZeroMQ package [**rzmq**](https://github.com/ropensci/rzmq).

The package implements a growing subset of the Advanced Message Queuing Protocol (AMQP) used by RabbitMQ (see [Limitations](#Limitations) for details), and the API largely reflects [the protocol itself](https://www.rabbitmq.com/amqp-0-9-1-reference.html).

Installation
------------

You will need `librabbitmq`, otherwise the installation will fail. On Ubuntu, run

``` shell
$ apt install librabbitmq-dev
```

The package is only available from GitHub for now, so you can install it with

``` r
# install.packages("devtools")
devtools::install_github("atheriel/longears")
```

Usage
-----

You will need to have a local RabbitMQ server running with the default settings to test this.

``` shell
$ # apt install rabbitmq-server
$ systemctl start rabbitmq-server
$ rabbitmqctl status
```

First, connect to the server (with default settings):

``` r
conn <- amqp_connect()
conn
#> AMQP Connection:
#>   status:  connected
#>   address: localhost:5672
#>   vhost:   '/'
```

Create an exchange to route messages and a queue to store them:

``` r
amqp_declare_exchange(conn, "my.exchange")
amqp_declare_queue(conn, "my.queue")
#> AMQP queue 'my.queue'
#>   messages:  0
#>   consumers: 0
amqp_bind_queue(conn, "my.queue", "my.exchange", routing_key = "#")
```

Now, send a message to this exchange:

``` r
amqp_publish(conn, "#", "message", exchange = "my.exchange")
amqp_publish(conn, "#", "second message", exchange = "my.exchange")
```

Check if your messages are going into the queue:

``` shell
$ rabbitmqctl list_queues
```

And to pull messages back into R:

``` r
amqp_get(conn, "my.queue")
#> [1] "message"
#> attr(,"content_type")
#> [1] "text/plain"
amqp_get(conn, "my.queue")
#> [1] "second message"
#> attr(,"content_type")
#> [1] "text/plain"
amqp_get(conn, "my.queue")
#> character(0)
```

Afterwards you can delete the queue and disconnect from the server:

``` r
amqp_delete_queue(conn, "my.queue")
amqp_delete_exchange(conn, "my.exchange")
amqp_disconnect(conn)
conn
#> AMQP Connection:
#>   status:  disconnected
#>   address: localhost:5672
#>   vhost:   '/'
```

And check that the connection is closed:

``` shell
$ rabbitmqctl list_connections
```

Limitations
-----------

There are many AMQP features missing at present but that will be added in the future. An incomplete list is as follows:

-   Additional Basic methods.
-   Additional Basic properties.
-   Message headers.
-   Support for "table" arguments to e.g. exchange declarations.

In addition, the API does not at present implement any asynchronous functionality. Most notably, there is no `consume` support, although it is my hope a design for one can be worked out in the future.

License
-------

The package is licensed under the GPL, version 2 or later.
