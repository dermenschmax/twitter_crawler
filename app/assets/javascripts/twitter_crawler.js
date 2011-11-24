function ule_expose(e){
    alert("Hallo");
}



// registiert die notwendigen Event-Handler beim Laden der Seite
function reg_events(){
    
  // ---- user_listing_entry ----
  $('.lnk').click(ule_expose);
}



reg_events();