# Project Kickstart-R

> ## This template is deprecated. It has been replaced by *Academic Kickstart*. [Install Academic Kickstart](https://sourcethemes.com/academic/docs/install/#install-with-rstudio) instead.

---

**Project Kickstart-R** provides a minimal template to create a **Landing Page** and **Knowledge Sharing Platform** with *Academic* and (R) Markdown. Popular applications include creating sites for organizations, software documentation, online courses, conferences, and academic labs.

[**Academic**](https://sourcethemes.com/academic/) makes it easy to create a beautiful website for free using (R) Markdown. Customize anything on your site with widgets, themes, and language packs.

- [Explore the demo](https://sourcethemes.com/academic/)
- [Read the documentation](https://sourcethemes.com/academic/docs/)
- Ask a question [on the forums](http://discuss.gohugo.io/) or [Stack Overflow](https://stackoverflow.com/questions/tagged/blogdown)
- [Request a feature or report a bug](https://github.com/gcushen/hugo-academic/issues)
- Updating? View the [Update Guide](https://sourcethemes.com/academic/docs/update/) and [Release Notes](https://sourcethemes.com/academic/updates/)
- Support development of Academic:
  - [Donate a coffee](https://paypal.me/cushen)
  - [Become a backer on Patreon](https://www.patreon.com/cushen)
  - [Decorate your laptop or journal with an Academic sticker](https://www.redbubble.com/people/neutreno/works/34387919-academic)
  - [Wear the T-shirt](https://academic.threadless.com/)

[![Screenshot](https://raw.githubusercontent.com/sourcethemes/project-kickstart-r/master/project-kickstart-r.png)](https://github.com/sourcethemes/project-kickstart-r)

## Install in 5 Steps

Open [RStudio](https://www.rstudio.com/products/rstudio/) and run the following commands to create your new project website with **Project Kickstart-R**:

1. Download [**Project Kickstart-R**](https://github.com/sourcethemes/project-kickstart-r/archive/master.zip) to your working directory:

    ```r
    download.file( url = "https://github.com/sourcethemes/project-kickstart-r/archive/master.zip", destfile="project-kickstart-r.zip")
    ```

2. Extract the ZIP file and open the `project-kickstart-r.Rproj` project:

    ```r
    unzip( zipfile = "project-kickstart-r.zip" )
    ```

3. Install the [Blogdown](https://bookdown.org/yihui/blogdown/) and [Hugo](https://gohugo.io/) dependencies:

    ```r
    install.packages("blogdown")
    blogdown::install_hugo()
    ```

4. Install the [Academic](https://sourcethemes.com/academic/) framework:

    ```r
    blogdown::install_theme(theme = "gcushen/hugo-academic@v3.3.1")
    ```

5. View your new site:

    ```r
    blogdown::serve_site()
    ```

A browser tab should open, displaying your new website. Otherwise, check your RStudio console messages - you may need to restart RStudio after installing the dependencies.

## Next Steps

Learn how to [customize](https://sourcethemes.com/academic/docs/get-started/) your site, [create content](https://sourcethemes.com/academic/docs/managing-content/), and [edit content using R Markdown and shortcodes](https://sourcethemes.com/academic/docs/writing-markdown-latex/).

Note that **R content should be saved with the `.Rmarkdown` file extension** rather than `.Rmd`.
 
Finally, [deploy](https://sourcethemes.com/academic/docs/deployment/) your site to the internet.

## Ecosystem

* **[Academic Admin](https://github.com/sourcethemes/academic-admin):** An admin tool to import publications from BibTeX or import assets for an offline site
* **[Academic Scripts](https://github.com/sourcethemes/academic-scripts):** Scripts to help migrate content to new versions of Academic

## License

Copyright 2018-present [George Cushen](https://georgecushen.com).

Released under the [MIT](https://github.com/sourcethemes/project-kickstart-r/blob/master/LICENSE.md) license.

[![Analytics](https://ga-beacon.appspot.com/UA-78646709-2/project-kickstart-r/readme?pixel)](https://github.com/igrigorik/ga-beacon)
