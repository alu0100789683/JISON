$(document).ready(function() {
  $('#parse').click(function() {
    try {
      var myCodeMirror = $(".CodeMirror")[0].CodeMirror
      var source = myCodeMirror.getValue()

      out.className = "unhidden";
      
      // Import: Change: $('#input').val() -> source, i forget it, again 
      var result = calculator.parse(source);
      $('#output').html(JSON.stringify(result,undefined,2));
    } catch (e) {
      $('#output').html('<div class="error"><pre>\n' + String(e) + '\n</pre></div>');
    }
  });

  $("#examples").change(function(ev) {
    var f = ev.target.files[0]; 
    var r = new FileReader();
    r.onload = function(e) { 
      var contents = e.target.result;
      
      var myCodeMirror = $('.CodeMirror')[0].CodeMirror;
      myCodeMirror.setValue(contents);
    }
    r.readAsText(f);
  });

});

  

