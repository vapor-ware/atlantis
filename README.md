# Atlantis

[Atlantis](https://runatlantis.io) is a tool for safe collaboration on Terraform repositories.

# Atlantis

<p align="center">
  <img src="https://github.com/runatlantis/atlantis/blob/master/runatlantis.io/.vuepress/public/hero.png?raw=true" alt="Atlantis Logo"/><br><br>
  <b>Terraform Pull Request Automation</b>
</p>

## Resources
* How to get started: [www.runatlantis.io/guide](https://www.runatlantis.io/guide)
* Full documentation: [www.runatlantis.io/docs](https://www.runatlantis.io/docs)
* Download the latest release: [github.com/runatlantis/atlantis/releases/latest](https://github.com/runatlantis/atlantis/releases/latest)

## What is Atlantis?
A self-hosted golang application that listens for Terraform pull request events via webhooks.

## What does it do?
Runs `terraform plan` and `apply` remotely and comments back on the pull request with the output.

## Why should you use it?
* Make Terraform changes visible to your whole team.
* Enable non-operations engineers to collaborate on Terraform.
* Standardize your Terraform workflows.
