

http = require("socket.http")
local gfind = string.gfind

function _download_img( img_url, filename )
   body, ret = http.request(img_url)
   io.open(filename, 'wb'):write(body)
   print(filename .. ' done')
end

function _parse_li(li)
   -- get img id
   local pattern = '%-(.-)">'
   local id = 0
   for _1, _ in gfind(li, pattern) do
      id = _1
      break
   end

   -- get img list
   local pattern = '<img src="(.-)" />'
   local idx = 1
   for img, _ in gfind(li, pattern) do
      local filename = id .. tostring(idx) .. string.sub(img, -4)
      _download_img(img, filename)
      idx = idx + 1
   end
end

function _parse_li_list(commentlist)
   local pattern = '<li id="comment(.-)</li>'
   for li, _ in gfind(commentlist, pattern) do
      _parse_li(li)
      -- print(li)
   end
end

function _parse_commentlist(cnt)
   local pattern = '<ol class="commentlist"(.-)</ol>'
   for commentlist, _ in gfind(cnt, pattern) do
      _parse_li_list(commentlist)
   end
end

function get_next_url( content )
   local pattern = '<span class="current%-comment%-page">%[(.-)%]</span>'
   local cur = ''
   for _1, _ in gfind(content, pattern) do
      cur = tonumber(_1) - 1
      break
   end

   local url = 'http://jandan.net/ooxx/page-' .. tostring(cur)
   return url
end

function download_ooxx_img(url)
   body, ret = http.request(url)
   if not body then
      return
   end

   local url = get_next_url(body)
   _parse_commentlist(body)
   return url
end

function main( url )
   local u = url
   for i = 1, 10 do
      print(u)
      u = download_ooxx_img(u)
   end
end

main('http://jandan.net/ooxx')