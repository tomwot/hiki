# $Id: test_util.rb,v 1.2 2005-01-28 04:35:32 fdiary Exp $

$KCODE = 'e'

require 'test/unit'
require 'hiki/util'
require 'stringio'

class TMarshal_Unit_Tests < Test::Unit::TestCase
  include Hiki::Util

  def setup
    @t1 = "123\n456\n"
    @t2 = "123\nabc\n456\n"
    @t3 = "123\n456\ndef\n"
    @t4 = "����ˤ��ϡ����̾���Ϥ錄�ʤ٤Ǥ���\n���Just Another Ruby Porter�Ǥ���"
    @t5 = "����Ф�ϡ����̾���ϤޤĤ�ȤǤ���\nRuby���ä��Τϻ�Ǥ������Ruby Hacker�Ǥ���"
    @d1 = Document.new( @t1, 'EUC-JP', 'LF' )
    @d2 = Document.new( @t2, 'EUC-JP', 'LF' )
    @d3 = Document.new( @t3, 'EUC-JP', 'LF' )
    @d4 = Document.new( @t4, 'EUC-JP', 'LF' )
    @d5 = Document.new( @t5, 'EUC-JP', 'LF' )
  end

  def test_word_diff_html
    assert_equal( "123\n<ins class=\"added\">abc</ins>\n456\n", word_diff( @t1, @t2 ) )
    assert_equal( "<del class=\"deleted\">����ˤ���</del><ins class=\"added\">����Ф��</ins>�����<del class=\"deleted\">̾���Ϥ錄�ʤ٤Ǥ�</del><ins class=\"added\">̾���ϤޤĤ�ȤǤ�</ins>��\n<ins class=\"added\">Ruby���ä��Τϻ�Ǥ���</ins>���<del class=\"deleted\">Just Another </del>Ruby <del class=\"deleted\">Porter</del><ins class=\"added\">Hacker</ins>�Ǥ���", word_diff( @t4, @t5) )
  end

  def test_word_diff_txt
    assert_equal( "123\n{+abc+}\n456\n", word_diff( @t1, @t2, false ) )
    assert_equal( "[-����ˤ���-]{+����Ф��+}�����[-̾���Ϥ錄�ʤ٤Ǥ�-]{+̾���ϤޤĤ�ȤǤ�+}��\n{+Ruby���ä��Τϻ�Ǥ���+}���[-Just Another -]Ruby [-Porter-]{+Hacker+}�Ǥ���", word_diff( @t4, @t5, false ) )
  end

  def test_unified_diff
    assert_equal( "@@ -1,2 +1,3 @@\n 123\n+abc\n 456\n", unified_diff( @t1, @t2 ) )
    assert_equal( "@@ -1,3 +1,2 @@\n 123\n-abc\n 456\n", unified_diff( @t2, @t1 ) )
  end

  def test_euc_to_utf8
    assert_equal( "\343\201\273\343\201\222", euc_to_utf8( '�ۤ�' ) )
    assert_equal( "\343\200\234", euc_to_utf8( '��' ) )
  end

  def test_utf8_to_euc
    assert_equal( '�ۤ�', utf8_to_euc( "\343\201\273\343\201\222" ) )
    assert_equal( '��', utf8_to_euc( "\343\200\234" ) )
  end
end