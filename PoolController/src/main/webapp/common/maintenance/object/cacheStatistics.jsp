<!doctype html>
<html lang="us">
<%@ page
  language="java"
  contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@page import="com.axiomtank.objectdb.*, java.util.*,com.axiomtank.common.objects.Role"%>
<%
  String __rolesNeeded[] = {"Admin", "SuperAdmin"};
  String _title = "ObjectDB Cache Diagnostics";
 %>
<%@include file="../../commonWithMenuJSandCSS.inc"%>
<%
  long cacheSize = objectDB.getCacheSize();
  long population = objectDB.getCachePopulation();
  long maxSize = objectDB.getObjectSizeLimitForCaching() / 1024 / 1024;
  float populationPercentage = ((float) population) / cacheSize * 100;
  long hits = objectDB.getHits();
  long requests = objectDB.getRequests();
  float hitPercentage = ((float) hits) / requests * 100;
  
  String refreshString = request.getParameter("refresh");
  int refreshMinutes = 5;
  try {
	  refreshMinutes = Integer.parseInt(refreshString);
  }
  catch (Throwable e) {}
   
%>
  <form action="cacheStatistics.jsp" method="post" id="refreshForm">
	  <div style="float:right">
	    Refresh interval (minutes): 
	  		<input class="form-contol input-sm" size="2" type="text" name="refresh" value="<%=refreshMinutes%>">
	  		<button class="btn btn-default">Refresh</button>
	  </div>
  </form>
  <form action="showObject.jsp" id="showObjectForm" method="post" target="_blank">
  	<input type="hidden" name="uuid" id="uuid">
  </form>
  <div class="container-fluid">
  	<h5>ObjectDB Cache information</h5>
  	<table class="table"	>
  		<tr>
  			<td>
		      Object Size Limit for caching
  			</td>
  			<td>
		       lte <%=maxSize %> M
  			</td>
  		</tr>
  		<tr>
  			<td>
		      Cache Size
  			</td>
  			<td>
		       <%=cacheSize %>
  			</td>
  		</tr>
  		<tr>
  			<td>
		      Cache Population
  			</td>
  			<td>
		      <%=String.format("%d (%.2f%%)", population, populationPercentage) %>	
  			</td>
  		</tr>
  		<tr>
  			<td>
		      Hits
  			</td>
  			<td>
		      <%=String.format("%d of %d (%.2f%%)", hits, requests, hitPercentage) %>
  			</td>
  		</tr>
  		<tr>
  			<td colspan="2">
			    <table class="table table-striped table-bordered table-hover" id="entriesTable" style="width:100%">
			      <thead>
			      <tr>
			        <th align="left">Last Accessed</th>
			        <th align="left">Loaded</th>
			        <th align="left">Cache Time</th>
			        <th align="left">Hits</th>
			        <th align="left">Size</th>
			        <th align="left">Type</th>
			        <th align="left">Description</th>
			        <th align="left" class="none">UUID</th> 
			      </tr>
			      </thead>
			      <tbody>
			      </tbody>
			      <tfoot>
			      </tfoot>
			    </table>
  			</td>
  		</tr>
  	</table>
  </div> <!-- container -->
</body>
<script>
function refreshPage() {
	$("#refreshForm").submit();
}
function msToHuman(duration) {
	var    seconds = parseInt((duration/1000)%60);
	var    minutes = parseInt((duration/(1000*60))%60);
	var    hours = parseInt((duration/(1000*60*60))%24);
	var    days = parseInt(duration/(1000*60*60*24));

	return days+"d" + hours + "h" + minutes + "m" + seconds + "s";
}

$(document).ready(function() {
	//set refresh timeout
	//alert("<%=refreshMinutes*60*1000%>");
	window.setTimeout(refreshPage, <%=refreshMinutes*60*1000%>);
	
	//initialize entries table.
	var table = $('#entriesTable').DataTable(
	{
	"searching": true,
	"responsive": false,
	"serverSide": false,
	stateSave: true,
	"ajax": {
		"url": 'getEntries.jsp',
		"type": "POST",
		"cache" : false
	},
    "columnDefs": [
        {
        	"render": function ( data, type, row ) {
      		  if ( type === "sort" || type === 'type' ) {
  			    return data;
 			  }
  		 	  else {
  			  	return new Date(data).toLocaleString();
 			  }
        	},
        	"searchable": false,
        	"sortable": true,
        	"sType": 'Date',
            "targets": [0, 1]
        },
        {
        	"render": function ( data, type, row ) {
        		var cacheTime = new Date().getTime() - row["loaded"];
        		  if ( type === "sort" || type === 'type' ) {
        			    return cacheTime;
       			  }
        		  else {
        			  return msToHuman(cacheTime);
       			  }
        	},
        	"searchable": false,
        	"sortable": true,
            "targets": [2]
        },
        {
        	"searchable": false,
        	"sortable": false,
            "targets": [7]
        }
    ],
	"columns": [
		{
		  "data": "lastAccessed"
		},
		{
		  "data": "loaded"
		},
		{
		  "data": "loaded"	
		},
		{
		  "data": "hits"
		},
		{
			"data": "size"
		},
		{ "data": "type"
        },
        { "data": "description"
		},
        { "data": "uuid"
		}
	],
    pageLength: "50",
    "order": [[ 1, "desc" ]]
	});
	//initialize clicking on table row
  	$('#entriesTable tbody').on('click', 
  			'tr>', function () {
    	var table = $('#entriesTable').DataTable();
    	var data = table.row(this).data();
    	var rowIndex = table.cell(this).index().row;
		var page = "showObjectContent.jsp?uuid=" + table.row(rowIndex).data()["uuid"];

		var $dialog = $('<div></div>')
		               .html('<iframe style="border: 0px; " src="' + page + '" width="100%" height="100%"></iframe>')
		               .dialog({
		                   autoOpen: false,
		                   modal: true,
		                   width: $(window).width()*.9,
		                   height: $(window).height()*.9,
		                   title: "Object",
		                   resizable: true,
		                   buttons: {
		                       Cancel: function(){
		                           $(this).dialog("close");
		                       }
		                   }
		               });
			$dialog.dialog('open');
		} );

});

</script>
</html>