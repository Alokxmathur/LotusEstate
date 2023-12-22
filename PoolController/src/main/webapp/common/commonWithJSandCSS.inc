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
	    	else {
	    	}
	    }
	}
}
String __theme = "cupertino";
if (__user != null && __user.getTheme() != null && __user.getTheme().trim().length() > 0) {
	__theme = __user.getTheme();
}
%>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
  <link rel="shortcut icon" href="<%=request.getContextPath()%>/common/assets/images/brandLogo.png" type="image/png">

  <link rel="stylesheet" href="<%=request.getContextPath()%>/common/assets/bootstrap/css/bootstrap.min.css">

  <link href="<%=request.getContextPath()%>/common/assets/jquery/themes/<%=__theme%>/jquery-ui.min.css" rel="stylesheet">

<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/ju/dt-1.11.5/b-2.2.2/b-html5-2.2.2/fh-3.2.2/r-2.2.9/rr-1.2.8/sc-2.0.5/sb-1.3.2/sl-1.3.4/sr-1.1.0/datatables.min.css"/> 
  <link rel="stylesheet" href="<%=request.getContextPath()%>/common/assets/jquery/simpleFilePreview/simpleFilePreview.css">

  <link href="<%=request.getContextPath()%>/common/assets/jquery/password/jquery.validate.password.css" rel="stylesheet">

  <link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/common/assets/maps/maps.css" />

  <link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/common/assets/jCarousel/jCarousel.css" />

  <link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/common/assets/jquery/phone/css/intlTelInput.min.css" />
  
 <link href="https://cdn.jsdelivr.net/npm/froala-editor@latest/css/froala_editor.pkgd.min.css" rel="stylesheet" type="text/css" />
 
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <script src="<%=request.getContextPath()%>/common/assets/jquery/jquery.js"></script>
  <script src="<%=request.getContextPath()%>/common/assets/bootstrap/js/bootstrap.min.js"></script>
  <script src="<%=request.getContextPath()%>/common/assets/jquery-ui/jquery-ui.min.js"></script>
  <script src="<%=request.getContextPath()%>/common/assets/jquery/jquery.validate.min.js"></script>
  <script src="<%=request.getContextPath()%>/common/assets/jquery/cookie/jquery.cookie.js"></script>
  <script src="<%=request.getContextPath()%>/common/assets/jquery/additional-methods.min.js"></script>
  <script src="<%=request.getContextPath()%>/common/assets/jquery/simpleFilePreview/jquery.simpleFilePreview.js"></script>
  
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/vfs_fonts.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/v/ju/dt-1.11.5/b-2.2.2/b-html5-2.2.2/fh-3.2.2/r-2.2.9/rr-1.2.8/sc-2.0.5/sb-1.3.2/sl-1.3.4/sr-1.1.0/datatables.min.js"></script>
  <script src="https://www.gstatic.com/charts/loader.js"></script>
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDQTsiGZX7QnAIYVzoM2H5RdMAxKfJ-mfw"></script>
  <script src="<%=request.getContextPath()%>/common/assets/maps/maps.js"></script>
  <script src="<%=request.getContextPath()%>/common/assets/jCarousel/jCarousel.min.js"></script>
  <script src="<%=request.getContextPath()%>/common/assets/jquery/jquery.fileinput.min.js"></script>
  <script src="<%=request.getContextPath()%>/common/assets/bootstrap/bootstrap-session-timeout.min.js"></script>  
  <script src="<%=request.getContextPath()%>/common/assets/jquery/scrollToTop.js"></script>  
  <script src="//cdnjs.cloudflare.com/ajax/libs/select2/3.3.2/select2.js"></script>
  <script charset="UTF-8" src="<%=request.getContextPath()%>/common/assets/jquery/phone/js/intlTelInput.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/froala-editor@latest/js/froala_editor.pkgd.min.js"></script>

  <title><%=_title%></title>
</head>
   
<body style="height: 100%; width:100%" class="jquery-ui">
