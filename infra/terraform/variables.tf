variable "region" { default = "us-east-1" }
variable "instance_type" { default = "t3.micro" }
variable "key_name" { description = "Existing key pair name" }
variable "repo_url" { default = "https://github.com/BobbyGeorgeKJ/cookmate-devops.git" }
variable "repo_branch" { default = "main" }
variable "app_directory" { default = "cookmate-app" }
