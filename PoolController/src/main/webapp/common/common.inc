<%@ page import="java.util.*,
	com.axiomtank.objectdb.*, 
	com.axiomtank.common.objects.*, 
	java.util.logging.Logger,
	com.axiomtank.util.AxiomLogger,
	org.apache.commons.text.StringEscapeUtils"%>
<%
ObjectDB objectDB = ObjectDB.getInstance(request.getContextPath(), "commonDB");
Logger systemLogger = AxiomLogger.getSystemLogger();
Logger applicationLogger = AxiomLogger.getApplicationLogger();
User __user = null;
{
	if (__rolesNeeded != null) {
		__user = (User) session.getAttribute("__user");
		if (__user == null) {
    		response.sendRedirect(request.getContextPath() + "/common/authentication/loginForm.jsp?reason=Please log in");
	    	return;
	    }
	    else if (__rolesNeeded.length > 0) {
	    	//if we have one or more acceptable roles specified, find one that matches
	    	boolean foundRole = false;
	    	Set<String> userRoles = __user.getRoles();
	    	HashSet<String> userRoleNames = new HashSet<String>();
	    	for (String roleId : userRoles) {
	    		Role role = (Role) objectDB.getObjectByUUID(roleId);
	    		if (role != null) {
	    			userRoleNames.add(role.getName());
	    		}
	    	}
	    	for (String role : __rolesNeeded) {
	    		if (userRoleNames.contains(role)) {
					foundRole = true;
	    			break;
	    		}
	    	}
	    	if (!foundRole) {
	    		response.sendRedirect(request.getContextPath() 
	    			+ "/common/authentication/loginForm.jsp?reason=You do not have the required authorization to access this page");
	    		return;
	    	}
	    }
	}
}
%>