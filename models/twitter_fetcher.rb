require "capybara/poltergeist"

Capybara.javascript_driver = :poltergeist

class TwitterFetcher
  def initialize(screen_name, filename)
    @screen_name = screen_name
    @filename    = "cache/#{filename}.png"
    @session = Capybara::Session.new(:poltergeist)
  end

  def self.fetch(screen_name, filename)
    self.new(screen_name, filename).fetch
  end

  def fetch
    @session.visit "https://twitter.com/#{@screen_name}"
    # 3 回スクロールしてから screenshot 取る
    3.times do
      @session.execute_script <<-JS
      setTimeout(function() {
        window.document.body.scrollTop = document.body.scrollHeight;
      }, 0);
      JS
      sleep 0.3 # 無限スクロールが発火するのを雑に待つ
    end
    @session.save_screenshot(@filename, full: true)
  end
end
