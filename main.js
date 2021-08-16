
jQuery(document).ready(function($) {
        let server = "http://35.75.152.23:5000/v1/info"
    //load all containers list
        loaddata()


    function loaddata(){
        $("#resources").html("");
        $.ajax({
            dataType: "json",
            type: "GET",
            url: server,
            success:function(data){
                $("#content").append(data);
            },
            error: function(jqXHR, textStatus, err){
                alert(jqXHR.status)
            }
        });
    }

   $('body').on('click','#restart', function(){
       var name = $(this).attr("name");
       //doing ajax
       $.ajax({
            dataType: "json",
            type: "PUT",
            url: server+"?dockername="+name,
            contentType: 'application/json; charset=utf-8',
            success:function(res){
                result = res.Data
                var d = new Date();
                let log ="<li>"+d.toTimeString() +"Restart for container name: " + name + " .Result: " + res.Data + "</li>"
                $('#logconsole').append(log)
                loaddata();
            },
            error: function(jqXHR, textStatus, err){
                let log ="<li>"+d.toTimeString() +"Restart for container name: " + name + " .Result: " + res.Data + " .Detail:" +jqXHR.status +"</li>"
                $('#logconsole').append(log)
            }

       });
   })

   //change status of docker 
   $('body').on('change','#changeState',function(e){
        let name = $(this).attr("name");
        let action = $(this).prop("checked");
        $.ajax({
            dataType: "json",
            type: "POST",
            url: server+"?dockername="+name+"&status="+action,
            contentType: 'application/json; charset=utf-8',
            success:function(res){
                result = res.Data
                var d = new Date();
                let log ="<li>"+d.toTimeString() +"Restart for container name: " + name + " .Result: " + res.Data + "</li>"
                $('#logconsole').append(log)
            },
            error: function(jqXHR, textStatus, err){
                let log ="<li>"+d.toTimeString() +"Restart for container name: " + name + " .Result: " + res.Data + " .Detail:" +jqXHR.status +"</li>"
                $('#logconsole').append(log)
            }

       });
    });
});