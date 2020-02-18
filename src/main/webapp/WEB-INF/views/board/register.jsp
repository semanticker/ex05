<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp"%> 
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Board Register
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
        <div class="col-lg-12">
          <!-- general form elements -->
          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">Quick Example</h3>
            </div>
            <!-- /.box-header -->
            <!-- form start -->
            <form role="form" action="/board/register" method="post">
              <div class="box-body">
                <div class="form-group">
                  <label for="title">Title</label>
                  <input class="form-control" name="title" placeholder="Enter title">
                </div>
                <div class="form-group">
                  <label for="content">Text area</label>
                  <textarea class="form-control" rows="3" name="content"></textarea>
                </div>
                <div class="form-group">
                  <label for="writer">Writer</label>
                  <input class="form-control" name="writer" placeholder="Enter writer">
                </div>
              </div>
              <!-- /.box-body -->

              <div class="box-footer">
                <button type="submit" class="btn btn-default">Submit</button>
                <button type="reset" class="btn btn-default">Reset</button>
              </div>
            </form>
          </div>
          <!-- /.box -->
      	</div>
      </div>
      <!-- /.row -->
      
      <div class="row">
        <!-- left column -->
        <div class="col-lg-12">
          <!-- general form elements -->
          <div class="box box-primary">
            <div class="box-header with-border">
              <h3 class="box-title">File Attach</h3>
            </div> <!--  end of box-header -->
            <div class="box-body">
            	<div class="form-group uploadDiv">
    				<input type="file" name='uploadFile' multiple>
    			</div>
    			<div class='uploadResult'>
    				<ul></ul>
    			</div>
            </div><!--  end of box-body -->
          </div> <!-- box-primary --> 
        </div>
      </div><!-- end of row -->
      <!--/.col (left) -->
      </section>
    <!-- /.content -->
    
    <script>
    $(document).ready(function(e){
    	var formObj = $("form[role='form']");
    	$("button[type='submit']").on("click", function(e){
    		e.preventDefault();
    		console.log("submit clicked");
    		
    		var str = "";
    		
    		$(".uploadResult ul li").each(function(i, obj){
    			var jobj = $(obj);
    			console.dir(jobj);
    			
    			//var type = jobj.data("type") ? "I" : "O";
    			
    			str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
    			str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
    			str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
    			str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
    		});
    		
    		console.log(str);
    		
    		formObj.append(str).submit();
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
    	
    	
    	
    	
    	$(".uploadResult").on("click", "button", function(e){
    		console.log("delete file");
    		
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
    		})
    	});
    	
    	
    });
    </script>
    
    <%@include file="../includes/footer.jsp" %>
    
