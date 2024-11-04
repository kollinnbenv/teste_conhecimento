
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
  driver = "bridge"
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

  networks_advanced {
    name = docker_network.network.name
  }

  

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
resource "docker_container" "frontend" {
  image = "cubos/frontend"
  name  = "frontend"
  restart = "always"
  ports {
    internal = 80
    external = 80
  }

  networks_advanced {
    name = docker_network.network.name
  }
}

resource "docker_container" "backend" {
  image = "cubos/backend"
  name  = "backend"
  restart = "always"
  ports {
    internal = 3000
    external = 3000
  }

  networks_advanced {
    name = docker_network.network.name
  }

  env = [
    "DB_PORT=5432",
    "DB_USER=admin",
    "DB_PASS=123",
    "DB_HOST=postgres", 
    "DB_NAME=teste",
    "PORT=3000"
  ]
}
