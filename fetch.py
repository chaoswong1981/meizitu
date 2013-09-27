# coding: utf-8

from urllib2 import *
import re

def download_img(name, url):
    if url[-4:] in ('.jpg', '.gif', '.png'):
	pathname = './imgs/' + name + url[-4:]
    else:
	pathname = './imgs/' + name + '.jpg'
    try:
	f = open(pathname, 'w+')
	f.write(urlopen(url).read())
	f.close()
    except URLError, msg:
	print '!!!!!!!!!! DOWNLOAD IMAGE ERROR !!!!!!!!!!!'
	print msg
	print 'fail:', url
	return 
    print 'done:', pathname

def fetch_next_url(content):
    p = re.compile(r'<span class="current-comment-page">\[(.*?)\]</span>')
    m = p.search(content)
    if not m:
	return m
    page_number = int(m.groups()[0])-1
    return 'http://jandan.net/ooxx/page-%d' % (page_number)

def fetch_img(url):
    content = urlopen(url).read()
    content = content.replace('\r\n', '')
    content = content.replace('\n', '')

    commentlist = re.compile(r'''<ol class="commentlist"(.*)</ol>''')
    m = commentlist.search(content)
    if not m:
	return

    tmp = m.group(0)
    p = re.compile(r'''<li id="comment-(.*?)</li>''')
    lis = p.findall(tmp)

    if not lis:
	return

    p1 = re.compile(r'(.*?)">')
    p2 = re.compile(r'<p>.*?<img (.*?) ?/>')
    for g in lis:
	try:
	    id_ =  p1.search(g).groups()[0]
	
	    imgs = p2.search(g).groups()[0]
	    p3 = re.compile(r'src="(.*?)"')
	    imgs = p3.findall(imgs)
	    idx = 0
	    for img in imgs:
		download_img(id_+'_'+str(idx), img)
		idx+=1
	except AttributeError, msg:
	    print '!!!!!!!!!!!!!OCCUR ERROR!!!!!!!!!!!!!!!'
	    print msg
	    print g
	    sys.exit()

    return fetch_next_url(content)


url = 'http://jandan.net/ooxx/page-900'

for i in xrange(20):
    print url
    url = fetch_img(url)
