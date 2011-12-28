class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :authenticate_malladmin!
  #$checked = ' '
  def logd(a, b)
    if a == nil && b == nil
      logger.debug 'nil' + 'nil'
    elsif a != nil && b == nil
      logger.debug a + 'nil'
    elsif a == nil && b != nil
      if b.to_s == ' '
	logger.debug 'nil' + 'B'
      else
	logger.debug 'nil' + b.to_s
      end
    else
      if b.to_s == ' '
	logger.debug a + 'B'
      else
	logger.debug a + b.to_s
      end
    end
  end

  def logary(a, b)
    if a == nil && b == nil
      logger.debug 'nil' + 'nil'
    elsif a != nil && b == nil
      logger.debug a + 'nil'
    elsif a == nil && b != nil
      logger.debug 'nil' + concats(b)
    else
      logger.debug a + concats(b)
    end
  end 
  def concats(b)
      s = ''
      for i in 0..b.size - 1
	if b[i] == nil
	  s += 'N' + ' '
	else
	  s += b[i].to_s + ' '
	end
      end
      s
  end
  
  def to_s_nil(a)
    if a == nil
      return 'nil'
    end
    return a.to_s
  end
end

class CtgNet < ActionController::Base
  @@ctgcd = ''
  @@next = 0

  def setctgcd(n)
    @@ctgcd = n
  end
  def getctgcd
    @@ctgcd
  end
  def setnext(n)
    @@next = n
  end
  def getnext
    @@next
  end
  
end

class Contnet < ActionController::Base
  @@top = 0
  @@end = 0
  #def intialize
   # @@top = 0
   # @@end = 0
  #end

  def settop(n)
    @@top = n
  end
  def gettop
    @@top
  end
  def setend(n)
    @@end = n
  end
  def getend
    @@end
  end
  
  def appendNet(ctgcd)
    e = CtgNet.new()
    e.setctgcd(ctgcd)
    e.setnext(0)
    
    if @@top == 0
      logger.debug 'come to here:'
      @@top = e
    else
      @@end.setnext(e)
    end
    @@end = e
    #logd('top:', @@top.getctgcd.to_s)
  end

  def listNet
    #logd('top end:', @@top.to_s+' '+@@end.to_s)
    if gettop == 0
      return
    end
    cur = gettop
    str = ''
    str = cur.getctgcd
    logd('cur:', cur.to_s)
    logd('str:', str.to_s)
    i = 0
    while cur != 0 || i < 8
      str = str + cur.getctgcd + ' '
      cur = cur.getnext
      logd('str:', str)
      logd('cur:', cur)
      i +=1
    end
    logger.debug 'list:' + str
  end

end
