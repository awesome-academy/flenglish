$(document).ready(function(){
  $("select#movie_category_id").change(function(){
    var category_id = $(this).val();
    $.ajax({
      url: admin_movies_path + category_id,

    })
  })
})
