# Automic-Bot
Bot using the Automic Rest API

Target: Automic Engine v12.1 and Official Rest API
Chat UI: This bot is built on Hubot and for Slack specifically, however it can be ported easily to any other chat app

How to Deploy it:
  0- Make sure your system has all prerequisites to run "Hubot" (a quick google query will yield many tutorials on this)
  1- Clone this repository
  2- For Unix / Linux / Mac: Rename the set_env.sh.template to set_env.sh (For Windows, create a similar set_env.bat)
  3- Modify the set_env.sh (or set_env.bat) with your own parameters (including the IP to AE, Client #, Slack Token, etc.)
  4- Open a terminal / CMD session and load the set_env file (on Linux / Unix / Mac:  . ./bin/set_env.sh)
  5- Start the bot (on Linux / Unix / Mac: From within the Repo folder: ./bin/hubot --adapter slack
  
How to Use it:
  => Say "hi" and say "help", the bot will guide you through what can be done.
  => ask for the release notes ("get release notes") to see the latest changes
  
  
