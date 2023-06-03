# Crossref-listings extension For Quarto

This filter automates the creation of listings of cross-referenced items such as theorems, definitions, examples, etc.

Say you have a book project over multiple files, and it includes many formal `example` divs, such as the following.

```markdown
::::{#exm-good-example description="A fine example" type=text}
## Good example
This is example 1.
::::
```

There may be examples on pages throughout the book. Your readers might like to have a one-stop summary of all of them. But this is tedious and fragile for you to do by hand. This extension takes out (most) of the pain by collecting all the relevant information so that you can create a listing. 

The example above creates fields called `description` and `type` that can be used as columns in the auto-generated table of examples. You can use whatever attributes you like for this.

See the [documentation](https://tobydriscoll.github.io/crossref-listings) for information on installation and use.