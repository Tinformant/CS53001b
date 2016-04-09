package testPackage;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import testPackage.Session;
class Session {
	int sessionID;
	int version;
	String message;
	Date expirationTime;
	public Session(int sessionID, int version, String message) {
		this.sessionID = sessionID;
		this.version = version;
		this.message = message;
		this.expirationTime =  new Date(new Date().getTime() + 60000);//Session expires after 60 seconds.
	}
}
@WebServlet("/hello")
public class HelloWorld extends HttpServlet {
	  static HashMap<Integer, Session> sessionTable = new HashMap<Integer, Session>();
	  static Integer sessionCounter = 1;
	  static Session currentSession;
	  static String messageToDisplay;
	  static String projName = "CS5300PROJ1SESSION";
	  static Cookie projCookie;
	  public void createNewSession(HttpServletResponse response) { //This method creates a new session.
		  currentSession = new Session(sessionCounter++, 1, "Hello User");
		  sessionTable.put(currentSession.sessionID, currentSession);
		  projCookie = new Cookie(projName,currentSession.sessionID+"_" + currentSession.version);//This updates the cookie.
		  response.addCookie(projCookie);
	  }
	  public void printWeb(PrintWriter out) {//This method prints out the web contents.
		  out.println(
		    		"<div>NetID: rs2357 Session: "+ currentSession.sessionID + " Version: "+ currentSession.version + " Date: "+  new Date() + "</div>"
			    	+"<div>Message:" + currentSession.message + "</div>"
		    	    +"<div><form method='post' action = '/test-app/hello'><textArea name='newMessage' rows = '1' cols = '10'></textArea> "
		    	    + "<input type='submit'>"+"</form>"
		    	    + "</div>"
		    	    + "<form ><input type='submit' value='refresh'> </form>"
		    	    + "<div><form method='post' action = '/test-app/hello'><input type ='submit' name='logout' value='logOut'> </form></div>"
		    	    +"<div>Cookie:" + projCookie.getValue() +"</div>"+"<div>Expire: " + currentSession.expirationTime + "</div><br>"); 
	  }
	  public boolean sessionStillGood(Session tempSessionHist){//This method tells if the session is still good(not expired).	   
		 boolean stillGood = (new Date().getTime() < tempSessionHist.expirationTime.getTime());
		 sessionTable.remove(currentSession.sessionID);
		 return stillGood;
	  }
	  @Override
	  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    PrintWriter out = response.getWriter();
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null){//If there is cookie
	    	boolean cookieRelevant = false;//Assume the cookie is not relevant to this project.
	    	for(Cookie i: cookies) {   		
				   String tempName = i.getName();
				   if (projName.equals(tempName)){//If the cookie is for this project
	    			   String[] tempValues = i.getValue().split("_",2);//The cookie's value will be stored
	    			   Session tempSessionHist = sessionTable.get(Integer.parseInt(tempValues[0]));
	    			   if (tempSessionHist == null) {//If there is no cookie for this project				   
	    				   createNewSession(response);
		    			   } else {		   
		    				   if (sessionStillGood(tempSessionHist)){//If the session has not expired
		    					   Session updatedSession = new Session(tempSessionHist.sessionID, tempSessionHist.version+1, tempSessionHist.message);
		    					   sessionTable.put(updatedSession.sessionID, updatedSession);
		    					   projCookie = new Cookie(projName,updatedSession.sessionID+"_" + updatedSession.version);
		    					   response.addCookie(projCookie);
		    					   currentSession = updatedSession;
		    				   } else { //If the current session has expired, create a new one
		    					   createNewSession(response);
		    				   }
		    			   	}
	    			   cookieRelevant = !cookieRelevant;//There is relevant cookie.
				   }
	    	   }
	    	if (cookieRelevant == false){//If there is no relevant cookie, create a new session/cookie.
		    	createNewSession(response);
		    }
	    } else {//If there is no cookie at all, create a new session/cookie.
	    	createNewSession(response);
	    }
	    printWeb(out);
	  } 
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		  Cookie[] cookies = request.getCookies();
		  String logOut = request.getParameter("logout");
		  PrintWriter out = response.getWriter();
		  if (request.getParameter("newMessage") == null) {//This checks if there is an input message.
			  messageToDisplay = "Hello User";
		  } else {
			  messageToDisplay = request.getParameter("newMessage");
		  }
		    if (cookies != null){//Most of this part is the same as the previous part, so I did not repeat comments.
		    	boolean cookieRelevant = false;
		    	for(Cookie i: cookies) {
					   String tempName = i.getName();
					   if (projName.equals(tempName) && logOut == null){//If logOut is not pressed
		    			   String[] tempValues = i.getValue().split("_",2);	   
		    			   Session tempSessionHist = sessionTable.get(Integer.parseInt(tempValues[0]));		   
		    			   if (tempSessionHist == null){
		    				  createNewSession(response);
			    			   }else {			   
			    			   if (sessionStillGood(tempSessionHist)){
			    				   if ( (request.getParameter("newMessage") != null) && (request.getParameter("newMessage").length() < 512) ){//This makes sure that the size of the message is smaller than 512 bytes.
			    					   tempSessionHist.message = request.getParameter("newMessage");
			    				   }
			    				   Session updatedSession = new Session(tempSessionHist.sessionID, tempSessionHist.version+1, tempSessionHist.message);
			    				   sessionTable.put(updatedSession.sessionID, updatedSession);
			    				   projCookie = new Cookie(projName,updatedSession.sessionID+"_" + updatedSession.version);
			    				   response.addCookie(projCookie);
			    				   currentSession = updatedSession;
			    			   } else {
			    				   createNewSession(response);
			    			   }
			    			   }
		    			   cookieRelevant = !cookieRelevant;
					   }  
		    	   }
		    	if (cookieRelevant == false){
		    		createNewSession(response);
		    	}
		    } else {//If there is no cookie at all
		    	createNewSession(response);
		    }
		    if (logOut != null) {//This is the logout page.
				  out.println("<!DOCTYPE html>\n"+
						  	  "<html>\n"+
						  	  "<body>"+
						  	  "<h1>You have logged out</h1>\n"+
						  	  "</body></html>");
				   currentSession.version = currentSession.version-1;
			} else {
				printWeb(out);
		    }
}
}