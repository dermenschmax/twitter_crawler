function ule_expose(e){
    alert("Hallo");
}



// registiert die notwendigen Event-Handler beim Laden der Seite
function reg_events(){
    
  // ---- user_listing_entry ----
  $('.lnk').click(function() { alert('inline');});
  $('div').click(function() {
        alert('Handler for .click() called.');
    });
}



reg_events();