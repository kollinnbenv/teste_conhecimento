
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
  start = "true"
}


resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_volume" "postgres_data" {
  name = "volum_potgres"
}

resource "docker_image" "postgres_image" {
  name         = "postgres:15.8"
  keep_locally = false
}

resource "docker_container" "postgres_container" {
  image = docker_image.postgres_image.image_id
  name  = "postgres"
  mounts {
    target = "/var/lib/postgresql/data"
    source = docker_volume.postgres_data.name
    type   = "volume"
  }

  ports {
    internal = 5432   
    external = 5432   
  }

  env = [
    "POSTGRES_USER=admin",       
    "POSTGRES_PASSWORD=123", 
    "POSTGRES_DB=teste"      
  ]

  restart = "always"
}
