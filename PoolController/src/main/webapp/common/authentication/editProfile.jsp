<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page
  import="com.axiomtank.objectdb.*, com.axiomtank.util.Session, java.util.*,org.apache.commons.lang3.StringUtils,
  java.util.*, org.apache.commons.text.StringEscapeUtils, com.axiomtank.common.objects.Role" 
%><%
  String __rolesNeeded[] = {}; 
  String _title = "Edit Profile";
 %>
<%@include file="../commonWithMenuJSandCSS.inc"%>
<%
User user = (User) session.getAttribute("__user");
if (user == null) {
  out.println("Error: Your session seems to have expired. Please login again to try.");
  return;
}
%>
<div class="container-fluid">
  <form
    method="post"
    		id="profileForm"
    		enctype="multipart/form-data" 
  		action="<%=request.getContextPath()%>/common/authentication/SaveProfile">
    <div>
      <h3>Edit Profile</h3>
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
              <input
                type="text"
                size="50"
                name="<%=StringEscapeUtils.escapeEcmaScript(User.LAST_NAME)%>"
                id="<%=StringEscapeUtils.escapeEcmaScript(User.LAST_NAME)%>"
                value="<%=StringEscapeUtils.escapeEcmaScript(user.getLastName())%>">
            </td>
          <tr>
          <tr>
            <td>
              First Name:
            </td>
            <td>
              <input
                type="text"
                size="50"
                name="<%=User.FIRST_NAME%>"
                id="<%=User.FIRST_NAME%>"
                value="<%=user.getFirstName()%>">
            </td>
          </tr>
          <tr>
            <td>
              Mobile Phone (used to reset password):
            </td>
            <td>
              <input
                type="text"
                data-rule-phone="true"
                size="50"
                name="<%=User.MOBILE_PHONE%>"
                id="<%=User.MOBILE_PHONE%>"
                placeholder="mobile phone number"
                value="<%=user.getMobilePhone()%>">
            </td>
          </tr>
          <tr>
            <td>
              Theme:
            </td>
            <td>
              <select
                name="<%=User.THEME%>"
                id="<%=User.THEME%>">
                <%
                for (String theme: Session.THEMES) {
                	out.println("<option value='" + theme + "'");
                	if (theme.equals(user.getTheme())) {
                		out.print(" selected");
                	}
                	out.println(">" + theme + "</option>");
                }
                %>       
              </select>
            </td>
          </tr>
		<tr>
			<td>
				Current Photograph: <img width=100 style="border-radius: 50%"
					src='../../GetBlob?oid=<%=user.getUUID()%>&bid=Image.png&rand=<%=new Date().getTime()%>'>
			</td>
			<td>
				<input title="Click to pick new image" 
	   				type="file" name="Image.png" 
	   				id="Image.png"
	   				accept="photo/png"/>
			</td>
			</tr>
	       </tbody>
        </table>
      </div>
    </div>
    <input
      type="button"
      class="btn btn-primary"
      onClick="javascript:updateProfile()"
      value="Update"> 
  </form>
</div>
	<div id="updateProfileDiv" style="display: none">Updating profile ...</div>

<script>
	var iti;

	$(document).ready(function() {
		var phone = document.querySelector("#<%=User.MOBILE_PHONE%>");
		iti = window.intlTelInput(phone, {
		    utilsScript: "<%=request.getContextPath()%>/common/assets/jquery/phone/js/utils.js"
		});

      	$.validator.addMethod('phone', function (value, element, param) {
       		$("#<%=User.MOBILE_PHONE%>").val(iti.getNumber());
            return iti.isValidNumber(); // return bool here if valid or not.
        }, 'Please enter a valid phone number!');
      	       
       $("#profileForm").validate();
    });
    
    function updateProfile() {
   		var form = $("#profileForm");
   		if (!form.valid()) {
   			return false;
   		};
   		$("#updateProfileDiv").show();
  		var formData = new FormData($("#profileForm")[0]);
    		$.ajax({
        	    cache: false,
        	    contentType: false,
        	    processData: false,
    			type: "POST",
        		url: $("#profileForm").attr('action'),
        		data: formData, // form's data
        	    cache: false,
        		success: function(data)
      			{
  			  	$("#updateProfileDiv").hide();
      				if (data.indexOf("Error:") != -1) {
  	        			$("<p>" + data + "</p>").dialog({
  	        		         
  	        		         modal: true,
  	        		         title: "Error in updating profile",
  	        		         buttons: { "Ok": function() {
  	        		        	 	$(this).dialog("close"); 
  	        		        	 }
  	        				}       
  	        			});
      				}
      				else {
  	        			$("<p>" + data + "</p>").dialog({
  	        		         
  	        		         modal: true,
  	        		         title: "Successfully updated profile",
  	        		         buttons: { "Ok": function() {
  			    		  		location.reload();
          		        	 }}       
  	        			});
      				}
      			},
  			error: function (jqXHR, textStatus, errorThrown) {
  		  		$("#updateProfileDiv").hide();
          			$("<p>We are sorry. There was error "  + jqXHR.status + " in saving the profile.</p>").dialog({			        		         
          		         modal: true,
          		         title: "Error in saving profile",
          		         buttons: { "Ok": function() {
          		        	 	$(this).dialog("close"); 
  			    		  		$("#updateProfileDiv").hide();
          		        	 }
          				}       
          			});
  			}
    		});
  	}
    </script>
</body>
</html>