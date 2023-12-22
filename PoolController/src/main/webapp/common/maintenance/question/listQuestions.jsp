<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*"%>
<%
  String __rolesNeeded[] = {"SuperAdmin"};
  String _title = "Secret Questions";
 %>
<%@include file="../../../common/commonWithMenuJSandCSS.inc" %>
  <div class="container-fluid">
    <div class="row">
      <div class="md-col-12">
        <h5>Select a Question to edit from the list or <a href="editQuestion.jsp">add</a> a new one.</h5>
      </div>
    </div>
    <div class="row">
      <div class="md-col-12">
        <table
          id="questionTable"
          class="table table-hover">
          <thead>
            <tr>
              <th>Name</th>
              <th>Description</th>
            </tr>
          </thead>
          <tbody>
            <%
              Set<String> questionUUIDs = objectDB.listObjectUUIDs(PersistableObject.TYPE, "AxiomTank_Question");
        		for (String uuid: questionUUIDs)
        		{
              	PersistableObject question = objectDB.getObjectByUUID(uuid);
          %>
            <tr>
              <td><a href="editQuestion.jsp?uuid=<%=uuid%>"> <%=question.getString("Question_Name")%></a></td>
              <td><%=question.getString("Question_Description")%></td>
            </tr>
            <%
            	}
            %>
          </tbody>
        </table>
      </div>
    </div>
    <div class="row">
      <div class="sm-col-1">
        <a href="editQuestion.jsp" class="btn btn-primary">Add</a>
      </div>
    </div>
    <script>
		$(document).ready(function() {
			$("#questionTable").DataTable();
		});
	</script>
  </div>
</body>
</html>