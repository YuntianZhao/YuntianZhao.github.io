# Yuntian Zhao

Personal academic website built with Jekyll and adapted from the
[Minimal Light](https://github.com/yaoyao-liu/minimal-light) theme.

Content is maintained in:

- `index.md` for the biography and service
- `_data/news.yml` for announcement wording, posting dates, and expiry dates
- `_data/publications.yml` for working papers and publications
- `_data/blog.yml` for blog titles, dates, and file links
- `assets/blog/` for Markdown and PDF blog files
- `_config.yml` for profile and site metadata

## Add a blog entry

1. Upload the `.md` or `.pdf` file to `assets/blog/`.
2. Add its title, date, and path to `_data/blog.yml`:

   ```yml
   posts:
     - title: "Example post"
       date: 2026-07-30
       file: /assets/blog/example-post.pdf
   ```

The newest entries are displayed first. Markdown files should not begin with
Jekyll front matter if you want the public link to retain its `.md` extension.

## Site maintenance

`.github/workflows/site-maintenance.yml` runs daily at 11:23 UTC and can also be
started from **Actions > Site maintenance > Run workflow**. It uses GitHub's
built-in token; no personal token or extra secret is needed. Commit and push the
workflow to `master` to activate it.

- The content job tests news expiry and checks each distinct coauthor homepage
  listed in `_data/publications.yml`, using GET requests, redirects, timeouts,
  and two retries. Failed checks appear as errors and in the workflow summary.
  HTTP 403 or 429 can mean bot blocking or rate limiting; inspect the site before
  deciding to change a URL. Email alerts depend on your GitHub Actions
  notification settings.
- The independent refresh job requests a build of the existing GitHub Pages
  site. It still runs if a link check fails. Jekyll uses the New York date to
  display only unexpired announcements, with the newest first. If none remain,
  the News heading also disappears. Working Papers and their PDFs stay listed.

Add any announcement to `_data/news.yml`. Its complete wording belongs in
`text`, as one concise paragraph; Markdown links and emphasis are supported.
The template supplies the posting date and expiry filtering. These are examples
of the supported formats, not additional announcements on the website:

```yml
- date: "2026-10-12"
  expires: "2026-11-12"
  text: >-
    New working paper: [Paper title](/assets/papers/paper.pdf).

- date: "2026-10-20"
  expires: "2026-11-20"
  text: >-
    [Paper title](https://example.org/article) has been published in *Journal Name*.

- date: "2026-10-15"
  expires: "2026-10-26"
  text: >-
    I will present at [Conference name](https://example.org/conference) on October 25.

- date: "2026-10-20"
  expires: "2026-11-20"
  text: "I received a research award."
```

Default `expires` to one calendar month after `date`, using the last valid day
of the next month when necessary. Set a different expiry when it better fits
the announcement: an upcoming conference can remain visible until it ends.
Links are optional and can point to local PDFs or external journal and event
pages. Adding news does not change the separate working-paper/publication list.
The announcement is visible from `date` through
the day before `expires`. It disappears after the first rebuild on or after
the expiry date. Scheduled runs can be delayed, so expiry is daily rather than
an exact midnight timer. Expired entries can remain in the data file as a record.

GitHub automatically disables scheduled workflows in public repositories after
60 days without repository activity. If that happens, open **Actions > Site
maintenance** and select **Enable workflow**. A manual run refreshes the site
immediately. GitHub documents this behavior under
[scheduled workflows](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#schedule).

Run the link checks locally with `ruby scripts/check_coauthor_links.rb`. Template
tests need Liquid 4.0.4 and Kramdown 2.4.0, supplied by the site's GitHub Pages
bundle, and run with
`bundle exec ruby scripts/test_site_maintenance.rb`. The workflow installs its
test dependencies independently of the website's build.
