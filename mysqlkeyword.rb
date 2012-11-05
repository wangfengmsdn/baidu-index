#coding:UTF-8
require 'mysql'

begin
  dbh = Mysql.real_connect("192.168.33.199", "fly", "test3721","db_elongseo", 3306)   #连接数据库本机：用户名：root 密码：sa 数据库：makedish 端口：3306
  dbh.query('set names utf8;');
  
  #dbh.query("drop table if exists test_foolfish")                                        #ruby执行语句
  #dbh.query("create table test_foolfish(id int,name varchar(20))")
  #dbh.query("insert into test_foolfish values(1,'你好')")
  #dbh.query("insert into test_foolfish values(2,hello)")
  #printf "%d rows were inserted\n",dbh.affected_rows                        #affected_rows返回受影响的行数

  #查询分布设置
  perNum = 2000 #默认每次查1000条
  #总记录数
  resCount = dbh.query("SELECT COUNT(*) AS sums FROM pre_keyword")
  #puts resCount
  #exit
  resSum =  resCount.fetch_row()[0].to_i
  #puts resSum
  pages = resSum/perNum
  pages = pages.to_i
  
  #puts pages
  #exit
  
  page = 0

  while page <= pages  do
    #分页
    puts "第"+page.to_s+"页"
    start = page*perNum

    res=dbh.query("SELECT k_word FROM pre_keyword WHERE k_word !='' AND k_word IS NOT NULL GROUP BY k_word ORDER BY k_id LIMIT " + start.to_s + "," + perNum.to_s )

    res.each_hash(with_table = true) do |row|
 
   		dbpoi = Mysql.real_connect("192.168.33.199", "fly", "test3721","poidb", 3306)   #连接数据库本机：用户名：root 密码：sa 数据库：makedish 端口：3306
  		dbpoi.query('set names utf8;');
  	  dbpoi.query("INSERT INTO pre_keyword(keyword) VALUES ('"+ row["pre_keyword.k_word"] + "')")    	
      printf "%s\n",row["pre_keyword.k_word"]
      
      dbpoi.close if dbpoi
      
    end

    page = page + 1
  end
  
  
  puts "Server version:"+dbh.get_server_info
  rescue Mysql::Error=>e
    puts "Error code:#{e.errno}"
    puts "Error message:#{e.error}"
    puts "Error SQLSTATE:#{e.sqlstate}" if e.respond_to?("sqlstate")
  ensure
  
  dbh.close if dbh
  
end