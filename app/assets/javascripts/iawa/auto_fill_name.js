function get_rights_bibliographic_citation() {
  var rights_first_part = "Permission to publish material from the ";
  var rights_second_part = " must be obtained from University Libraries Special Collections, Virginia Tech.";
  var b_c_first_part = "Researchers wishing to cite this collection should include the following information: ";
  var b_c_second_part = " - Special Collections, Virginia Polytechnic Institute and State University, Blacksburg, Va. Available from [DOI]";
  $("#collection_title").bind('mouseover keyup', function(){
    $("#collection_rights").val(rights_first_part + this.value.replace("The ", "") + rights_second_part);
    $("#collection_bibliographic_citation").val(b_c_first_part + this.value.replace("The ", "") + b_c_second_part);
    });
  $("#item_title").bind('mouseover keyup', function(){
    $("#item_rights").val(rights_first_part + this.value + rights_second_part);
    $("#item_bibliographic_citation").val(b_c_first_part + this.value + b_c_second_part);
  });
}

Blacklight.onLoad(function() {
  get_rights_bibliographic_citation();
});
