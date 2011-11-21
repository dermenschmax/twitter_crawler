
function ule_expose(){
    alert("Hallo");
}



#// registiert die notwendigen Event-Handler beim Laden der Seite
function reg_events(){
    
  // ---- user_listing_entry ----
  $('.ule_expose').click(ule_expose);
   
}



reg_events();