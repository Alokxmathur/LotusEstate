<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page
  import="com.axiomtank.objectdb.*, java.util.*, org.apache.commons.lang3.StringUtils,
  com.axiomtank.common.objects.User, com.axiomtank.util.ReCaptchaVerifier, com.axiomtank.util.Session, 
  com.axiomtank.common.authentication.Authenticator"%>
<%
  String __rolesNeeded[] = null;
  String _title = Session.getAppName() + " Password Reset";
 %>
<%@include file="../commonWithMenuJSandCSS.inc"%>
<div class="container-fluid">
  <form
    method="post"
    id="myForm"
    action="processNewPassword.jsp">
    <div class="tab-content">
      <h3>Password reset</h3>
      <div>
        <table class="table">
        <thead>
        </thead>
        <tbody>
          <tr>
            <td>
              New Password:
            </td>
            <td>
              <input
                type="password"
                size="30"
                id="password"
                name="password"
                class="password error">
              <label for="password" class="error" style="display: none;">&nbsp;</label>
              <div class="password-meter">
                <div class="password-meter-message">Use digits, mixed case letters and punctuation to create a strong password.</div>
                <div class="password-meter-bg">
                  <div class="password-meter-bar"></div>
                </div>
              </div>              
            </td>
          </tr>
          <tr>
            <td>
              Confirm Password:
            </td>
            <td>
              <input
                required
                type="password"
                size="30"
                id="confirmPassword"
                name="confirmPassword">
            </td>
          </tr>
        </tbody>
        </table>
      </div>
    </div>
    <input
      type="submit"
      class="btn btn-primary"
      value="Reset Password"> 
    <script>
      $(document).ready(function() {
        $("#myForm").validate({
      	    rules: {
      	        confirmPassword: {
      	            required: true,
      	            minlength: 7,
      	            equalTo: "#password"
      	        }
      	    },
      	    messages: {
      	        confirmPassword: {
      	            equalTo: "Please enter the same password as above"
      	        }
      	    }
      	});
        $("#password").valid();
      });
    </script>
  </form>
</div>
</body>
</html>