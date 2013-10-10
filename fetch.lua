

http = require("socket.http")

function get_img_list(url)
   body, ret = http.request(url)
   if not body then
      print(body)
      return
   end
   pattern = '<span class="current-comment-page">[(.*?)]</span>'

   -- 获取comment list
   pattern = '<ol class="commentlist"(.*)</ol>'
   for commentlist, _ in string.gfind(body, pattern) do
      print(commentlist)

      -- 获取img list
      pattern = '<li id="comment%-(.-)</li>'
      for comments, _ in string.gfind(commentlist, pattern) do
	 local p1 = '(.-)">'
	 local p2 = '<p>.-<img src="(.-)" />'
	 for c in comments do
	    local imgs = string.gfind(c, p2)
	    for img in imgs do
	       print(img)
	    end
	 end
      end

   end
end

get_img_list('http://jandan.net/ooxx')