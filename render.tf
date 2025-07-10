resource "render_web_service" "test" {
  name              = "test"
  health_check_path = "/"
  plan              = "starter"
  num_instances     = 1
  region            = "oregon"
  runtime_source = {
    image = {
      image_url = "hashicorp/http-echo"
      tag       = "1.0"
    }
  }
  custom_domains = [
    {
      name : "scepter-gripe-wrench.com",
    },
    {
      name : "www.scepter-gripe-wrench.com",
    }
  ]
}