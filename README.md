# Issue Shadower

A webhook receiver to mirror GitHub.com issues to private GitHub Enterprise forks.

## How it works

Lets say you have a repository on GitHub.com, called `benbalter/awesome-project`, and a GitHub Enterprise instance at `github.benbalter.com`.

Almost without exception, [you can, and should, work in the open, ensuring that all stakeholders, both those on the inside and those on the outside of your firewall are on equal footing](http://ben.balter.com/2015/03/08/open-source-best-practices-internal-collaboration/#minimize-information-imbalance). Sometimes that's not possible. That's where Issue Shadower comes in. 

Issue Shadower will open an issue in the corresponding repository on your GitHub Enterprise instance, each time an issue is opened on GitHub.com. Let's say someone opens an issue on `benbalter/awesome-project`. Issue Shadower will open an issue on `github.benbalter.com/benbalter/awesome-project`, and link back to the original issue. That way you can discuss the issue internally (such as weighing any security concerns), before replying publicly.

## Usage

Issue Shadower is tiny Sinatra app designed to run on services like Heroku. You'll need to do two things, configure the server and configure the webhook on GitHub.

### Configure the server

You need a Ruby server with the following environmental variables:

* `GITHUB_TOKEN` - A personal access token of a bot account
* `GITHUB_HOOK_SECRET` - Secret shared with webhook to authenticate payload
* `GITHUB_HOST` - The URL to your GitHub Enterprise instance

If not using a service like Heroku, you can start the server with the `script/server` command.

### Configure the webhook
Navigate to the repository's settings, and create a new webhook with the following settings:

- URL: `[SERVER URL]/payload`
- Content Type: `application/json`
- Secret: Your shared secret (`GITHUB_HOOK_SECRET`)
- Select "let me select individual events" and check only the "issues" events

## Running locally
1. `script/bootstrap`
2. `script/server`

You'll also probably want to [install ngrok](https://developer.github.com/webhooks/configuring/#using-ngrok) to test the hooks locally.
