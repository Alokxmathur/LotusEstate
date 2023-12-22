<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page
  import="com.axiomtank.objectdb.*, java.util.*, com.axiomtank.common.objects.User, com.axiomtank.common.objects.Role, org.apache.commons.lang3.StringUtils"%>
<%
	String __rolesNeeded[] = { "SuperAdmin", "Admin" };
	String _title = "Process User";
%>
<%@include file="../../common.inc"%>
<%
	String uuid = request.getParameter("uuid");
	String userId = request.getParameter(User.USER_ID);
	String name = request.getParameter(User.LAST_NAME) + ", " + request.getParameter(User.FIRST_NAME);
	System.out.println("User name =" + name);
	String hashedPassword = null;
	boolean deleteUser = "true".equals(request.getParameter("deleteUser"));
	User user = (User) objectDB.getObjectByUUID(uuid);
	if (user == null) {
		//we must be adding a user
		user = new User(name, userId);
	} else {
		hashedPassword = user.getHashedPassword();
		user.getContents().clear();
	}
	Map<String, String[]> parameterMap = request.getParameterMap();
	for (String parameterName : parameterMap.keySet()) {
		String[] parameterValues = parameterMap.get(parameterName);
		if (parameterName.startsWith("User_Role_")) {
			String roleUUID = StringUtils.substringAfter(parameterName, "User_Role_");
			if (parameterValues[0].equals("true")) {
				user.addRole(roleUUID);
			} else {
				user.removeRole(roleUUID);
			}
		} else if (parameterName.startsWith("User_Organization_")) {
			String organizationUUID = StringUtils.substringAfter(parameterName, "User_Organization_");
			if (parameterValues[0].equals("true")) {
				user.addOrganization(organizationUUID);
			} else {
				user.removeOrganization(organizationUUID);
			}
		}
		else if (!"password".equals(parameterName) && !"deleteUser".equals(parameterName)) {
			user.getContents().put(parameterName, parameterValues[0]);
		}
	}
	user.setDescription(name);

	boolean nonUniqueId = false;
	if (deleteUser) {
		objectDB.removeObject(user);
		out.println("User has been deleted");
	} else {
		Criteria criteria = new Criteria(User.TYPE);
		criteria.addCriterion(Criterion.Operator.AND, User.USER_ID, userId);
		Set<String> uuidsWithSameUserId = objectDB.listObjectUUIDs(criteria);
		//exclude the user being saved from list of users with the same id
		uuidsWithSameUserId.remove(user.getUUID());
		if (uuidsWithSameUserId.size() > 0) {
			out.println("Error: The following users have the same email address: " + userId);
			for (String userUUID : uuidsWithSameUserId) {
				User userWithSameId = (User) objectDB.getObjectByUUID(userUUID);
				if (userWithSameId != null) {
					out.println("<br>" + userWithSameId.getLastName() + "," + userWithSameId.getFirstName());
				}
			}
			nonUniqueId = true;
		} else {
			String suppliedPassword = StringUtils.defaultString(request.getParameter("password"));
			if (suppliedPassword.trim().length() > 0) {
				user.setPassword(suppliedPassword);
			} else if (hashedPassword != null) {
				user.setHashedPassword(hashedPassword);
			}
			objectDB.putObject(user);
			out.println("User has been saved");
		}
	}
%>