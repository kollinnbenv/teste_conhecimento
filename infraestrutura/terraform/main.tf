
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}



resource "docker_network" "network" {
  name = "network"
}


resource "docker_container" "nginx_container" {
  image = docker_image.nginx_image.image_id
  name  = "my_nginx"

  networks_advanced {
    name = docker_network.network.name
  }
  
  ports {
    internal = 80   
    external = 8080
  }

  restart = "always"  
}


resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}
