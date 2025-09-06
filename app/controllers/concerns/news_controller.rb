require "rss"
require "open-uri"

class NewsController < ApplicationController
  COUNTRIES = [
     # アジア
    { code: "JP", name: "日本" },
    { code: "KR", name: "韓国" },
    { code: "CN", name: "中国" },
    { code: "IN", name: "インド" },
    { code: "TH", name: "タイ" },
    { code: "VN", name: "ベトナム" },
    { code: "SG", name: "シンガポール" },
    { code: "PH", name: "フィリピン" },
    { code: "MY", name: "マレーシア" },
    { code: "ID", name: "インドネシア" },
    { code: "NP", name: "ネパール" },
    { code: "LK", name: "スリランカ" },
    { code: "PK", name: "パキスタン" },
    { code: "BD", name: "バングラデシュ" },
    { code: "KH", name: "カンボジア" },
    { code: "LA", name: "ラオス" },
    { code: "MM", name: "ミャンマー" },
    { code: "MN", name: "モンゴル" },
    { code: "BT", name: "ブータン" },
    { code: "MO", name: "マカオ" },
    { code: "UZ", name: "ウズベキスタン" },

    # ハワイ・グアム・サイパンなど
    { code: "HI", name: "ハワイ（米国）" },
    { code: "GU", name: "グアム（米領）" },
    { code: "MP", name: "サイパン（北マリアナ諸島）" },
    { code: "PW", name: "パラオ" },
    { code: "FM", name: "ミクロネシア連邦" },

    # 北米
    { code: "US", name: "アメリカ合衆国" },
    { code: "CA", name: "カナダ" },

    # ヨーロッパ
    { code: "GB", name: "イギリス" },
    { code: "FR", name: "フランス" },
    { code: "IT", name: "イタリア" },
    { code: "GR", name: "ギリシャ" },
    { code: "DE", name: "ドイツ" },
    { code: "AT", name: "オーストリア" },
    { code: "ES", name: "スペイン" },
    { code: "CH", name: "スイス" },
    { code: "RU", name: "ロシア" },
    { code: "NL", name: "オランダ" },
    { code: "FI", name: "フィンランド" },
    { code: "SE", name: "スウェーデン" },
    { code: "NO", name: "ノルウェー" },
    { code: "PT", name: "ポルトガル" },
    { code: "DK", name: "デンマーク" },
    { code: "BE", name: "ベルギー" },
    { code: "BG", name: "ブルガリア" },
    { code: "IE", name: "アイルランド" },
    { code: "PL", name: "ポーランド" },
    { code: "CZ", name: "チェコ" },
    { code: "MC", name: "モナコ" },
    { code: "UA", name: "ウクライナ" },
    { code: "HU", name: "ハンガリー" },
    { code: "RO", name: "ルーマニア" },
    { code: "IS", name: "アイスランド" },
    { code: "MT", name: "マルタ共和国" },
    { code: "LU", name: "ルクセンブルク" },
    { code: "LV", name: "ラトビア" },
    { code: "LT", name: "リトアニア" },
    { code: "EE", name: "エストニア" },
    { code: "SI", name: "スロベニア共和国" },
    { code: "SK", name: "スロバキア" },
    { code: "HR", name: "クロアチア" },
    { code: "BY", name: "ベラルーシ" },
    { code: "RS", name: "セルビア" },

    # オセアニア
    { code: "AU", name: "オーストラリア" },
    { code: "NZ", name: "ニュージーランド" },
    { code: "NC", name: "ニューカレドニア" },
    { code: "TA", name: "タヒチ（仏領ポリネシア）" },
    { code: "FJ", name: "フィジー" },
    { code: "MH", name: "マーシャル諸島" },
    { code: "PF", name: "フランス領ポリネシア" },

    # 中南米・カリブ
    { code: "BR", name: "ブラジル" },
    { code: "MX", name: "メキシコ" },
    { code: "JM", name: "ジャマイカ" },
    { code: "AR", name: "アルゼンチン" },
    { code: "CL", name: "チリ" },
    { code: "PE", name: "ペルー" },
    { code: "CU", name: "キューバ" },
    { code: "EC", name: "エクアドル" },
    { code: "VE", name: "ベネズエラ" },
    { code: "BS", name: "バハマ" },
    { code: "PR", name: "プエルト・リコ" },
    { code: "BO", name: "ボリビア" },
    { code: "PA", name: "パナマ" },
    { code: "GT", name: "グアテマラ" },
    { code: "CR", name: "コスタリカ" },

    # 中東・アフリカ
    { code: "EG", name: "エジプト" },
    { code: "TR", name: "トルコ" },
    { code: "MA", name: "モロッコ" },
    { code: "IR", name: "イラン" },
    { code: "ZA", name: "南アフリカ共和国" },
    { code: "AE", name: "UAE（アラブ首長国連邦）" },
    { code: "TN", name: "チュニジア" },
    { code: "KE", name: "ケニア" },
    { code: "DZ", name: "アルジェリア" },
    { code: "GH", name: "ガーナ" },
    { code: "TZ", name: "タンザニア" }
  ]

  def index
    url = "https://news.google.com/rss/search?q=ハワイ&hl=ja&gl=JP&ceid=JP:ja"
    @articles = []

    begin
      URI.open(url) do |rss|
        feed = RSS::Parser.parse(rss)
        @articles = feed.items.map do |item|
          {
            title: item.title,
            link: item.link,
            pub_date: item.pubDate
          }
        end
    end
    rescue => e
      Rails.logger.error "RSS取得失敗: #{e.message}"
      @articles = [] # エラー時も必ず空配列にする
    end
  end

  def map
    @regions = {
      "アジア" => COUNTRIES.select { |c| %w[JP CN KR IN TH].include?(c[:code]) },
      "ヨーロッパ" => COUNTRIES.select { |c| %w[FR DE IT ES GB].include?(c[:code]) },
      "北米" => COUNTRIES.select { |c| %w[US CA MX].include?(c[:code]) },
      # 他の地域も同様にグループ化
    }
  end

  def news
    @country = COUNTRIES.find { |c| c[:code] == params[:code] }
    if @country.nil?
      redirect_to travels_map_path, alert: "記事なし"
      return
    end

    url = "https://news.google.com/rss/search?q=#{URI.encode_www_form_component(@country[:name])}+when:7d&hl=ja&gl=JP&ceid=JP:ja"

    begin
      rss = URI.open(url).read
      @items = RSS::Parser.parse(rss, false)&.items || []
    rescue
      @items = []
    end
  end
end
