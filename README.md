# Yuntian Zhao

Personal academic website built with Jekyll and adapted from the
[Minimal Light](https://github.com/yaoyao-liu/minimal-light) theme.

Content is maintained in:

- `index.md` for the biography, research interests, news, and service
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
