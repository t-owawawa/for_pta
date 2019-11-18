require 'bundler'
require 'keynote-client'
include Keynote
require "csv"
require "pp"

arr = []
CSV.foreach("./得点表.csv") do |row|
  # 行に対する処理
  arr.push({"team_name" => row[0], "score" => row[1].to_i})
end

# score低い順でソートする
arr.sort!{|a,b| a['score']<=>b['score']}

# keynote作成
# マスタースライド、テーマを作っておく必要アリ。
theme = Theme.find_by(name: '2019_xmas_for_PTA').first
doc = Document.create(theme: theme, file_path: '../result.key')
slide = Slide.new("2019_xmas_for_PTA", title: "けっかはっぴょう", body: ["結果発表"].join("\n"))
doc.slides << slide

arr.each_with_index{|item, index|
  rank = (index - 8).abs
  str_rank = sprintf("%s位", rank.to_s)
  all_score = sprintf("%d点", item["score"])
  team = "#{item["team_name"]}！"
  # puts item, strRank
  slide = Slide.new("2019_xmas_for_PTA", title: str_rank, body: [team, "合計点数：", all_score].join("\n"))
  doc.slides << slide
}
doc.save