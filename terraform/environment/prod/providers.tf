provider "aws" {
  region = local.region

  default_tags {
    tags = {
      env = local.env
    }
  }
}

provider "aws" {
  alias = "us-east-1"

  region = "us-east-1"

  default_tags {
    tags = {
      env = local.env
    }
  }
}
