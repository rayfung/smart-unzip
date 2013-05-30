#!/usr/bin/python

import sys
import os
import urllib
import chardet

def convert_filename(files):
	from_encoding='GB18030'
	to_encoding='UTF-8'
	for oldfile in files:
		try:
			newfile=oldfile.decode(from_encoding).encode(to_encoding)
		except UnicodeDecodeError:
			return 1
		os.rename(oldfile, newfile)
	return 0

def detect_encoding(filepath):
	content = open(filepath, "rb").read()
	encoding = chardet.detect(content)['encoding']
	if encoding.lower() == 'ascii':
		encoding = 'utf-8'
	return encoding.lower()

def uri2raw(url):
	protocol='file://'
	if url.find(protocol) == 0:
		return urllib.unquote(url[len(protocol):])

def main():
	if len(sys.argv) < 3:
		sys.exit(1)
	op=sys.argv[1]
	if op == 'mv':
		convert_filename(sys.argv[2:])
	elif op == 'detect':
		sys.stdout.write(detect_encoding(sys.argv[2]))
	else:
		sys.stdout.write(uri2raw(sys.argv[2]))

if __name__ == '__main__':
	main()
