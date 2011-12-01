module ActiveSupport
  class SafeBuffer < String
    def concat(value)
      if value.html_safe?
        super(value.force_encoding('utf-8'))
      else
        super(ERB::Util.h(value.force_encoding('utf-8')))
      end
    end
    alias << concat
  end
end
