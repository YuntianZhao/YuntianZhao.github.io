# Website content preferences

These preferences apply when updating Yuntian Zhao's academic website.

## Working papers and author lists

- Use the paper's title and full author list as printed on its title page, preserving author order.
- Link each coauthor's name to their personal website's homepage. Display Yuntian Zhao's name as plain text.
- Use the root of each personal site. For a hosted site, retain the path identifying that site, such as `https://sites.google.com/view/radhika-goyal/`.
- Link the paper title to its uploaded PDF.

## News announcements

- Store each announcement's complete wording in the `text` field of `_data/news.yml`, as one concise paragraph with optional Markdown links and emphasis. The template renders the wording without adding an announcement type or fixed phrase.
- Use this format for working papers, journal publications, conferences, awards, and other news. Describe only events and details supplied or verified for the user.
- Keep a new working paper announcement to the posting date and linked paper title:
  `October 12, 2026: New working paper: [Paper title](PDF URL).`
- Add a description of the research, methods, or findings only when the user explicitly requests it.
- Give each announcement a posting date and expiry date. Default to one calendar month; use an expiry appropriate to the event when specified, such as the day after a conference ends. Expired announcements leave the News section; research listings and PDFs remain available.

## Maintenance

- Keep coauthor links in `_data/publications.yml`; the maintenance workflow checks them daily and when they change.
- Follow redirects and retry failed requests. A failed automated check calls for review; update a URL after verifying the author's current homepage.
- Preserve the daily Pages rebuild so news expires even when no content changes. See the maintenance procedure in `README.md` for running checks and reactivating an inactive schedule.
