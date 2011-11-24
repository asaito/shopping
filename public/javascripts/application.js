// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function on_load(){
  var ff=$$('form#edit_mallshopm_4 .field input');
  var ss = '';
  for(var i=0; i<ff.length; i++){
    ss += ff[i].value + '/';
  }
  alert(ff.length); 
  alert('test test')
  alert(ss); 
}
function testscript(){
  var ff=$$('form#edit_mallshopm_4 .field input');
  var ss = '';
  for(var i=0; i<ff.length; i++){
    ss += ff[i].value + '/';
  }
  alert(ff.length);
  alert('test test')
  alert(ss);
}

