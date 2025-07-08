terraform {
  required_providers {
    render = {
      source  = "render-oss/render"
      version = "1.7.0"
    }
  }
}

provider "render" {
  # put your render api key and owner id in these files.
  # the render provider honors the RENDER_API_KEY and RENDER_API_KEY env vars, but it's cleaner to
  # put them in files.
  api_key  = trimspace(file("~/.render_api_key"))
  owner_id = trimspace(file("~/.render_owner_id"))
}