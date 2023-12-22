<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page
  import="com.axiomtank.objectdb.*, java.util.*,org.apache.commons.lang3.*,com.axiomtank.common.objects.Role"%>
<%
  String __rolesNeeded[] = {"Admin", "SuperAdmin"};
  String _title = "Edit User";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc"%> 
<%
	User user = null;
	String uuid = request.getParameter("uuid");
	if (uuid == null) {
		//we are adding a new user 
		user = new User("", "");
		uuid = user.getUUID();
	} else {
		//load user  from the database
		user = (User) objectDB.getObjectByUUID(uuid);
	}
%>
<div class="container-fluid">
  <form
    method="post"
    id="userForm"
    name="userForm"
    action="processUser.jsp">
    <input
      type="hidden"
      name="uuid"
      value="<%=uuid%>"> 
    <input
      type="hidden"
      id="deleteUser"
      name="deleteUser"
      value="">
    <div class="tab-content">
      <h5>Edit User</h5>
      <div>
        <table class="table">
        <thead>
        </thead>
        <tbody>
          <tr>
            <td>
              Last Name:
            </td>
            <td>
              <input required
                type="text"
                size="20"
                name="<%=StringEscapeUtils.escapeEcmaScript(User.LAST_NAME)%>"
                value="<%=StringEscapeUtils.escapeEcmaScript(user.getLastName())%>">
            </td>
          <tr>
          <tr>
            <td>
              First Name:
            </td>
            <td>
              <input required
                type="text"
                size="50"
                name="<%=User.FIRST_NAME%>"
                value="<%=user.getFirstName()%>">
            </td>
          <tr>
          <tr>
            <td>
              Nick Name:
            </td>
            <td>
              <input
                type="text"
                size="50"
                name="<%=User.NICK_NAME%>"
                value="<%=user.getNickName()%>">
            </td>
          <tr>
          <tr>
            <td>
              Suffix (e.g. Jr, Sr, III):
            </td>
            <td>
              <input
                type="text"
                size="50"
                name="<%=User.SUFFIX%>"
                value="<%=user.getSuffix()%>">
            </td>
          <tr>
          <tr>
            <td>
              E-Mail:
            </td>
            <td>
              <input required
                type="text"
                size="50"
                name="<%=User.USER_ID%>"
                value="<%=user.getUserId()%>">
            </td>
          </tr>
          <tr>
            <td>
              Password:
            </td>
            <td>
              <input
                type="password"
                size="50"
                name="password">
            </td>
          </tr>
          <tr>
            <td>
              Phone:
            </td>
            <td>
              <input required
                type="tel"
                data-rule-phone="true"
                size="50"
                name="<%=User.MOBILE_PHONE%>"
                id="<%=User.MOBILE_PHONE%>"
                value="<%=user.getMobilePhone()%>">
            </td>
          </tr>          
        </tbody>
        </table>
      </div>
      <h3>Roles</h3>
      <div>
        <table id="rolesTable"  class="table">
          <thead>
            <tr>
              <th></th>
              <th></th>
            </tr>
          </thead>
          <tbody>
          <%
          	User currentUser = (User) session.getAttribute("__user");
                    Criteria criteria = new Criteria(Role.TYPE);
                    Set<String> roleUUIDs = objectDB.listObjectUUIDs(criteria);
                    for (String roleUUID : roleUUIDs) {
                      Role role = (Role) objectDB.getObjectByUUID(roleUUID);
                      if (role != null) {
                        out.print("<tr><td>" + role.getName() + "</td><td>");
                        out.println("<input type='checkbox' name='User_Role_" + roleUUID + "' value='true'"
                          + (user.getRoles().contains(roleUUID) ? " checked" : "")
                          + (currentUser.getHighestRolePrecedence(objectDB) <= user.getHighestRolePrecedence(objectDB) ? "" : " disabled")
                          + "></td></tr>");
                      }
                    }
          %>
          </tbody>
        </table>
      </div>
    </div>
    <input
      type="button"
      class="btn btn-primary"
      onClick="javascript:updateUser()"
      value="Save"> 
    <input
      type="button"
      value="Cancel"
      class="btn btn-primary"
      onclick="window.location.href='listUsers.jsp'"> 
    <input
      type="button"
      id="deletebutton"
      class="btn btn-primary"
      value="Delete">
    <div
      id="delete-confirm"
      style="display: none">
      <p>Deleting a user can result in problems.</p>
    </div>
  </form>
	<div id="updateUserDiv" style="display: none">Updating profile ...</div>
</div>

  <script type="text/javascript">
    var iti;
	$(document).ready(function() {
		var input = document.querySelector("#<%=User.MOBILE_PHONE%>");
		iti = window.intlTelInput(input, {
		    utilsScript: "<%=request.getContextPath()%>/common/assets/jquery/phone/js/utils.js"
		});
    	$.validator.addMethod('phone', function (value, element, param) {
       		$("#<%=User.MOBILE_PHONE%>").val(iti.getNumber());
            return iti.isValidNumber(); // return bool here if valid or not.
          }, 'Please enter a valid phone number!');

    	$("#userForm").validate();
        $("#accordion").accordion({
			heightStyle : "content"
		});
		//show the dialog on click of the delete button
		$("#deletebutton").click(function() {
			$("#delete-confirm").dialog({
				modal : true,
				title : "Delete the user ?",
				buttons : {
					"Cancel" : function() {
						$(this).dialog("close");
					},
					"Delete" : function() {
						$("#deleteUser").val("true");
						$("#userForm").submit();
					}
				}
			});
		});

	});
    function updateUser() {
   		console.log("phone = " + iti.getNumber()+ ", Is valid = " + iti.isValidNumber());
   		var form = $("#userForm");
   		if  (!form.valid()) {
   			return false;
   		};
   		console.log(form.serialize());
    	var updateDiv = $("#updateUserDiv");
   		updateDiv.show();
  		$.ajax({
      	    cache: false,
      	    processData: false,
  			type: "POST",
      		url: form.attr('action'),
      		data: form.serialize(), // form's data
      	    cache: false,
      		success: function(data)
   			{	
      			updateDiv.hide();
    				if (data.indexOf("Error:") != -1) {
	        			$("<p>" + data + "</p>").dialog({
	        		         
	        		         modal: true,
	        		         title: "Error in updating user",
	        		         buttons: { "Ok": function() {
	        		        	 	$(this).dialog("close"); 
	        		        	 }
	        				}       
	        			});
    				}
    				else {
	        			$("<p>" + data + "</p>").dialog({
	        		         
	        		         modal: true,
	        		         title: "Successfully updated user",
	        		         buttons: { "Ok": function() {
			    		  		location.reload();
        		        	 }}       
	        			});
    				}
    			},
				error: function (jqXHR, textStatus, errorThrown) {
					updateDiv.hide();
        				$("<p>We are sorry. There was error "  + jqXHR.status + " in saving the profile.</p>").dialog({			        		         
        		         modal: true,
        		         title: "Error in saving profile",
        		         buttons: { "Ok": function() {
        		        	 	$(this).dialog("close"); 
			    		  		$("#updateUserDiv").hide();
        		        	 }
        				}       
        			});
  				}
    		});
  		return false;
  	}
	</script>
</body>
</html>