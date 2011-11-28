

function ule_mouse_over(e){
    $(this).find('.ule_all').show();
    //$(this).find('.ule_all').slideDown();
}


function ule_mouse_out(e){
    $(this).find('.ule_all').hide();
    //$(this).find('.ule_all').slideUp();
}


// registiert die notwendigen Event-Handler beim Laden der Seite
function reg_events(){
    
  $(".user_listing_entry").mouseover(ule_mouse_over)
  $(".user_listing_entry").mouseout(ule_mouse_out)
}



reg_events();