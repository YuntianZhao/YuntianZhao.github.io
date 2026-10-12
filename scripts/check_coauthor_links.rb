require "open3"
require "uri"
require "yaml"

module CoauthorLinks
  def self.check(url)
    uri = URI.parse(url)
    unless %w[http https].include?(uri.scheme) && uri.host
      return { ok: false, detail: "Expected an HTTP or HTTPS website URL" }
    end

    output, error, status = Open3.capture3(
      "curl", "--silent", "--show-error", "--fail", "--location",
      "--proto", "=http,https", "--proto-redir", "=http,https",
      "--connect-timeout", "10", "--max-time", "30", "--max-redirs", "10",
      "--retry", "2", "--retry-delay", "2", "--retry-all-errors",
      "--user-agent", "AcademicWebsiteLinkCheck/1.0",
      "--output", File::NULL, "--write-out", "%{http_code}\t%{url_effective}",
      "--", url
    )
    code, destination = output.strip.split("\t", 2)
    ok = status.success? && code.to_i.between?(200, 299)
    detail = "HTTP #{code || '000'}"
    detail += "; #{error.strip}" unless ok || error.strip.empty?
    if %w[403 429].include?(code)
      detail += "; automated access may be blocked or rate limited; check manually"
    end
    { ok: ok, detail: detail, destination: destination }
  rescue URI::InvalidURIError
    { ok: false, detail: "Invalid website URL" }
  end

  def self.run(data_path, summary_path: nil)
    data = YAML.safe_load(File.read(data_path))
    authors = %w[working_papers publications].flat_map do |section|
      data.fetch(section, []).flat_map { |paper| paper.fetch("authors", []) }
    end
    authors = authors.select { |author| author["url"] }.uniq { |author| author["url"] }
    report = ["## Coauthor homepage checks", "",
              "| Author | Website | Result |", "| --- | --- | --- |"]
    failed = false

    authors.each do |author|
      result = check(author.fetch("url"))
      label = result[:ok] ? "OK" : "Could not verify"
      detail = result[:detail]
      detail += " -> #{result[:destination]}" if result[:ok] && result[:destination] != author["url"]
      puts "#{label}: #{author['name']} - #{detail}"
      row = [author["name"], author["url"], "#{label}: #{detail}"]
      report << "| #{row.map { |value| value.gsub('|', '\\|').gsub(/\r?\n/, ' ') }.join(' | ')} |"
      next if result[:ok]

      failed = true
      message = "#{author['name']}: #{detail}".gsub("%", "%25").gsub("\r", "%0D").gsub("\n", "%0A")
      puts "::error file=_data/publications.yml::#{message}"
    end

    report << "\nNo coauthor website URLs are configured." if authors.empty?
    File.open(summary_path, "a") { |file| file.puts(report.join("\n")) } if summary_path
    failed ? 1 : 0
  end
end

if $PROGRAM_NAME == __FILE__
  data_path = ARGV.fetch(0, File.expand_path("../_data/publications.yml", __dir__))
  exit CoauthorLinks.run(data_path, summary_path: ENV["GITHUB_STEP_SUMMARY"])
end
