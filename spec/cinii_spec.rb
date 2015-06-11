require 'sist02'

describe "CiNii" do 

  it 'test_articles' do
    # 雑誌記事論文
    naid = "110009886645"
    Sist02::CiNii.article_ref(naid)
  end

  it 'test_books' do
    # 図書
    ncid = "BB18507477"
    Sist02::CiNii.book_ref(ncid)
    ncid = "BB18726608"
    Sist02::CiNii.book_ref(ncid)
  end

  it 'test_dissertations' do
    # 博士論文
    naid = "500000587337"
    Sist02::CiNii.dissertation_ref(naid)
  end

end
