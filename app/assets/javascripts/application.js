// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .

$(function(){ $(document).foundation(); });

$('#add_recipe').click(function(){
    file_holder = $('#recipes');
    new_index = file_holder.children().length;
    html = "<div class=\"row recipe\">";
    html += "<div class=\"columns small-1\">"
    html += "<label for=\"shopping_list_recipes_attributes_" + new_index + "_Url\">Url</label>"
    html += "</div>";
    html += "<div class=\"columns small-11\">";
    html += "<input id=\"form_recipes_attributes_" + new_index + "_file\" name=\"form[recipes_attributes][" + new_index + "][url]\" type=\"text\">";
    html += "</div></div>";

    file_holder.append(html);
});