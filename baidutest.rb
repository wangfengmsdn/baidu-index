#coding:UTF-8
require 'baidu'

baidu = Baidu.new

#关键词文件夹路径
keywordsFiledir = '/home/wangfeng/baidu-index/keywordsdata'

#结果输出文件夹路径
resultFiledir = '/home/wangfeng/baidu-index/result'

#域名列表
domainArray = ['hotel.elong.com','hotels.ctrip.com','hotel.qunar.com','www.17u.cn']

#关键词文件的总数标记文件
pagecountfile = '/home/wangfeng/baidu-index/pagecountfile'

#标记文件
indexFile = '/home/wangfeng/baidu-index/indexfile'


#读取关键词文件的总数
io=open(pagecountfile)
arrCountfile = io.readlines
fileCounts =  arrCountfile[0].gsub(/\s+/,'').strip        # 读出第1行的数据

#读取记录当前运行到的文件名
io=open(indexFile) 
arrIndexfile = io.readlines 

if arrIndexfile[0] == nil
	indexNum = 0
else
	indexNum =  arrIndexfile[0].gsub(/\s+/,'').strip	
end

	
io.close

#结果文件夹
resultFilepath = resultFiledir + '/' + Time.now.strftime("%Y%m%d").to_s

if File.exists?(resultFilepath) && File.directory?(resultFilepath)
    puts ''	#文件夹存在
else
    #Dir.mkdir(resultFilepath,755)       #文件夹不存在，mkdir
    #Dir.mkdir(resultFilepath,0777)       #文件夹不存在，mkdir
    Dir.mkdir(resultFilepath)       #文件夹不存在，mkdir
end



indexNum = indexNum.to_i
fileCounts = fileCounts.to_i

while indexNum <= fileCounts   do

	#关键词列表文件
	keywordsFilename = keywordsFiledir + '/' + indexNum.to_s
	#结果文件
	resultFilename = resultFilepath + '/' + indexNum.to_s

  resultIsexists = File.exists?(resultFilename)	#文件是否存在
  
  if resultIsexists
		File.delete(resultFilename)
	end

	#p resultFilename

	File.open(keywordsFilename, "r") do |file|
		
	    file.each_line do |line|

				line.force_encoding('utf-8').gsub(/\s+/,'').strip
			
				puts lineArray = line.split('|')
		
			  puts keyword_index = lineArray[0].to_s
				puts keyword = lineArray[1].to_s
		
				result = baidu.query(keyword)	#result = baidu.query('王府井酒店')
		
				domainArray.each do |domain|
					puts domain
					#puts result.rank(domain)
					#exit;
					result_index = result.rank(domain);
					if result_index
						result_index = result_index.to_i + 1
					end
					
					p result_index
					
					#写入结果文件
=begin
					if !File.exists?(resultFilename)
						f = File.new(resultFilename,"r") 
				  end
				  puts File.exists?(resultFilename)
					exit
=end
					
					#puts resultFilename
					
					f = File.open(resultFilename,"a")
					f.puts Time.now.strftime("%Y%m%d %H:%M:%S").to_s + "|" + domain + "|" + result_index.to_s + "|" + keyword_index + "|" + keyword
					f.close
					
				end
	    end    
	end

	#修改记录文件
  indexfile = open(indexFile,"w")
  
  if indexNum == fileCounts
			indexfile.puts '0'
	else
			indexNum = indexNum + 1 
			indexfile.puts indexNum.to_s
	end
  
  indexfile.close
	
=begin
					indexFileIsexists = File.exists?(indexFile)
			  	if indexFileIsexists
			  	  #File.chmod(0777, indexFile)
						File.delete(indexFile)
					end
					
					io=open(indexFile,"a") 
					
					if indexNum == fileCounts
						io.puts '0'
					else
					   indexNum = indexNum + 1 
					   io.puts indexNum.to_s
					end
					io.close
=end
				
end
