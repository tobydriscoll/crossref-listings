# Crossref-listings Extension For Quarto

This filter automates the creation of listings of cross-referenced items such as theorems, definitions, examples, etc.

## Installing

```bash
quarto add tobydriscoll/crossref-listings
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

You also must copy the script `concatenate.ts` out of the extension directory and into the working directory of your project.

## Using

Say you have a book project over multiple files, and it includes many formal `example` divs, such as the following.

::::{#exm-good-example description="A fine example"}
## Good example
This is example 1.
::::

There may be examples on pages throughout the book. Your readers might like to have a one-stop summary of all of them. But this is tedious and fragile for you to do by hand. This extension takes out (most) of the pain by collecting all the relevant information so that you can create a listing.

## Example

The extension includes demo code that both exhibits and explains the usage. Just run `quarto render` twice within the extension directory and open the file at `_book/index.html`.
