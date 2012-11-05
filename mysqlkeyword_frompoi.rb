#coding:UTF-8
require 'mysql'

begin
  dbh = Mysql.real_connect("192.168.33.199", "fly", "test3721","poidb", 3306)   #连接数据库本机：用户名：root 密码：sa 数据库：makedish 端口：3306
  dbh.query('set names utf8;');
  
  #dbh.query("drop table if exists test_foolfish")                                        #ruby执行语句
  #dbh.query("create table test_foolfish(id int,name varchar(20))")
  #dbh.query("insert into test_foolfish values(1,'你好')")
  #dbh.query("insert into test_foolfish values(2,hello)")
  #printf "%d rows were inserted\n",dbh.affected_rows                        #affected_rows返回受影响的行数

  #查询分布设置
  perNum = 1000 #默认每次查1000条
  #总记录数
  resCount = dbh.query("SELECT COUNT(*) AS sums FROM poi WHERE showflag = 2")
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
    res=dbh.query("SELECT name FROM poi WHERE name !='' AND name IS NOT NULL AND showflag = 2 GROUP BY name ORDER BY id LIMIT " + start.to_s + "," + perNum.to_s )

    res.each_hash(with_table = true) do |row|
  	  dbh.query("INSERT INTO pre_keyword(keyword) VALUES ('"+ row["poi.name"] + "')")    	
      printf "%s\n",row["poi.name"]      
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