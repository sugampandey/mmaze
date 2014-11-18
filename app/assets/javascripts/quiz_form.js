function add_answer(link, questionIdx, columnIdx) {
  var newId = new Date().getTime();
  var content = '<div class="column-fields"><div style="float:none;"><input name="questions[' + questionIdx + '][' + columnIdx + ']['+ newId +'][content]" style="float:left;" type="text" value=""> <a href="#" class="remove-answer" title="Remove Answer" style="float:left;">(x)</a></div></div>';
  $(link).before(content);
}

$(function(){
   $("input.column-name").live('keyup',function(){
      $("#questions-table thead tr th:eq("+ ($(this).parents(".fields").index(".fields:visible") + 1) +")").html($(this).val());
   });
   $("input.is-answer-radio").live('click',function(event){
    idx = $(this).parents(".fields").index(".fields:visible") + 1;
      if($(this).is(':checked') === true){
        if($(this).val() == "true"){
          $("td:eq("+idx+") .add-answer", "#questions-table tbody tr").show();
          $("td:eq("+idx+") .remove-answer", "#questions-table tbody tr").show();
        }
        else {
          $("td:eq("+idx+") .add-answer", "#questions-table tbody tr").hide();
          $("td:eq("+idx+") .remove-answer", "#questions-table tbody tr").hide();
        }
      }
   });
   $("a.remove-quiz").live('click',function(event){
     $(this).parents("tr").remove();
     return false;
   });
   $("a.remove-answer").live('click',function(event){
    $(this).parents(".column-fields").empty();
    return false;
   });
   $("#quiz-columns a.removeField").live('click',function(event){
      idx = $(this).parents(".fields").index(".fields:visible") + 1;
      $("#questions-table thead tr th:eq("+idx+")").remove();
      $("td:eq("+idx+")", "#questions-table tbody tr").remove();
      $(this).prev("input[type=hidden]").val("1");
      $(this).closest(".fields").hide();
      return false;
   });
   $("#quiz-columns a.addField").live('click',function(event){
      columnIdx = $("#columns .fields").length - 1;
      isAnswer = $("#columns .fields:last input:radio:checked").val() == "true";
      $("#questions-table thead tr").append("<th style='text-align:center;'></th>");
      $("#questions-table tbody > tr").each(function(i){
        content = '<td valign="top">'+
              '<div class="column-fields">'+  
                '<div style="float:none;">'+
                  '<div style="float:none;"><input name="questions['+ i +']['+ columnIdx +'][0][content]" style="float:left;" type="text" value=""> <a href="#" class="remove-answer hide-this" title="Remove Answer" style="float:left;">(x)</a></div>' +
                '</div>'+
              '</div>' +
              '<a class="add-answer hide-this" href="#" onclick="add_answer(this, '+ i +', ' + columnIdx + '); return false;" style="float:none;">add more answer</a>' +
            '</td>';
        $(this).append(content);
      });
      return false;
   });
 });