<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*, com.axiomtank.common.objects.User"%>
<%
String __rolesNeeded[] = {"Admin", "SuperAdmin"};
String _title = "Users";
%>
<%@include file="../../../common/commonWithMenuJSandCSS.inc" %>
  <div class="container-fluid">
    <div class="row">
      <div class="md-col-12">
       	<form style=" display:inline!important;" id="refreshList" method="post" action="listUsers.jsp">
          <div style="float:left">
	       	<h5>Select a User to edit from the list or <a href="editUser.jsp">add</a> a new one.</h5>
       	  </div>
       	</form>
      </div>
    </div>
    <div class="row">
      <div class="md-col-12">
        <table
          id="userTable"
          class="table table-hover"
          style="width:100%">
          <thead>
            <tr>
              <th></th>
              <th>Name</th>
              <th>E-mail</th>
              <th>Phone</th>
            </tr>
          </thead> 
          <tbody>
          </tbody>
        </table>
      </div>
    </div>
    <script>
		$(document).ready(function() {
		    //initialize entries table.
		  	var table = $('#userTable').DataTable(
			{
				"searching": true,
				"responsive": true,
				"serverSide": false,
				"ajax": {
					"url": 'getUsers.jsp',
					"type": "POST",
					"cache" : false
				},
		        "columnDefs": [
		            {
		              "targets": [ 0],
		              "searchable": false,
		              "sortable": false,
		              visible: false
		            }
		 	   ],
				"columns": [
					{ "data": "uuid"},
					{ "data": "name",},
					{ "data": "email"},
					{ "data": "phone"}
				],
		        "order": [[ 1, "asc" ]],
		        pageLength: "50"
			});
			//initialize clicking on table row
		  	$('#userTable tbody').on('click', 
		  			'tr>td:nth-child(2), tr>td:nth-child(3), tr>td:nth-child(5)', function () {
		  	        	var rowIndex = table.cell(this).index().row;
		  				window.location.href="editUser.jsp?uuid=" + table.row(rowIndex).data()["uuid"];
	        } );

		});
	</script>
  </div>
</body>
</html>