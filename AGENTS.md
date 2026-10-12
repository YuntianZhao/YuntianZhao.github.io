# Website content preferences

These preferences apply when updating Yuntian Zhao's academic website.

## Working papers and author lists

- Use the paper's title and full author list as printed on its title page, preserving author order.
- Link each coauthor's name to their personal website's homepage. Display Yuntian Zhao's name as plain text.
- Use the root of each personal site. For a hosted site, retain the path identifying that site, such as `https://sites.google.com/view/radhika-goyal/`.
- Link the paper title to its uploaded PDF.

## News announcements

- Keep a new working paper announcement to the posting date and linked paper title:
  `October 12, 2026: New working paper: [Paper title](PDF URL).`
- Add a description of the research, methods, or findings only when the user explicitly requests it.
- Store announcements in `_data/news.yml` with a posting date and an expiry date one calendar month later. Expired announcements leave the News section; their papers remain under Working Papers.

## Maintenance

- Keep coauthor links in `_data/publications.yml`; the maintenance workflow checks them daily and when they change.
- Follow redirects and retry failed requests. A failed automated check calls for review; update a URL after verifying the author's current homepage.
- Preserve the daily Pages rebuild so news expires even when no content changes. See the maintenance procedure in `README.md` for running checks and reactivating an inactive schedule.
