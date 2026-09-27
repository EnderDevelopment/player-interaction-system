# Player Interaction System

Enhance player interactions in FiveM with a radial menu system.

## Features

- Radial menu for player interactions
- Multiple interaction types (talk, trade, invite)
- Database logging of interactions

## Requirements

- FiveM server
- ESX Framework
- MySQL database

## Installation

1. Download the script files.
2. Place them in your FiveM server's `resources` directory.
3. Add `start InteractionSystem` to your `server.cfg` file.
4. Import the `database.sql` file into your MySQL database.

## Usage

- Press the G key to open the radial menu when near another player.
- Select an interaction type from the menu.

## Configuration

- Adjust the interaction distance and key in the `config.lua` file.
- Customize the radial menu options in the `config.lua` file.