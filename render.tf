resource "render_web_service" "test" {
  name              = "test"
  health_check_path = "/"
  plan              = "starter"
  num_instances     = 1
  region            = "oregon"
  runtime_source = {
    native_runtime = {
      auto_deploy   = true
      branch        = "main"
      build_command = "go build"
      repo_url      = "https://github.com/Ubehebe/r2a"
      runtime       = "go"
    }
  }
  start_command = "go run ."
}