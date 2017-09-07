# Hubway Data Visualization
#Introduction
Hubway is a bike-sharing system, based in the Greater Boston Metropolitian areas. Launching in 2011, Hubway has now owned over 1,600 bikes at 160+ stations across Boston, Brookline, Cambridge and Somerville. As fast as Hubway bike network has been growing, its users also showed different types of behaviors. The goal of this project is to investigate into further insights about Hubway users and their corresponding behaviors, based on the Hubway data recorded about trips taken from July 2011 to November 2013. We aim to develop a good understanding of behaviors of different demographics of Hubway users.
As such, the ultimate goal of the project is to investigate Hubway stations and trips. We will analyze the geographical locations of all Hubway stations, as well as the traffic in-between these stations. We aim to develop a good understanding of how people use this service and recommend any solution to improve the service and quality of the overall system.


#Data Description
The dataset used in this report is obtained from Hubway Data Visualization Challenge. We obtained two CSV files. 
The first file `df.stations` lists the details regarding 142 Hubway bike stations, which include properties such as id (integer), terminal code (character), station name (character), municipal (character), latitude (num), longitude (num), status (existing/removed-character). 

The second file `df.trips` describes the trips from July 2011 to December 2013. Details about these trips include:

* seq_id: unique record ID (integer)
* hubway_id: trip ID (integer)
* status: Closed- meaning a trip is completed (character)
* duration: length of trip in seconds (integer)
* start_date: start date of trip with date and time (string) 
* str_station: start station (integer)
* end_date: start date of trip with date and time (string) 
* end_station: end station (integer). 
* bike_nr: bike number (character)
* subsc_type: subscription type (Casual/Registered)(character)
* zip_code: zip code of users (character)
* birth_date: birth year of users (integer)
* gender: male/female (character)