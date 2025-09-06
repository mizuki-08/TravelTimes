class TravelsController < ApplicationController
  
  before_action :authenticate_user!, only: [:new, :create]

  def index
       @travels = Travel.all
        if params[:search] == nil
        @travels= Travel.all
        elsif params[:search] == ''
        @travels= Travel.all
      else
        #部分検索
        @travels = Travel.where("title LIKE ? OR country_name LIKE ? ",'%' + params[:search] + '%','%' + params[:search] + '%')
      end
  end

  def worldmap
    @regions = {
        "アジア" => {
        image: "https://i.pinimg.com/1200x/bf/ea/94/bfea94ee28424eee986ced8679e9ad22.jpg",
        countries: %w[日本 韓国 中国 インド タイ ベトナム シンガポール フィリピン マレーシア インドネシア ネパール スリランカ パキスタン バングラデシュ カンボジア ラオス ミャンマー モンゴル ブータン マカオ ウズベキスタン]
      },
      "ハワイ・グアム・サイパン" => {
        image: "https://i.pinimg.com/1200x/eb/2f/99/eb2f99ec07e2963bc36045d53f734c93.jpg",
        countries: %w[ハワイ グアム サイパン パラオ ミクロネシア連邦]
      },
      "北アメリカ" => {
        image: "https://i.pinimg.com/1200x/f3/13/54/f3135468158288ed1d39cf8233e0dd8c.jpg",
        countries: %w[アメリカ カナダ]
      },
      "ヨーロッパ" => {
        image: "https://i.pinimg.com/1200x/17/0e/76/170e76c83ccda6ab2eb6640100798992.jpg",
        countries: %w[イギリス フランス イタリア ギリシャ ドイツ オーストリア スペイン スイス ロシア オランダ フィンランド スウェーデン ノルウェー ポルトガル デンマーク ベルギー ブルガリア アイルランド ポーランド チェコ モナコ ウクライナ ハンガリー ルーマニア アイスランド マルタ共和国 ルクセンブルク ラトビア リトアニア エストニア スロベニア共和国 スロバキア クロアチア ベラルーシ セルビア]
      },
      "オセアニア" => {
        image: "https://i.pinimg.com/1200x/9e/1f/89/9e1f893ebce92b9d3131dfa53c60a340.jpg",
        countries: %w[オーストラリア ニュージーランド ニューカレドニア タヒチ フィジー マーシャル諸島 フランス領ポリネシア]
      },
      "中南米" => {
        image: "https://i.pinimg.com/1200x/b7/26/ea/b726ea954d217d11031188ce811f0d95.jpg",
        countries: %w[ブラジル メキシコ ジャマイカ アルゼンチン チリ ペルー キューバ エクアドル ベネズエラ バハマ プエルト・リコ ボリビア パナマ グアテマラ コスタ・リカ]
      },
      "中東・アフリカ" => {
        image: "https://i.pinimg.com/1200x/42/1e/22/421e22093ad3d0542dd4c96db37592b4.jpg",
        countries: %w[エジプト トルコ モロッコ イラン 南アフリカ UAE ドバイ チュニジア ケニア アルジェリア ガーナ タンザニア]
      }
    }
  end    
      
  

  def new
        @travel = Travel.new
  end

  def create
    travel = Travel.new(travel_params)

    travel.user_id = current_user.id

    if travel.save!
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  def show
    @travel = Travel.find(params[:id])
  end

  def edit
    @travel = Travel.find(params[:id])
  end

  def destroy
     travel = Travel.find(params[:id])
     travel.destroy
     redirect_to action: :index
  end

  def update
    travel = Travel.find(params[:id])
    if travel.update(travel_params)
      redirect_to :action => "show", :id => travel.id
    else
      redirect_to :action => "new"
    end
  end

  

  private
  def travel_params
    params.require(:travel).permit(:title, :image, :country_name, :highlight,tag_ids: [])
  end
 
end
