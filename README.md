# Project Name
![Version](https://img.shields.io/github/v/release/username/repo-name.svg)

## Description
A brief description of your project.

![Build Status](https://img.shields.io/github/actions/workflow/status/username/repo-name/main.yml)

## Table of Contents
1. [Description](#description)
2. [Dependancies](#dependancies)
3. [Installation](#installation)
4. [Change Log](#change-log)
5. [Technical Data](#technical-data)
6. [Usage](#usage)
7. [Contributing](#contributing)
8. [License](#license)
9. [Acknowledgements](#acknowledgements)

## Dependancies

![Dependencies](https://img.shields.io/david/username/repo-name.svg)


## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/username/repo-name.git

## Change Log
### [v2024.17.1.0] - 2024-09-13

#### Added
- Real-time estimated profit feature, which updates on every tick.
- Real-time exchange rate, which updates on every tick.
- Changed all ENUM variables from numbers to text defaults.
- Formatted all comparable ENUM variables by casting them in order to achieve like-for-like comparing. 

### [v2024.18.0.1] - 2024-09-16

#### Added
- When in DEBUG mode, we found that it was selecting the ``OrderOpenPrice()`` from the history ledger as opposed to using the zero value. This meant that it was giving an inaccurate number of pips gained when displayed on the chart.This was due to subtracting the ``_OrderOpenPrice`` of the last closed order from the current market price. This was of course inaccurate, however, this would only be the case when in ``DEBUG`` mode. 
- Because of this, we have declared the ``_OrderOpenPrice`` as the current spot price, divided by the ``_Digits`` of the chart.
- In addition to this, we have implemented a replacement function which will replace the ``fEvents`` function. The replacement function will perform the same task as the previous function in that it will look for new orders that have been added to the orders history. This will be checked on every incoming tick and is currently in beta mode. The purpose of this new function is to simplify the process of checking for new orders in the history ledger, which will then be used to collect data (though the ``OrderSelect`` feature) from the most recently-closed order, thence a transactional email will be sent to the user which will contain key data, such as the crystalized profit or loss, the price with which the position closed, the ticket reference number as well as any additional costs incurred in the process of closing the position.

## Technical Data

![GitHub pull requests](https://img.shields.io/github/issues-pr/username/repo-name.svg)
![GitHub issues](https://img.shields.io/github/issues/username/repo-name.svg)
![Downloads](https://img.shields.io/github/downloads/username/repo-name/total.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/username/repo-name.svg)


## Usage

## Contributing
Contributes are always welcome. You can submit a pull request, or email [engineering@bluecitycapital.com](mailto:engineering@bluecitycapital.com)

You can also submit a support ticket my emailing [hello@bluecitycapital.com](mailto:hello@bluecitycapital.com)

## Licence
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

---

This format makes your `README.md` easy to read and provides all the necessary information for users to understand and contribute to your project.


## Acknowledgements
- [Library](https://github.com/library) for awesome functionality.
- [Person](https://github.com/person) for their guidance.

