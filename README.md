# Project Name
![GitHub Release](https://img.shields.io/github/v/release/BlauweStadTechnologieen/hammertime?include_prereleases&sort=date&display_name=release)

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

## Downloads

![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/blauwestadtechnologieen/hammertime/total)


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

### [v2024.18.1.0] - 2024-09-18

#### Added
- When in DEBUG mode, we found that it was selecting the ``OrderOpenPrice()`` from the history ledger as opposed to using the zero value. This meant that it was giving an inaccurate number of pips gained when displayed on the chart.This was due to subtracting the ``_OrderOpenPrice`` of the last closed order from the current market price. This was of course inaccurate, however, this would only be the case when in ``DEBUG`` mode. 
- Because of this, we have declared the ``_OrderOpenPrice`` as the current spot price, divided by the ``_Digits`` of the chart.
- In addition to this, we have implemented a replacement function which will replace the ``fEvents`` function. The replacement function will perform the same task as the previous function in that it will look for new orders that have been added to the orders history. This will be checked on every incoming tick and is currently in beta mode. The purpose of this new function is to simplify the process of checking for new orders in the history ledger, which will then be used to collect data (though the ``OrderSelect`` feature) from the most recently-closed order, thence a transactional email will be sent to the user which will contain key data, such as the crystalized profit or loss, the price with which the position closed, the ticket reference number as well as any additional costs incurred in the process of closing the position.

#### Changed
- Moved the FileName variable initialisation from the ``WriteFile`` function to the ``GlobalNamespace.mqh`` file.
- Removed screen capture file name varible from the instantiation in the ``ConformationMessage`` function. This is not declared locally depending or whether the all the parameters for a successful order was executed or not. Is one or more parameters were NOT met, the file name will be a randomly generated set of numbers. For a successful order executon, the name of the file will be the ticket number of the position.
- We have cleaned up and improved the ``WriteFile`` function. The screenshot capture function has now been removed from this ``WriteFile`` function. The screenshot capture function will now only run when an order is successfully executed.

#### Future Developments
- In addition, we will centrally declare certain variables depending on whether the system is in Debug mode or not. This hopefully make things a bit more efficient and will save us from have to redeclare variables that may have declared with different values at an earlier time in the current iteration - which may return incorrect results.

### [v2024.18.1.1] - 2024-09-19

## Added
- We have added a ``sleep(1000)`` to the diagnostics module ``(RunDiagnostics.mqh Line 15)`` as we were finding that it was returning an incorrect trading hour. For example, the position or diagnosic message was being sent for a position that would have been, or was execured (respectively) at 1700 when the data was showing as 1600. This was because there were occasions where the data was being sent at ``16:59:59`` and not at ``17:00:00``, giving a reading of 16 and not 17. By delaying of sending the position data by one second will mean that the data will be sent in the correct trading hour.
- Added a symbol check on line 226 for better efficiency for the the memory.

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

