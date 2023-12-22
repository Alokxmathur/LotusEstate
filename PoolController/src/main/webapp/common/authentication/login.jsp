<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" 
    import="java.util.*, 
            com.axiomtank.objectdb.*, 
            com.axiomtank.common.objects.*, 
            com.axiomtank.common.authentication.Authenticator, com.axiomtank.util.Session
     "%>
<%
String __rolesNeeded[] = null;
String _title=Session.getAppName() + " Login";
%>
<%@include file="../common.inc"%>
<%
String userId = request.getParameter("userId");
String password = request.getParameter("password");
if (userId != null && password != null) { 
  Criteria criteria = new Criteria(User.TYPE);
  criteria.addCriterion(Criterion.Operator.AND, User.USER_ID, userId);
  //find user object ids that match the provided userId
  Set<String> userObjectIds = objectDB.listObjectUUIDs(criteria);
  if (userObjectIds.size() == 1)
  {
    for (String objectId : userObjectIds) {
      User user = (User) objectDB.getObjectByUUID(objectId);
      if (user != null && user.getHashedPassword() !=  null 
          && Authenticator.validatePassword(password, user.getHashedPassword())) {
        session.setAttribute("__user", user);
        String assignedUrl = user.getAssignedUrl();
        if (assignedUrl.trim().length() > 0) {
            response.sendRedirect(request.getContextPath() + "/" + assignedUrl.trim());
        }
        else {
            Set<String> organizations = user.getOrganizations();
            String organizationUUID = null;
            if (organizations != null && organizations.size() > 0) {
              //try to use the first organization uuid as the default uuid
              organizationUUID = organizations.iterator().next();
            }
            user.setLastLogin();
          	response.sendRedirect("../../index.jsp" + ((organizationUUID == null) ? "" : "?organization=" + organizationUUID));
        }
        return;
      }
    }
  }
}
session.setAttribute("__user", null);
response.sendRedirect("loginForm.jsp?reason=The supplied user id and password do not match. Please try again.");
%>