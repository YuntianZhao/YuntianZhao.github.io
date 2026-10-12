require "date"
require "time"
require "yaml"
require "liquid"
require "minitest/autorun"
require_relative "check_coauthor_links"

# The site has an empty baseurl; Jekyll supplies this filter in production.
module NewsTestFilters
  def relative_url(url)
    url
  end
end
Liquid::Template.register_filter(NewsTestFilters)

class NewsExpiryTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)
  NEWS = YAML.safe_load(File.read(File.join(ROOT, "_data/news.yml")))
  TEMPLATE = File.read(File.join(ROOT, "_includes/news.md"))
  ANNOUNCEMENT = {
    "date" => "2026-10-12", "expires" => "2026-11-12",
    "title" => "Example working paper", "url" => "/assets/papers/example.pdf"
  }.freeze

  def render(at, news = [ANNOUNCEMENT])
    Liquid::Template.parse(TEMPLATE, error_mode: :strict).render!(
      { "site" => { "time" => Time.iso8601(at), "data" => { "news" => news } } },
      strict_variables: true, strict_filters: true
    )
  end

  def test_configured_news_has_valid_dates_and_existing_pdfs
    NEWS.each do |item|
      posted = Date.iso8601(item.fetch("date"))
      expires = Date.iso8601(item.fetch("expires"))
      assert_operator expires, :>, posted
      assert File.file?(File.join(ROOT, item.fetch("url").delete_prefix("/")))
    end
  end

  def test_news_is_visible_on_the_posting_date
    assert_includes render("2026-10-12T00:00:00-04:00"), ANNOUNCEMENT.fetch("title")
  end

  def test_news_is_visible_just_before_expiry
    assert_includes render("2026-11-11T23:59:59-05:00"), ANNOUNCEMENT.fetch("title")
  end

  def test_news_and_heading_disappear_on_expiry
    assert_empty render("2026-11-12T00:00:00-05:00").strip
  end

  def test_future_news_is_hidden
    assert_empty render("2026-10-11T23:59:59-04:00").strip
  end

  def test_only_active_news_is_shown_newest_first
    later = ANNOUNCEMENT.merge("date" => "2026-10-20", "expires" => "2026-11-20", "title" => "Later paper")
    html = render("2026-10-21T12:00:00-04:00", [ANNOUNCEMENT, later])
    assert_operator html.index("Later paper"), :<, html.index(ANNOUNCEMENT.fetch("title"))
    expired = render("2026-11-12T12:00:00-05:00", [ANNOUNCEMENT, later])
    assert_includes expired, "Later paper"
    refute_includes expired, ANNOUNCEMENT.fetch("title")
  end
end

class CoauthorLinkCheckTest < Minitest::Test
  def check_response(code, success, error = "", destination = "https://example.com/")
    status = Struct.new(:success?).new(success)
    Open3.stub(:capture3, ["#{code}\t#{destination}", error, status]) do
      CoauthorLinks.check("https://example.com/")
    end
  end

  def test_success_after_a_redirect_is_accepted
    result = check_response("200", true, "", "https://new.example.com/")
    assert result[:ok]
    assert_equal "https://new.example.com/", result[:destination]
  end

  def test_missing_page_fails
    refute check_response("404", false)[:ok]
  end

  def test_blocked_or_rate_limited_checks_need_manual_review
    %w[403 429].each do |code|
      result = check_response(code, false)
      refute result[:ok]
      assert_includes result[:detail], "check manually"
    end
  end

  def test_network_failure_is_reported
    result = check_response("000", false, "Connection timed out")
    refute result[:ok]
    assert_includes result[:detail], "Connection timed out"
  end

  def test_non_web_urls_are_rejected
    refute CoauthorLinks.check("file:///etc/passwd")[:ok]
  end
end
