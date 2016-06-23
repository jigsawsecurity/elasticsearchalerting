# Elasticsearch Keyword Matches - Reports to Email
A stand alone utility to query Elasticsearch and send email reports of keyword matches contained in the strings file. This utility was created to provide a way to send a report hourly on matches to terms that you want to be alerted to in your logs or ES indices. 

![screenshot][https://github.com/jigsawsecurity/elasticsearchalerting/blob/master/ESA.PNG]

##Getting Started

#Configuring the ini settings file
To get started you must edit the server.ini file. This file contains information on your mail server and login details for sending the email. 

- esserver - This is your Elasticsearch Server IP Address

- esport - This is your Elasticsearch Server Port

- mailserver - This is your mail server in the form mail.server.com

- username - This is the username for your mail server

- password - This is your mail server password

- mailto - This is the email account to send the report in form user@domain.com

#Configuring the Search terms
To configure the search terms edit the strings.txt file. You should only enter the term you want to search without spaces and no special characters. 

This utility is open source and the source code is included in the package file. Utility was written by Kevin Wetzel for Jigsaw Security. A commercial version and support is available at www.jigsawsecurityenterprise.com. 


