<!doctype html>
<html lang="us">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page
	import="com.axiomtank.objectdb.*, java.util.*, org.apache.commons.lang3.StringUtils,
  com.axiomtank.common.objects.User, com.axiomtank.util.ReCaptchaVerifier, com.axiomtank.util.Session, 
  com.axiomtank.common.authentication.Authenticator, com.axiomtank.util.EmailSender"%>
<%
  String __rolesNeeded[] = null;
  String _title = Session.getAppName() + " Password Reset";
 %>
<%@include file="../commonWithMenuJSandCSS.inc"%>
<script>
	$.extend({
		alert : function(message, title) {
			$("<div></div>").dialog({
				buttons : {
					"Ok" : function() {
						$(this).dialog("close");
					}
				},
				close : function(event, ui) {
					$(this).remove();
					window.history.go(-1);
				},
				resizable : false,
				title : title,
				position : {
					my : "top",
					at : "top"
				},
				modal : true
			}).text(message);
		}
	});
</script>

<%
final String verificationURL = "https://www.google.com/recaptcha/api/siteverify";
final String privateKey = "6LdH_QQTAAAAAE0ek94YnjaLVmWNBEsLmec9p9Oo";

ReCaptchaVerifier reCaptchaVerifier = new ReCaptchaVerifier(verificationURL, privateKey);

String userId = StringUtils.defaultString(request.getParameter(User.USER_ID));
String lastName = StringUtils.defaultString(request.getParameter(User.LAST_NAME));
String firstName = StringUtils.defaultString(request.getParameter(User.FIRST_NAME));
String textOrEmail = StringUtils.defaultString(request.getParameter("textOrEmail"), "text");

String message = "?";

if (!reCaptchaVerifier.verify(request.getParameter("g-recaptcha-response"))) {
  out.println("<script>$.alert('Please attest that you are a human, not a robot.', 'Error');</script>");
}
else if (userId.trim().length() == 0) {
  out.println("<script>$.alert('Please provide the email address you used to register.', 'Error');>/script>");
}
else if (lastName.trim().length() == 0) {
  out.println("<script>$.alert('Please provide your last name.', 'Error');>/script>");
}
else if (firstName.trim().length() == 0) {
  out.println("<script>$.alert('Please provide your first name.', 'Error');</script>");
}
else {
  systemLogger.info("Password reset request for " + userId + " from " + request.getRemoteAddr());
  //load user
  Criteria criteria = new Criteria(User.TYPE);
  criteria.addCriterion(Criterion.Operator.AND, User.USER_ID,
      userId.toLowerCase());
  Set<String> uuidsWithSameUserId = objectDB
      .listObjectUUIDs(criteria);
  if (uuidsWithSameUserId.size() == 1) {
    for (String userUUID : uuidsWithSameUserId) {
      User user = (User) objectDB
          .getObjectByUUID(userUUID);
      if (user != null) {
        //we have a user - check if the name supplied matches that stored
        if (lastName.equalsIgnoreCase(user.getLastName()) && firstName.equalsIgnoreCase(user.getFirstName())) {
      		try {
          		String token = Authenticator.generateBase32Secret(6);
          		if ("text".equals(textOrEmail)) {
	        		if (user.getMobilePhone().trim().length() > 0) {
	                	systemLogger.info("Sending password reset text to " + user.getMobilePhone());
			  		    user.sendSMSMessage(Session.getAppName() + " code: " + token);
			  		    message = "We sent a text to you mobile phone number: " + user.getMobilePhone();
		        	}
	        		else {
	        			out.println("You selected text but we don't have a valid mobile phone number for you."
		                	+ " We apologize for this inconvenience. Please <a href='passwordReset.jsp'>try again.</a>");
       					return;
	        		}
          		}
        		else {
        			EmailSender emailSender = new EmailSender();
        			String emailText = "Here is your code to reset your password: " + token;
        			emailSender.sendEmail(user.getUserId(), "Password reset", emailText);
                	systemLogger.info("Sending password reset email to " + user.getUserId());
		  		    message = "We sent an email to you with the code to reset your password. Please check your spam folder if you did not receive it.";

        		}
	  		    //save our reset attributes in session
	  		    session.setAttribute("resetToken", token);
	  		    session.setAttribute("requestingUser", user);
	  		    Date expirationDate = new Date();
	  		    expirationDate.setTime(new Date().getTime() + 5*60*1000);
	  		    session.setAttribute("resetExpiration", expirationDate);
	  		  }
	  		  catch (Throwable e)
	  		  {
	  		      out.println("We tried to send the code to reset your password, but ran into an error." 
	                + " We apologize for this inconvenience. Please <a href='passwordReset.jsp'>try again.</a>");
	  		      e.printStackTrace();
	              return;
	  		  }
        }
        else {
          systemLogger.info("User provided information in password reset did not match records, request ignored."); 
			out.println("The information you provided did not match our system."
                	+ " We apologize for this inconvenience. Please <a href='passwordReset.jsp'>try again.</a>");
            return;

        }
	}
   }
  }
  else {
    systemLogger.info("Found multiple users with id: " + userId); 
	out.println("The information you provided did not match our system."
           	+ " We apologize for this inconvenience. Please <a href='passwordReset.jsp'>try again.</a>");
	return;
  }
}
%>
<form method="post" action="verifyReset.jsp">
	<div class="container-fluid">
		<h4><%=message%></h4>
		<div class="row">
			<div class="col-md-2">Please provide the code received to reset
				your password.</div>
			<div class="col-md-2">
				<input type="text" id="token" name="token" placeholder="Code"
					required autofocus>
			</div>
			<div class="col-md-2">
				<input type="submit" class="btn btn-default" value="Submit">
			</div>
		</div>
	</div>
</form>

</body>
</html>