require 'active_support/core_ext/hash'

module Maas
  module Client
    module Util
      # taken from https://gist.github.com/andrewpcone/11359798
		  def symbolize_keys(thing)
		    case thing
		    when Array
		      thing.map{|v| symbolize_keys(v)}
		    when Hash
		      inj = thing.inject({}) {|h, (k,v)| h[k] = symbolize_keys(v); h}
		      inj.symbolize_keys
		    else
		      thing
		    end
		  end
    end
  end
end

