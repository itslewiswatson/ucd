# Union of Clarity and Diversity
UCD is a lightweight flexible RPG game mode developed for MTA:SA. The code seen in this repository's [`master`](/nokizorque/ucd/tree/master) branch runs on the UCD server.

## Introduction
### History
Development on UCD officially began in May of 2014, however the idea and concept go back to October of 2013. The game mode was worked on slightly, then left for months. Development was resumed and went into full force in December later that year, where the code base saw itself go through many overhauls to be as efficient as possible. This period ended in May, 2015. Only a few months later in September did development pick up again. This time it saw itself go right through to February, 2016, where it stopped once again. However, it was seriously continued again and ended up releasing to the public on the 29th of July, 2016 (or on the 30th, depending on your time zone).

### Idealogy
UCD was initially planned to be a piloting server for MTA, similar to *Pilot's Paradise* of SA:MP. Though that idea was dismissed in favour of ripping off CIT. Why bother being original when you can copy someone else's originality? Though UCD was never meant to be a carbon copy, but more of a taste of what CIT was in 2012, with a number of improvements.

UCD aims to address problems faced in most small RPG MTA servers
- Boredom
- Single-player activities
- Mini-games
- Lack of consistency
- Centralization (code-related)

## Status & Roadmap
There is no official roadmap, however planning for new features is taking place on [our Trello board](https://trello.com/b/9SGcbZVY/ucd).
### Versions
- Alpha 1 (released)
- Alpha 2 (current)

Verions will be increase as the project reaches certain milestones, which should be available for viewing at our aformentioned Trello board.

## Server
The server is currently in open-development, and has not been released in this iteration. Anyone may contribute to the pre-release and will receive appropriate accreditation on release.

## Installation
If you would like to run this server yourself, you are more than free to do so. It is recommended that you clone this repository and edit configuration files or fork the project and make your own version.
### Linux:
*This assumes the MTA Server is already installed. If you would like to install the MTA Server on Linux, please follow [this guide](https://wiki.multitheftauto.com/wiki/Installing_and_Running_MTASA_Server_on_GNU_Linux).*

1. Clone the repository
	- `git clone https://github.com/nokizorque/ucd.git`
2. Make it a carpet (rename it to anything, though it must be surrounded by brackets)
	- `mv ucd [ucd]`
3. Change into the UCDsql resource
	- `cd [ucd]/UCDsql`
4. Copy the example credentials file and fill it with your MySQL credentials.
	- `cp credentials.json.example credentials.json`
	- `nano credentials.json` (or any text editor of your liking)
5. Go back to the resource carpet
	- `cd ..`
6. Copy the example mtaserver.conf to `mods/deathmatch` and edit it with your server name, password (if any) and other details.
	- `cp mtaserver.conf ../.. && cd ../..`
	- `nano mtaserver.conf`
7. Go back into the main MTA directory and start the server.
	- `cd ../..`
	- `./mta-server` or `./mta-server64`
	
### Windows
*This assumes the MTA Server is already installed.*

1. Clone or download the repository
	- `git clone https://github.com/nokizorque/ucd.git`
	- From the repository's main page:
		- ![](https://noki.zorque.xyz/i/78a2111.png)
		- Download as a ZIP or clone, and place into your server directory (`C:\Program Files (x86)\MTA San Andreas 1.5.3\server\mods\deathmatch\resources`)
2. Rename the folder to be a carpet (signified by the surrounding square brackets)
	 -
	 ```
	 +--resources
	 	+-- [admin]
	 	+-- [editor]
	 	+-- [gamemodes]
	 	..
	 	+-- [ucd]
	 	|	+-- UCDadmin
	 	|	+-- UCDactions
			|	...
	 ```
	 - You may also rename it to anything else, as long as its surrounded by square brackets.

3. Navigate to `UCDsql` and copy `credentials.json.example` to `credentials.json` and edit the contents with your MySQL database credentials.
4. Copy `mtaserver.conf` from the main carpet (mentioned in step 2) to `server/mods/deathmatch` and edit it to your liking.
5. Start `MTA Server.exe`.

## Issues & Bugs
Issues are to be reported on the [`issues`](/nokizorque/ucd/issues) tab. They are then open for anyone to fix, but will most likely be handled by any collaborator or maintainer.
A pull request must be opened for the issue, even if you are a collaborator with write-access. This is so the change may be reviewed.

## Development
UCD was not designed to be open-source, or plug-and-play. It was meant for development by a few people. However, that has changed and the code base will need to be made suitable for open-source contributions.

Please open a pull request for any changes. Check the [`issues`](/nokizorque/ucd/issues) board for any potential problems to fix. Otherwise, check the Trello board for functionality additions.

### Guidelines
- Maintain current code consistency
- Use OOP syntax where possible
- Tabs for indendation
- Use camelCase
- Use global variables sparingly
- Make reasonable comments

## Contributors
nokizorque (Lewis Watson)
<br>
Risk (Amr Gamal)
<br>
Carl (Carl Rizk)

## Links
| Description | Link |
| ------------- | ------------- |
| Home Page  | http://ucdmta.com  |
| Forum  | http://community.ucdmta.com  |
| Discord  | https://discord.gg/HAEwucW  |
| Trello  | https://trello.com/b/9SGcbZVY/ucd  |
