<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page
  import="com.axiomtank.objectdb.*, java.util.*, org.apache.commons.lang3.StringUtils,
  com.axiomtank.common.objects.User, com.axiomtank.util.ReCaptchaVerifier, com.axiomtank.util.Session"%>
<%
  String __rolesNeeded[] = null;
  String _title = Session.getAppName() + " Password Reset";
 %>
<%@include file="../commonWithJSandCSS.inc"%>
<script>
  $.extend({ alert: function (message, title) {
    $("<div></div>").dialog( {
      buttons: { "Ok": function () { $(this).dialog("close"); } },
      close: function (event, ui) { $(this).remove(); window.history.go(-1);},
      resizable: false,
      title: title,
      position: {my: "top", at: "top"},
      modal: true
    }).text(message);
  }});
</script>
<div class="container-fluid">
  <h5>
  <%
    String password = request.getParameter("password");
    User user = (User) session.getAttribute("resetPasswordUser");
    if (user == null) {
      out.println("<script>$.alert('Sorry, your password reset session seems to have expired.', 'Error');</script>");
    }
    else if (password == null) {
      out.println("<script>$.alert('Sorry, no password was provided.', 'Error');</script>");
    }
    else {
      user.setPassword(password);
      user.clearPasswordResetRequests();
      objectDB.putObject(user);
      out.println("Your password has been successfully reset. Click <a href='loginForm.jsp'>here</a> to login.");
    }
  %>
  </h5>
</div>
</body>
</html>