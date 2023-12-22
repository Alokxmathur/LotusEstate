<!DOCTYPE html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page
  import="com.axiomtank.objectdb.*, java.util.*, org.apache.commons.lang3.StringUtils,
  com.axiomtank.common.objects.User, com.axiomtank.util.Session, com.axiomtank.util.ReCaptchaVerifier"%>
<%
  String __rolesNeeded[] = null;
  String _title = "Password Reset"; 
 %> 
<%@include file="../commonWithMenuJSandCSS.inc"%>
<script src="https://www.google.com/recaptcha/api.js" async defer></script>
<div class="container-fluid">
	<h5 class="form-signin-heading">Please provide the following information to reset your password. 
		We will send a text with the code to your registered phone number to reset it.
	</h5>
  <form class="form-signin" action="processReset.jsp" method="post">
    <div class="row">
      <div class="sm-col1">
        <label for="<%=User.USER_ID%>">Email address</label>
      </div>
      <div class="sm-col1">
        <input type="email" id="<%=User.USER_ID%>" name="<%=User.USER_ID%>" class="form-control" placeholder="Email address" required autofocus>
      </div>
    </div>
    <div class="row">
      <div class="sm-col1">
        <label for="<%=User.LAST_NAME%>">Last Name</label>
      </div>
      <div class="sm-col1">
        <input type="text" id="<%=User.LAST_NAME%>" name="<%=User.LAST_NAME%>" class="form-control" placeholder="last name" required>
      </div>
    </div>
    <div class="row">
      <div class="sm-col1">
        <label for="<%=User.FIRST_NAME%>">First Name</label>
      </div>
      <div class="sm-col1">
        <input type="text" id="<%=User.FIRST_NAME%>" name="<%=User.FIRST_NAME%>" class="form-control" placeholder="first name" required>
      </div>
    </div>
    <div class="row">
      <div class="sm-col1">
        <label for="textOrEmail>">Select method to receive code</label>
      </div>
      <div class="sm-col1">
        <select id="textOrEmail" name="textOrEmail" class="form-control" required>
        	<option value="text">Text</option>
        	<option value="email">Email</option>
        </select>
      </div>
    </div> 
    <div class="row">
      <div class="g-recaptcha" data-sitekey="6LdH_QQTAAAAAIBzia4-SKGQBjP86zxAmu1SR8oz"
         data-size="compact" 
         style="transform:scale(0.77);-webkit-transform:scale(0.77);transform-origin:0 0;-webkit-transform-origin:0 0;">
      </div>
    </div>
    <div class="row">
      <div class="sm-col2">
        <button class="btn btn-lg btn-primary btn-block" type="submit">Reset Password</button>
      </div>
    </div>
  </form>
</div>
</body>
</html>