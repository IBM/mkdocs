# Documentation Template

- All content in the docs folder will be converted to HTML by [MkDocs](https://www.mkdocs.org)

- All you need to do is edit content in the docs folder and just do a `git push`

- The documentation will be automatically deployed on the GitHub Pages

!!! note
    Hello World
    
## Mkdocs Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.


## Local install of MkDocs

If you want to use MkDocs locally then you need to have python3 and Node.js installed on your system.  Then run commands:

```shell
pip install -r requirements.txt
npm ci
```

The following commands can be used (command needs to be run in the root folder of the cloned github repository):

-   `mkdocs serve` : run a local dev environment where live documentation updates can be seen in a browser served from localhost:8000
-   `mkdocs gh-deploy` : update the mkdocs site served by github pages (you need to be authenticated to the git server)

## Mermaid Js

- You can create simple diagrams like the following using Mermaid Js

```diagram
  graph TD;
    A --> B;
    A --> C;
    B --> D;
    C --> D;
```

- For full documentation of mermaid visit [About Mermaid](https://mermaid-js.github.io/mermaid/#/).
