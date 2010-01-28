######################################################################
# Enhance the Fixnum class with a XML escaped character conversion.
#
class Fixnum
  XChar = Builder::XChar if ! defined?(XChar)

  # XML escaped version of chr
  def escaped_non_ncr_char
    n = XChar::CP1252[self] || self
    case n when *XChar::VALID
      XChar::PREDEFINED[n] or [n].pack("U")
    else
      '*'
    end
  end
end

class String
  # XML escaped version of to_s that does not do NCR's
  def to_non_ncr_xs
    unpack('U*').map {|n| n.escaped_non_ncr_char}.join # ASCII, UTF-8
  rescue
    unpack('C*').map {|n| n.escaped_non_ncr_char}.join # ISO-8859-1, WIN-1252
  end
end

module Builder
  class XmlBase < BlankSlate
    def _escape(text)
      text.to_non_ncr_xs
    end
  end
end