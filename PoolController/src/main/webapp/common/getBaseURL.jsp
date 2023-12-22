<%@ page import="java.util.*,com.axiomtank.objectdb.*, com.axiomtank.common.objects.*, org.apache.commons.lang3.StringUtils"%><%
ObjectDB objectDB = ObjectDB.getInstance(request.getContextPath(), "commonDB");
String appId=request.getParameter("appId");
String userId=request.getParameter("userId");
Criteria criteria = new Criteria(User.TYPE);
criteria.addCriterion(Criterion.Operator.AND, User.USER_ID, userId);
Set<String> matchingUserUUIDs = objectDB.listObjectUUIDs(criteria);
if (matchingUserUUIDs.size() == 1) {
  User user = (User) objectDB.getObjectByUUID(matchingUserUUIDs.iterator().next());
  if (user != null) {
    String redirect = user.getString("User_App_Redirection_" + appId); 
    if (redirect != null && redirect.trim().length() > 0) {
      out.println(redirect);
      return;
    }
  }
}
//String redirectToSelf = StringUtils.substringBefore(request.getRequestURL().toString(), request.getServletPath());
//TODO - change this to handle port and webapp name
String redirectToSelf = "https://" +request.getServerName() ;
out.println(redirectToSelf);%>