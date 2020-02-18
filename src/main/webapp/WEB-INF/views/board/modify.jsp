<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp"%> 
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Board Read
        <small>board reg.</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
        <li><a href="#">Tables</a></li>
        <li class="active">Data tables</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content"> 
      <div class="row">
        <!-- left column -->
        <div class="col-md-6">
          <!-- general form elements -->
          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">Quick Example</h3>
            </div>
            <!-- /.box-header -->
            <!-- form start -->
            <form name="data_form" role="form" action="/board/modify" method="post">
              <input type="text" id="pageNum" name="pageNum" value="<c:out value='${cri.pageNum}'/>">
              <input type="text" id="amount" name="amount" value="<c:out value='${cri.amount}'/>">
              <input type='text' name='type' value='<c:out value="${cri.type}"/>'>
              <input type='text' name='keyword' value='<c:out value="${cri.keyword}"/>'>

              <div class="box-body">
                <div class="form-group">
                  <label for="bno">Bno</label>
                  <input class="form-control" name="bno" value="<c:out value='${board.bno}'/>" readonly="readonly">
                </div>
                <div class="form-group">
                  <label for="title">Title</label>
                  <input class="form-control" name="title" placeholder="Enter title" value="<c:out value='${board.title}'/>">
                </div>
                <div class="form-group">
                  <label for="content">Text area</label>
                  <textarea class="form-control" rows="3" name="content"><c:out value='${board.content}'/></textarea>
                </div>
                <div class="form-group">
                  <label for="writer">Writer</label>
                  <input class="form-control" name="writer" placeholder="Enter writer" value="<c:out value='${board.writer}'/>">
                </div>
              </div>
              <!-- /.box-body -->

              <div class="box-footer">
                <button data-oper='modify' class="btn btn-default">Modify</button>
                <button data-oper='remove' class="btn btn-danger">Remove</button>
                <button data-oper='list' class="btn btn-info">List</button>
              </div>
            </form>
          </div>
          <!-- /.box -->
      </div>
      
      
      
      </div><!-- /.row -->
      
      <style>
.uploadResult{
	width:100%;
	background-color: gray;
}
.uploadResult ul{
	display:flex;
	flex-flow:row;
	justify-content: center;
	align-items: center;
}
.uploadResult ul li{
	list-style: none;
	padding: 10px;
	align-content: center;
	text-align:center;
}
.uploadResult ul li img{
	width: 100px;
}
.uploadResult ul li span{
	color:white;
}
.bigPictureWrapper{
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
	background:rgba(255,255,255,0.5);
}
.bigPicture{
	position: releative;
	display: flex;
	justify-content: center;
	align-items: center;
}
.bigPicture img{
	width:600px;
}
</style>
      
	<!-- Reply -->
    <div class="row">
        <div class="col-lg-6">
            <!-- /.panel -->
            <div class="panel panel-default">
                <div class="panel-heading">
        			<i class="fa fa-comments fa-fw"></i> Files
      			</div><!-- /.panel-heading -->
	      		<div class="panel-body">
		        	<ul class="chat">
		        	</ul><!-- ./ end ul -->
		        	
		        	<div class="form-group uploadDiv">
		        		<input type="file" name='uploadFile' multiple="multiple">
		        	</div>
		        	
		        	<div class='uploadResult'>
		        		<ul></ul>
		        	</div>
	      		</div><!-- /.panel .chat-panel -->
			</div>
  		</div>
	</div><!-- ./ end row -->
      
      
      
      <!--/.col (left) -->
      </section>
    <!-- /.content -->
    <script type="text/javascript">
    $(document).ready(function(){
    	
    	
    	var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");
		var pageNum = 1;
		var replyPageFooter = $(".panel-footer");
		
		//showList(1);
		
		// 첨부파일을 가져온다
		$.getJSON("/board/getAttachList", {bno: bnoValue}, function(arr){
			console.log(arr);
			
			var str = "";
			
			$(arr).each(function(i, attach){
				if(attach.fileType){    					
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
    				
    				str += "<li data-path='" + attach.uploadPath + "'";
    				str += " data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
    				str += "<span> " + attach.fileName + "</span>";
    				str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'>";
    				str += "<i class='fa fa-times'></i>";
    				str += "</button>";
    				str += "<br>";
    				str += "<img src='/display?fileName=" + fileCallPath + "'>";
    				str += "</div>";
    				str += "</li>";
					
				}else{
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName);
    				
    				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
    				
    				str += "<li data-path='" + attach.uploadPath + "'";
    				str += " data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
    				str += "<span> " + attach.fileName + "</span>";
    				str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='file' class='btn btn-warning btn-circle'>";
    				str += "<i class='fa fa-times'></i>";
    				str += "</button>";
    				str += "<br>";
    				str += "<img src='/resources/img/attach.png'></a>";
    				str += "</div>";
    				str += "</li>";
				}
			});
			console.log(str);
			$(".uploadResult ul").html(str);
		});
    	
    	
    	var formObj = $("form[name=data_form]");
    	
    	$('button').on("click", function(e){
    		e.preventDefault();
    		
    		var operation = $(this).data("oper");
    		
    		console.log(operation);
    		
    		if(operation == 'remove'){
    			formObj.attr("action", "/board/remove");
    		}else if(operation == 'list'){
    			//self.location = '/board/list';
    			formObj.attr("action", "/board/list").attr("method", "get");
    			
    			var pageNumTag = $("input[name='pageNum']").clone();	
    			var amountTag = $("input[name='amount']").clone();	
    			var keywordTag = $("input[name='keyword']").clone();	
    			var typeTag = $("input[name='type']").clone();	
    			
    			formObj.empty();
    			formObj.empty();
    			formObj.append(pageNumTag);
    			formObj.append(amountTag);
    			formObj.append(keywordTag);
    			formObj.append(typeTag);
    		}else if(operation == 'modify'){
    			console.log("submit clicked");
    			
    			var str = "";
    			
    			$(".uploadResult ul li").each(function(i, obj){
    				var jobj = $(obj);
    				
    				console.dir(jobj);
    				
    				str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
        			str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
        			str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
        			str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
    			});
    			formObj.append(str).submit();
    		}
    		formObj.submit();
    	});
    	
    	$(".uploadResult").on("click", "button", function(e){
    		console.log("delete file");
    		
    		if(confirm("Remove this file?")){
    			var targetLi = $(this).closest("li");
    			targetLi.remove();
    		}
    		/*
    		var targetFile = $(this).data("file");
    		var type = $(this).data("type");
    		
    		var targetLi = $(this).closest("li");
    		
    		$.ajax({
    			url: '/deleteFile',
    			data: {fileName: targetFile, type: type},
    			dataType: 'text',
    			type: 'POST',
    			success: function(result){
    				alert(result);
    				targetLi.remove();
    			}
    		});
    		*/
    	});
    	
    	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
    	var maxSize = 5242880; // 5MB
    	
    	function checkExtension(fileName, fileSize){
    		if(fileSize >= maxSize){
    			alert("파일 사이즈 초과");
    			return false;
    		}
    		
    		if(regex.test(fileName)){
    			alert("해당 종류의 파일은 업로드할 수 없습니다.");
    			return false;
    		}
    		
    		return true;
    	}
    	
    	var uploadResult = $(".uploadResult ul");
    	function showUploadResult(uploadResultArr){
    		var str = "";
    		$(uploadResultArr).each(function(i, obj){
    			
    			if(!obj.image){
    				var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
    				
    				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
    				
    				str += "<li data-path='" + obj.uploadPath + "'";
    				str += " data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>";
    				str += "<span> " + obj.fileName + "</span>";
    				str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='file' class='btn btn-warning btn-circle'>";
    				str += "<i class='fa fa-times'></i>";
    				str += "</button>";
    				str += "<br>";
    				str += "<img src='/resources/img/attach.png'></a>";
    				str += "</div>";
    				str += "</li>";
    				
    				/*
    				str += "<li><a href='/download?fileName=" + fileCallPath + "'>"
    						+ "<img src='/resources/img/attach.png' height=\'100px\'>" + obj.fileName + "</a>"
    						+ "<span data-file=\'" + fileCallPath + "\' data-type='file'> x </span>"
    					    + "</li>";*/
    			}else{
    				//str += "<li>" + obj.fileName + "</li>";
    				
    				var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
    				
    				str += "<li data-path='" + obj.uploadPath + "'";
    				str += " data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>";
    				str += "<span> " + obj.fileName + "</span>";
    				str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'>";
    				str += "<i class='fa fa-times'></i>";
    				str += "</button>";
    				str += "<br>";
    				str += "<img src='/display?fileName=" + fileCallPath + "'>";
    				str += "</div>";
    				str += "</li>";
    				
    				
    				/*
    				var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
    				originPath = originPath.replace(new RegExp(/\\/g), "/");
    				
    				//str += "<li><img src='/display?fileName=" + fileCallPath + "'></li>";
    				str += "<li><a href=\"javascript:showImage(\'" + originPath + "\')\">"
    					+ "<img src='/display?fileName=" + fileCallPath + "'></a>"
    					+ "<span data-file='" + fileCallPath + "\' data-type='image'> x </span>"
    					+ "</li>";
    					*/
    			}
    			
    			
    		});
    		
    		uploadResult.append(str);
    	} // end of showUploadedFile method
    	
    	$("input[type='file']").change(function(e){
    		var formData = new FormData();
    		var inputFile = $("input[name='uploadFile']");
    		var files = inputFile[0].files;
    		
    		for(var i=0; i<files.length; i++){
    			if(!checkExtension(files[i].name, files[i].size)){
    				return false;
    			}
    			formData.append("uploadFile", files[i]);
    		} // end of for
    		
    		$.ajax({
    			url: '/uploadAjaxAction',
    			processData: false,
    			contentType: false,
    			data: formData,
    			type: 'POST',
    			dataType: 'json',
    			success: function(result){
    				console.log(result);
    				showUploadResult(result);
    			}
    		}); // end of $.ajax
    	}); // end of change event
    	
    });
    </script>
    <%@include file="../includes/footer.jsp" %>
    
