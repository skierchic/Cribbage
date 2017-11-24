![Build Status](https://codeship.com/projects/36426c00-9e61-0135-eb8d-5e3172fc544d/status?branch=master)
![Code Climate](https://codeclimate.com/github/skierchic/Cribbage.png)
![Coverage Status](https://coveralls.io/repos/skierchic/Cribbage/badge.png)
# README

Cribbage - An Online Cribbage Game Site

This cribbage game site allows users to play the game of cribbage either in real time through the implementation of action cable or asynchronously as game play is saved to a database.  

Author
* Jenna Hight

Built With

* Rails 5.1.2 - Backend framework
* React 16.0.0 - Front end
* React-Router 3.0.5 - React rendering
* Devise - User authentication
* Action Cable - Real time move updates
* Postgresql - SQL Database
* Rspec, Capybara - Backend testing

Features
* Users can view their in progress games, games they've started that are waiting on a player, and games others have started that they can join.  They can also view their all time win-loss record.
* Users can play opponent in real time through the use of action cable to update the page whenever either player makes a move.
* During game play a player can see all of the cards they've been dealt and select cards to play that update the count.  If a player cannot play a card without the count going over 31 they select the go button to allow their opponent to play a card.  
* A player is informed which player's turn it is and is not allowed to play a card unless it is their turn.
* A player gets scores points for the count hitting 15 or 31, getting a go, or playing the last card.
* A player wins by being the first one to reach 61 points.

To Dos
* Add scoring based on previous cards played
* Add hand counting
* Add crib hand
* Test controllers
