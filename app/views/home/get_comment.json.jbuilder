json.comments @comments.each do |comment|
 json.text comment.text
 json.position_x comment.position_x
 json.positon_y comment.position_y
 json.time comment.time
 json.id comment.id
end
