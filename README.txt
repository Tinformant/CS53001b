# CS53001b

Does not allow "_", "|" characters within the message

Launch.sh

Sets up the simpledb database and creates the necessary domain: serverList
Creates a security group needed to access port 8080 and 22
Creates 5 ec-2 instances and configure them by running install-my-app.sh


install-my-app.sh

Installs Tomcat 8 in each ec-2 instance
Changes permissions to give access for deployment
Deploys the .war file from S3
Appends information of each server to serverList in SimpleDB
Waits for 15 seconds, then pulls information from every server in SimpleDB

NodeEndServlet

Run by each individual node end

On a initiation
	1. reads local files 
		a. reboot.txt gives reboot index
		b. selfID.txt gives the self launch-id
		c. serverMappings.txt is a multiline text comma seperated text file providing
			self_launch_id, private_ip
	2. Initiates messageReceiver Class Thread that extends runnable
		This thread is in charge of receiving messages and communication
		a. Initializes datagramsocket object
		b. every second tries to receive data coming into the socket
			i. manifests the data into byte[] inn
		c. This class deals with other servers trying to communicate with this server: there are 3 major server codes to deal with
			a. SESSIONREAD
				i. other servers sent this machine a request asking for sessionID information
				ii. if the information is fresh (not expired) and found in the table
					we ping back to the requesting server
			b. SESSIONWRITE
				i. other server sent this machine a request to record sessionData
				ii. records data onto own local memory 
				iii. sends back a WRITE CONFIRM PING to original server so the record of which servers contain the session data can be written in user cookie
			c. SESSIONDELETE
				i. user has manually requested to have their session information deleted
				ii. every receiving server will check if the session still exists on the server and then deletes it
				iii. does not send a delete confirmation
	3. Initiates the garbage Collector Thread
		a. every four seconds 
On doGet
	1. Checks if cookie relevant to our project exists in local Memory
		a.Load information based on the session Information if fresh
		b. if not fresh then see 3.a
	2. if not in local memory, send read requests to all servers that cookie says contains session Information
		a. Assume first Read response is the correct one and ignore the subsequent ones
		b. Load Information based on the read Session 
			i. if not fresh then 
	3. If no cookie at all, then make a new cookie
		a. send a write request to every other server asking them to store this information locally
			i. waits for at least WQ confirmations and appends these WQ servers onto the cookie
			ii. appends these WQ servers to a newly created Cookie, attach cookie to response 
		
On doPost
	1. Changes if relevant Post information was filled in
		a. if it is, check if cookie exists
			i. if cookie
				then update the information on the cookie
				send write requests to other servers
				update cookie information
			ii. if no cookie
				make a new cookie 
		b. if not then we just go for doGet
