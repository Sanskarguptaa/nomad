job "non-gpu-example" {
  datacenters = ["dc1"]
  type = "service"

  group "web" {
    count = 2

    network {
      port "http" {
        to = 80
      }
    }

    service {
      name = "webapp"
      port = "http"
      
      check {
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "server" {
      driver = "docker"

      config {
        image = "nginx:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}